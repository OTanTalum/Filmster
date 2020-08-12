import 'dart:convert';

import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {

  Map mapOfGanres={};

  getGanresSettings() async{
   List list = await Api().getGenres();
   list.forEach((value) {
      mapOfGanres[value["id"]] = value["name"];
    });
    notifyListeners();
  }

}

