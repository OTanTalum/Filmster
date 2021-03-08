import 'dart:async';
import 'dart:convert';

import 'film.dart';

class Search{
  List<SearchResults>? results=[];
  int? total;
  String? response;

  Search({
    this.results,
    this.total,
    this.response,
  });


  Search.fromJson(Map<String, dynamic> json) {
    if(json['results']!=null)
      json['results'].forEach((element)=>results!.add(SearchResults.fromJson(element)));
    if(json['total_results']!=null)
      total = json['total_results'];
    response = json['Response'];
  }
}

class SearchResults{
  int? id;
  String? mediaType;
  double? popularity;
  int? voteCount;
  bool? isVideo;
  String? poster;
  bool? isAdult;
  String? backdrop;
  String? language;
  List? ganres=[];
  String? title;
  String? originalTitle;
  String?  voteAverage;
  String? overview;
  String? release;

  SearchResults({
    this.id,
    this.popularity,
    this.voteCount,
    this.isVideo,
    this.poster,
    this.isAdult,
    this.backdrop,
    this.language,
    this.ganres,
    this.title,
    this.voteAverage,
    this.overview,
    this.release,
    this.mediaType,
  });


  SearchResults.fromJson(Map<String, dynamic> json) {
   id=json['id'];
   mediaType=json['media_type'];
   if(json['popularity']!=null)
   popularity=json['popularity']*1.0;
   voteCount=json['vote_count'];
   isVideo=json['video'];
   poster=json['poster_path'];
   isAdult=json['adult'];
   backdrop=json['backdrop_path'];
   language=json['original_language'];
   originalTitle=json['original_title'];
   if(json['genre_ids']!=null)
      json['genre_ids'].forEach((element)=>ganres!.add(element));
   if(json['title']!=null)
    title=json['title'];
   else if(json['name']!=null)
     title = json['name'];
   voteAverage=json['vote_average'].toString();
   overview=json['overview'];
   if(json['release_date']!=null) {
     release = json['release_date'];
   }else if(json["first_air_date"]!=null){
     release = json["first_air_date"];
   }
  }
}