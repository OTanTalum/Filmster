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

  List<SearchResults> favoriteList=[];
  List<int> favoriteIds=[];

  List<SearchResults> watchList=[];
  List<int> watchListIds=[];

  int currentPage = 1;

  auth(String username, String password) async {
    await createRequest();
    await validate(username, password);
    await createSesion();
    await getUser();
    await saveUser(password);
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
    favoriteIds = [];
    favoriteList = [];
    int totalResults = 21;
    for (int i = 1; (i-1)*20< totalResults; i++) {
      ListResponse response =
          await Api().getFavoriteMovies(currentUser.id, sesion_id, i);
      totalResults = response.totalResults;
      response.results.forEach((element) {
        if (!favoriteList.contains(element)) {
          favoriteList.add(element);
        }
      });
      favoriteList.forEach((element) {
        if(!favoriteIds.contains(element.id)) {
          favoriteIds.add(element.id);
        }
      });
    }
    notifyListeners();
  }

  getWatchList() async {
    watchListIds = [];
    watchList = [];
    int totalResults = 21;
    for (int i = 1; (i-1)*20< totalResults; i++) {
      ListResponse response =
          await Api().getWatchListMovies(currentUser.id, sesion_id, i);
      totalResults = response.totalResults;
      response.results.forEach((element) {
        if (!watchList.contains(element)) {
          watchList.add(element);
        }
      });
      watchList.forEach((element) {
        if(!watchListIds.contains(element.id)) {
          watchListIds.add(element.id);
        }
      });
    }
    notifyListeners();
  }

  markAsFavorite(id, isRemove) async {
    var response =
        await Api().markAsFavorite( id, isRemove, sesion_id, currentUser.id);
    if (response["success"]) {
      await getFavorite();
    }
    notifyListeners();
  }

  markAsWatch(id, isRemove) async {
    var response =
        await Api().markAsWatch( id, isRemove, sesion_id, currentUser.id);
    if (response["success"]) {
      await getWatchList();
    }
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

