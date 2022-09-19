import 'dart:io';

import 'package:equatable/equatable.dart';

class RouterSettings {
  final ParamNames paramNames;

  final LibsPlatformSettings _libsSettings;

  const RouterSettings({
    this.paramNames = const ParamNames(),
    LibsPlatformSettings libsSettings = const LibsPlatformSettings(),
  }) : _libsSettings = libsSettings;

  LibSettings get libs => _libsSettings.settings;
}

class LibsPlatformSettings {
  final IOSLibSettings iosLibSettings;
  final AndroidLibSettings androidLibSettings;

  const LibsPlatformSettings(
      {this.iosLibSettings = const IOSLibSettings(),
      this.androidLibSettings = const AndroidLibSettings()});

  LibSettings get settings =>
      Platform.isIOS ? iosLibSettings : androidLibSettings;
}

class LibSettings with EquatableMixin {
  final bool collectDeviceInfo;
  final bool collectPackageName;
  final bool collectLocale;
  final bool collectBatteryInfo;
  final bool checkRootStatus;
  final bool collectMnoInfo;
  final bool checkVpnStatus;
  final bool useAppsFlyer;
  final bool getAppsFlyerUID;
  final bool getAppsflyerRegisterConversionDataCallback;
  final bool useFacebook;
  final bool useFacebookChangeable;
  final bool useFacebookDeeplink;

  ///ads id
  final bool collectAID;
  final bool useAndroidInstallReferrer;

  const LibSettings(
      {required this.collectDeviceInfo,
      required this.collectPackageName,
      required this.collectLocale,
      required this.checkRootStatus,
      required this.collectBatteryInfo,
      required this.collectMnoInfo,
      required this.checkVpnStatus,
      required this.useAppsFlyer,
      required this.getAppsFlyerUID,
      required this.getAppsflyerRegisterConversionDataCallback,
      required this.useFacebook,
      required this.useFacebookChangeable,
      required this.useFacebookDeeplink,
      required this.collectAID,
      required this.useAndroidInstallReferrer});

  @override
  List<Object?> get props => [
        collectDeviceInfo,
        collectPackageName,
        collectLocale,
        collectBatteryInfo,
        checkRootStatus,
        collectMnoInfo,
        checkVpnStatus,
        useAppsFlyer,
        getAppsFlyerUID,
        getAppsflyerRegisterConversionDataCallback,
        useFacebook,
        useFacebookChangeable,
        useFacebookDeeplink,
        collectAID,
        useAndroidInstallReferrer,
      ];
}

class IOSLibSettings extends LibSettings {
  const IOSLibSettings({
    bool collectDeviceInfo = true,
    bool collectBatteryInfo = true,
    bool collectPackageName = true,
    bool collectLocale = true,
    bool collectMnoInfo = true,
    bool checkVpnStatus = true,
    bool useAppsFlyer = true,
    bool getAppsflyerUID = false,
    bool getAppsflyerRegisterConversionDataCallback = false,
    bool useFacebook = true,
    bool useFacebookChangeable = true,
    bool useFacebookDeeplink = false,
    bool getADsID = false,
  }) : super(
            collectDeviceInfo: collectDeviceInfo,
            checkRootStatus: false,
            collectLocale: collectLocale,
            collectPackageName: collectPackageName,
            collectBatteryInfo: collectBatteryInfo,
            collectMnoInfo: collectMnoInfo,
            checkVpnStatus: checkVpnStatus,
            useAppsFlyer: useAppsFlyer,
            getAppsFlyerUID: getAppsflyerUID,
            getAppsflyerRegisterConversionDataCallback:
                getAppsflyerRegisterConversionDataCallback,
            useFacebook: useFacebook,
            useFacebookChangeable: useFacebookChangeable,
            useFacebookDeeplink: useFacebookDeeplink,
            collectAID: getADsID,
            useAndroidInstallReferrer: false);
}

class AndroidLibSettings extends LibSettings {
  const AndroidLibSettings(
      {bool collectDeviceInfo = true,
      bool checkRootStatus = true,
      bool collectBatteryInfo = true,
      bool collectPackageName = true,
      bool collectLocale = true,
      bool collectMnoInfo = true,
      bool checkVpnStatus = true,
      bool useAppsFlyer = true,
      bool getAppsflyerUID = true,
      bool getAppsflyerRegisterConversionDataCallback = true,
      bool useFacebook = true,
      bool useFacebookDeeplink = true,
      bool getADsID = true,
      bool useAndroidInstallReferrer = true})
      : super(
            collectDeviceInfo: collectDeviceInfo,
            checkRootStatus: checkRootStatus,
            collectBatteryInfo: collectBatteryInfo,
            collectLocale: collectLocale,
            collectPackageName: collectPackageName,
            collectMnoInfo: collectMnoInfo,
            checkVpnStatus: checkVpnStatus,
            useAppsFlyer: useAppsFlyer,
            getAppsFlyerUID: getAppsflyerUID,
            getAppsflyerRegisterConversionDataCallback:
                getAppsflyerRegisterConversionDataCallback,
            useFacebook: useFacebook,
            useFacebookChangeable: false,
            useFacebookDeeplink: useFacebookDeeplink,
            collectAID: getADsID,
            useAndroidInstallReferrer: useAndroidInstallReferrer);
}

class ParamNames {
  ///
  final String iosAppId;

  ///Firebase data
  final String databaseRoot;
  final String baseUrl1;
  final String baseUrl2;
  final String appsflyer;
  final String facebook;

  ///data from host
  final String urlPath;
  final String queryParamName;
  final String url11key;
  final String url12key;
  final String url21key;

  final String url22key;
  final String overrideUrlKey;

  ///Device data
  final String mnoKey;
  final String bundleKey;
  final String batteryPercentageKey;
  final String batteryStateKey;
  final String deviceNameKey;
  final String deviceLocaleKey;
  final String deviceVpnKey;
  final String deviceRootedKey;
  final String deviceTabletKey;

  final String deepDataKey;

  final String installRefererKey;

  ///Appsflyer data
  final String appsflyerUid;
  final String mediaSourceKey;
  final String agencyKey;
  final String adIdKey;
  final String adsetIdKey;
  final String campaignIdKey;
  final String campaignKey;
  final String adgroupIdKey;
  final String isFbKey;
  final String afSitedKey;
  final String httpReferrerKey;

  ///Storage keys
  final String webViewUrl;
  final String initiated;

  final int tabletScreenWidth;

  ///Facebook data
  final String facebookAppId;
  final String facebookDisplayName;
  final String facebookClientToken;

  ///Facebook keys
  final String fbDeeplink;

  ///Advertising ID
  final String advertisingId;

  const ParamNames({
    this.iosAppId = 'ios_app_id',
    this.databaseRoot = "json_cadre",
    this.baseUrl1 = "bries",
    this.baseUrl2 = "gents",
    this.appsflyer = "appsflyer_api_key",
    this.facebook = "facebook_api",
    this.urlPath = 'getDomain',
    this.queryParamName = 'encoded_data',
    this.url11key = 'pease',
    this.url12key = 'burgs',
    this.url21key = 'knout',
    this.url22key = 'envoi',
    this.overrideUrlKey = 'override_url',
    this.mnoKey = "mno",
    this.bundleKey = "bundle_back",
    this.batteryPercentageKey = "battery_percent",
    this.batteryStateKey = "battery_charging",
    this.deviceNameKey = "device_name",
    this.deviceLocaleKey = "device_locale",
    this.deviceVpnKey = "device_vpn",
    this.deviceRootedKey = "device_rooted",
    this.deviceTabletKey = "device_tablet",
    this.deepDataKey = "deep_data",
    this.installRefererKey = "install_referer",
    this.appsflyerUid = "appsflyer_uid",
    this.mediaSourceKey = "media_source",
    this.agencyKey = "agency",
    this.adIdKey = "ad_id",
    this.adsetIdKey = "adset_id",
    this.campaignIdKey = "campaign_id",
    this.campaignKey = "campaign",
    this.adgroupIdKey = "adgroup_id",
    this.isFbKey = "is_fb",
    this.facebookAppId = 'facebook_app_id',
    this.facebookDisplayName = 'facebook_display_name',
    this.facebookClientToken = 'facebook_client_token',
    this.afSitedKey = "af_siteid",
    this.httpReferrerKey = "http_referrer",
    this.webViewUrl = 'webview_url',
    this.initiated = 'initiated',
    this.tabletScreenWidth = 550,
    this.fbDeeplink = "deep_fb",
    this.advertisingId = "gaid",
  });
}
