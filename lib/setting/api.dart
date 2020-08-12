
import 'dart:convert';

import 'package:filmster/model/search.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Api{

  final String api_key = "22e195d94c2274b3dcf6484e58a1715f";
  final String imageBannerAPI = "https://image.tmdb.org/t/p/w500";
  String language = "ru";
  String imdbAPI = 'https://api.themoviedb.org/3/search/movie?api_key=';
  String imdbGenreAPI = 'https://api.themoviedb.org/3/genre/movie/list?api_key=';


  searchMovie(type, query, page) async{
    final response = await http.get('$imdbAPI$api_key&type=$type&query=${query}&page=${page}&language=$language');
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR SEARCH");
    }
  }

  getGenres() async{
    final response = await http.get('$imdbGenreAPI$api_key&language=$language');
    if (response.statusCode == 200) {
      Map genres = json.decode(response.body);
      return genres["genres"];
    }
    else {
      print("ERROR Genres");
    }
  }

}