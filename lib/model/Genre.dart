class Genre{
  String? name;
  int? id;

  Genre({
    this.name,
    this.id
  });

  Genre.fromJson(Map <String,dynamic> json){
    name = json['name'];
    id = json['id'];
  }
}

class GenresResponse{
  List <Genre>? genres=[];
  bool? isSuccess;
  String? message;

  GenresResponse({
    this.genres,
    this.isSuccess,
    this.message
  });

  GenresResponse.fromJson(Map <String, dynamic> json){
    if(json["genres"]!=null){
      genres=[];
      json["genres"].forEach((element)=>genres!.add(Genre.fromJson(element)));
      isSuccess = true;
    }else{
      isSuccess = false;
    }
    if(json["status_message"]!=null){
      message = json["status_message"];
    }
  }
}