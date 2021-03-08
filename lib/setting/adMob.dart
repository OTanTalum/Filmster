import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

const String APP_ID_ANDROID = "ca-app-pub-3113025288273721~8287602911";
const String BANNER_ID_ANDROID = "ca-app-pub-3113025288273721/1021263084";
const String MOVIE_DETAIL_BANNER_ID_ANDROID = "ca-app-pub-3113025288273721/6607756946";
const String DRAWER_ID_ANDROID = "ca-app-pub-3113025288273721/5425703062";

const String APP_ID_IOS = "ca-app-pub-3113025288273721~7357255507";
const String BANNER_ID_IOS = "ca-app-pub-3113025288273721/9709739067";
const String MOVIE_DETAIL_BANNER_ID_IOS = "ca-app-pub-3113025288273721/1682926849";
const String DRAWER_ID_IOS = "ca-app-pub-3113025288273721/3962795196";

const String APP_ID_ANDROID_TEST = "ca-app-pub-3940256099942544~3347511713";
const String APP_ID_IOS_TEST = "ca-app-pub-3940256099942544~1458002511";
const String BANNER_ID_IOS_TEST = "ca-app-pub-3940256099942544/2934735716";
const String BANNER_ID_ANDROID_TEST = "ca-app-pub-3940256099942544/6300978111";

class AddMobClass{

  String? getBannerAdUnitId() {
    if(kDebugMode){
      if (Platform.isIOS) {
        return BANNER_ID_IOS_TEST;
      } else if (Platform.isAndroid) {
        return BANNER_ID_ANDROID_TEST;
      }
    }
    else {
      if (Platform.isIOS) {
        return BANNER_ID_IOS;
      } else if (Platform.isAndroid) {
        return BANNER_ID_ANDROID;
      }
    }
  }

  String? getDrawerBannerAdUnitId() {
    if(kDebugMode){
      if (Platform.isIOS) {
        return BANNER_ID_IOS_TEST;
      } else if (Platform.isAndroid) {
        return BANNER_ID_ANDROID_TEST;
      }
    }
    if (Platform.isIOS) {
      return DRAWER_ID_IOS;
    } else if (Platform.isAndroid) {
      return DRAWER_ID_ANDROID;
    }
  }

  String? getMovieDetailBannerAdUnitId() {
    if(kDebugMode){
      if (Platform.isIOS) {
        return BANNER_ID_IOS_TEST;
      } else if (Platform.isAndroid) {
        return BANNER_ID_ANDROID_TEST;
      }
    }
    if (Platform.isIOS) {
      return MOVIE_DETAIL_BANNER_ID_IOS;
    } else if (Platform.isAndroid) {
      return MOVIE_DETAIL_BANNER_ID_ANDROID;
    }
  }

  getAdMobId(){
    if(kDebugMode){
      if (Platform.isIOS) {
        return APP_ID_IOS_TEST;
      } else if (Platform.isAndroid) {
        return APP_ID_ANDROID_TEST;
      }
    }
    if (Platform.isIOS) {
      return APP_ID_IOS;
    } else if (Platform.isAndroid) {
      return APP_ID_ANDROID;
    }
  }

  Widget buildAdMobBanner(){
    return AdmobBanner(
      adUnitId: getMovieDetailBannerAdUnitId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.opened) {
          FirebaseAnalytics().logEvent(name: 'adMobMovieDetailClick');
        }
      },
      onBannerCreated: (AdmobBannerController controller) {
      },
    );
  }

  Widget buildListBanner() {
   return  AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.FULL_BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.opened) {
          print('Admob banner opened!');
          FirebaseAnalytics().logEvent(name: 'adMobTrendingClick');
        }
      },
      onBannerCreated: (AdmobBannerController controller) {},
    );
  }

  Widget buildSearchListBunner(){
    return AdmobBanner(
      adUnitId: getDrawerBannerAdUnitId(),
      adSize: AdmobBannerSize.LARGE_BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.opened) {
          FirebaseAnalytics().logEvent(name: 'adMobDrawerClick');
        }
      },
      onBannerCreated: (AdmobBannerController controller) {},
    );
  }
}