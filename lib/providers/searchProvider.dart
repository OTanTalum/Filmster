import 'dart:convert';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {

  List<SearchResults> listOfFilms=[];
  bool isLast = false;
  bool isLoading = false;
  String oldValue = '';

  addFilms(List<SearchResults> list, int page) {
    if(page!=1){
      list.forEach((element) {
        listOfFilms.add(element);
      });
    }
    else{
      listOfFilms=list;
    }
    notifyListeners();
  }

  changeIsLast(bool last){
    isLast = last;
    notifyListeners();
  }

  Future<bool> fetchData(Oldtext, currentPage, type) async {
    if (!isLoading) {
      isLoading = true;
      Search response = await Api().searchMovie(type, Oldtext, currentPage);
      oldValue = Oldtext;
      isLoading = false;
      List<SearchResults> list = response.search;
      addFilms(list, currentPage);
      changeIsLast(
          (response
              .total ?? 0) < currentPage * 10
      );
      return (response.total ?? 0) < currentPage * 10;
    }
  }


}

