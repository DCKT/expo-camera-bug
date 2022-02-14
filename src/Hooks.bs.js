

import * as Curry from "../node_modules/rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Option from "../node_modules/rescript/lib/es6/belt_Option.js";
import * as Caml_option from "../node_modules/rescript/lib/es6/caml_option.js";
import * as ReactNative from "react-native";

function useDisclosure(defaultIsOpen, param) {
  var match = React.useState(function () {
        return Belt_Option.getWithDefault(defaultIsOpen, false);
      });
  var setIsOpen = match[1];
  return {
          isOpen: match[0],
          show: React.useCallback(function (param) {
                return Curry._1(setIsOpen, (function (param) {
                              return true;
                            }));
              }),
          hide: React.useCallback(function (param) {
                return Curry._1(setIsOpen, (function (param) {
                              return false;
                            }));
              }),
          toggle: React.useCallback(function (param) {
                return Curry._1(setIsOpen, (function (isOpen) {
                              return !isOpen;
                            }));
              })
        };
}

function useToggle(defaultValue) {
  var match = React.useState(function () {
        return defaultValue;
      });
  var setValue = match[1];
  var toggle = function (param) {
    return Curry._1(setValue, (function (v) {
                  return !v;
                }));
  };
  return [
          match[0],
          toggle
        ];
}

function _hardwareBackPress(action, param) {
  var $$event = ReactNative.BackHandler.addEventListener("hardwareBackPress", action);
  return (function (param) {
            return $$event.remove();
          });
}

function useHardwareBackPress(action, deps) {
  React.useEffect((function () {
          return _hardwareBackPress(action, undefined);
        }), deps);
  
}

function useHardwareBackPress2(action, deps) {
  React.useEffect((function () {
          return _hardwareBackPress(action, undefined);
        }), deps);
  
}

function useWhenAppComeToForeground(cb) {
  var appState = React.useRef(ReactNative.AppState.currentState);
  React.useEffect((function () {
          var handleAppStateChange = function (nextAppState) {
            var match = appState.current;
            if ((match === "background" || match === "inactive") && nextAppState === "active") {
              Curry._1(cb, undefined);
            }
            appState.current = nextAppState;
            
          };
          ReactNative.AppState.addEventListener("change", handleAppStateChange);
          return (function (param) {
                    ReactNative.AppState.removeEventListener("change", handleAppStateChange);
                    
                  });
        }), []);
  
}

function usePrevious(state) {
  var ref = React.useRef(undefined);
  React.useEffect(function () {
        ref.current = Caml_option.some(state);
        
      });
  return ref.current;
}

export {
  useDisclosure ,
  useToggle ,
  _hardwareBackPress ,
  useHardwareBackPress ,
  useHardwareBackPress2 ,
  useWhenAppComeToForeground ,
  usePrevious ,
  
}
/* react Not a pure module */
