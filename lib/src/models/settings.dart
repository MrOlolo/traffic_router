class Settings {
  final ParamNames paramNames;

  const Settings({this.paramNames = const ParamNames()});
}

class ParamNames {
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
