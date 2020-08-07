import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/main.dart';
import 'package:filmster/page/films.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerMenu {
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
                  style: GoogleFonts.lifeSavers(
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
                  style:  GoogleFonts.lifeSavers(
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
                  style:  GoogleFonts.lifeSavers(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: provider.currentFontColor,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'In progress',
                  style:  GoogleFonts.lifeSavers(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: provider.currentFontColor,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'In progress',
                  style:  GoogleFonts.lifeSavers(
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
            ],
          ),
      ),
    );
  }
}
