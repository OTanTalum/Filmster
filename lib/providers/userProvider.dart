import 'package:filmster/model/authentication.dart';
import 'package:filmster/model/film.dart';
import 'package:filmster/model/responses.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  String requestToken;
  String logedToken;
  String sesion_id;
  bool isloged;
  User currentUser;

  String watchedId;

  List<SearchResults> favoriteMovieList=[];
  List<int> favoriteMovieIds=[];
  List<SearchResults> favoriteTVList=[];
  List<int> favoriteTVIds=[];

  List<SearchResults> markedMovieList=[];
  List<int> markedMovieListIds=[];
  List<SearchResults> markedTVList=[];
  List<int> markedTVListIds=[];

  List<SearchResults> watchedList=[];
  List<int> watchedListIds=[];


  List <CustomList> listOfLists=[];

  List<SearchResults> christianMovie=[];
  
  String currentType = 'movie';
  String currentPeriod = 'day';

  int currentPage = 1;
  int totalPage;

  auth(String username, String password) async {
    await createRequest();
    await validate(username, password);
    await createSesion();
    await getUser();
    await saveUser(password);
    print(currentUser.id);
  }

  createRequest() async {
    TokenRequestResponse response = await Api().getRequestToken();
    requestToken = response.requestToken;
    notifyListeners();
    return response;
  }

  validate(String username, String password) async {
    TokenRequestResponse response = await Api().login(username, password, requestToken);
    logedToken = response.requestToken;
    isloged = response.success;
    notifyListeners();
    return response;
  }

  createSesion() async {
    SesionRequestResponse response = await Api().createSession(logedToken);
    sesion_id = response.sesionId;
    isloged = response.success;
    notifyListeners();
    return response;
  }

  getUser()async{
    User response = await Api().getUser(sesion_id);
    currentUser = response;
    notifyListeners();
    return currentUser;
  }

  saveUser(String password) async {
    await Prefs().setIntPrefs('userID', currentUser.id);
    await Prefs().setStringPrefs('username', currentUser.userName);
    await Prefs().setStringPrefs('password', password);
    if (await Prefs().hasString("username")) {
      String username = await Prefs().getStringPrefs("username");
      String password = await Prefs().getStringPrefs("password");
      print(username);
      print(password);
    }
    notifyListeners();
  }

  getFavorite() async {
    if (currentType == "tv") {
      favoriteTVIds = [];
      favoriteTVList = [];
      int totalResults = 21;
      for (int i = 1; (i - 1) * 20 < totalResults; i++) {
        ListResponse response = await Api().getFavoriteMovies(currentUser.id,
            sesion_id, i, currentType != "tv" ? "movies" : "tv");
        totalResults = response.totalResults;
        response.results.forEach((element) {
          if (!favoriteTVList.contains(element)) {
            favoriteTVList.add(element);
          }
        });
        favoriteTVList.forEach((element) {
          if (!favoriteTVIds.contains(element.id)) {
            favoriteTVIds.add(element.id);
          }
        });
      }
    }
    else{
      favoriteMovieIds = [];
      favoriteMovieList = [];
      int totalResults = 21;
      for (int i = 1; (i - 1) * 20 < totalResults; i++) {
        ListResponse response = await Api().getFavoriteMovies(currentUser.id,
            sesion_id, i, currentType != "tv" ? "movies" : "tv");
        totalResults = response.totalResults;
        response.results.forEach((element) {
          if (!favoriteMovieList.contains(element)) {
            favoriteMovieList.add(element);
          }
        });
        favoriteMovieList.forEach((element) {
          if (!favoriteMovieIds.contains(element.id)) {
            favoriteMovieIds.add(element.id);
          }
        });
      }
    }
    notifyListeners();
  }

  getMarkList() async {
    if (currentType == "tv") {
      markedTVListIds = [];
      markedTVList = [];
      int totalResults = 21;
      for (int i = 1; (i - 1) * 20 < totalResults; i++) {
        ListResponse response =
        await Api().getMarkedListMovies(currentUser.id, sesion_id, i,
            currentType != "tv" ? "movies" : "tv");
        totalResults = response.totalResults;
        response.results.forEach((element) {
          if (!markedTVList.contains(element)) {
            markedTVList.add(element);
          }
        });
        markedTVList.forEach((element) {
          if (!markedTVListIds.contains(element.id)) {
            markedTVListIds.add(element.id);
          }
        });
      }
    }
    else {
      markedMovieListIds = [];
      markedMovieList = [];
      int totalResults = 21;
      for (int i = 1; (i - 1) * 20 < totalResults; i++) {
        ListResponse response =
        await Api().getMarkedListMovies(currentUser.id, sesion_id, i,
            currentType != "tv" ? "movies" : "tv");
        totalResults = response.totalResults;
        response.results.forEach((element) {
          if (!markedMovieList.contains(element)) {
            markedMovieList.add(element);
          }
        });
        markedMovieList.forEach((element) {
          if (!markedMovieListIds.contains(element.id)) {
            markedMovieListIds.add(element.id);
          }
        });
      }
    }
    notifyListeners();
  }

  markAsFavorite(id, isRemove) async {
    var response =
        await Api().markAsFavorite( id, isRemove, sesion_id, currentUser.id, currentType);
    if (response["success"]) {
      await getFavorite();
    }
    notifyListeners();
  }

  markAsWatched(mediaId, bool isWatched) async {
    var response = isWatched
        ? await Api().markAsWatched(watchedId, sesion_id, mediaId)
        : await Api().deleteFromWatched(watchedId, sesion_id, mediaId);
    if (response["success"]) {
      await getWatched();
    }
    notifyListeners();
  }

  mark(id, isRemove) async {
    var response =
        await Api().mark( id, isRemove, sesion_id, currentUser.id, currentType);
    if (response["success"]) {
      await getMarkList();
    }
    notifyListeners();
  }

  changeCurrentType(type){
    currentType = type;
    notifyListeners();
  }

  changeCurrentPeriod(type){
    currentPeriod = type;
    notifyListeners();
  }
  getChristian() async {
  ListResponse response = await Api().getChristianMovies(currentPage);
  totalPage = response.totalPage;
    response.results.forEach((element) {
      if (!christianMovie.contains(element)) {
        christianMovie.add(element);
      }
    });
    notifyListeners();
  }
  getWatched() async {
      watchedListIds = [];
      watchedList = [];
      int totalResults = 21;
      for (int i = 1; (i - 1) * 20 < totalResults; i++) {
        print(i);
        CustomList response =
        await Api().getWatchedList(sesion_id, watchedId, i);
        totalResults = response.itemCount;
        response.items.forEach((element) {
          if (!watchedList.contains(element)) {
            watchedList.add(element);
          }
        });
        watchedList.forEach((element) {
          if (!watchedListIds.contains(element.id)) {
            watchedListIds.add(element.id);
          }
        });
      }
    notifyListeners();
  }

  getLists() async {
    listOfLists = [];
    CustomListResponse response = await Api().getLists(
        currentUser.id, sesion_id);
    response.results.forEach((element) {
      print(element.name);
      if (element.name == "Watched list by Filmster") {
        watchedId= element.id.toString();
        listOfLists.add(element);
      }

    });
    if (listOfLists.isEmpty) {
    var res =  await Api().createWatchedList(sesion_id);
    watchedId= res['list_id'];
    }
    await getWatched();
    notifyListeners();
  }

  exit() async{
    await Prefs().removeValues('userID');
    await Prefs().removeValues('username');
    await Prefs().removeValues('password');
    isloged = false;
    currentUser=null;
    notifyListeners();
  }
}

