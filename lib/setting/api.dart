
import 'dart:convert';

import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/GalleryResponse.dart';
import 'package:filmster/model/Genre.dart';
import 'package:filmster/model/Season.dart';
import 'package:filmster/model/authentication.dart';
import 'package:filmster/model/film.dart';
import 'package:filmster/model/responses.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:http/http.dart' as http;

const int RESPONSE_SUCCESS = 200;

class Api extends http.BaseClient {

  final String apiKey = "22e195d94c2274b3dcf6484e58a1715f";
  final String imageLowAPI = "https://image.tmdb.org/t/p/w300";
  final String imageBannerAPI = "https://image.tmdb.org/t/p/w500";
  final String imageGalleryAPI = "https://image.tmdb.org/t/p/original";
  String tMDBApi = 'https://api.themoviedb.org/3';
  bool includeAdult = false;

  searchMovie(String type, String query, int page) async {
    final response = await http.get(
        '$tMDBApi/search/$type?api_key=$apiKey&query=$query&page=$page&language=${SettingsProvider
            .language}&include_adult=$includeAdult');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getTrending(String type, String period, int page) async {
    final response = await http.get(
        '$tMDBApi/trending/$type/$period?api_key=$apiKey&page=$page&language=${SettingsProvider
            .language}&include_adult=$includeAdult');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  Future<GenresResponse> getMovieGenres() async {
    final response = await http.get(
        '$tMDBApi/genre/movie/list?api_key=$apiKey&language=${SettingsProvider
            .language}');
    return GenresResponse.fromJson(json.decode(response.body));
  }

  Future<GenresResponse> getTVGenres() async {
    final response = await http.get(
        '$tMDBApi/genre/tv/list?api_key=$apiKey&language=${SettingsProvider
            .language}');
    return GenresResponse.fromJson(json.decode(response.body));
  }

  getTvDetail(String? id) async {
    final response = await http.get(
        '$tMDBApi/tv/$id?api_key=$apiKey&language=${SettingsProvider
            .language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Film.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getFilmDetail(String? id) async {
    final response = await http.get(
        '$tMDBApi/movie/$id?api_key=$apiKey&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Film.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> getRequestToken() async {
    final response = await http.get('$tMDBApi/authentication/token/new?api_key=$apiKey');
    return BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> login(String username, String password, String? requestToken) async {
    final response = await http.post(
        '$tMDBApi/authentication/token/validate_with_login?api_key=$apiKey',
        body: {
          "username": username,
          "password": password,
          "request_token": requestToken
        });
    return BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> createSession(String? token) async {
    final response = await http.post(
        '$tMDBApi/authentication/session/new?api_key=$apiKey',
        body: {
          "request_token": token
        });
    return BasicResponse.fromJson(json.decode(response.body));
  }

  getUser(String? sessionId) async {
    final response =
        await http.get('$tMDBApi/account?api_key=$apiKey&session_id=$sessionId');
    return response.statusCode == RESPONSE_SUCCESS
        ? User.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getChristianMovies(page) async {
    final response = await http.get(
        '$tMDBApi/keyword/253695/movies?api_key=$apiKey&language=${SettingsProvider.language}&page=$page');
    return response.statusCode == RESPONSE_SUCCESS
        ? ListResponse.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getFavoriteMovies(int? id, String? sessionId, page, type) async {
    final response = await http.get(
        '$tMDBApi/account/$id/favorite/$type?api_key=$apiKey&session_id=$sessionId&page=$page&sort_by=created_at.desc&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? ListResponse.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getMarkedListMovies(int? id, String? sessionId, page, type) async {
    final response = await http.get(
        '$tMDBApi/account/$id/watchlist/$type?api_key=$apiKey&session_id=$sessionId&page=$page&sort_by=created_at.desc&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? ListResponse.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> removeFromMarkedList(mediaId, String? sessionId, userId, type) async {
    final response = await http.post(
        '$tMDBApi/account/$userId/watchlist?api_key=$apiKey&session_id=$sessionId',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: jsonEncode({
          "watchlist": false,
          "media_type": type,
          "media_id": mediaId.toString(),
        })
    );
    return BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> mark(mediaId, String? sessionId, userId, type) async {
    final response = await http.post(
        '$tMDBApi/account/$userId/watchlist?api_key=$apiKey&session_id=$sessionId',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: jsonEncode({
          "watchlist": true,
          "media_type": type,
          "media_id": mediaId.toString(),
        })
    );
    return BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> markAsFavorite(mediaId, bool isRemove, String? sessionId, userId, type) async {
    final response = await http.post(
        '$tMDBApi/account/$userId/favorite?api_key=$apiKey&session_id=$sessionId',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: jsonEncode({
          "favorite": isRemove,
          "media_type": type,
          "media_id": mediaId,
        })
    );
    return BasicResponse.fromJson(json.decode(response.body));
  }

  getDiscover(bool isMovie, int page, String genres, year) async {
    final response = await http.get(''
        '$tMDBApi/discover/'
        '${isMovie ? "movie" : "tv"}?'
        'api_key=$apiKey'
        '&page=$page'
        '&language=${SettingsProvider.language}'
        '&include_adult=$includeAdult'
        "$year"
        '&with_genres=$genres'
        '&sort_by=popularity.desc');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getLists(int? userId, String? sessionId) async {
    var response = await http.get(
        '$tMDBApi/account/$userId/lists?'
            'api_key=$apiKey'
            '&language=${SettingsProvider.language}'
            '&session_id=$sessionId');
    return response.statusCode == RESPONSE_SUCCESS
        ? CustomListResponse.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> createWatchedMovieList(String? sessionId) async {
    final response = await http.post(
        '$tMDBApi/list?api_key=$apiKey&session_id=$sessionId',
        body: {
          "name": "Watched list by Filmster",
          "description": "List watched Movie by Filmster",
          "language": "${SettingsProvider.language}"
        });
    return BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> createWatchedTVList(String? sessionId) async {
    var response = await http.post(
        '$tMDBApi/list?api_key=$apiKey&session_id=$sessionId',
        body: {
          "name": "Watched TVlist by Filmster",
          "description": "List watched Movie by Filmster",
          "list_type": "tv",
          "language": "${SettingsProvider.language}"
        });
    return BasicResponse.fromJson(json.decode(response.body));
  }

  getWatchedList(String? sessionId, String? listId) async {
    var response = await http.get('$tMDBApi/list/$listId?'
        'api_key=$apiKey'
        '&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? CustomList.fromJson(json.decode(response.body))
        : false;
  }

  Future<BasicResponse> markAsWatched(String? listId, String? sessionId, mediaId) async {
    final response = await http.post('$tMDBApi/list/$listId/add_item'
        '?api_key=$apiKey'
        '&session_id=$sessionId',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: jsonEncode({
          "media_id": mediaId.toString(),
        })
    );
    return BasicResponse.fromJson(json.decode(response.body));
  }

  Future<BasicResponse> deleteFromWatched(String? listId, String? sessionId, mediaId) async {
    final response = await http.post('$tMDBApi/list/$listId/remove_item'
        '?api_key=$apiKey'
        '&session_id=$sessionId',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: jsonEncode({
          "media_id": mediaId.toString(),
        })
    );
    return BasicResponse.fromJson(json.decode(response.body));
  }

  getFilmImages(String? id) async {
    var response = await http.get(
        '$tMDBApi/movie/$id/images?api_key=$apiKey');
    return response.statusCode == RESPONSE_SUCCESS
        ? GalleryResponse.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getTvImages(String? id) async {
    var response = await http.get(
        '$tMDBApi/tv/$id/images?api_key=$apiKey');
    return response.statusCode == RESPONSE_SUCCESS
        ? GalleryResponse.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getPosters(link) async{
    var response = await http.get(
        '$imageGalleryAPI$link');
    return response;
  }

  getSimilarMovie(id)async{
    var response = await http.get(
        '$tMDBApi/movie/$id/similar?api_key=$apiKey'
            '&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getSimilarTv(id)async{
    var response = await http.get(
        '$tMDBApi/tv/$id/similar?api_key=$apiKey'
            '&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }


  getRecommendedMovie(id)async{
    var response = await http.get(
        '$tMDBApi/movie/$id/recommendations?api_key=$apiKey'
            '&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getRecommendedTv(id)async{
    var response = await http.get(
        '$tMDBApi/tv/$id/recommendations?api_key=$apiKey'
            '&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Search.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  getSeason(seasonNumber, tvId)async{
    var response = await http.get(
        '$tMDBApi/tv/$tvId/season/$seasonNumber?api_key=$apiKey'
            '&language=${SettingsProvider.language}');
    return response.statusCode == RESPONSE_SUCCESS
        ? Season.fromJson(json.decode(response.body))
        : BasicResponse.fromJson(json.decode(response.body));
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get);

    await metric.start();
    print(request);
    print("_____________________");
    http.StreamedResponse? response;
    try {
      metric
        ..responsePayloadSize = response!.contentLength
        ..responseContentType = response.headers['Content-Type']!
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }
}