import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/authentication.dart';
import 'package:filmster/model/responses.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int ELEMENTS_PER_PAGE = 20;
const int RESPONSE_ADD_TO_LIST_SUCCESS = 12;
const int RESPONSE_REMOVE_FROM_LIST_SUCCESS = 13;
const int RESPONSE_MARK_SUCCESS = 1;

class LibraryProvider extends ChangeNotifier {
  String? requestToken;
  String? logedToken;
  String? sesion_id;
  bool? isloged;
  User? currentUser;

  String? watchedmovieId;
  String? watchedTVId;

  List<SearchResults> favoriteMovieList = [];
  List<int?> favoriteMovieListIds = [];
  List<SearchResults> favoriteTVList = [];
  List<int?> favoriteTVIds = [];

  List<SearchResults> markedMovieList = [];
  List<int?> markedMovieListIds = [];
  List<SearchResults> markedTVList = [];
  List<int?> markedTVListIds = [];

  List<SearchResults> watchedMovieList = [];
  List<int?> watchedMovieListIds = [];
  List<SearchResults> watchedTvList = [];
  List<int?> watchedTvListIds = [];

  List<CustomList> listOfMovieLists = [];
  List<CustomList> listOfTVLists = [];

  List<SearchResults> christianMovie = [];

  bool isMovie = true;
  String currentPeriod = 'day';

  int currentPage = 1;
  int? totalChristianPage;
  int? totalWatchedPage;


  bool isLoading = false;

  auth(String username, String password, scaffoldKey) async {
    await createRequest(scaffoldKey);
    await validate(username, password, scaffoldKey);
    await createSession(scaffoldKey);
    await getUser(scaffoldKey);
    if(currentUser!=null) {
      await saveUser(password);
    }
  }

  Future<void> createRequest(keyState) async {
    BasicResponse response = await Api().getRequestToken();
    if (response.isSuccess!) {
      requestToken = response.requestToken;
      notifyListeners();
    } else {
      CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
    }
  }

  Future<void> validate(String username, String password, keyState) async {
    BasicResponse response =
        await Api().login(username, password, requestToken);
    if(response.isSuccess!){
      logedToken = response.requestToken;
      isloged = response.isSuccess;
      notifyListeners();
    }else{
      CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
    }
  }

  Future<void> createSession(keyState) async {
    BasicResponse response = await Api().createSession(logedToken);
    if(response.isSuccess!){
      sesion_id = response.sessionId;
      isloged = response.isSuccess;
      notifyListeners();
    }else{
      CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
    }
  }

  Future<void> getUser(keyState) async {
    var response = await Api().getUser(sesion_id);
    if(hasError(response)){
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
      currentUser =  null;
      notifyListeners();
    }
    else {
      currentUser = response;
      notifyListeners();
    }
  }

  saveUser(String password) async {
    await Prefs().setIntPrefs('userID', currentUser!.id!);
    await Prefs().setStringPrefs('username', currentUser!.userName!);
    await Prefs().setStringPrefs('password', password);
    if (await Prefs().hasString("username")) {
      String username = await Prefs().getStringPrefs("username");
      String password = await Prefs().getStringPrefs("password");
      print(username);
      print(password);
    }
    notifyListeners();
  }

  List<SearchResults> getFavoriteList() {
    return isMovie ? favoriteMovieList : favoriteTVList;
  }

  List<SearchResults> getMarkedList() {
    return isMovie ? markedMovieList : markedTVList;
  }

  List<SearchResults> getWatchedList() {
    return isMovie ? watchedMovieList : watchedTvList;
  }

  getFavoriteMovies(keyState) async {
    favoriteMovieListIds = [];
    favoriteMovieList = [];
    int? totalPages;
    for (int page = 1; page <= (totalPages ?? 2); page++) {
      var response = await Api()
          .getFavoriteMovies(currentUser!.id, sesion_id, page, "movies");
      if (hasError(response)) {
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return;
      } else {
        totalPages = response.totalPage;
        response.results.forEach((element) {
          favoriteMovieList.add(element);
        });
        favoriteMovieList.forEach((element) {
          favoriteMovieListIds.add(element.id);
        });
      }
    }
    notifyListeners();
  }

  getFavoriteTv(keyState) async {
    favoriteTVIds = [];
    favoriteTVList = [];
    int? totalPages;
    for (int page = 1; page <= (totalPages ?? 2); page++) {
      var response =
      await Api().getFavoriteMovies(currentUser!.id, sesion_id, page, "tv");
      if (hasError(response)) {
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return;
      } else {
        totalPages = response.totalPage;
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
    notifyListeners();
  }

  getMarkedMovieList(keyState) async {
    markedMovieListIds = [];
    markedMovieList = [];
    int? totalPages;
    for (int page = 1; page < (totalPages ?? 2); page++) {
      var response = await Api()
          .getMarkedListMovies(currentUser!.id, sesion_id, page, "movies");
      if (hasError(response)) {
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return;
      } else {
        totalPages = response.totalPage;
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

  getMarkedTVList(keyState) async {
    markedTVListIds = [];
    markedTVList = [];
    int? totalPages;
    for (int page = 1; page < (totalPages ?? 2); page++) {
      var response = await Api()
          .getMarkedListMovies(currentUser!.id, sesion_id, page, "tv");
      if (hasError(response)) {
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return;
      } else {
        totalPages = response.totalPage;
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
    notifyListeners();
  }

  Future<void> removeFromMarkedList(SearchResults film, keyState) async {
    await Api()
        .removeFromMarkedList(
            film.id, sesion_id, currentUser!.id, isMovie ? "movie" : "tv")
        .then((BasicResponse response) {
      if (response.isSuccess ??
          response.code == RESPONSE_REMOVE_FROM_LIST_SUCCESS) {
        if (isMovie) {
          markedMovieList
              .removeWhere((SearchResults element) => element.id == film.id);
          markedMovieListIds.removeWhere((int? element) => element == film.id);
        } else {
          markedTVList
              .removeWhere((SearchResults element) => element.id == film.id);
          markedTVListIds.removeWhere((int? element) => element == film.id);
        }
      }
      else{
        CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
      }
    });
    notifyListeners();
  }

  Future<void> mark(SearchResults film, keyState) async {
    BasicResponse response = await Api()
        .mark(film.id, sesion_id, currentUser!.id, isMovie ? "movie" : "tv");
    if (response.isSuccess ?? response.code == RESPONSE_MARK_SUCCESS) {
      if (isMovie) {
        markedMovieList.add(film);
        markedMovieListIds.add(film.id);
      } else {
        markedTVList.add(film);
        markedTVListIds.add(film.id);
      }
    }else{
      CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
    }
    notifyListeners();
  }

  Future<void> markAsFavorite(SearchResults film, isFavorite, keyState) async {
    BasicResponse response = await Api().markAsFavorite(film.id, !isFavorite,
        sesion_id, currentUser!.id, isMovie ? "movie" : "tv");
    if (response.isSuccess ??
        (isFavorite
            ? response.code == RESPONSE_MARK_SUCCESS
            : response.code == RESPONSE_REMOVE_FROM_LIST_SUCCESS)) {
      if (isMovie) {
        isFavorite
            ? favoriteMovieList
                .removeWhere((SearchResults element) => element.id == film.id)
            : favoriteMovieList.add(film);
        isFavorite
            ? favoriteMovieListIds.removeWhere((int? element) => element == film.id)
            : favoriteMovieListIds.add(film.id);
      } else {
        isFavorite
            ? favoriteTVList
                .removeWhere((SearchResults element) => element.id == film.id)
            : favoriteTVList.add(film);
        isFavorite
            ? favoriteTVIds.removeWhere((int? element) => element == film.id)
            : favoriteTVIds.add(film.id);
      }
    }
    else{
      CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
    }
    notifyListeners();
  }

  Future<void> removeFromWatched(SearchResults film, keyState) async {
    await Api()
        .deleteFromWatched(watchedmovieId, sesion_id, film.id)
        .then((BasicResponse response) {
      if (response.isSuccess ??
          response.code == RESPONSE_REMOVE_FROM_LIST_SUCCESS) {
        if (isMovie) {
          watchedMovieList
              .removeWhere((SearchResults element) => element.id == film.id);
          watchedMovieListIds.removeWhere((int? element) => element == film.id);
        } else {
          watchedTvList
              .removeWhere((SearchResults element) => element.id == film.id);
          watchedTvListIds.removeWhere((int? element) => element == film.id);
        }
      } else {
        CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
      }
    });
    notifyListeners();
  }

  Future<void> markAsWatched(SearchResults film, keyState) async {
    await Api()
        .markAsWatched(watchedmovieId, sesion_id, film.id)
        .then((BasicResponse response) {
      if (response.isSuccess ?? response.code == RESPONSE_ADD_TO_LIST_SUCCESS) {
        if (isMovie) {
          watchedMovieList.add(film);
          watchedMovieListIds.add(film.id);
        } else {
          watchedTvList.add(film);
          watchedTvListIds.add(film.id);
        }
      } else {
        CustomSnackBar().showSnackBar(title: response.massage!, state: keyState);
      }
    });
    notifyListeners();
  }

  Future<void> getChristian(keyState, int page) async {
    isLoading = true;
    var response = await Api().getChristianMovies(page);
    if(hasError(response)){
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
      isLoading = false;
      return;
    }else {
      totalChristianPage = response.totalPage;
      response.results.forEach((element) {
        if (!christianMovie.contains(element)) {
          christianMovie.add(element);
        }
      });
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> getWatchedTvList(keyState) async {
    watchedTvList = [];
    watchedTvListIds = [];
      var response = await Api().getWatchedList(sesion_id, watchedTVId);
      if (response==false) {
       // CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return;
      } else {
        totalWatchedPage=response.itemCount~/20+(response.itemCount%20==0?0:1);
        response.items.forEach((element) {
          if (!watchedTvList.contains(element)) {
            watchedTvList.add(element);
          }
        });
        watchedTvList.forEach((element) {
          if (!watchedTvListIds.contains(element.id)) {
            watchedTvListIds.add(element.id);
          }
        });
    }
    notifyListeners();
  }

  Future<void> getWatchedMovieList(keyState) async {
    watchedMovieListIds.clear();
    watchedMovieList.clear();
      var response = await Api().getWatchedList(sesion_id, watchedmovieId);
      if (response==false) {
       // CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return;
      } else {
        totalWatchedPage=response.itemCount~/20+(response.itemCount%20==0?0:1);
        response.items.forEach((element) {
          if (!watchedMovieList.contains(element)) {
            watchedMovieList.add(element);
          }
        });
        watchedMovieList.forEach((element) {
          if (!watchedMovieListIds.contains(element.id)) {
            watchedMovieListIds.add(element.id);
          }
        });
    }
    notifyListeners();
  }


  Future<void> getLists(keyState) async {
    listOfMovieLists = [];
    listOfTVLists = [];

    var response = await Api().getLists(currentUser!.id, sesion_id);
    if (hasError(response)) {
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
    } else {
      response.results.forEach((element) {
        if (element.name == "Watched list by Filmster") {
          watchedmovieId = element.id.toString();
          listOfMovieLists.add(element);
        }
        if (element.name == "Watched TVlist by Filmster") {
          watchedTVId = element.id.toString();
          listOfTVLists.add(element);
        }
      });

      if (listOfMovieLists.isEmpty) {
        BasicResponse res = await Api().createWatchedMovieList(sesion_id);
        if (res.isSuccess!) {
          watchedmovieId = res.listId;
        } else {
          CustomSnackBar().showSnackBar(title: res.massage!, state: keyState);
        }
      }
      if (listOfTVLists.isEmpty) {
        BasicResponse res = await Api().createWatchedTVList(sesion_id);
        if (res.isSuccess!) {
          watchedTVId = res.listId;
        } else {
          CustomSnackBar().showSnackBar(title: res.massage!, state: keyState);
        }
      }

      isMovie
          ? await getWatchedMovieList(keyState)
          : await getWatchedTvList(keyState);
    }
    notifyListeners();
  }

  Future<void> exit() async {
    await Prefs().removeValues('userID');
    await Prefs().removeValues('username');
    await Prefs().removeValues('password');
    isloged = false;
    currentUser = null;
    notifyListeners();
  }

  void changeCurrentType() {
    isMovie = !isMovie;
    notifyListeners();
  }

  void changeCurrentPeriod(type) {
    currentPeriod = type;
    notifyListeners();
  }

  bool hasError(response) {
    return response.runtimeType == BasicResponse();
  }

  void notify() {
    notifyListeners();
  }
}
