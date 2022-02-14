# expo-camera ratio repro

Randomly there is a ratio error on Android devices.

Occured on Android 9/10/11 with SDK 42/43/44.

```
java.lang.NullPointerException: Attempt to invoke interface method 'java.lang.Object java.util.SortedSet.last()' on a null object reference
    at com.google.android.cameraview.Camera2.setAspectRatio(Camera2.java:402)
    at com.google.android.cameraview.Camera2.start(Camera2.java:282)
    at com.google.android.cameraview.CameraView.start(CameraView.java:284)
    at expo.modules.camera.ExpoCameraView.onHostResume(ExpoCameraView.java:299)
    at expo.modules.adapters.react.services.UIManagerModuleWrapper$3.onHostResume(UIManagerModuleWrapper.java:127)
    at com.facebook.react.bridge.ReactContext$1.run(ReactContext.java:200)
    at android.os.Handler.handleCallback(Handler.java:938)
    at android.os.Handler.dispatchMessage(Handler.java:99)
    at com.facebook.react.bridge.queue.MessageQueueThreadHandler.dispatchMessage(MessageQueueThreadHandler.java:27)
    at android.os.Looper.loop(Looper.java:236)
    at android.app.ActivityThread.main(ActivityThread.java:8031)
    at java.lang.reflect.Method.invoke(Method.java)
    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:620)
    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:1011)
```

## Test

Install deps

```
yarn
```

Build ReScript files

```
yarn rescript:watch
```

Start expo server

```
yarn start
```
