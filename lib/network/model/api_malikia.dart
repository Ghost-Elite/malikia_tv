class Apimalikia {
  List<ACANAPI> aCANAPI;
  String date;
  String error;
  Apimalikia({this.aCANAPI,this.date,this.error});
  Apimalikia.withError(String errorMessage){
    error = errorMessage;
  }

  Apimalikia.fromJson(Map<String, dynamic> json) {
    if (json['ACAN_API'] != null) {
      aCANAPI = <ACANAPI>[];
      json['ACAN_API'].forEach((v) {
        aCANAPI.add(new ACANAPI.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aCANAPI != null) {
      data['ACAN_API'] = this.aCANAPI.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ACANAPI {
  String appName;
  String appLogo;
  String appDataToload;
  String appDataUrl;
  String appYoutubeUrl;
  String appYoutubeUid;
  String appGoogleApikey;
  String appNewsUrl;
  String appFbUrl;
  String appTwitterUrl;
  String appVersion;
  String appAuthor;
  String appContact;
  String appEmail;
  String appWebsite;
  String appInfo;
  String appDescription;
  String appDevelopedBy;
  String appPrivacyPolicy;
  String publisherId;
  String appId;
  String interstitalAd;
  String interstitalAdId;
  String interstitalAdClick;
  String bannerAd;
  String bannerAdId;

  ACANAPI(
      {this.appName,
        this.appLogo,
        this.appDataToload,
        this.appDataUrl,
        this.appYoutubeUrl,
        this.appYoutubeUid,
        this.appGoogleApikey,
        this.appNewsUrl,
        this.appFbUrl,
        this.appTwitterUrl,
        this.appVersion,
        this.appAuthor,
        this.appContact,
        this.appEmail,
        this.appWebsite,
        this.appInfo,
        this.appDescription,
        this.appDevelopedBy,
        this.appPrivacyPolicy,
        this.publisherId,
        this.appId,
        this.interstitalAd,
        this.interstitalAdId,
        this.interstitalAdClick,
        this.bannerAd,
        this.bannerAdId});

  ACANAPI.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appLogo = json['app_logo'];
    appDataToload = json['app_data_toload'];
    appDataUrl = json['app_data_url'];
    appYoutubeUrl = json['app_youtube_url'];
    appYoutubeUid = json['app_youtube_uid'];
    appGoogleApikey = json['app_google_apikey'];
    appNewsUrl = json['app_news_url'];
    appFbUrl = json['app_fb_url'];
    appTwitterUrl = json['app_twitter_url'];
    appVersion = json['app_version'];
    appAuthor = json['app_author'];
    appContact = json['app_contact'];
    appEmail = json['app_email'];
    appWebsite = json['app_website'];
    appInfo = json['app_info'];
    appDescription = json['app_description'];
    appDevelopedBy = json['app_developed_by'];
    appPrivacyPolicy = json['app_privacy_policy'];
    publisherId = json['publisher_id'];
    appId = json['app_id'];
    interstitalAd = json['interstital_ad'];
    interstitalAdId = json['interstital_ad_id'];
    interstitalAdClick = json['interstital_ad_click'];
    bannerAd = json['banner_ad'];
    bannerAdId = json['banner_ad_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['app_logo'] = this.appLogo;
    data['app_data_toload'] = this.appDataToload;
    data['app_data_url'] = this.appDataUrl;
    data['app_youtube_url'] = this.appYoutubeUrl;
    data['app_youtube_uid'] = this.appYoutubeUid;
    data['app_google_apikey'] = this.appGoogleApikey;
    data['app_news_url'] = this.appNewsUrl;
    data['app_fb_url'] = this.appFbUrl;
    data['app_twitter_url'] = this.appTwitterUrl;
    data['app_version'] = this.appVersion;
    data['app_author'] = this.appAuthor;
    data['app_contact'] = this.appContact;
    data['app_email'] = this.appEmail;
    data['app_website'] = this.appWebsite;
    data['app_info'] = this.appInfo;
    data['app_description'] = this.appDescription;
    data['app_developed_by'] = this.appDevelopedBy;
    data['app_privacy_policy'] = this.appPrivacyPolicy;
    data['publisher_id'] = this.publisherId;
    data['app_id'] = this.appId;
    data['interstital_ad'] = this.interstitalAd;
    data['interstital_ad_id'] = this.interstitalAdId;
    data['interstital_ad_click'] = this.interstitalAdClick;
    data['banner_ad'] = this.bannerAd;
    data['banner_ad_id'] = this.bannerAdId;
    return data;
  }
}
