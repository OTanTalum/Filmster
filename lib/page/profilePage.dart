import 'dart:ui';
import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/Widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/Widgets/UI/LIbraryActionButton.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/page/loginPage.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
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
    var userProfile = Provider.of<LibraryProvider>(context, listen: false);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: ()async {
        mySettings.changePage(Pages.HOME_PAGE);
        Navigator.of(context).pop();

      } as Future<bool> Function()?,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: myColors.currentBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations().translate(context, WordKeys.profile)!,
            style: TextStyle(
              fontFamily: "AmaticSC",
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await userProfile.exit();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginPage()));
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: LibraryActionButton.build(context: context, keyState: _scaffoldKey),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //drawer: DrawerMenu().build(context),
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 36,
            ),
            CircleAvatar(
                radius: 48,
                backgroundColor: myColors.currentSecondaryColor,
                child: Icon(
                  Icons.person,
                  color: myColors.currentFontColor,
                  size: 48,
                )),
            Center(
              child: Text(
                userProfile.currentUser!.userName!,
                style: TextStyle(
                    fontFamily: "MPLUSRounded1c",
                    fontWeight: FontWeight.w300,
                    fontSize: 35,
                    color: myColors.currentFontColor),
              ),
            ),
          ]),
          Padding(
            padding:EdgeInsets.only(bottom: 24),
            child: FutureBuilder<String>(
              future: getVersion(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      child: Text(
                    "Version: ${snapshot.data}",
                    style: TextStyle(
                      fontFamily: "AmaticSC",
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                      color: myColors.currentFontColor,
                    ),
                  ));
                }
                return Container();
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}+${packageInfo.buildNumber}";
  }
}
