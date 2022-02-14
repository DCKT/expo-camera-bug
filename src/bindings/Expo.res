module Constants = {
  @module("expo-constants") @scope("default")
  external nativeAppVersion: string = "nativeAppVersion"
  @module("expo-constants") @scope("default")
  external isDevice: bool = "isDevice"
  @module("expo-constants") @scope("default")
  external manifest: Js.Dict.t<string> = "manifest"
}

module Clipboard = {
  @module("expo-clipboard")
  external setString: string => unit = "setString"
}

module Permissions = {
  type iosScope = [#whenInUse | #always]
  type androidScope = [#fine | #coarse | #none]

  type rec response = {
    status: status,
    granted: bool,
    expires: expires,
    canAskAgain: bool,
    permissions: Js.Dict.t<permissionInfo>,
  }
  and status = [#granted | #undetermined | #denied]
  and expires = [#never | #number(int)]
  and permissionInfo = {
    status: status,
    granted: bool,
    expires: expires,
    canAskAgain: bool,
    ios: option<iosScope>,
    android: option<androidScope>,
  }
}

module ImagePicker = {
  @module("expo-image-picker")
  external requestCameraPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "requestCameraPermissionsAsync"

  module MediaTypeOptions = {
    type t

    @module("expo-image-picker") external all: t = "MediaTypeOptions.All"

    @module("expo-image-picker")
    external images: t = "MediaTypeOptions.Images"

    @module("expo-image-picker")
    external videos: t = "MediaTypeOptions.Videos"
  }

  type options

  @obj
  external makeOptions: (
    ~mediaTypes: MediaTypeOptions.t=?,
    ~allowsEditing: bool=?,
    ~quality: float,
    ~base64: bool=?,
    ~aspect: (int, int)=?,
    unit,
  ) => options = ""

  type response = {
    cancelled: bool,
    @as("type")
    type_: string,
    uri: string,
    width: int,
    height: int,
    base64: option<string>,
  }

  @module("expo-image-picker")
  external launchCameraAsync: options => Promise.Js.t<response, 'err> = "launchCameraAsync"

  @module("expo-image-picker")
  external getPendingResultAsync: unit => Promise.Js.t<array<response>, 'err> =
    "getPendingResultAsync"
}

module IntentLauncher = {
  module Type = {
    type t
    @module("expo-intent-launcher")
    external locationSource: t = "ACTION_LOCATION_SOURCE_SETTINGS"
    @module("expo-intent-launcher")
    external applicationSettings: t = "ACTION_APPLICATION_SETTINGS"
    @module("expo-intent-launcher")
    external applicationDetailsSettings: t = "ACTION_APPLICATION_DETAILS_SETTINGS"
  }

  module Result = {
    type t

    @module("expo-intent-launcher") external success: t = "Success"
    @module("expo-intent-launcher") external canceled: t = "Canceled"
    @module("expo-intent-launcher") external firstUser: t = "FirstUser"
  }

  type intentParams

  @obj
  external intentParams: (~data: 'a=?, ~flags: int=?, unit) => intentParams = ""

  @module("expo-intent-launcher")
  external startActivityAsync: (
    ~activityAction: Type.t,
    ~intentParams: intentParams=?,
    unit,
  ) => Promise.Js.t<Result.t, 'a> = "startActivityAsync"
}

module AppLoading = {
  @module("expo-app-loading") @react.component
  external make: unit => React.element = "default"
}

module GoogleFonts = {
  module MontSerrat = {
    module Font = {
      type t

      @module("@expo-google-fonts/montserrat")
      external light300: t = "Montserrat_300Light"
      @module("@expo-google-fonts/montserrat")
      external regular400: t = "Montserrat_400Regular"
      @module("@expo-google-fonts/montserrat")
      external bold700: t = "Montserrat_700Bold"
      @module("@expo-google-fonts/montserrat")
      external semiBold600: t = "Montserrat_600SemiBold"
      @module("@expo-google-fonts/montserrat")
      external regularItalic400: t = "Montserrat_400Regular_Italic"
    }

    @module("@expo-google-fonts/montserrat")
    external useFonts: Js.Dict.t<Font.t> => (bool, unit) = "useFonts"
  }
  module Roboto = {
    module Font = {
      type t

      @module("@expo-google-fonts/roboto")
      external light300: t = "Roboto_300Light"
      @module("@expo-google-fonts/roboto")
      external regular400: t = "Roboto_400Regular"
      @module("@expo-google-fonts/roboto")
      external medium500: t = "Roboto_500Medium"
      @module("@expo-google-fonts/roboto")
      external bold700: t = "Roboto_700Bold"
      @module("@expo-google-fonts/roboto")
      external regularItalic400: t = "Roboto_400Regular_Italic"
    }

    @module("@expo-google-fonts/roboto")
    external useFonts: Js.Dict.t<Font.t> => (bool, unit) = "useFonts"
  }
}

module FileSystem = {
  @module("expo-file-system")
  external documentDirectory: string = "documentDirectory"

  type downloadResult = {
    uri: string,
    status: int,
    headers: {.},
  }

  @module("expo-file-system")
  external downloadAsync: (string, string) => Promise.Js.t<downloadResult, 'a> = "downloadAsync"

  @module("expo-file-system")
  external getContentUriAsync: string => Promise.Js.t<string, 'a> = "getContentUriAsync"

  type getInfoAsyncOptions = {size: bool}

  type getInfoAsyncError = {
    exists: bool,
    isDirectory: bool,
  }

  type getInfoAsyncResult = {
    exists: bool,
    isDirectory: bool,
    size: int,
    uri: string,
    modificationTime: int,
  }

  @module("expo-file-system")
  external getInfoAsync: (
    string,
    getInfoAsyncOptions,
  ) => Promise.Js.t<getInfoAsyncResult, getInfoAsyncError> = "getInfoAsync"

  @module("expo-file-system")
  external cacheDirectory: string = "cacheDirectory"

  type deleteAsyncOptions = {idempotent: bool}
  @module("expo-file-system")
  external deleteAsync: (string, deleteAsyncOptions) => Promise.Js.t<unit, unit> = "deleteAsync"

  @module("expo-file-system")
  external makeDirectoryAsync: string => Promise.Js.t<string, unit> = "makeDirectoryAsync"
}

module Notifications = {
  type expoToken = string

  type handleNotification = {
    shouldShowAlert: bool,
    shouldPlaySound: bool,
    shouldSetBadge: bool,
  }

  type notificationHandlerOptions

  @obj
  external makeNotificationHandlerOptions: (
    ~handleNotification: unit => handleNotification,
    unit,
  ) => notificationHandlerOptions = ""

  @module("expo-notifications")
  external setNotificationHandler: notificationHandlerOptions => unit = "setNotificationHandler"

  @module("expo-notifications")
  external getPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "getPermissionsAsync"

  @module("expo-notifications")
  external requestPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "requestPermissionsAsync"

  module AndroidImportance = {
    type t

    @module("expo-notifications") @scope("AndroidImportance")
    external max: t = "MAX"
  }

  type channelOptions = {
    name: string,
    importance: AndroidImportance.t,
    vibrationPattern: array<int>,
    lightColor: string,
  }

  @module("expo-notifications")
  external setNotificationChannelAsync: (string, channelOptions) => unit =
    "setNotificationChannelAsync"

  type listener

  @module("expo-notifications")
  external addNotificationReceivedListener: 'a => listener = "addNotificationReceivedListener"

  type rec notificationResponse = {
    notification: notification,
    actionIdentifier: string,
    userText: option<string>,
  }
  and notification = {
    date: int,
    request: notificationRequest,
  }
  and notificationRequest = {content: notificationContent}
  and notificationContent = {data: Js.Dict.t<string>}

  @module("expo-notifications")
  external addNotificationResponseReceivedListener: (notificationResponse => unit) => listener =
    "addNotificationResponseReceivedListener"

  @module("expo-notifications")
  external removeNotificationSubscription: listener => unit = "removeNotificationSubscription"

  type result = {
    data: expoToken,
    @as("type")
    type_: string,
  }

  @module("expo-notifications")
  external getExpoPushTokenAsync: unit => Promise.Js.t<result, 'err> = "getExpoPushTokenAsync"

  type rec setNotificationCategoryAction = {
    identifier: string,
    buttonTitle: string,
    options: setNotificationCategoryActionOptions,
  }
  and setNotificationCategoryActionOptions = {isDestructive: bool}

  type notificationCategory = {
    identifier: string,
    actions: array<setNotificationCategoryAction>,
  }

  @module("expo-notifications")
  external setNotificationCategoryAsync: (
    string,
    array<setNotificationCategoryAction>,
  ) => Promise.Js.t<notificationCategory, 'err> = "setNotificationCategoryAsync"

  @module("expo-notifications")
  external getNotificationCategoriesAsync: unit => Promise.Js.t<array<notificationCategory>, 'err> =
    "getNotificationCategoriesAsync"
}

module Location = {
  module Accuracy = {
    type t

    @module("expo-location") @scope("Accuracy")
    external high: t = "High"
    @module("expo-location") @scope("Accuracy")
    external balanced: t = "Balanced"
  }

  module GeofencingEventType = {
    type t

    @module("expo-location") @scope("GeofencingEventType")
    external enter: t = "Enter"

    @module("expo-location") @scope("GeofencingEventType")
    external exit: t = "Exit"

    let toString = t =>
      switch t {
      | t if t == enter => "enter"
      | _ => "exit"
      }
  }

  module GeofencingRegionState = {
    type t

    @module("expo-location") @scope("GeofencingRegionState")
    external inside: t = "Inside"

    @module("expo-location") @scope("GeofencingRegionState")
    external outside: t = "Outside"
  }

  module ActivityType = {
    type t

    @module("expo-location") @scope("ActivityType")
    external automotiveNavigation: t = "AutomotiveNavigation"
  }

  @module("expo-location")
  external hasServicesEnabledAsync: unit => Promise.Js.t<bool, 'err> = "hasServicesEnabledAsync"

  type settings
  type foregroundService = {
    notificationTitle: string,
    notificationBody: string,
  }

  @obj
  external makeSettings: (
    ~deferredUpdatesDistance: int=?,
    ~deferredUpdatesInterval: int=?,
    ~deferredUpdatesTimeout: int=?,
    ~pausesUpdatesAutomatically: bool=?,
    ~foregroundService: foregroundService=?,
    ~accuracy: Accuracy.t=?,
    ~distanceInterval: int=?,
    ~activityType: ActivityType.t=?,
    ~timeInterval: int=?,
    unit,
  ) => settings = ""

  type region = {
    identifier: string,
    latitude: float,
    longitude: float,
    radius: int,
    notifyOnEnter: bool,
    notifyOnExit: bool,
  }

  type regionResult = {
    identifier: string,
    latitude: float,
    longitude: float,
    radius: int,
    state: GeofencingRegionState.t,
  }

  @module("expo-location")
  external startGeofencingAsync: (string, array<region>) => Promise.Js.t<bool, 'err> =
    "startGeofencingAsync"

  @module("expo-location")
  external startLocationUpdatesAsync: (string, settings) => Promise.Js.t<bool, 'err> =
    "startLocationUpdatesAsync"

  type getCurrentPositionSettings = {accuracy: Accuracy.t}
  type rec locationObject = {
    coords: coords,
    timestamp: int,
  }
  and coords = {
    latitude: float,
    longitude: float,
    altitude: Js.Nullable.t<float>,
    altitudeAccuracy: Js.Nullable.t<float>,
  }

  @module("expo-location")
  external getCurrentPositionAsync: (
    ~options: getCurrentPositionSettings=?,
    unit,
  ) => Promise.Js.t<locationObject, 'err> = "getCurrentPositionAsync"

  @module("expo-location")
  external getLastKnownPositionAsync: (
    ~options: getCurrentPositionSettings=?,
    unit,
  ) => Promise.Js.t<Js.Nullable.t<locationObject>, 'err> = "getLastKnownPositionAsync"

  @module("expo-location")
  external stopLocationUpdatesAsync: string => Promise.Js.t<unit, 'err> = "stopLocationUpdatesAsync"

  @module("expo-location")
  external stopGeofencingAsync: string => Promise.Js.t<unit, 'err> = "stopGeofencingAsync"

  let useHasServicesEnabled = () => {
    let (serviceEnabled, setServiceEnabled) = React.useState(() => None)

    React.useEffect0(() => {
      hasServicesEnabledAsync()
      ->Promise.Js.toResult
      ->Promise.tapOk(enabled => setServiceEnabled(_ => Some(enabled)))
      ->ignore

      None
    })

    serviceEnabled
  }

  @module("expo-location")
  external requestForegroundPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "requestForegroundPermissionsAsync"

  @module("expo-location")
  external requestBackgroundPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "requestBackgroundPermissionsAsync"

  @module("expo-location")
  external getBackgroundPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "getBackgroundPermissionsAsync"

  @module("expo-location")
  external hasStartedLocationUpdatesAsync: string => Promise.Js.t<bool, 'err> =
    "hasStartedLocationUpdatesAsync"

  @module("expo-location")
  external getForegroundPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "getForegroundPermissionsAsync"

  let useGetForegroundPermission = () => {
    let (permission, setPermission) = React.useState(() => None)

    React.useEffect0(() => {
      getForegroundPermissionsAsync()
      ->Promise.Js.toResult
      ->Promise.tapOk(permission => setPermission(_ => Some(permission)))
      ->ignore

      None
    })

    permission
  }
  let useGetBackgroundPermission = () => {
    let (permission, setPermission) = React.useState(() => None)

    React.useEffect0(() => {
      getBackgroundPermissionsAsync()
      ->Promise.Js.toResult
      ->Promise.tapOk(permission => setPermission(_ => Some(permission)))
      ->ignore

      None
    })

    permission
  }
  let useHasStartedLocationUpdatesAsync = taskName => {
    let (started, setStarted) = React.useState(() => None)

    React.useEffect0(() => {
      hasStartedLocationUpdatesAsync(taskName)
      ->Promise.Js.toResult
      ->Promise.tapOk(started => setStarted(_ => Some(started)))
      ->ignore

      None
    })

    started
  }
}

module AsyncStorage = {
  @module("@react-native-async-storage/async-storage") @scope("default")
  external getItem: string => Promise.Js.t<Js.Nullable.t<string>, Js.Exn.t> = "getItem"
  @module("@react-native-async-storage/async-storage") @scope("default")
  external removeItem: string => Promise.Js.t<unit, Js.Exn.t> = "removeItem"
  @module("@react-native-async-storage/async-storage") @scope("default")
  external setItem: (string, string) => Promise.Js.t<unit, Js.Exn.t> = "setItem"
}

module BackgroundFetch = {
  module Result = {
    type t

    @module("expo-background-fetch")
    external failed: t = "Failed"
    @module("expo-background-fetch")
    external newData: t = "NewData"
    @module("expo-background-fetch")
    external noData: t = "NoData"
  }

  type registerConfig = {
    minimumInterval: int,
    startOnBoot: bool,
    stopOnTerminate: bool,
  }

  @module("expo-background-fetch")
  external registerTaskAsync: (string, registerConfig) => Promise.Js.t<unit, 'err> =
    "registerTaskAsync"

  @module("expo-task-manager")
  external unregisterTaskAsync: string => Promise.Js.t<unit, 'err> = "unregisterTaskAsync"
}

module TaskManager = {
  type taskData<'data> = {
    data: 'data,
    error: Js.Nullable.t<Js.Exn.t>,
  }

  @module("expo-task-manager")
  external defineTask: (string, taskData<'a> => unit) => unit = "defineTask"

  @module("expo-task-manager")
  external defineBackgroundTask: (
    string,
    taskData<'a> => Promise.promise<result<BackgroundFetch.Result.t, 'err>>,
  ) => unit = "defineTask"
}

module ImageManipulator = {
  type rec action = Resize({resize: resize})
  and resize = {width: int}

  type result = {
    uri: string,
    width: int,
    height: int,
  }

  module SaveFormat = {
    type t

    @module("expo-image-manipulator")
    external png: t = "ImageManipulator.SaveFormat.PNG"

    @module("expo-image-manipulator")
    external jpeg: t = "ImageManipulator.SaveFormat.JPEG"
  }

  type saveOptions = {
    compress: float,
    format: SaveFormat.t,
    base64: bool,
  }

  @module("expo-image-manipulator")
  external manipulateAsync: (string, array<action>, saveOptions) => Promise.Js.t<result, 'a> =
    "manipulateAsync"
}

module Linking = {
  @module("expo-linking")
  external _canOpenURL: string => Promise.Js.t<bool, 'err> = "canOpenURL"

  @module("expo-linking")
  external _openURL: string => Promise.Js.t<bool, 'err> = "openURL"

  let openURL = url =>
    _canOpenURL(url)
    ->Promise.Js.toResult
    ->Promise.map(supported =>
      switch supported {
      | Ok(true) => Ok()
      | _ => Error()
      }
    )
    ->Promise.flatMapOk(() => _openURL(url)->Promise.Js.toResult)
}

module Camera = {
  type cameraRef

  @module("expo-camera") @react.component
  external make: (
    ~style: ReactNative.Style.t,
    ~children: React.element,
    ~useCamera2Api: bool=?,
    ~ratio: string=?,
    ~ref: Js.Nullable.t<cameraRef> => unit,
    ~onCameraReady: unit => unit,
    ~onMountError: Js.Exn.t => unit,
  ) => React.element = "Camera"

  type options

  type response = {
    uri: string,
    width: int,
    height: int,
    base64: option<string>,
  }

  @obj
  external makeOptions: (
    ~allowsEditing: bool=?,
    ~quality: float,
    ~base64: bool=?,
    ~skipProcessing: bool=?,
    ~onPictureSaved: response => unit=?,
    ~aspect: (int, int)=?,
    unit,
  ) => options = ""

  @send
  external takePictureAsync: (cameraRef, options) => Promise.Js.t<response, 'err> =
    "takePictureAsync"

  @send external pausePreview: (cameraRef, unit) => unit = "pausePreview"

  @send
  external resumePreview: (cameraRef, unit) => unit = "resumePreview"

  @send
  external getSupportedRatiosAsync: (cameraRef, unit) => Promise.Js.t<array<string>, 'err> =
    "getSupportedRatiosAsync"

  @module("expo-camera") @scope("Camera")
  external requestCameraPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "requestCameraPermissionsAsync"

  @module("expo-camera") @scope("Camera")
  external getCameraPermissionsAsync: unit => Promise.Js.t<Permissions.response, 'err> =
    "getCameraPermissionsAsync"

  @send
  external getAvailablePictureSizesAsync: (cameraRef, string) => Promise.Js.t<array<int>, 'err> =
    "getAvailablePictureSizesAsync"
}

module Updates = {
  module UpdateEventType = {
    type t
    @module("expo-updates") @scope("UpdateEventType")
    external updateAvailable: t = "UPDATE_AVAILABLE"
  }

  type event = {
    @as("type")
    type_: UpdateEventType.t,
  }

  type eventSubscription = {remove: (. unit) => unit}

  @module("expo-updates")
  external addListener: (event => unit) => eventSubscription = "addListener"

  @module("expo-updates")
  external reloadAsync: unit => unit = "reloadAsync"
}
