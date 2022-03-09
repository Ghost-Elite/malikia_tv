class AlauneByGroup {
  List<Allitems> allitems;

  AlauneByGroup({this.allitems});

  AlauneByGroup.fromJson(Map<String, dynamic> json) {
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
  String chaineId;
  String title;
  String desc;
  String type;
  String views;
  String logo;
  String logoUrl;
  String videoUrl;
  String relatedItems;
  String feedUrl;
  String date;
  String time;

  Allitems(
      {this.chaineId,
        this.title,
        this.desc,
        this.type,
        this.views,
        this.logo,
        this.logoUrl,
        this.videoUrl,
        this.relatedItems,
        this.feedUrl,
        this.date,
        this.time});

  Allitems.fromJson(Map<String, dynamic> json) {
    chaineId = json['chaine_id'];
    title = json['title'];
    desc = json['desc'];
    type = json['type'];
    views = json['views'];
    logo = json['logo'];
    logoUrl = json['logo_url'];
    videoUrl = json['video_url'];
    relatedItems = json['relatedItems'];
    feedUrl = json['feed_url'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chaine_id'] = this.chaineId;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['type'] = this.type;
    data['views'] = this.views;
    data['logo'] = this.logo;
    data['logo_url'] = this.logoUrl;
    data['video_url'] = this.videoUrl;
    data['relatedItems'] = this.relatedItems;
    data['feed_url'] = this.feedUrl;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
