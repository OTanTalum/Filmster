import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/authentication.dart';
import 'package:filmster/model/responses.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/widgets/UI/CustomSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int ELEMENTS_PER_PAGE = 20;
const int RESPONSE_SUCCESS = 200;
const int RESPONSE_ADD_TO_LIST_SUCCESS = 12;
const int RESPONSE_REMOVE_FROM_LIST_SUCCESS = 13;
const int RESPONSE_MARK_SUCCESS = 1;

class UserProvider extends ChangeNotifier {
  String requestToken;
  String logedToken;
  String sesion_id;
  bool isloged;
  User currentUser;

  String watchedmovieId;
  String watchedTVId;

  List<SearchResults> favoriteMovieList = [];
  List<int> favoriteMovieIds = [];
  List<SearchResults> favoriteTVList = [];
  List<int> favoriteTVIds = [];

  List<SearchResults> markedMovieList = [];
  List<int> markedMovieListIds = [];
  List<SearchResults> markedTVList = [];
  List<int> markedTVListIds = [];

  List<SearchResults> watchedMovieList = [];
  List<int> watchedMovieListIds = [];
  List<SearchResults> watchedTvList = [];
  List<int> watchedTvListIds = [];

  List<CustomList> listOfLists = [];
  List<CustomList> listOfLists2 = [];

  List<SearchResults> christianMovie = [];

  bool isMovie = true;
  String currentPeriod = 'day';

  int currentPage = 1;
  int totalPage;

  bool isLoading = false;

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
    TokenRequestResponse response =
        await Api().login(username, password, requestToken);
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

  getUser() async {
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

  List<SearchResults> getFavoriteList() {
    return isMovie ? favoriteMovieList : favoriteTVList;
  }

  List<SearchResults> getMarkedList() {
    return isMovie ? markedMovieList : markedTVList;
  }

  List<SearchResults> getWatchedList() {
    return isMovie ? watchedMovieList : watchedTvList;
  }

  getFavoriteMovies() async {
    favoriteMovieIds = [];
    favoriteMovieList = [];
    int totalPages;
    for (int page = 1; page <= (totalPages ?? 2); page++) {
      ListResponse response = await Api()
          .getFavoriteMovies(currentUser.id, sesion_id, page, "movies");
      totalPages = response.totalPage;
      response.results.forEach((element) {
        favoriteMovieList.add(element);
      });
      favoriteMovieList.forEach((element) {
        favoriteMovieIds.add(element.id);
      });
    }
    notifyListeners();
  }

  getFavoriteTv() async {
    favoriteTVIds = [];
    favoriteTVList = [];
    int totalPages;
    for (int page = 1; page <= (totalPages ?? 2); page++) {
      ListResponse response =
          await Api().getFavoriteMovies(currentUser.id, sesion_id, page, "tv");
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
    notifyListeners();
  }

  getMarkedMovieList() async {
    markedMovieListIds = [];
    markedMovieList = [];
    int totalPages;
    for (int page = 1; page < (totalPages ?? 2); page++) {
      ListResponse response = await Api()
          .getMarkedListMovies(currentUser.id, sesion_id, page, "movies");
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
    notifyListeners();
  }

  getMarkedTVList() async {
    markedTVListIds = [];
    markedTVList = [];
    int totalPages;
    for (int page = 1; page < (totalPages ?? 2); page++) {
      ListResponse response = await Api()
          .getMarkedListMovies(currentUser.id, sesion_id, page, "tv");
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
    notifyListeners();
  }

 Future<void> removeFromMarkedList(SearchResults film) async {
    await Api()
        .removeFromMarkedList(
            film.id, sesion_id, currentUser.id, isMovie ? "movie" : "tv")
        .then((BasicResponse response) {
      if (response.isSuccess??response.code==RESPONSE_REMOVE_FROM_LIST_SUCCESS) {
        if (isMovie) {
          markedMovieList
              .removeWhere((SearchResults element) => element.id == film.id);
          markedMovieListIds.removeWhere((int element) => element == film.id);
        } else {
          markedTVList
              .removeWhere((SearchResults element) => element.id == film.id);
          markedTVListIds.removeWhere((int element) => element == film.id);
        }
      }
    });
    notifyListeners();
  }

  Future<void> mark(SearchResults film) async {
    BasicResponse response = await Api()
        .mark(film.id, sesion_id, currentUser.id, isMovie ? "movie" : "tv");
    if (response.isSuccess??response.code == RESPONSE_MARK_SUCCESS) {
      if (isMovie) {
        markedMovieList.add(film);
        markedMovieListIds.add(film.id);
      } else {
        markedTVList.add(film);
        markedTVListIds.add(film.id);
      }
    }
    notifyListeners();
  }

  Future<void> markAsFavorite(SearchResults film, isFavorite) async {
    BasicResponse response = await Api().markAsFavorite(film.id, !isFavorite,
        sesion_id, currentUser.id, isMovie ? "movie" : "tv");
    if (response.isSuccess ?? (isFavorite
        ? response.code == RESPONSE_MARK_SUCCESS
        : response.code == RESPONSE_REMOVE_FROM_LIST_SUCCESS)) {
      if (isMovie) {
        isFavorite
            ? favoriteMovieList
                .removeWhere((SearchResults element) => element.id == film.id)
            : favoriteMovieList.add(film);
        isFavorite
            ? favoriteMovieIds.removeWhere((int element) => element == film.id)
            : favoriteMovieIds.add(film.id);
      } else {
        isFavorite
            ? favoriteTVList
                .removeWhere((SearchResults element) => element.id == film.id)
            : favoriteTVList.add(film);
        isFavorite
            ? favoriteTVIds.removeWhere((int element) => element == film.id)
            : favoriteTVIds.add(film.id);
      }
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
          watchedMovieListIds.removeWhere((int element) => element == film.id);
        } else {
          watchedTvList
              .removeWhere((SearchResults element) => element.id == film.id);
          watchedTvListIds.removeWhere((int element) => element == film.id);
        }
      } else {
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
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
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
      }
    });
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  changeCurrentType() {
    isMovie = !isMovie;
    notifyListeners();
  }

  changeCurrentPeriod(type) {
    currentPeriod = type;
    notifyListeners();
  }

  getChristian() async {
    isLoading = true;
    ListResponse response = await Api().getChristianMovies(currentPage);
    totalPage = response.totalPage;
    response.results.forEach((element) {
      if (!christianMovie.contains(element)) {
        christianMovie.add(element);
      }
    });
    isLoading = false;
    notifyListeners();
  }

  getWatched() async {
    watchedMovieListIds = [];
    watchedMovieList = [];
    watchedTvList = [];
    watchedTvListIds = [];
    int totalResults = 21;
    for (int i = 1; (i - 1) * 20 < totalResults; i++) {
      CustomList response = isMovie
          ? await Api().getWatchedList(sesion_id, watchedmovieId, i)
          : await Api().getWatchedList(sesion_id, watchedTVId, i);
      totalResults = response.itemCount;
      print(response.name);
      print(response.itemCount);
      response.items.forEach((element) {
        if (!watchedMovieList.contains(element) && isMovie) {
          watchedMovieList.add(element);
        } else if (!watchedTvList.contains(element) && !isMovie) {
          watchedTvList.add(element);
        }
      });
      if (isMovie) {
        watchedMovieList.forEach((element) {
          if (!watchedMovieListIds.contains(element.id)) {
            watchedMovieListIds.add(element.id);
          }
        });
      } else {
        watchedTvList.forEach((element) {
          if (!watchedTvListIds.contains(element.id)) {
            watchedTvListIds.add(element.id);
          }
        });
      }
    }
    notifyListeners();
  }

  getLists() async {
    listOfLists = [];
    listOfLists2 = [];
    CustomListResponse response =
        await Api().getLists(currentUser.id, sesion_id);
    response.results.forEach((element) {
      if (element.name == "Watched list by Filmster") {
        watchedmovieId = element.id.toString();
        listOfLists.add(element);
      }
      if (element.name == "Watched TVlist by Filmster") {
        watchedTVId = element.id.toString();
        listOfLists2.add(element);
      }
    });

    if (listOfLists.isEmpty) {
      var res = await Api().createWatchedList(sesion_id);
      watchedmovieId = res['list_id'];
    }
    if (listOfLists2.isEmpty) {
      var res2 = await Api().createWatchedTVList(sesion_id);
      watchedTVId = res2['list_id'];
    }
    await getWatched();
    notifyListeners();
  }

  exit() async {
    await Prefs().removeValues('userID');
    await Prefs().removeValues('username');
    await Prefs().removeValues('password');
    isloged = false;
    currentUser = null;
    notifyListeners();
  }
}
