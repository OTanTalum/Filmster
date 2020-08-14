import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/main.dart';
import 'package:filmster/page/films.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';

class DrawerMenu {

  String version;
  String buildNumber;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Container(
        color: provider.currentBackgroundColor,
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: provider.currentMainColor,
                ),
                child: Text(
                  'Hello ;)',
                  style: TextStyle(fontFamily:"AmaticSC",
                    color: provider.currentFontColor,
                    fontSize: 28,),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MyHomePage()));
                },
                title: Text(
                  'Home',
                  style:  TextStyle(fontFamily:"AmaticSC",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: provider.currentFontColor,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => FilmsPage()));
                },
                title: Text(
                  'Films',
                  style:  TextStyle(fontFamily:"AmaticSC",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: provider.currentFontColor,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'In progress',
                  style:  TextStyle(fontFamily:"AmaticSC",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: provider.currentFontColor,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'In progress',
                  style:  TextStyle(fontFamily:"AmaticSC",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: provider.currentFontColor,
                  ),
                ),
              ),
            AdmobBanner(
                    adUnitId: addMobClass().getBannerAdUnitId(),
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    },
                    onBannerCreated: (AdmobBannerController controller) {},
              ),
              Center(
                child:FutureBuilder<String>(
                future: getVersion(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        child: Text(
                          "Version: ${snapshot.data}",
                          style: TextStyle(
                            fontFamily: "AmaticSC",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: provider.currentFontColor,
                          ),
                        ));
                  }
                  return Container();
                },
              ),
              ),
            ],
          ),
      ),
    );
  }

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}+${packageInfo.buildNumber}";
  }
}
