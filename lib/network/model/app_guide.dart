class GuideTv {
  Allitems allitems;

  GuideTv({this.allitems,this.date,this.error});
  String date;
  String error;
  GuideTv.withError(String errorMessage){
    error = errorMessage;
  }

  GuideTv.fromJson(Map<String, dynamic> json) {
    allitems = json['allitems'] != null
        ? new Allitems.fromJson(json['allitems'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allitems != null) {
      data['allitems'] = this.allitems.toJson();
    }
    return data;
  }
}

class Allitems {
  List<Matin> matin;
  List<Soir> soir;
  String day;
  String direct;

  Allitems({this.matin, this.soir, this.day, this.direct});

  Allitems.fromJson(Map<String, dynamic> json) {
    if (json['matin'] != null) {
      matin = new List<Matin>();
      json['matin'].forEach((v) {
        matin.add(new Matin.fromJson(v));
      });
    }
    if (json['soir'] != null) {
      soir = new List<Soir>();
      json['soir'].forEach((v) {
        soir.add(new Soir.fromJson(v));
      });
    }
    day = json['day'];
    direct = json['direct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matin != null) {
      data['matin'] = this.matin.map((v) => v.toJson()).toList();
    }
    if (this.soir != null) {
      data['soir'] = this.soir.map((v) => v.toJson()).toList();
    }
    data['day'] = this.day;
    data['direct'] = this.direct;
    return data;
  }
}

class Matin {
  String channelId;
  String title;
  String streamName;
  String logo;
  String startTime;
  String categoryName;
  String subcategoryName;
  String endTime;
  String daysInWeek;
  String description;
  String presentateurs;
  String feedUrl;

  Matin(
      {this.channelId,
        this.title,
        this.streamName,
        this.logo,
        this.startTime,
        this.categoryName,
        this.subcategoryName,
        this.endTime,
        this.daysInWeek,
        this.description,
        this.presentateurs,
        this.feedUrl});

  Matin.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    title = json['title'];
    streamName = json['streamName'];
    logo = json['logo'];
    startTime = json['startTime'];
    categoryName = json['categoryName'];
    subcategoryName = json['subcategoryName'];
    endTime = json['endTime'];
    daysInWeek = json['daysInWeek'];
    description = json['description'];
    presentateurs = json['presentateurs'];
    feedUrl = json['feed_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelId'] = this.channelId;
    data['title'] = this.title;
    data['streamName'] = this.streamName;
    data['logo'] = this.logo;
    data['startTime'] = this.startTime;
    data['categoryName'] = this.categoryName;
    data['subcategoryName'] = this.subcategoryName;
    data['endTime'] = this.endTime;
    data['daysInWeek'] = this.daysInWeek;
    data['description'] = this.description;
    data['presentateurs'] = this.presentateurs;
    data['feed_url'] = this.feedUrl;
    return data;
  }
}
class Soir {
  String channelId;
  String title;
  String streamName;
  String logo;
  String startTime;
  String categoryName;
  String subcategoryName;
  String endTime;
  String daysInWeek;
  String description;
  String presentateurs;
  String feedUrl;

  Soir(
      {this.channelId,
        this.title,
        this.streamName,
        this.logo,
        this.startTime,
        this.categoryName,
        this.subcategoryName,
        this.endTime,
        this.daysInWeek,
        this.description,
        this.presentateurs,
        this.feedUrl});

  Soir.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    title = json['title'];
    streamName = json['streamName'];
    logo = json['logo'];
    startTime = json['startTime'];
    categoryName = json['categoryName'];
    subcategoryName = json['subcategoryName'];
    endTime = json['endTime'];
    daysInWeek = json['daysInWeek'];
    description = json['description'];
    presentateurs = json['presentateurs'];
    feedUrl = json['feed_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelId'] = this.channelId;
    data['title'] = this.title;
    data['streamName'] = this.streamName;
    data['logo'] = this.logo;
    data['startTime'] = this.startTime;
    data['categoryName'] = this.categoryName;
    data['subcategoryName'] = this.subcategoryName;
    data['endTime'] = this.endTime;
    data['daysInWeek'] = this.daysInWeek;
    data['description'] = this.description;
    data['presentateurs'] = this.presentateurs;
    data['feed_url'] = this.feedUrl;
    return data;
  }
}