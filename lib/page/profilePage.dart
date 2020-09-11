import 'dart:ui';

import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/page/loginPage.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';

import 'package:filmster/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'library.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var userProfile = Provider.of<UserProvider>(context, listen: false);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        mySettings.changePage(0);
        Navigator.of(context).pop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: myColors.currentBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              fontFamily: "AmaticSC",
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: ()async {
              await userProfile.exit();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginPage()));
              },
              icon: Icon(
                Icons.exit_to_app
              ),
            )
          ],
        ),
        bottomNavigationBar: CustomeBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            mySettings.changePage(4);
            if(Provider.of<UserProvider>(context, listen: false).currentUser!=null){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LibraryPage()));
            }
          },
          elevation: 12,
          backgroundColor: myColors.currentSecondaryColor,
          child: Icon(
              Icons.favorite,
              color: mySettings.currentPage==4
                  ? myColors.currentMainColor
                  : myColors.currentFontColor
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //drawer: DrawerMenu().build(context),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 36,
                ),
              CircleAvatar(
                radius:48,
                backgroundColor: myColors.currentSecondaryColor,
                child: Icon(
                  Icons.person,
                  color: myColors.currentFontColor,
                  size: 48,
                )
              ),
              Center(
                child: Text(userProfile.currentUser.userName,
                  style: TextStyle(
                      fontFamily: "MPLUSRounded1c",
                      fontWeight: FontWeight.w300,
                      fontSize: 35,
                      color: myColors.currentFontColor),
                ),
              ),
          userProfile.currentUser.name != null
              ? Container(
                  child: Text(
                  "Hi, ${userProfile.currentUser.name}\n Watch you favorite list!",
                  style: TextStyle(
                      fontFamily: "MPLUSRounded1c",
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: myColors.currentFontColor),
                ))
              : Container(),
          Container(),
        ]),
      ),
    );
  }
}
