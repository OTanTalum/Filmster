class BasicResponse{
  String massage;
  int code;
  bool isSuccess;
  String listId;
  String sessionId;
  String requestToken;

  BasicResponse({this.massage, this.code, this.isSuccess});

  BasicResponse.fromJson(Map<String, dynamic> json){
    if(json["success"]!=null){
      isSuccess=json["success"];
    }
    massage = json["status_message"];
    code = json["status_code"];

    // some API Point return field list_id, sessionId, requestToken
    if(json["list_id"]!=null) {
      listId = json["list_id"].toString();
    }
    if(json['session_id']!=null){
      sessionId = json['session_id'];
    } if(json['request_token']!=null){
      requestToken = json['request_token'];
    }
  }
}