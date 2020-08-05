import 'dart:async';
import 'dart:convert';

class Search{
  final List search;
  final String total;
  final String response;

  Search({
    this.search,
    this.total,
    this.response,
  });


  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      search: json['Search'],
      total: json['totalResults'],
      response: json['Response'],
    );
  }
}