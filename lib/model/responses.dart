
import 'package:filmster/model/search.dart';

import 'film.dart';

class ListResponse{
  List<SearchResults> results=[];
  int totalPage;
  int totalResults;

  ListResponse({
    this.results,
    this.totalPage,
    this.totalResults
  });

  ListResponse.fromJson(Map<String, dynamic> json) {
    if(json['results']!=[]){
      json['results'].forEach((movie)=>{
        results.add(SearchResults.fromJson(movie))
      });
    }
    totalPage = json['total_pages'];
    totalResults = json['total_results'];
  }
}