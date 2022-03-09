class ListChannelsbygroup {
 List<Allitems> allitems;

  ListChannelsbygroup(this.allitems, this.date, this.error);

  String date;
  String error;
  ListChannelsbygroup.withError(String errorMessage){
    error = errorMessage;
  }

  ListChannelsbygroup.fromJson(Map<String, dynamic> json) {
    if (json['allitems'] != null) {
      allitems = <Allitems>[];
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
  String logo;
  String logoUrl;
  String desc;
  String feedUrl;
  String relatedItems;
  String time;
  String date;
  String type;
  String chaineName;
  String chaineLogo;
  String videoUrl;

  Allitems(
      {
        this.title,
        this.logo,
        this.logoUrl,
        this.desc,
        this.feedUrl,
        this.relatedItems,
        this.time,
        this.date,
        this.type,
        this.chaineName,
        this.chaineLogo,
        this.videoUrl});

  Allitems.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    logo = json['logo'];
    logoUrl = json['logo_url'];
    desc = json['desc'];
    feedUrl = json['feed_url'];
    relatedItems = json['relatedItems'];
    time = json['time'];
    date = json['date'];
    type = json['type'];
    chaineName = json['chaine_name'];
    chaineLogo = json['chaine_logo'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['logo'] = this.logo;
    data['logo_url'] = this.logoUrl;
    data['desc'] = this.desc;
    data['feed_url'] = this.feedUrl;
    data['relatedItems'] = this.relatedItems;
    data['time'] = this.time;
    data['date'] = this.date;
    data['type'] = this.type;
    data['chaine_name'] = this.chaineName;
    data['chaine_logo'] = this.chaineLogo;
    data['video_url'] = this.videoUrl;
    return data;
  }
}
