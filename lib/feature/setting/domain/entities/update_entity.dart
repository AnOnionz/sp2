class UpdateEntity {
  final String version;
  final String url;

  UpdateEntity({this.version, this.url});

  factory UpdateEntity.formJson(Map<String, dynamic> json){
    return UpdateEntity(
      version: json['version'],
      url: json['url']
    );

  }
}