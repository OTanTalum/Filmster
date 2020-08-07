import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/main.dart';
import 'package:filmster/page/films.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:flutter/material.dart';

class DrawerMenu {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:Stack(
        children:[
          ListView(
          padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
                child: Text(
                  'Hello ;)',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                onTap:() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (_) => MyHomePage()));
                },
                title: Text('Home'),
              ),
               ListTile(
                 onTap:() {
                   Navigator.of(context)
                       .push(MaterialPageRoute(
                       builder: (_) => FilmsPage()));
                   },
                  title: Text('Films'),
               ),
              ListTile(
                title: Text('In progress'),
              ),
              ListTile(
                title: Text('In progress'),
              ),
            ],
        ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:AdmobBanner(
                adUnitId: addMobClass().getBannerAdUnitId(),
                adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                  print("some data");
                },
                onBannerCreated: (AdmobBannerController controller) {},
              ),
            ),
      ]),

    );
  }
}
