import 'dart:async';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'languages/PT.dart';
import 'languages/eng.dart';
import 'languages/rus.dart';
import 'languages/workKeys.dart';

class AppLocalizations {

  Map<String, Map<WordKeys, String>> localization = {
    'us': ENG,
    "ru" : RUS,
    "pt" : PT,
  };

  String? translate(context, key) {
    switch(SettingsProvider.language){
      case "us":
        return localization["us"]![key];
        break;
        case "ru":
        return localization["ru"]![key];
        break;
        case "pt":
        return localization["pt"]![key];
        break;
    }
  }
}
