import 'dart:convert';

import 'package:dartpedia/dartpedia.dart';
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

  Future<bool> loadDiscoveryData(bool isMovie, context) async {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    Search response = await Api().getDiscover(
        isMovie,
        currentPage,
        isMovie ? getMovieGenres(context) : getTVGenres(context),
        settingsProvider.currentYear != null
            ? "&year=${settingsProvider.currentYear}"
            : "");

    List<SearchResults> list = response.search;
    isMovie ? addToDiscoverMovieList(list) : addToDiscoverTVList(list);
    changeIsLast((response.total ?? 0) < currentPage * 20);
    notifyListeners();
    return (response.total ?? 0) < currentPage * 20;
  }

  getMovieGenres(BuildContext context) {
    String movieGenres = "";
    Provider.of<SettingsProvider>(context, listen: false)
        .movieArrayGenres
        .forEach((genre) {
      movieGenres += genre.toString();
      movieGenres += ",";
    });
    return movieGenres;
  }

  getTVGenres(BuildContext context) {
    String tvGenres = "";
    Provider.of<SettingsProvider>(context, listen: false)
        .tvArrayGenres
        .forEach((genre) {
      tvGenres += genre.toString();
      tvGenres += ",";
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
}
