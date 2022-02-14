

import * as Curry from "../node_modules/rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_math from "../node_modules/rescript/lib/es6/js_math.js";
import * as $$Promise from "../node_modules/reason-promise/src/js/promise.bs.js";
import * as Belt_Array from "../node_modules/rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "../node_modules/rescript/lib/es6/belt_Option.js";
import * as Caml_option from "../node_modules/rescript/lib/es6/caml_option.js";
import * as ReactUpdate from "../node_modules/rescript-react-update/src/ReactUpdate.bs.js";
import * as ExpoCamera from "expo-camera";
import * as ReactNative from "react-native";
import * as ExpoFileSystem from "expo-file-system";
import * as Style$ReactNative from "../node_modules/rescript-react-native/src/apis/Style.bs.js";
import * as ReactNativePaper from "react-native-paper";
import * as ExpoImageManipulator from "expo-image-manipulator";
import * as Hooks$ExpoRescriptTemplate from "./Hooks.bs.js";
import * as Theme$ExpoRescriptTemplate from "./Theme.bs.js";
import * as ReactNativeSafeAreaContext from "react-native-safe-area-context";
import * as Camera_Service$ExpoRescriptTemplate from "./Camera_Service.bs.js";
import FontAwesome5 from "react-native-vector-icons/FontAwesome5";
import * as Paper__ActivityIndicator$ExpoRescriptTemplate from "./bindings/paper/Paper__ActivityIndicator.bs.js";

function reducePictureSize(initialUri, compress) {
  return $$Promise.flatMapOk($$Promise.mapError($$Promise.Js.toResult(ExpoImageManipulator.manipulateAsync(initialUri, [/* Resize */{
                            resize: {
                              width: 800
                            }
                          }], {
                          compress: compress,
                          format: ExpoImageManipulator["ImageManipulator.SaveFormat.JPEG"],
                          base64: false
                        })), (function (param) {
                    
                  })), (function (param) {
                var uri = param.uri;
                return $$Promise.mapError($$Promise.flatMapOk($$Promise.mapError($$Promise.Js.toResult(ExpoFileSystem.getInfoAsync(uri, {
                                            size: true
                                          })), (function (param) {
                                      
                                    })), (function (param) {
                                  if ((param.size / 1000 | 0) > 200 && compress > 0.20) {
                                    return $$Promise.mapError(reducePictureSize(initialUri, compress - 0.10), (function (param) {
                                                  
                                                }));
                                  } else {
                                    return $$Promise.resolved({
                                                TAG: /* Ok */0,
                                                _0: uri
                                              });
                                  }
                                })), (function (_err) {
                              
                            }));
              }));
}

var styles = ReactNative.StyleSheet.create({
      root: {
        backgroundColor: "#000",
        flex: 1
      },
      camera: {
        flex: 1,
        justifyContent: "flex-end"
      },
      centerView: {
        alignItems: "center",
        flex: 1,
        justifyContent: "center"
      },
      text: {
        color: "#fff",
        fontSize: 16
      },
      buttonTakePicture: {
        backgroundColor: "#fff",
        borderRadius: 100,
        elevation: 2,
        shadowColor: Theme$ExpoRescriptTemplate.Colors.neutral400,
        shadowOffset: {
          height: 2,
          width: 0
        },
        shadowOpacity: 0.25,
        alignItems: "center",
        flex: 0,
        height: 66,
        justifyContent: "center",
        width: 66
      },
      buttonContent: {
        borderColor: "#eee",
        borderRadius: 100,
        borderWidth: 1,
        flex: 0,
        height: 56,
        width: 56
      },
      rootButtons: {
        backgroundColor: "rgba(24,24,24,0.35)",
        alignItems: "center",
        flex: 0,
        flexDirection: "row",
        justifyContent: "space-around",
        width: Style$ReactNative.pct(100)
      },
      header: {
        elevation: 2,
        alignItems: "center",
        flex: 0,
        flexDirection: "row",
        height: 80,
        left: 0,
        paddingHorizontal: 16,
        position: "absolute",
        top: 0,
        width: Style$ReactNative.pct(100),
        zIndex: 100
      }
    });

var screenSize = ReactNative.Dimensions.get("screen");

function getBestRatioAvailable(camera) {
  var screenRatio = screenSize.height / screenSize.width;
  return $$Promise.flatMapOk($$Promise.Js.toResult(camera.getSupportedRatiosAsync()), (function (availableRatios) {
                return $$Promise.mapOk($$Promise.Js.toResult($$Promise.allArray(Belt_Array.map(availableRatios, (function (ratio) {
                                          return $$Promise.Js.$$catch(camera.getAvailablePictureSizesAsync(ratio), (function (param) {
                                                        return $$Promise.resolved([]);
                                                      }));
                                        })))), (function (availablePictureSizes) {
                              var supportedRatio = Belt_Array.keepWithIndex(availableRatios, (function (_ratio, i) {
                                      var sizesRatio = Belt_Array.get(availablePictureSizes, i);
                                      if (sizesRatio !== undefined) {
                                        return sizesRatio.length !== 0;
                                      } else {
                                        return false;
                                      }
                                    }));
                              console.log("Supported ratios", supportedRatio);
                              var supportedRatio$1 = Belt_Array.map(supportedRatio, (function (ratio) {
                                      var ratioParsed = ratio.split(":");
                                      var realRatio = Number(Belt_Array.get(ratioParsed, 0)) / Number(Belt_Array.get(ratioParsed, 1));
                                      return [
                                              ratio,
                                              screenRatio - realRatio
                                            ];
                                    }));
                              var match = Belt_Array.reduce(supportedRatio$1, supportedRatio$1[0], (function (savedRatio, ratio) {
                                      var calculatedSavedRatio = savedRatio[1];
                                      if (calculatedSavedRatio >= 0 && calculatedSavedRatio < ratio[1]) {
                                        return savedRatio;
                                      } else {
                                        return ratio;
                                      }
                                    }));
                              var verticalPadding = Js_math.floor(match[1] * screenSize.width / 2) / 2 | 0;
                              return {
                                      verticalPadding: verticalPadding,
                                      ratio: match[0]
                                    };
                            }));
              }));
}

function Camera(Props) {
  var match = Curry._2(Camera_Service$ExpoRescriptTemplate.store.useStore, undefined, undefined);
  var onSave = match.onSave;
  var onCancel = match.onCancel;
  var visible = match.visible;
  var insets = ReactNativeSafeAreaContext.useSafeAreaInsets();
  var cameraRef = React.useRef(null);
  var match$1 = ReactUpdate.useReducerWithMapState((function (state, action) {
          if (typeof action === "number") {
            switch (action) {
              case /* TakePicture */0 :
                  return {
                          TAG: /* UpdateWithSideEffects */1,
                          _0: {
                            permissionGranted: state.permissionGranted,
                            cameraState: /* Processing */2,
                            ratio: state.ratio
                          },
                          _1: (function (param) {
                              var send = param.send;
                              Belt_Option.forEach(Caml_option.nullable_to_opt(cameraRef.current), (function (camera) {
                                      $$Promise.tapOk($$Promise.Js.toResult(camera.takePictureAsync({
                                                    quality: 1,
                                                    base64: false
                                                  })), (function (picture) {
                                              Curry._1(send, {
                                                    TAG: /* Preview */3,
                                                    _0: picture
                                                  });
                                              camera.pausePreview();
                                              
                                            }));
                                      
                                    }));
                              
                            })
                        };
              case /* Cancel */1 :
                  return {
                          TAG: /* UpdateWithSideEffects */1,
                          _0: {
                            permissionGranted: state.permissionGranted,
                            cameraState: /* Idle */1,
                            ratio: state.ratio
                          },
                          _1: (function (param) {
                              Belt_Option.forEach(Caml_option.nullable_to_opt(cameraRef.current), (function (camera) {
                                      camera.resumePreview();
                                      
                                    }));
                              
                            })
                        };
              case /* Confirm */2 :
                  return {
                          TAG: /* SideEffects */2,
                          _0: (function (param) {
                              var match = param.state.cameraState;
                              if (onSave !== undefined && typeof match !== "number" && match.TAG === /* WaitingApproval */1) {
                                var uri = match._0.uri;
                                $$Promise.tapError($$Promise.tapOk(reducePictureSize(uri, 0.70), Curry.__1(onSave)), (function (param) {
                                        return Curry._1(onSave, uri);
                                      }));
                                Curry._1(param.send, /* Exit */3);
                              }
                              
                            })
                        };
              case /* Exit */3 :
                  return {
                          TAG: /* UpdateWithSideEffects */1,
                          _0: {
                            permissionGranted: state.permissionGranted,
                            cameraState: /* Idle */1,
                            ratio: state.ratio
                          },
                          _1: (function (param) {
                              Belt_Option.forEach(onCancel, (function (fn) {
                                      return Curry._1(fn, undefined);
                                    }));
                              Camera_Service$ExpoRescriptTemplate.hide(undefined);
                              
                            })
                        };
              
            }
          } else {
            switch (action.TAG | 0) {
              case /* PermissionGranted */0 :
                  return {
                          TAG: /* Update */0,
                          _0: {
                            permissionGranted: action._0,
                            cameraState: state.cameraState,
                            ratio: state.ratio
                          }
                        };
              case /* CameraReady */1 :
                  return {
                          TAG: /* Update */0,
                          _0: {
                            permissionGranted: state.permissionGranted,
                            cameraState: /* Idle */1,
                            ratio: action._0
                          }
                        };
              case /* UnableToMountCamera */2 :
                  return {
                          TAG: /* Update */0,
                          _0: {
                            permissionGranted: state.permissionGranted,
                            cameraState: {
                              TAG: /* MountError */0,
                              _0: action._0
                            },
                            ratio: state.ratio
                          }
                        };
              case /* Preview */3 :
                  return {
                          TAG: /* Update */0,
                          _0: {
                            permissionGranted: state.permissionGranted,
                            cameraState: {
                              TAG: /* WaitingApproval */1,
                              _0: action._0
                            },
                            ratio: state.ratio
                          }
                        };
              
            }
          }
        }), (function (param) {
          return {
                  permissionGranted: undefined,
                  cameraState: /* NotReady */0,
                  ratio: undefined
                };
        }));
  var dispatch = match$1[1];
  var match$2 = match$1[0];
  var ratio = match$2.ratio;
  var cameraState = match$2.cameraState;
  React.useEffect((function () {
          if (visible) {
            $$Promise.tapOk($$Promise.Js.toResult(ExpoCamera.Camera.getCameraPermissionsAsync()), (function (param) {
                    if (param.status === "granted") {
                      return Curry._1(dispatch, {
                                  TAG: /* PermissionGranted */0,
                                  _0: true
                                });
                    } else {
                      $$Promise.tapOk($$Promise.Js.toResult(ExpoCamera.Camera.requestCameraPermissionsAsync()), (function (param) {
                              return Curry._1(dispatch, {
                                          TAG: /* PermissionGranted */0,
                                          _0: param.status === "granted"
                                        });
                            }));
                      return ;
                    }
                  }));
          }
          
        }), [visible]);
  Hooks$ExpoRescriptTemplate.useHardwareBackPress2((function (param) {
          if (!visible) {
            return false;
          }
          if (typeof cameraState === "number" || cameraState.TAG !== /* WaitingApproval */1) {
            Curry._1(dispatch, /* Exit */3);
          } else {
            Curry._1(dispatch, /* Cancel */1);
          }
          return true;
        }), [
        visible,
        cameraState
      ]);
  if (visible) {
    return React.createElement(ReactNativePaper.Portal, {
                children: React.createElement(ReactNative.View, {
                      style: styles.root,
                      children: null
                    }, React.createElement(ReactNative.View, {
                          style: [
                            styles.header,
                            {
                              paddingTop: insets.top
                            }
                          ],
                          children: React.createElement(ReactNative.TouchableOpacity, {
                                onPress: (function (param) {
                                    return Curry._1(dispatch, /* Exit */3);
                                  }),
                                children: React.createElement(FontAwesome5, {
                                      name: "times",
                                      color: "#fff",
                                      size: 36
                                    })
                              })
                        }), Belt_Option.mapWithDefault(match$2.permissionGranted, React.createElement(ReactNative.View, {
                              style: styles.centerView
                            }), (function (permissionGranted) {
                            if (!permissionGranted) {
                              return React.createElement(ReactNative.View, {
                                          style: styles.centerView,
                                          children: React.createElement(ReactNativePaper.Text, {
                                                style: styles.text,
                                                children: "pleaseAllowCameraPermission"
                                              })
                                        });
                            }
                            var tmp;
                            if (typeof cameraState === "number") {
                              switch (cameraState) {
                                case /* NotReady */0 :
                                    tmp = null;
                                    break;
                                case /* Idle */1 :
                                    tmp = React.createElement(ReactNative.TouchableOpacity, {
                                          style: styles.buttonTakePicture,
                                          onPress: (function (param) {
                                              return Curry._1(dispatch, /* TakePicture */0);
                                            }),
                                          children: React.createElement(ReactNative.View, {
                                                style: styles.buttonContent
                                              })
                                        });
                                    break;
                                case /* Processing */2 :
                                    tmp = React.createElement(ReactNativePaper.ActivityIndicator, {
                                          color: "#fff",
                                          size: Paper__ActivityIndicator$ExpoRescriptTemplate.Size.large
                                        });
                                    break;
                                
                              }
                            } else {
                              tmp = cameraState.TAG === /* MountError */0 ? React.createElement(ReactNativePaper.Text, {
                                      style: styles.text,
                                      children: cameraState._0
                                    }) : React.createElement(React.Fragment, undefined, React.createElement(ReactNative.TouchableOpacity, {
                                          onPress: (function (param) {
                                              return Curry._1(dispatch, /* Cancel */1);
                                            }),
                                          children: React.createElement(FontAwesome5, {
                                                name: "times-circle",
                                                color: "#fff",
                                                size: 50
                                              })
                                        }), React.createElement(ReactNative.TouchableOpacity, {
                                          onPress: (function (param) {
                                              return Curry._1(dispatch, /* Confirm */2);
                                            }),
                                          children: React.createElement(FontAwesome5, {
                                                name: "check",
                                                color: "#fff",
                                                size: 50
                                              })
                                        }));
                            }
                            return React.createElement(ExpoCamera.Camera, {
                                        style: [
                                          Caml_option.some(styles.camera),
                                          Belt_Option.map(ratio, (function (param) {
                                                  return {
                                                          marginVertical: param.verticalPadding
                                                        };
                                                }))
                                        ],
                                        children: React.createElement(ReactNative.View, {
                                              style: [
                                                styles.rootButtons,
                                                {
                                                  paddingVertical: insets.bottom > 0 ? insets.bottom : 20
                                                }
                                              ],
                                              children: tmp
                                            }),
                                        useCamera2Api: true,
                                        ratio: Belt_Option.mapWithDefault(ratio, "4:3", (function (param) {
                                                return param.ratio;
                                              })),
                                        ref: (function (ref_) {
                                            cameraRef.current = ref_;
                                            
                                          }),
                                        onCameraReady: (function (param) {
                                            if (ratio !== undefined) {
                                              return Curry._1(dispatch, {
                                                          TAG: /* CameraReady */1,
                                                          _0: ratio
                                                        });
                                            } else if (ReactNative.Platform.OS === "android") {
                                              return Belt_Option.forEach(Caml_option.nullable_to_opt(cameraRef.current), (function (camera) {
                                                            $$Promise.tapError($$Promise.tapOk(getBestRatioAvailable(camera), (function (ratio) {
                                                                        return Curry._1(dispatch, {
                                                                                    TAG: /* CameraReady */1,
                                                                                    _0: ratio
                                                                                  });
                                                                      })), (function (err) {
                                                                    console.log("getBestRatioAvailable error", err);
                                                                    
                                                                  }));
                                                            
                                                          }));
                                            } else {
                                              return Curry._1(dispatch, {
                                                          TAG: /* CameraReady */1,
                                                          _0: {
                                                            verticalPadding: 0,
                                                            ratio: "4:3"
                                                          }
                                                        });
                                            }
                                          }),
                                        onMountError: (function (error) {
                                            return Curry._1(dispatch, {
                                                        TAG: /* UnableToMountCamera */2,
                                                        _0: Belt_Option.getWithDefault(error.message, "Unable to mount camera")
                                                      });
                                          })
                                      });
                          })))
              });
  } else {
    return null;
  }
}

var make = Camera;

export {
  reducePictureSize ,
  styles ,
  screenSize ,
  getBestRatioAvailable ,
  make ,
  
}
/* styles Not a pure module */
