import 'dart:ui';
import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/page/searchByName.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/widgets/UI/LIbraryActionButton.dart';
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
  UserProvider userProvider;
  SettingsProvider settingsProvider;
  ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    settingsProvider = Provider.of<SettingsProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        settingsProvider.changePage(Pages.HOME_PAGE);
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: themeProvider.currentBackgroundColor,
        appBar: AppBar(
          title: Text("Search",),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: LibraryActionButton.build(context),
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
        if(userProvider.isMovie&&type!="movie"||
        !userProvider.isMovie&&type=="movie"
        ) {
          Provider.of<UserProvider>(context, listen: false).changeCurrentType();
        }
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => FilmsPage()));
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
}
