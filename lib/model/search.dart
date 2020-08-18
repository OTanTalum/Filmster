import 'dart:async';
import 'dart:convert';

import 'film.dart';

class Search{
  List<SearchResults> search=[];
  int total;
  String response;

  Search({
    this.search,
    this.total,
    this.response,
  });


  Search.fromJson(Map<String, dynamic> json) {
    if(json['results']!=null)
      json['results'].forEach((element)=>search.add(SearchResults.fromJson(element)));
    if(json['total_results']!=null)
      total = json['total_results'];
    response = json['Response'];
  }
}

class SearchResults{
  int id;
  double popularity;
  int voteCount;
  bool isVideo;
  String poster;
  bool isAdult;
  String backdrop;
  String language;
  List ganres=[];
  String title;
  String originalTitle;
  String  voteAverage;
  String overview;
  String release;

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
  });


  SearchResults.fromJson(Map<String, dynamic> json) {
   id=json['id'];
   popularity=json['popularity']*1.0;
   voteCount=json['vote_count'];
   isVideo=json['video'];
   poster=json['poster_path'];
   isAdult=json['adult'];
   backdrop=json['backdrop_path'];
   language=json['original_language'];
   originalTitle=json['original_title'];
   if(json['genre_ids']!=null)
      json['genre_ids'].forEach((element)=>ganres.add(element));
   title=json['title'];
   voteAverage=json['vote_average'].toString();
   overview=json['overview'];
   release=json['release_date'];
  }
}