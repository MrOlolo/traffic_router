## Getting started

### Add it to your package's pubspec.yaml file

```yml
dependencies:
  traffic_router:
    git:
      url: https://github.com/MrOlolo/traffic_router
```

### Configure Android

#### Firebase

[Official docs](https://firebase.flutter.dev/docs/installation/android)

On the [Firebase Console](https://console.firebase.google.com/project/_/overview), add a new Android
app or select an existing Android app for your Firebase project.

The "Android package name" must match your local project's package name that was created when you
started the Flutter project. The current package name can be found in your module (app-level) Gradle
file, usually `android/app/build.gradle`, `defaultConfig` section (example package name:
`com.yourcompany.yourproject`).

Once your Android app has been registered, download the configuration file from the Firebase
Console (the file is called `google-services.json`). Add this file into the `android/app` directory
within your Flutter project.

To allow Firebase to use the configuration on Android, the 'google-services' plugin must be applied
on the project. This requires modification to two files in the `android/` directory.

First, add the 'google-services' plugin as a dependency inside of the `android/build.gradle` file:

```groovy
buildscript {
    dependencies {
        // ... other dependencies
        classpath 'com.google.gms:google-services:4.3.8'
    }
}
```

Lastly, execute the plugin by adding the following underneath the line `apply plugin: '
com.android.application'`, within the `/android/app/build.gradle` file:

```groovy
apply plugin: 'com.google.gms.google-services'
```

#### Facebook

For Android configuration, you can follow the same instructions of the Flutter Facebook App Events
plugin:
Read through
the "[Getting Started with App Events for Android](https://developers.facebook.com/docs/app-events/getting-started-app-events-android)"
tutorial and in particular,
follow [step 2](https://developers.facebook.com/docs/app-events/getting-started-app-events-android#2--add-your-facebook-app-id)
by adding the following into `/app/res/values/strings.xml` (or into respective `debug` or `release`
build flavor)

```xml

<string name="facebook_app_id">[APP_ID]</string>
```

After that, add that string resource reference to your main `AndroidManifest.xml` file:

```xml

<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id" />
```

#### Common settings

Add this permissions to your `AndroidManifest.xml` file:

```xml

<uses-permission android:name="android.permission.INTERNET" />

    <!--    For sim info-->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />

    <!--    Fix WebView error at some Samsung devices-->
<uses-permission android:name="android.permission.WAKE_LOCK" />

    <!--    Apps with target API level set to 31 (Android 12) or later must declare-->
    <!--    the normal permission com.google.android.gms.AD_ID as below-->
    <!--    in order to use this API.-->
<uses-permission android:name="com.google.android.gms.permission.AD_ID" />
```

If you use `http` links add to `<application>` at your `AndroidManifest.xml` file:

```xml

<application android:usesCleartextTraffic="true">
    . . .
</application>
```

### Configure iOS

#### Firebase

[Official docs](https://firebase.flutter.dev/docs/installation/ios)

On the [Firebase Console](https://console.firebase.google.com/project/_/overview), add a new iOS app
or select an existing iOS app for your Firebase project. The "iOS bundle ID" must match your local
project bundle ID. The bundle ID can be found within the "General" tab when
opening `ios/Runner.xcworkspace` with Xcode.

Download the `GoogleService-Info.plist` file for the Firebase app.

Next you must add the file to the project using Xcode (adding manually via the filesystem won't link
the file to the project). Using Xcode, open the project's `ios/{projectName}.xcworkspace` file.
Right click Runner from the left-hand side project navigation within Xcode and select "Add files".

Select the `GoogleService-Info.plist` file you downloaded, and ensure the "Copy items if needed"
checkbox is enabled

#### Open links at browser

Add any URL schemes passed to `canLaunch` as `LSApplicationQueriesSchemes` entries in your
Info.plist file.

Example:

```
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
</array>
```

#### Facebook deeplink

For iOS configuration, you can follow the same instructions of the Flutter Facebook App Events
plugin:
Read through
the "[Getting Started with App Events for iOS](https://developers.facebook.com/docs/app-events/getting-started-app-events-ios)"
tutorial and in particular,
follow [step 4](https://developers.facebook.com/docs/app-events/getting-started-app-events-ios#plist-config)
by opening `info.plist` "As Source Code" and add the following

* If your code does not have `CFBundleURLTypes`, add the following just before the final `</dict>`
  element:

```xml

<key>CFBundleURLTypes</key><array>
<dict>
    <key>CFBundleURLSchemes</key>
    <array>
        <string>fb[APP_ID]</string>
    </array>
</dict>
</array><key>FacebookAppID</key><string>[APP_ID]</string><key>FacebookDisplayName</key><string>
[APP_NAME]
</string>
```

* If your code already contains `CFBundleURLTypes`, insert the following:

 ```xml

<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fb[APP_ID]</string>
        </array>
    </dict>
</array><key>FacebookAppID</key><string>[APP_ID]</string><key>FacebookDisplayName</key><string>
[APP_NAME]
</string>
 ```

## Usage

```dart

void routerInit(NavigatorState navigator) async {

  /// To initialize trafficRouter instance
  /// Also you can set [Settings] param at [initialize]
  final trafficRouter = await TrafficRouter.initialize(
      settings: Settings(paramNames: ParamNames(...)));

  ///U can navigate with default route function or create ur own 
  trafficRouter.routeWithNavigator(
    navigator,
        (context) => const MyHomePage(title: 'App'),
        (url) =>
        WebViewPage(url: url
        )
    ,
  );
}

```

## Additional information

### If ur get error about Kotlin module versions:

Update version `ext.kotlin_version` to `1.5.31` at `android\build.gradle`
