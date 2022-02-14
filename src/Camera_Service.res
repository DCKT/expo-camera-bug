type state = {
  visible: bool,
  onCancel: option<unit => unit>,
  onSave: option<string => unit>,
}

type action =
  | Hide
  | Show({onCancel: unit => unit, onSave: string => unit})

let initialState = {visible: false, onCancel: None, onSave: None}

let store = Restorative.createStore(initialState, (_state, action) =>
  switch action {
  | Hide => initialState
  | Show({onCancel, onSave}) => {
      visible: true,
      onCancel: Some(onCancel),
      onSave: Some(onSave),
    }
  }
)

let launchCamera = (~onSave: string => unit, ~onCancel=() => (), ()) =>
  store.dispatch(Show({onCancel: onCancel, onSave: onSave}))

let hide = () => store.dispatch(Hide)
