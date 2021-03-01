import 'dart:convert';

import 'package:dartpedia/dartpedia.dart';
import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/Genre.dart';
import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int FIRST_PAGE = 1;

class DiscoverProvider extends ChangeNotifier {
  List<SearchResults> discoverMovie = [];
  List<SearchResults> discoverTv = [];
  int currentPage = 1;
  bool isLast = false;

  Future<bool> loadDiscoveryData(bool isMovie, context, keyState) async {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    var response = await Api().getDiscover(
        isMovie,
        currentPage,
        isMovie ? getMovieGenres(context) : getTVGenres(context),
        settingsProvider.currentYear != null
            ? isMovie
              ?"&year=${settingsProvider.currentYear}"
              :"&first_air_date_year=${settingsProvider.currentYear}"
            : "");
    if (hasError(response)) {
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
      return true;
    } else {
      List<SearchResults> list = response.search;
      isMovie ? addToDiscoverMovieList(list) : addToDiscoverTVList(list);
      changeIsLast((response.total ?? 0) < currentPage);
      notifyListeners();
      return (response.total ?? 0) < currentPage;
    }
  }

  getMovieGenres(BuildContext context) {
    String movieGenres = "";
    Provider.of<SettingsProvider>(context, listen: false)
        .movieFilter.forEach((Genre genre, bool enabled) {
          if(enabled) {
            movieGenres += genre.id.toString();
            movieGenres += ",";
          }
    });
    return movieGenres;
  }

  getTVGenres(BuildContext context) {
    String tvGenres = "";
    Provider.of<SettingsProvider>(context, listen: false)
        .tvFilter.forEach((Genre genre, bool enabled) {
          if(enabled) {
            tvGenres += genre.id.toString();
            tvGenres += ",";
          }
    });
    return tvGenres;
  }

  addToDiscoverMovieList(List<SearchResults> list) {
    if (currentPage != FIRST_PAGE) {
      list.forEach((element) {
        discoverMovie.add(element);
      });
    } else {
      discoverMovie = list;
    }
    notifyListeners();
  }

  addToDiscoverTVList(List<SearchResults> list) {
    if (currentPage != FIRST_PAGE) {
      list.forEach((element) {
        discoverTv.add(element);
      });
    } else {
      discoverTv = list;
    }
    notifyListeners();
  }

  clear() {
    discoverMovie.clear();
    currentPage = 1;
    discoverTv.clear();
    notifyListeners();
  }

  changeIsLast(bool last) {
    isLast = last;
    notifyListeners();
  }

  bool hasError(response) {
    return response.runtimeType == BasicResponse();
  }
}
