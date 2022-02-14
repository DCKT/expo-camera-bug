open ReactNative

module StatusBar = {
  @module("expo-status-bar") @react.component
  external make: (~style: string) => React.element = "StatusBar"
}

let styles = {
  open Style

  StyleSheet.create({
    "container": viewStyle(
      ~flex=1.,
      ~backgroundColor="#fff",
      ~alignItems=#center,
      ~justifyContent=#center,
      (),
    ),
  })
}

let primary = "#12c8e0"
let secondary = "#245056"
let success = "#7cb342"
let warning = "#ffb300"
let danger = "#ff1744"
let light = "#f2f9f9"
let dark = "#15373a"
let white = "#fff"
let grey = "#ccc"
let darkGrey = "#777"

let paperTheme = Js.Obj.assign(
  Paper.ThemeProvider.defaultTheme->Obj.magic,
  {
    "colors": {
      "primary": primary,
      "accent": secondary,
      "background": white,
      "surface": white,
      "error": danger,
      "text": "black",
      "disabled": "rgba(0, 0, 0, 0.26)",
      "placeholder": "rgba(0, 0, 0, 0.54)",
      "backdrop": "rgba(0, 0, 0, 0.5)",
      "onSurface": "rgba(44, 44, 44, 1)",
    },
  },
)->Obj.magic

module PaperProvider = {
  @module("react-native-paper") @react.component
  external make: (
    ~theme: Paper.ThemeProvider.Theme.t=?,
    ~children: React.element,
  ) => React.element = "Provider"
}

@react.component
let make = () => {
  <PaperProvider theme=paperTheme>
    <ReactNativeSafeAreaContext.SafeAreaProvider>
      <View style={styles["container"]}>
        <StatusBar style="auto" />
        <Button
          onPress={_ => Camera_Service.launchCamera(~onSave=Js.log, ())} title={"Take a picture"}
        />
        <Camera />
      </View>
    </ReactNativeSafeAreaContext.SafeAreaProvider>
  </PaperProvider>
}

let default = make
