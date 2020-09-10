import 'dart:ui';

import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';

import 'package:filmster/widgets/drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final textController = TextEditingController();

  @override
  void initState() {
    textController.addListener(()=> print(textController.text));
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
      onWillPop: (){
        Provider.of<SettingsProvider>(context, listen: false)
            .changePage(0);
        Navigator.of(context).pop();
      },
      child:Scaffold(
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
          onPressed: () {},
          elevation: 0,
          backgroundColor: myColors.currentSecondaryColor,
          child: Icon(
              Icons.favorite,
              color: myColors.currentFontColor
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //drawer: DrawerMenu().build(context),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 64),
                child: Icon(
                  Icons.local_movies,
                  size: 128,
                  color: myColors.currentMainColor,
                ),
              ),
              Expanded(
                child: Padding(
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
              ),
              buildInput("Username"),
              buildInput("Password"),
              Expanded(
                  child:buildButton(),
              ),
              SizedBox(
                height: 64,
              ),
            ]),
      ),
    );
  }

  buildButton(){
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.only(bottom:40.0),
        child:  ButtonBar(
          buttonHeight: MediaQuery.of(context).size.width*0.2,
          buttonMinWidth: MediaQuery.of(context).size.width*0.5,
            children:[
              RaisedButton(
                onPressed:(){
                 print("Hello");
                },
                child:Text("Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: myColors.currentFontColor,
                    fontFamily: "AmaticSC",
                  ),
                ),
                color: myColors.currentSecondaryColor,
              )
            ],
            alignment:MainAxisAlignment.center,
            mainAxisSize:MainAxisSize.max
        )
    );
  }

  buildInput(String fieldName) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
        child: TextField(
          controller: textController,
          cursorRadius: Radius.circular(15),
          cursorColor: Provider.of<ThemeProvider>(context).currentMainColor,
          decoration: new InputDecoration(
            prefixIcon: Icon(
             fieldName=="Username"
              ? Icons.person
              : Icons.lock,
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
                color:
                Provider.of<ThemeProvider>(context).currentSecondaryColor,
                fontFamily: "AmaticSC"),
            hintText: fieldName,
          ),
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontWeight: FontWeight.w700,
            textBaseline: null,
            color: Provider.of<ThemeProvider>(context).currentFontColor,
            fontSize: 20.0,
          ),
        ));
  }
}
