import 'dart:convert';

import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SettingsProvider extends ChangeNotifier {

  static String language = "ru";
  Map mapOfGanres={};

  getGanresSettings() async{
   List list = await Api().getGenres();
   list.forEach((value) {
      mapOfGanres[value["id"]] = value["name"];
    });
    notifyListeners();
  }

  changeLanguage(String newLanguage){
    language = newLanguage;
    notifyListeners();
  }

}

