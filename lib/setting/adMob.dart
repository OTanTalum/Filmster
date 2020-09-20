
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class AddMobClass{
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  //IOS app id  "ca-app-pub-3113025288273721~7357255507"
  //ANDROID app id  "ca-app-pub-3113025288273721~8287602911"

  //Android Block ID "ca-app-pub-3113025288273721/1021263084"
  //IOS Block ID "ca-app-pub-3113025288273721/9709739067"


  //test admob banner ca-app-pub-3940256099942544/6300978111

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3113025288273721/9709739067';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getDrawerBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3113025288273721/3962795196';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getMovieDetailBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3113025288273721/1682926849';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  getAdMobId(){
    if (Platform.isIOS) {
      return 'ca-app-pub-3113025288273721~7357255507';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544~3347511713';
    }
    return null;
  }
}