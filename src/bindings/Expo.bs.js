

import * as Curry from "../../node_modules/rescript/lib/es6/curry.js";
import * as React from "react";
import * as $$Promise from "../../node_modules/reason-promise/src/js/promise.bs.js";
import * as Caml_obj from "../../node_modules/rescript/lib/es6/caml_obj.js";
import * as ExpoLinking from "expo-linking";
import * as ExpoLocation from "expo-location";

var Constants = {};

var Clipboard = {};

var $$Permissions = {};

var MediaTypeOptions = {};

var ImagePicker = {
  MediaTypeOptions: MediaTypeOptions
};

var Type = {};

var Result = {};

var IntentLauncher = {
  Type: Type,
  Result: Result
};

var AppLoading = {};

var Font = {};

var MontSerrat = {
  Font: Font
};

var Font$1 = {};

var Roboto = {
  Font: Font$1
};

var GoogleFonts = {
  MontSerrat: MontSerrat,
  Roboto: Roboto
};

var FileSystem = {};

var AndroidImportance = {};

var Notifications = {
  AndroidImportance: AndroidImportance
};

var Accuracy = {};

function toString(t) {
  if (Caml_obj.caml_equal(t, ExpoLocation.GeofencingEventType.Enter)) {
    return "enter";
  } else {
    return "exit";
  }
}

var GeofencingEventType = {
  toString: toString
};

var GeofencingRegionState = {};

var ActivityType = {};

function useHasServicesEnabled(param) {
  var match = React.useState(function () {
        
      });
  var setServiceEnabled = match[1];
  React.useEffect((function () {
          $$Promise.tapOk($$Promise.Js.toResult(ExpoLocation.hasServicesEnabledAsync()), (function (enabled) {
                  return Curry._1(setServiceEnabled, (function (param) {
                                return enabled;
                              }));
                }));
          
        }), []);
  return match[0];
}

function useGetForegroundPermission(param) {
  var match = React.useState(function () {
        
      });
  var setPermission = match[1];
  React.useEffect((function () {
          $$Promise.tapOk($$Promise.Js.toResult(ExpoLocation.getForegroundPermissionsAsync()), (function (permission) {
                  return Curry._1(setPermission, (function (param) {
                                return permission;
                              }));
                }));
          
        }), []);
  return match[0];
}

function useGetBackgroundPermission(param) {
  var match = React.useState(function () {
        
      });
  var setPermission = match[1];
  React.useEffect((function () {
          $$Promise.tapOk($$Promise.Js.toResult(ExpoLocation.getBackgroundPermissionsAsync()), (function (permission) {
                  return Curry._1(setPermission, (function (param) {
                                return permission;
                              }));
                }));
          
        }), []);
  return match[0];
}

function useHasStartedLocationUpdatesAsync(taskName) {
  var match = React.useState(function () {
        
      });
  var setStarted = match[1];
  React.useEffect((function () {
          $$Promise.tapOk($$Promise.Js.toResult(ExpoLocation.hasStartedLocationUpdatesAsync(taskName)), (function (started) {
                  return Curry._1(setStarted, (function (param) {
                                return started;
                              }));
                }));
          
        }), []);
  return match[0];
}

var $$Location = {
  Accuracy: Accuracy,
  GeofencingEventType: GeofencingEventType,
  GeofencingRegionState: GeofencingRegionState,
  ActivityType: ActivityType,
  useHasServicesEnabled: useHasServicesEnabled,
  useGetForegroundPermission: useGetForegroundPermission,
  useGetBackgroundPermission: useGetBackgroundPermission,
  useHasStartedLocationUpdatesAsync: useHasStartedLocationUpdatesAsync
};

var AsyncStorage = {};

var Result$1 = {};

var BackgroundFetch = {
  Result: Result$1
};

var TaskManager = {};

var SaveFormat = {};

var ImageManipulator = {
  SaveFormat: SaveFormat
};

function openURL(url) {
  return $$Promise.flatMapOk($$Promise.map($$Promise.Js.toResult(ExpoLinking.canOpenURL(url)), (function (supported) {
                    if (supported.TAG === /* Ok */0 && supported._0) {
                      return {
                              TAG: /* Ok */0,
                              _0: undefined
                            };
                    } else {
                      return {
                              TAG: /* Error */1,
                              _0: undefined
                            };
                    }
                  })), (function (param) {
                return $$Promise.Js.toResult(ExpoLinking.openURL(url));
              }));
}

var Linking = {
  openURL: openURL
};

var Camera = {};

var UpdateEventType = {};

var Updates = {
  UpdateEventType: UpdateEventType
};

export {
  Constants ,
  Clipboard ,
  $$Permissions ,
  ImagePicker ,
  IntentLauncher ,
  AppLoading ,
  GoogleFonts ,
  FileSystem ,
  Notifications ,
  $$Location ,
  AsyncStorage ,
  BackgroundFetch ,
  TaskManager ,
  ImageManipulator ,
  Linking ,
  Camera ,
  Updates ,
  
}
/* react Not a pure module */
