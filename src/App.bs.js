

import * as React from "react";
import * as ReactNative from "react-native";
import * as ExpoStatusBar from "expo-status-bar";
import * as ReactNativePaper from "react-native-paper";
import * as Camera$ExpoRescriptTemplate from "./Camera.bs.js";
import * as ReactNativeSafeAreaContext from "react-native-safe-area-context";
import * as Camera_Service$ExpoRescriptTemplate from "./Camera_Service.bs.js";

var StatusBar = {};

var styles = ReactNative.StyleSheet.create({
      container: {
        backgroundColor: "#fff",
        alignItems: "center",
        flex: 1,
        justifyContent: "center"
      }
    });

var primary = "#12c8e0";

var secondary = "#245056";

var danger = "#ff1744";

var white = "#fff";

var paperTheme = Object.assign(ReactNativePaper.DefaultTheme, {
      colors: {
        primary: primary,
        accent: secondary,
        background: white,
        surface: white,
        error: danger,
        text: "black",
        disabled: "rgba(0, 0, 0, 0.26)",
        placeholder: "rgba(0, 0, 0, 0.54)",
        backdrop: "rgba(0, 0, 0, 0.5)",
        onSurface: "rgba(44, 44, 44, 1)"
      }
    });

var PaperProvider = {};

function App(Props) {
  return React.createElement(ReactNativePaper.Provider, {
              theme: paperTheme,
              children: React.createElement(ReactNativeSafeAreaContext.SafeAreaProvider, {
                    children: React.createElement(ReactNative.View, {
                          style: styles.container,
                          children: null
                        }, React.createElement(ExpoStatusBar.StatusBar, {
                              style: "auto"
                            }), React.createElement(ReactNative.Button, {
                              onPress: (function (param) {
                                  return Camera_Service$ExpoRescriptTemplate.launchCamera((function (prim) {
                                                console.log(prim);
                                                
                                              }), undefined, undefined);
                                }),
                              title: "Take a picture"
                            }), React.createElement(Camera$ExpoRescriptTemplate.make, {}))
                  })
            });
}

var success = "#7cb342";

var warning = "#ffb300";

var light = "#f2f9f9";

var dark = "#15373a";

var grey = "#ccc";

var darkGrey = "#777";

var make = App;

var $$default = App;

export {
  StatusBar ,
  styles ,
  primary ,
  secondary ,
  success ,
  warning ,
  danger ,
  light ,
  dark ,
  white ,
  grey ,
  darkGrey ,
  paperTheme ,
  PaperProvider ,
  make ,
  $$default ,
  $$default as default,
  
}
/* styles Not a pure module */
