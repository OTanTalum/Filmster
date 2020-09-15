
import 'dart:convert';

import 'package:filmster/model/authentication.dart';
import 'package:filmster/model/film.dart';
import 'package:filmster/model/responses.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:http/http.dart' as http;

class Api{

  final String apiKey = "22e195d94c2274b3dcf6484e58a1715f";
  final String imageBannerAPI = "https://image.tmdb.org/t/p/w500";
  String tMDBApi = 'https://api.themoviedb.org/3';
  bool includeAdult = false;

  searchMovie(String type, String query, int page) async{
    final response = await http.get('$tMDBApi/search/$type?api_key=$apiKey&query=$query&page=$page&language=${SettingsProvider.language}&include_adult=$includeAdult');
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR SEARCH");
    }
  }

  getTrending(String type, String period, int page) async{
    final response = await http.get('$tMDBApi/trending/$type/$period?api_key=$apiKey&page=$page&language=${SettingsProvider.language}&include_adult=$includeAdult');
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Trending");
    }
  }

  getGenres(String type) async{
    final response = await http.get('$tMDBApi/genre/$type/list?api_key=$apiKey&language=${SettingsProvider.language}');
    if (response.statusCode == 200) {
      Map genres = json.decode(response.body);
      return genres["genres"];
    }
    else {
      print("ERROR Genres");
    }
  }

  getFilmDetail(String id, String type) async{
    final response = await http.get('$tMDBApi/$type/$id?api_key=$apiKey&language=${SettingsProvider.language}');
    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Details");
    }
  }

  getRequestToken() async {
    final response =
        await http.get('$tMDBApi/authentication/token/new?api_key=$apiKey');
    if (json.decode(response.body)['success']) {
      return TokenRequestResponse.fromJson(json.decode(response.body));
    } else
      print("ERROR REquEST");
  }

  login(String username, String password, String requestToken)async{
    final response = await http.post(
        '$tMDBApi/authentication/token/validate_with_login?api_key=$apiKey',
        body: {
          "username": username,
          "password": password,
          "request_token": requestToken
        });
    print(json.decode(response.body));
    print("responseLogin");
    if (json.decode(response.body)['success']) {
      return TokenRequestResponse.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Login");
    }
  }

  createSession(String token)async {
    final response = await http.post(
        '$tMDBApi/authentication/session/new?api_key=$apiKey',
        body: {
          "request_token": token
        });
    print(json.decode(response.body));
    print("response");
    if (json.decode(response.body)['success']) {
      return SesionRequestResponse.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Session");
    }
  }

  getUser(String sesionId)async {
    final response = await http.get('$tMDBApi/account?api_key=$apiKey&session_id=$sesionId');
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Session");
    }
  }


  getChristianMovies(page)async {
    final response = await http.get('$tMDBApi/keyword/253695/movies?api_key=$apiKey&language=${SettingsProvider.language}&page=$page');
    if (response.statusCode == 200) {
      return ListResponse.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Cristian");
    }
  }

  getFavoriteMovies(int id, String sessionId, page, type)async {
    final response = await http.get('$tMDBApi/account/$id/favorite/$type?api_key=$apiKey&session_id=$sessionId&page=$page&sort_by=created_at.asc&language=${SettingsProvider.language}');
    if (response.statusCode == 200) {
      return ListResponse.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Favorite");
    }
  }


  getWatchListMovies(int id, String sessionId, page, type)async {
    final response = await http.get('$tMDBApi/account/$id/watchlist/$type?api_key=$apiKey&session_id=$sessionId&page=$page&sort_by=created_at.asc&language=${SettingsProvider.language}');
    if (response.statusCode == 200) {
      return ListResponse.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR WatchList");
    }
  }

  markAsFavorite(mediaId, bool isRemove, String  sessionId,  userId, type) async {
    final response = await http.post('$tMDBApi/account/$userId/favorite?api_key=$apiKey&session_id=$sessionId',
        headers: {"Content-Type":"application/json;charset=utf-8"},
        body: jsonEncode({
          "favorite": isRemove,
          "media_type": type,
          "media_id": mediaId.toString(),
        })
    );
    print(json.decode(response.body));
    if (json.decode(response.body)["success"]) {
      return json.decode(response.body);
    }
    else {
      print("ERROR Favorite");
    }
  }

  markAsWatch(mediaId, bool isRemove, String  sessionId,  userId, type) async {
    final response = await http.post('$tMDBApi/account/$userId/watchlist?api_key=$apiKey&session_id=$sessionId',
        headers: {"Content-Type":"application/json;charset=utf-8"},
        body: jsonEncode({
          "watchlist": isRemove,
          "media_type": type,
          "media_id": mediaId.toString(),
        })
    );
    print(json.decode(response.body));
    if (json.decode(response.body)["success"]) {
      return json.decode(response.body);
    }
    else {
      print("ERROR WatchList");
    }
  }


  getDiscover(String type, int page, String genres, year) async{
    final response = await http.get(''
        '$tMDBApi/discover/''$type?'
        'api_key=$apiKey'
        '&page=$page'
        '&language=${SettingsProvider.language}'
        '&include_adult=$includeAdult'
        "$year"
        '&with_genres=$genres'
        '&sort_by=popularity.desc'
    );
    print(response.request);
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    }
    else {
      print("ERROR Trending");
    }
  }

}