import 'dart:convert';

import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {

  static String language = "ru";
  Map movieMapOfGanres={};
  Map tvMapOfGanres={};
  Map<String, bool> tvFilter ={};
  Map<String, bool> movieFilter ={};
  List <int> tvArrayGenres =[];
  List <int> movieArrayGenres =[];
  int currentPage = 0;
  String currentYear;
  bool isMovie;


  getListGenres()async {
    List list = await Api().getGenres("movie");
    list.forEach((value) {
      movieMapOfGanres[value["id"]] = value["name"];
      movieFilter[value["id"].toString()]=false;
    });
    list = await Api().getGenres("tv");
    list.forEach((value) {
      tvMapOfGanres[value["id"]] = value["name"];
      tvFilter[value["id"].toString()]=false;
    });
    notifyListeners();
  }

  saveFilter(bool isTV){
    movieArrayGenres=[];
    tvArrayGenres=[];
    isTV
    ? tvFilter.forEach((key, value) {
      if(value){
        tvArrayGenres.add(int.parse(key));
      }
    })
        : movieFilter.forEach((key, value) {
          if(value){
            movieArrayGenres.add(int.parse(key));
          }
    });
    notifyListeners();
  }

  changeLanguage(String newLanguage){
    language = newLanguage;
    notifyListeners();
    return language;
  }

  saveYearFilter(year){
    currentYear = year;
    notifyListeners();
  }

  changePage(int pageIndex){
    currentPage = pageIndex;
    notifyListeners();
  }
  getLanguage(){
    return language;
  }
}

