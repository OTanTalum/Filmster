import 'dart:convert';

import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingProvider extends ChangeNotifier {

  List<SearchResults>? trendingMoviesWeek= [];
  List<SearchResults>? trendingMoviesDay= [];
  List<SearchResults>? trendingTVWeek= [];
  List<SearchResults>? trendingTVDay= [];
  int currentPage = 1;
  bool isLoading = false;
  bool? isLast = false;

  addFilms(List<SearchResults>? list, int page, type, period) {
    if (page != 1) {
      type == "movie"
          ? list!.forEach((element) {
              period == "week"
                  ? trendingMoviesWeek!.add(element)
                  : trendingMoviesDay!.add(element);
            })
          : list!.forEach((element) {
              period == "week"
                  ? trendingTVWeek!.add(element)
                  : trendingTVDay!.add(element);
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

  clear(){
    trendingMoviesWeek!.clear();
    trendingMoviesDay!.clear();
    trendingTVWeek!.clear();
    trendingTVDay!.clear();
    notifyListeners();
  }

  changeIsLast(bool? last){
    isLast = last;
    notifyListeners();
  }

  Future<bool?> fetchData(type, period, keyState) async {
    if (!isLoading) {
      isLoading = true;
      var response = await Api().getTrending(type, period, currentPage);
      if (hasError(response)) {
        CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
        return true;
      } else {
        List<SearchResults>? list = response.results;
        addFilms(list, currentPage, type, period);
        isLoading = false;
        changeIsLast((response.total ?? 0) < currentPage);
        return (response.total ?? 0) < currentPage;
      }
    }
  }

  bool hasError(response) {
    return response.runtimeType == BasicResponse();
  }
}

