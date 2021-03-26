import 'dart:convert';

import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/model/Genre.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProvider extends ChangeNotifier {
  static String language = "ru";
  List <Genre>? movieListOfGenres = [];
  List <Genre>? tvListOfGenres = [];
  List <Genre>? listOfGenre=[];

  Map<Genre, bool> tvFilter = {};
  Map<Genre, bool> movieFilter = {};

  Pages currentPage = Pages.HOME_PAGE;
  Pages? prevPage;
  String? currentYear;


  loadMovieListGenres(keyState) async {
    GenresResponse response = await Api().getMovieGenres();
    if(response.isSuccess!){
      movieListOfGenres = response.genres;
      movieFilter.clear();
      movieListOfGenres!.forEach((Genre element) {
        movieFilter[element]=false;
      });
    }else{
      CustomSnackBar().showSnackBar(title: response.message!, state: keyState);
    }
    notifyListeners();
  }

  loadTVListGenres(keyState) async {
    GenresResponse response = await Api().getTVGenres();
    if(response.isSuccess!){
      tvListOfGenres = response.genres;
      tvFilter.clear();
      tvListOfGenres!.forEach((element) {
        tvFilter[element]=false;
      });
    }else{
      CustomSnackBar().showSnackBar(title: response.message!, state: keyState);
    }
    notifyListeners();
  }

  String? getOneGenre(BuildContext context, int? id) {
    List<Genre> temp = movieListOfGenres! + tvListOfGenres!;
    return temp.firstWhere((Genre element) => element.id==id).name;
  }

  changeTVGenreStatus(Genre genre){
    tvFilter[genre] = !tvFilter[genre]!;
    notifyListeners();
  }

  changeMovieGenreStatus(Genre genre){
    movieFilter[genre] = !movieFilter[genre]!;
    notifyListeners();
  }

  changeLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
    return language;
  }

  saveYearFilter(year) {
    currentYear = year;
    notifyListeners();
  }

  changePage(Pages pageIndex) {
    prevPage = currentPage;
    currentPage = pageIndex;
    notifyListeners();
  }

  getLanguage() {
    return language;
  }
}
