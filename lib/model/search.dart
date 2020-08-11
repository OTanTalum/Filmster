import 'dart:async';
import 'dart:convert';

import 'film.dart';

class Search{
  List<Film> search=[];
  int total;
  String response;

  Search({
    this.search,
    this.total,
    this.response,
  });


  Search.fromJson(Map<String, dynamic> json) {
   if(json['Search']!=null)
     json['Search'].forEach((element)=>search.add(Film.fromJson(element)));
   if(json['totalResults']!=null)
    total = int.parse(json['totalResults']);
    response = json['Response'];
  }
}