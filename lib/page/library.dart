import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';
import 'package:filmster/widgets/movieCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'film_detail_page.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scroll = ScrollController();
  TabController _tabController;
  int currentTab=0;
  List<Widget> list=[];


  @override
  void initState() {
    super.initState();
    initFavorite();
    _tabController =  new TabController(length: 3, vsync: this);
   // _scroll.addListener(addMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scroll.dispose();
    _tabController.dispose();
  }

  initFavorite() async{
    await Provider.of<UserProvider>(context, listen: false).getFavorite();
    await Provider.of<UserProvider>(context, listen: false).getWatchList();
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var userProfile = Provider.of<UserProvider>(context);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);

    List<Widget> favoritList=[];
    userProfile.favoriteList.forEach((element) {
        favoritList.add(MovieCard(element));
    });
    List<Widget> watchList=[];
    userProfile.watchList.forEach((element) {
        watchList.add(MovieCard(element));
    });
    return WillPopScope(
      onWillPop: () async {
     //   mySettings.changePage(0);
        Navigator.of(context).pop();
        return true;
      },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: myColors.currentBackgroundColor,
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: myColors.currentMainColor,
              tabs: [
              Tab(
                text: AppLocalizations().translate(context, WordKeys.favorite),

              ),
              Tab(
                text: AppLocalizations().translate(context, WordKeys.watchlist),
              ),
              Tab(
                  text: AppLocalizations().translate(context, WordKeys.favorite),
              ),
            ],
            ),
            title: Text(
              AppLocalizations().translate(context, WordKeys.library),
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
          body: TabBarView(
            controller: _tabController,
          children: [
          SingleChildScrollView(
                child: Column(
              children: favoritList,
            )),
            SingleChildScrollView(
                child: Column(
              children: watchList,
            )),
            Icon(
              Icons.timer,
            size: 64,
            color: myColors.currentMainColor,)
            ],
          ),
        ),
    );
  }
}
