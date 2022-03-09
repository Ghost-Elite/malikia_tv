
class Direct {
  List<Allitems> allitems;
  String date;
  String error;
  Direct({this.allitems,this.date,this.error});
  Direct.withError(String errorMessage){
    error = errorMessage;
  }

  Direct.fromJson(Map<String, dynamic> json) {
    if (json['allitems'] != null) {
      allitems = new List<Allitems>();
      json['allitems'].forEach((v) {
        allitems.add(new Allitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allitems != null) {
      data['allitems'] = this.allitems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allitems {
  String title;
  String desc;
  String logo;
  String logoUrl;
  String type;
  String feedUrl;
  String alauneFeed;
  String vodFeed;
  String streamUrl;

  Allitems(
      {this.title,
        this.desc,
        this.logo,
        this.logoUrl,
        this.type,
        this.feedUrl,
        this.alauneFeed,
        this.vodFeed,
        this.streamUrl});

  Allitems.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    logo = json['logo'];
    logoUrl = json['logo_url'];
    type = json['type'];
    feedUrl = json['feed_url'];
    alauneFeed = json['alaune_feed'];
    vodFeed = json['vod_feed'];
    streamUrl = json['stream_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['logo'] = this.logo;
    data['logo_url'] = this.logoUrl;
    data['type'] = this.type;
    data['feed_url'] = this.feedUrl;
    data['alaune_feed'] = this.alauneFeed;
    data['vod_feed'] = this.vodFeed;
    data['stream_url'] = this.streamUrl;
    return data;
  }
}
