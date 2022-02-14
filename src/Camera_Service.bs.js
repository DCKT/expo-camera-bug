

import * as Curry from "../node_modules/rescript/lib/es6/curry.js";
import * as Restorative from "../node_modules/restorative/src/Restorative.bs.js";

var initialState = {
  visible: false,
  onCancel: undefined,
  onSave: undefined
};

var store = Restorative.createStore(initialState, (function (_state, action) {
        if (action) {
          return {
                  visible: true,
                  onCancel: action.onCancel,
                  onSave: action.onSave
                };
        } else {
          return initialState;
        }
      }));

function launchCamera(onSave, onCancelOpt, param) {
  var onCancel = onCancelOpt !== undefined ? onCancelOpt : (function (param) {
        
      });
  return Curry._1(store.dispatch, /* Show */{
              onCancel: onCancel,
              onSave: onSave
            });
}

function hide(param) {
  return Curry._1(store.dispatch, /* Hide */0);
}

export {
  initialState ,
  store ,
  launchCamera ,
  hide ,
  
}
/* store Not a pure module */
