// ----------------------
// useDisclosure
// ----------------------

type disclosure = {
  isOpen: bool,
  show: unit => unit,
  hide: unit => unit,
  toggle: unit => unit,
}

let useDisclosure = (~defaultIsOpen=?, ()) => {
  let (isOpen, setIsOpen) = React.useState(() => defaultIsOpen->Belt.Option.getWithDefault(false))

  {
    isOpen: isOpen,
    show: React.useCallback(() => setIsOpen(_ => true)),
    hide: React.useCallback(() => setIsOpen(_ => false)),
    toggle: React.useCallback(() => setIsOpen(isOpen => !isOpen)),
  }
}

let useToggle = (defaultValue: bool) => {
  let (value, setValue) = React.useState(() => defaultValue)
  let toggle = () => setValue(v => !v)

  (value, toggle)
}

let _hardwareBackPress = (action, ()) => {
  let event = ReactNative.BackHandler.addEventListener(#hardwareBackPress, action)

  Some(
    () => {
      Obj.magic(event["remove"])(.)
    },
  )
}

let useHardwareBackPress = (action: unit => bool, deps) =>
  React.useEffect1(_hardwareBackPress(action), deps)

let useHardwareBackPress2 = (action: unit => bool, deps) =>
  React.useEffect2(_hardwareBackPress(action), deps)

let useWhenAppComeToForeground = cb => {
  let appState = React.useRef(ReactNative.AppState.currentState)

  React.useEffect0(() => {
    let handleAppStateChange = nextAppState => {
      switch (appState.current, nextAppState) {
      | (#inactive, #active)
      | (#background, #active) =>
        cb()
      | _ => ()
      }

      appState.current = nextAppState
    }

    ReactNative.AppState.addEventListener(#change(handleAppStateChange))

    Some(() => ReactNative.AppState.removeEventListener(#change(handleAppStateChange)))
  })
}

let usePrevious = state => {
  let ref = React.useRef(None)

  React.useEffect(() => {
    ref.current = Some(state)

    None
  })

  ref.current
}
