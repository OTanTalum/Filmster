
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class addMobClass{
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  //IOS app id  "ca-app-pub-3113025288273721~7357255507"
  //ANDROID app id  "ca-app-pub-3113025288273721~8287602911"

  //Android Block ID "ca-app-pub-3113025288273721/1021263084"
  //IOS Block ID "ca-app-pub-3113025288273721/9709739067"

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4339318960';
    } else if (Platform.isAndroid) {
     // return 'ca-app-pub-3940256099942544/8865242552';
      return 'ca-app-pub-3113025288273721/1021263084';
    }
    return null;
  }

  getAdMobId(){
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544~2594085930';
    } else if (Platform.isAndroid) {
    //  return 'ca-app-pub-3940256099942544~4354546703';
      return 'ca-app-pub-3113025288273721~8287602911';
    }
    return null;
  }
}