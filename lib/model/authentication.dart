
class TokenRequestResponse {
  bool success;
  String requestToken;

  TokenRequestResponse({this.success, this.requestToken});

  TokenRequestResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    requestToken = json['request_token'];
  }
}

class SesionRequestResponse {
  bool success;
  String sesionId;

  SesionRequestResponse({this.success, this.sesionId});

  SesionRequestResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sesionId = json['session_id'];
  }
}

class User {
  String avatar;
  int id;
  String name;
  bool includeAdult;
  String userName;

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
