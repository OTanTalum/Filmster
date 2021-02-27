class BasicResponse{
  String massage;
  int code;
  bool isSuccess;

  BasicResponse({this.massage, this.code, this.isSuccess});

  BasicResponse.fromJson(Map<String, dynamic> json){
    if(json["success"]!=null){
      isSuccess=json["success"];
    }
    massage = json["status_message"];
    code = json["status_code"];
  }
}