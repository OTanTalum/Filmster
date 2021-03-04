class User {
  String? avatar;
  int? id;
  String? name;
  bool? includeAdult;
  String? userName;

  User({
    this.avatar,
    this.id,
    this.name,
    this.includeAdult,
    this.userName,
  });

 User.fromJson(Map<String, dynamic> json) {
    avatar = "${json['avatar']['gravatar']['hash']}.jpg";
    id = json['id'];
    name = json['name'];
    includeAdult = json['include_adult'];
    userName = json['username'];
  }
}
