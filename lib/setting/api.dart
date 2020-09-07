
import 'dart:convert';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Api{

  final String api_key = "22e195d94c2274b3dcf6484e58a1715f";
  final String imageBannerAPI = "https://image.tmdb.org/t/p/w500";
  String TMDBAPI = 'https://api.themoviedb.org/3/search/movie';
  String TMDBTrendingAPI = 'https://api.themoviedb.org/3/trending/';
  String TMDBDetailAPI = 'https://api.themoviedb.org/3';
  String imdbGenreAPI = 'https://api.themoviedb.org/3/genre/';


  searchMovie(type, query, page) async{
    final response = await http.get('$TMDBAPI?api_key=$api_key&type=$type&query=${query}&page=${page}&language=${SettingsProvider.language}&include_adult=true');
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR SEARCH");
    }
  }

  getTrending(type, period, page) async{
    final response = await http.get('$TMDBTrendingAPI$type/$period?api_key=$api_key&page=${page}&language=${SettingsProvider.language}&include_adult=true');
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Trending");
    }
  }

  getGenres(type) async{
    final response = await http.get('$imdbGenreAPI$type/list?api_key=$api_key&language=${SettingsProvider.language}');
    if (response.statusCode == 200) {
      Map genres = json.decode(response.body);
      return genres["genres"];
    }
    else {
      print("ERROR Genres");
    }
  }

  getFilmDetail(String id, String type) async{
    final response = await http.get('$TMDBDetailAPI/$type/$id?api_key=$api_key&language=${SettingsProvider.language}');
    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Details");
    }
  }
}