import 'dart:convert';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingProvider extends ChangeNotifier {

  List<SearchResults> trendingMoviesWeek= [];
  List<SearchResults> trendingMoviesDay= [];
  List<SearchResults> trendingTVWeek= [];
  List<SearchResults> trendingTVDay= [];
  bool isLoading = false;
  bool isLast = false;

  addFilms(List<SearchResults> list, int page, type, period) {
    if (page != 1) {
      type == "movie"
          ? list.forEach((element) {
              period == "week"
                  ? trendingMoviesWeek.add(element)
                  : trendingMoviesDay.add(element);
            })
          : list.forEach((element) {
              period == "week"
                  ? trendingTVWeek.add(element)
                  : trendingTVDay.add(element);
            });
    } else{
      type=="movie"
          ?  period=="week"
            ? trendingMoviesWeek=list
            : trendingMoviesDay=list
          :   period=="week"
            ? trendingTVWeek=list
            : trendingTVDay=list;
    }
    notifyListeners();
  }

  changeIsLast(bool last){
    isLast = last;
    notifyListeners();
  }


  Future<bool> fetchData(currentPage, type, period) async {
    if (!isLoading) {
      isLoading = true;
      Search response = await Api().getTrending(type, period, currentPage);
      List<SearchResults> list = response.search;
      addFilms(list, currentPage, type, period);
      isLoading = false;
      changeIsLast(
          (response
              .total ?? 0) < currentPage * 20
      );
      return (response.total ?? 0) < currentPage * 20;
    }
  }


}

