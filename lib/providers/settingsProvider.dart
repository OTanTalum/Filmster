import 'dart:convert';

import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SettingsProvider extends ChangeNotifier {

  static String language = "ru";
  Map movieMapOfGanres={};
  Map tvMapOfGanres={};

  getGanresSettings(type) async{
   List list = await Api().getGenres(type);
    type=="movie"
    ? list.forEach((value) {
      movieMapOfGanres[value["id"]] = value["name"];
      })
    : list.forEach((value) {
      tvMapOfGanres[value["id"]] = value["name"];
    });
    notifyListeners();
  }

  changeLanguage(String newLanguage){
    language = newLanguage;
    notifyListeners();
    return language;
  }

  getLanguage(){
    return language;
  }
}

