import 'dart:convert';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverProvider extends ChangeNotifier {

  List<SearchResults> discoverMovie= [];
  List<SearchResults> discoverTv= [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLast = false;

  addFilms(List<SearchResults> list,  type) {
    if (currentPage != 1) {
      type == "movie"
          ? list.forEach((element) {
          discoverMovie.add(element);
      })
          : list.forEach((element) {
        discoverTv.add(element);
      });
    } else{
      type=="movie"
          ? discoverMovie = list
          : discoverTv=list;
    }
    notifyListeners();
  }

  clear(){
    discoverMovie.clear();
    discoverTv.clear();
    notifyListeners();
  }

  changeIsLast(bool last){
    isLast = last;
    notifyListeners();
  }


  Future<bool> fetchData(type, context) async {
    if (!isLoading) {
      var settingsProvider = Provider.of<SettingsProvider>(context, listen:false);
      isLoading = true;
      List listOfGanres = type=="movie"
          ? settingsProvider.movieArrayGenres
          : settingsProvider.tvArrayGenres;
      String ganres='';
      String year="";
      listOfGanres.forEach((element) {
          ganres+=element.toString();
          ganres+=",";
      });
      if(settingsProvider.currentYear!=null)
       year = "&year=${settingsProvider.currentYear}";
      Search response = await Api().getDiscover(
          type,
          currentPage,
          ganres,
          year);
      List<SearchResults> list = response.search;
      addFilms(list, type);
      isLoading = false;
      changeIsLast(
          (response
              .total ?? 0) < currentPage * 20
      );
      return (response.total ?? 0) < currentPage * 20;
    }
  }


}

