
import 'package:filmster/model/search.dart';
import 'package:flutter/material.dart';

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

class CustomListResponse{
  List<CustomList> results=[];
  int totalPages;
  int totalResults;

  CustomListResponse({
    this.results,
    this.totalPages,
    this.totalResults
  });

  CustomListResponse.fromJson(Map<String, dynamic> json) {
    if(json['results']!=[]){
      json['results'].forEach((movie)=>{
        results.add(CustomList.fromJson(movie))
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }
}
class CustomList{
  String description;
  int favoriteCount;
  String id;
  int itemCount;
  String listType;
  String name;
  String poster;
  List <SearchResults> items=[];

  CustomList({
    this.description,
    this.poster,
    this.listType,
    this.id,
    this.favoriteCount,
    this.name,
    this.itemCount,
    this.items,
  });

  CustomList.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    favoriteCount = json['favorite_count'];
    id = json['id'].toString();
    itemCount = json['item_count'];
    listType = json['list_type'];
    name = json['name'];
    poster = json['poster_path'];
    if(json['items']!=null)
      json['items'].forEach((element){
        items.add(SearchResults.fromJson(element));
      });
    poster = json['poster_path'];
  }
}