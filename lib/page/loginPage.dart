import 'dart:ui';

import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/page/library.dart';
import 'package:filmster/page/profilePage.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';

import 'package:filmster/widgets/drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = '';
  String _password = '';

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
    return WillPopScope(
      onWillPop: () async {
        Provider.of<SettingsProvider>(context, listen: false).changePage(0);
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: myColors.currentBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations().translate(context, WordKeys.login),
            style: TextStyle(
              fontFamily: "AmaticSC",
              fontSize: 20,
            ),
          ),
        ),
        bottomNavigationBar: CustomeBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          elevation: 0,
          backgroundColor: myColors.currentSecondaryColor,
          child: Icon(Icons.favorite, color: myColors.currentFontColor),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: SizedBox(
              height: 64,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppLocalizations().translate(context, WordKeys.login),
              style: TextStyle(
                  fontFamily: "MPLUSRounded1c",
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                  color: myColors.currentFontColor),
            ),
          ),
          buildInput("Username"),
          buildInput("Password"),
          buildButton(context),
          ButtonBar(
              buttonHeight: MediaQuery.of(context).size.width * 0.15,
              buttonMinWidth: MediaQuery.of(context).size.width * 0.5,
              alignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                RaisedButton(
                  onPressed: () async {
                    const url = "https://www.themoviedb.org/signup";
                    if (await canLaunch(url)) launch(url);
                  },
                  child: Text(
                    "Registration",
                    style: TextStyle(
                      fontSize: 20,
                      color: myColors.currentFontColor,
                      fontFamily: "AmaticSC",
                    ),
                  ),
                  color: myColors.currentSecondaryColor,
                ),
              ]),
          Expanded(
            child: SizedBox(
              height: 48,
            ),
          ),
        ]),
      ),
    );
  }

  buildButton(context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ButtonBar(
            buttonHeight: MediaQuery.of(context).size.width * 0.15,
            buttonMinWidth: MediaQuery.of(context).size.width * 0.5,
            children: [
              RaisedButton(
                onPressed: () async {
                  if(_password.length>6&&_username.length>3) {
                    try {
                      await userProvider.auth(_username, _password);
                      if (userProvider.isloged && userProvider.currentUser!=null){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => ProfilePage()),
                                (Route<dynamic> route) => false);
                      }
                    }
                    catch(e) {
                      var snackBar = SnackBar(
                        content: Text(e.toString()),
                        action: SnackBarAction(
                          label: 'Try again',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                  }
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: myColors.currentFontColor,
                    fontFamily: "AmaticSC",
                  ),
                ),
                color: myColors.currentSecondaryColor,
              )
            ],
            alignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max));
  }

  Padding buildInput(String fieldName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.0),
      child: TextField(
        cursorRadius: Radius.circular(15),
        cursorColor: Provider.of<ThemeProvider>(context).currentMainColor,
        obscureText: fieldName == "Password",
        decoration: InputDecoration(
          prefixIcon: Icon(
            fieldName == "Username" ? Icons.person : Icons.lock,
            color: Provider.of<ThemeProvider>(context).currentSecondaryColor,
          ),
          prefix: SizedBox(
            width: 12,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(
                color: Provider.of<ThemeProvider>(context).currentMainColor,
                width: 3.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(
                color: Provider.of<ThemeProvider>(context).currentMainColor,
                width: 1.0),
          ),
          hintStyle: TextStyle(
            color: Provider.of<ThemeProvider>(context).currentSecondaryColor,
            fontFamily: "MPLUSRounded1c",
            fontWeight: FontWeight.w700,
          ),
          hintText: fieldName,
        ),
        style: TextStyle(
          fontFamily: "MPLUSRounded1c",
          fontWeight: FontWeight.w700,
          textBaseline: null,
          color: Provider.of<ThemeProvider>(context).currentFontColor,
          fontSize: 20.0,
        ),
        onChanged: (String value) {
          setState(() {
            fieldName == "Username" ? _username = value : _password = value;
          });
        },
      ),
    );
  }
}
