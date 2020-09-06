import 'dart:convert';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingProvider extends ChangeNotifier {

  List<SearchResults> trendingMovies= [];
  List<SearchResults> trendingTV= [];
  bool isLoading = false;
  bool isLast = false;

  addFilms(List<SearchResults> list, int page, type) {
    if(page!=1){
      type=="movie"
          ? list.forEach((element) {
        trendingMovies.add(element);
      })
          : list.forEach((element) {
        trendingTV.add(element);
      });
    }
    else{
      type=="movie"
          ? trendingMovies=list
          : trendingTV = list;
    }
    notifyListeners();
  }

  changeIsLast(bool last){
    isLast = last;
    notifyListeners();
  }

  saveList(List list){
    trendingMovies = list;
    notifyListeners();
  }

  Future<bool> fetchData(currentPage, type, period) async {
    if (!isLoading) {
      isLoading = true;
      Search response = await Api().getTrending(type, period, currentPage);
      print(response.search);
      List<SearchResults> list = response.search;
      addFilms(list, currentPage, type);
      isLoading = false;
      changeIsLast(
          (response
              .total ?? 0) < currentPage * 20
      );
      return (response.total ?? 0) < currentPage * 20;
    }
  }


}

