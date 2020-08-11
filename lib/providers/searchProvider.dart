import 'package:filmster/model/film.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {

  List<Film> listOfFilms=[];
  bool isLast = false;

  addFilms(List<Film> list, int page) {
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
}
