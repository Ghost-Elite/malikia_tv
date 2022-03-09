class Status{
  final String privacyStatus;

  Status(this.privacyStatus);

  factory Status.fromJson(Map<String,dynamic> json){
    return Status(
      json['privacyStatus']
    );
  }
}