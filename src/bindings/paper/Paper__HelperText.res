@module("react-native-paper") @react.component
external make: (
  ~theme: Paper__ThemeProvider.Theme.t=?,
  ~style: ReactNative.Style.t=?,
  ~visible: bool=?,
  ~testID: string=?,
  ~accessibilityLabel: string=?,
  ~_type: [#error | #info],
  ~children: React.element,
) => React.element = "HelperText"
