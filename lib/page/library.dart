import 'dart:ui';

import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
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
        return true;
      },
      child:WillPopScope(
        onWillPop: () async {
          Provider.of<SettingsProvider>(context, listen: false).changePage(0);
          Navigator.of(context).pop();
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: myColors.currentBackgroundColor,
          appBar: AppBar(
            title: Text(
              "Library",
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 30,
              ),
            ),
          ),
          bottomNavigationBar: CustomeBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            elevation: 0,
            backgroundColor: myColors.currentSecondaryColor,
            child: Icon(
              Icons.favorite,
              color: mySettings.currentPage==4
                  ? myColors.currentMainColor
                  : myColors.currentFontColor
          ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36,
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
      ),
    );
  }
}
