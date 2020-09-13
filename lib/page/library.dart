import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'film_detail_page.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scroll = ScrollController();
  List<Widget> list=[];
  @override
  void initState() {
    super.initState();
    initFavorite();
   // _scroll.addListener(addMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scroll.dispose();
  }

  initFavorite() async{
    await Provider.of<UserProvider>(context, listen: false).getFavorite();
  }

  _buildVoteBlock(icon, text) {
    var provider = Provider.of<ThemeProvider>(context);
    return Row(children: [
      Icon(
        icon,
        color: provider.currentFontColor,
      ),
      Container(
          padding: EdgeInsets.only(left: 5),
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 25,
                //  fontWeight: FontWeight.bold,
                color: provider.currentFontColor,
              )))
    ]);
  }

  buildGenres(id) {
    return Text(
      Provider.of<SettingsProvider>(context).movieMapOfGanres[id],
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 25,
        //  fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).currentFontColor,
      ),
    );
  }

  _buildFilm(SearchResults film) {
    var provider = Provider.of<ThemeProvider>(context);
    List<Widget> list = [];
    if (film.ganres != null && film.ganres.isNotEmpty) {
      film.ganres.forEach((element) {
        list.add(buildGenres(element));
      });
    }
    return Container(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  FilmDetailPage(id: film.id.toString(), type:"movie")));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.26,
              decoration: BoxDecoration(
                color: provider.currentSecondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(children: [
                      film.poster != null
                          ? Image.network(
                        "${Api().imageBannerAPI}${film.poster}",
                        height: 139,
                        width: 100,
                      )
                          : Container(
                          height: 139,
                          width: 100,
                          child: Icon(
                            Icons.do_not_disturb_on,
                            size: 100.0,
                            color: provider.currentAcidColor,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _buildVoteBlock(
                              Icons.trending_up, film.popularity.toString()),
                          _buildVoteBlock(Icons.grade, film.voteAverage),
                        ],
                      )
                    ]),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.23,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(children: [
                              Expanded(
                                child: Text(
                                  film.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: "AmaticSC",
                                    fontSize: 25,
                                    color: provider.currentMainColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ]),
                            film.isAdult
                                ? Text("18+",
                                style: TextStyle(
                                  fontFamily: "AmaticSC",
                                  fontSize: 30,
                                  color: provider.currentAcidColor,
                                  fontWeight: FontWeight.w700,
                                ))
                                : Container(),
                            film.title != film.originalTitle
                                ? Expanded(
                              child: Text(
                                film.originalTitle,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "AmaticSC",
                                  fontSize: 23,
                                  //  fontWeight: FontWeight.bold,
                                  color: provider.currentFontColor,
                                ),
                              ),
                            )
                                : Container(),
                            Expanded(
                                child: Text(
                                  film.release ?? "-",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "AmaticSC",
                                    color: provider.currentFontColor,
                                  ),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.46,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 6,
                                children: list,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var userProfile = Provider.of<UserProvider>(context);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    List<Widget> favoritList=[];
    userProfile.favoriteList.forEach((element) {
        favoritList.add(_buildFilm(element));
    });
    print(favoritList);
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
          body: SingleChildScrollView(
            child: Column(
              children: favoritList,
            )
          ),
        ),
    );
  }
}
