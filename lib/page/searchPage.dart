

import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/page/searchByName.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';

import 'package:filmster/widgets/drawer.dart';
import 'package:filmster/widgets/movieCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'library.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        mySettings.changePage(0);
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: myColors.currentBackgroundColor,
        appBar: AppBar(
          title: Text("Search",),
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
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(context){
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
        _buildCard("Search movie by title", 'assets/image/mrRobotBackground.jpg', "movie"),
        _buildCard("Search tv by title", 'assets/image/riverdaleBackground.jpg', "tv"),
        ],
      ),
    );
  }
  _buildCard(String title, String imageURL, String type){
    return GestureDetector(
      onTap: (){
        Provider.of<UserProvider>(context, listen: false).changeCurrentType(type);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => FilmsPage(type:type)));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Container(
          height: MediaQuery.of(context).size.height*0.25,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            border: Border.all(
                color:Colors.blueGrey[900],
                width: 1.4,
                style: BorderStyle.solid),
            image: DecorationImage(
              image: AssetImage(imageURL),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topLeft
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              new BoxShadow(
                  color: Colors.blueGrey[900],
                  offset: new Offset(3.0, 5.0),
                  blurRadius: 5.0,
                  spreadRadius: 0.7
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 12, top: MediaQuery.of(context).size.height*0.17),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "MPLUSRounded1c",
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _scrollListener(){

  }

}
