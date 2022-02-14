open ReactNative
open ReactNativeSafeAreaContext

let rec reducePictureSize = (initialUri, compress) => {
  open! Expo.ImageManipulator

  manipulateAsync(
    initialUri,
    [
      Resize({
        resize: {
          width: 800,
        },
      }),
    ],
    {compress: compress, base64: false, format: SaveFormat.jpeg},
  )
  ->Promise.Js.toResult
  ->Promise.mapError(_ => ())
  ->Promise.flatMapOk(({uri}) =>
    Expo.FileSystem.getInfoAsync(uri, {size: true})
    ->Promise.Js.toResult
    ->Promise.mapError(_ => ())
    ->Promise.flatMapOk(({size}) =>
      if size / 1000 > 200 && compress > 0.20 {
        reducePictureSize(initialUri, compress -. 0.10)->Promise.mapError(_ => ())
      } else {
        Promise.resolved(Ok(uri))
      }
    )
    ->Promise.mapError(_err => ())
  )
}

let styles = StyleSheet.create({
  open Style
  {
    "root": viewStyle(~flex=1., ~backgroundColor="#000", ()),
    "camera": viewStyle(~flex=1., ~justifyContent=#flexEnd, ()),
    "centerView": viewStyle(~flex=1., ~justifyContent=#center, ~alignItems=#center, ()),
    "text": textStyle(~fontSize=16., ~color="#fff", ()),
    "buttonTakePicture": viewStyle(
      ~flex=0.,
      ~width=66.->dp,
      ~height=66.->dp,
      ~borderRadius=100.,
      ~backgroundColor="#fff",
      ~elevation=2.,
      ~shadowColor=Theme.Colors.neutral400,
      ~shadowOpacity=0.25,
      ~shadowOffset=offset(~width=0., ~height=2.),
      ~justifyContent=#center,
      ~alignItems=#center,
      (),
    ),
    "buttonContent": viewStyle(
      ~flex=0.,
      ~width=56.->dp,
      ~height=56.->dp,
      ~borderRadius=100.,
      ~borderWidth=1.,
      ~borderColor="#eee",
      (),
    ),
    "rootButtons": viewStyle(
      ~flex=0.,
      ~width=100.->pct,
      ~flexDirection=#row,
      ~alignItems=#center,
      ~justifyContent=#spaceAround,
      ~backgroundColor="rgba(24,24,24,0.35)",
      (),
    ),
    "header": viewStyle(
      ~position=#absolute,
      ~left=0.->dp,
      ~top=0.->dp,
      ~flex=0.,
      ~width=100.->pct,
      ~height=80.->dp,
      ~flexDirection=#row,
      ~alignItems=#center,
      ~paddingHorizontal=16.->dp,
      ~elevation=2.,
      ~zIndex=100,
      (),
    ),
  }
})

type rec state = {
  permissionGranted: option<bool>,
  cameraState: cameraState,
  ratio: option<ratio>,
}
and cameraState =
  | NotReady
  | Idle
  | Processing
  | MountError(string)
  | WaitingApproval(Expo.Camera.response)
and ratio = {
  verticalPadding: float,
  ratio: string,
}

type action =
  | PermissionGranted(bool)
  | CameraReady(ratio)
  | UnableToMountCamera(string)
  | TakePicture
  | Preview(Expo.Camera.response)
  | Cancel
  | Confirm
  | Exit

let screenSize = Dimensions.get(#screen)

let getBestRatioAvailable = camera => {
  let screenRatio = screenSize.height /. screenSize.width

  camera
  ->Expo.Camera.getSupportedRatiosAsync()
  ->Promise.Js.toResult
  ->Promise.flatMapOk(availableRatios => {
    availableRatios
    ->Array.map(ratio =>
      camera
      ->Expo.Camera.getAvailablePictureSizesAsync(ratio)
      ->Promise.Js.catch(_ => Promise.resolved([]))
    )
    ->Promise.allArray
    ->Promise.Js.toResult
    ->Promise.mapOk(availablePictureSizes => {
      let supportedRatio = availableRatios->Array.keepWithIndex((_ratio, i) => {
        let sizesRatio = availablePictureSizes->Array.get(i)

        switch sizesRatio {
        | None
        | Some([]) => false
        | _ => true
        }
      })

      Js.log2("Supported ratios", supportedRatio)
      let supportedRatio = supportedRatio->Array.map(ratio => {
        // eg: 16:9; 4:3; 2:1; etc...
        let ratioParsed = ratio->Js.String2.split(":")
        let realRatio =
          ratioParsed[0]->Option.getUnsafe->Js.Float.fromString /.
            ratioParsed[1]->Option.getUnsafe->Js.Float.fromString

        (ratio, screenRatio -. realRatio)
      })

      let (
        bestRatio,
        bestRatioCalculated,
      ) = supportedRatio->Array.reduce(supportedRatio->Array.getUnsafe(0), (savedRatio, ratio) => {
        let (_, calculatedSavedRatio) = savedRatio
        let (_, calculatedRatio) = ratio

        // the best ratio is the one closer to 0
        calculatedSavedRatio >= 0. && calculatedSavedRatio < calculatedRatio ? savedRatio : ratio
      })

      let verticalPadding = Js.Math.floor(bestRatioCalculated *. screenSize.width /. 2.) / 2

      {ratio: bestRatio, verticalPadding: verticalPadding->Int.toFloat}
    })
  })
}

@react.component
let make = () => {
  let {visible, onCancel, onSave} = Camera_Service.store.useStore()
  let insets = useSafeAreaInsets()
  let cameraRef = React.useRef(Js.Nullable.null)

  let ({permissionGranted, cameraState, ratio}, dispatch) = ReactUpdate.useReducerWithMapState(
    (state, action) =>
      switch action {
      | PermissionGranted(bool) => Update({...state, permissionGranted: Some(bool)})
      | CameraReady(ratio) => Update({...state, cameraState: Idle, ratio: Some(ratio)})
      | UnableToMountCamera(error) => Update({...state, cameraState: MountError(error)})
      | Exit =>
        UpdateWithSideEffects(
          {...state, cameraState: Idle},
          _ => {
            onCancel->Option.forEach(fn => fn())
            Camera_Service.hide()

            None
          },
        )
      | Preview(picture) => Update({...state, cameraState: WaitingApproval(picture)})
      | Cancel =>
        UpdateWithSideEffects(
          {...state, cameraState: Idle},
          _ => {
            cameraRef.current
            ->Js.Nullable.toOption
            ->Option.forEach(camera => camera->Expo.Camera.resumePreview())

            None
          },
        )
      | Confirm =>
        SideEffects(
          ({state, send}) => {
            switch (onSave, state.cameraState) {
            | (Some(fn), WaitingApproval({uri})) =>
              reducePictureSize(uri, 0.70)
              ->Promise.tapOk(uri => fn(uri))
              ->Promise.tapError(_ => fn(uri))
              ->ignore

              send(Exit)
            | _ => ()
            }
            None
          },
        )
      | TakePicture =>
        UpdateWithSideEffects(
          {...state, cameraState: Processing},
          ({send}) => {
            cameraRef.current
            ->Js.Nullable.toOption
            ->Option.forEach(camera => {
              open Expo.Camera
              camera
              ->takePictureAsync(makeOptions(~quality=1., ~base64=false, ()))
              ->Promise.Js.toResult
              ->Promise.tapOk(picture => {
                send(Preview(picture))
                camera->Expo.Camera.pausePreview()
              })
              ->ignore
            })

            None
          },
        )
      },
    () => {permissionGranted: None, cameraState: NotReady, ratio: None},
  )

  React.useEffect1(() => {
    if visible {
      Expo.Camera.getCameraPermissionsAsync()
      ->Promise.Js.toResult
      ->Promise.tapOk(({status}) => {
        switch status {
        | #granted => dispatch(PermissionGranted(true))
        | _ =>
          Expo.Camera.requestCameraPermissionsAsync()
          ->Promise.Js.toResult
          ->Promise.tapOk(({status}) => {
            dispatch(PermissionGranted(status == #granted))
          })
          ->ignore
        }
      })
      ->ignore
    }

    None
  }, [visible])

  Hooks.useHardwareBackPress2(() =>
    if visible {
      switch cameraState {
      | WaitingApproval(_) => dispatch(Cancel)
      | _ => dispatch(Exit)
      }
      true
    } else {
      false
    }
  , (visible, cameraState))

  visible
    ? <Paper.Portal>
        <View style={styles["root"]}>
          <View
            style={
              open Style
              array([styles["header"], viewStyle(~paddingTop=insets.top->dp, ())])
            }>
            <TouchableOpacity onPress={_ => dispatch(Exit)}>
              <BsReactNativeVectorIcons.FontAwesome5 name="times" size=36. color="#fff" />
            </TouchableOpacity>
          </View>
          {permissionGranted->Option.mapWithDefault(
            <View style={styles["centerView"]} />,
            permissionGranted =>
              permissionGranted
                ? <Expo.Camera
                    onMountError={error =>
                      dispatch(
                        UnableToMountCamera(
                          error->Js.Exn.message->Option.getWithDefault("Unable to mount camera"),
                        ),
                      )}
                    ref={ref_ => cameraRef.current = ref_}
                    style={
                      open Style
                      arrayOption([
                        Some(styles["camera"]),
                        ratio->Option.map(({verticalPadding}) =>
                          viewStyle(~marginVertical=verticalPadding->dp, ())
                        ),
                      ])
                    }
                    ratio={ratio->Option.mapWithDefault("4:3", ({ratio}) => ratio)}
                    useCamera2Api=true
                    onCameraReady={() => {
                      switch ratio {
                      | None =>
                        if Platform.os === Platform.android {
                          cameraRef.current
                          ->Js.Nullable.toOption
                          ->Option.forEach(camera =>
                            getBestRatioAvailable(camera)
                            ->Promise.tapOk(ratio => dispatch(CameraReady(ratio)))
                            ->Promise.tapError(err => Js.log2("getBestRatioAvailable error", err))
                            ->ignore
                          )
                        } else {
                          dispatch(
                            CameraReady({
                              verticalPadding: 0.,
                              ratio: "4:3",
                            }),
                          )
                        }
                      | Some(ratio) => dispatch(CameraReady(ratio))
                      }
                    }}>
                    <View
                      style={
                        open Style
                        array([
                          styles["rootButtons"],
                          viewStyle(
                            ~paddingVertical=insets.bottom > 0. ? insets.bottom->dp : 20.->dp,
                            (),
                          ),
                        ])
                      }>
                      {switch cameraState {
                      | NotReady => React.null
                      | Processing =>
                        <Paper.ActivityIndicator
                          color="#fff" size=Paper.ActivityIndicator.Size.large
                        />
                      | MountError(message) =>
                        <Paper.Text style={styles["text"]}> {message->React.string} </Paper.Text>
                      | Idle =>
                        <TouchableOpacity
                          style={styles["buttonTakePicture"]} onPress={_ => dispatch(TakePicture)}>
                          <View style={styles["buttonContent"]} />
                        </TouchableOpacity>
                      | WaitingApproval(_) => <>
                          <TouchableOpacity onPress={_ => dispatch(Cancel)}>
                            <BsReactNativeVectorIcons.FontAwesome5
                              name="times-circle" size=50. color="#fff"
                            />
                          </TouchableOpacity>
                          <TouchableOpacity onPress={_ => dispatch(Confirm)}>
                            <BsReactNativeVectorIcons.FontAwesome5
                              name="check" size=50. color="#fff"
                            />
                          </TouchableOpacity>
                        </>
                      }}
                    </View>
                  </Expo.Camera>
                : <View style={styles["centerView"]}>
                    <Paper.Text style={styles["text"]}>
                      {"pleaseAllowCameraPermission"->React.string}
                    </Paper.Text>
                  </View>,
          )}
        </View>
      </Paper.Portal>
    : React.null
}
