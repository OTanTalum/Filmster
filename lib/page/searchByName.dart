import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
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

class FilmsPage extends StatefulWidget {
  final String type;

  FilmsPage({
    this.type,
  });

  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  final textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLast = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    textController.addListener(onTextChange);
  }

  buildGenres(id) {
    return Text(
      widget.type == "movie"
          ? Provider.of<SettingsProvider>(context).movieMapOfGanres[id]
          : Provider.of<SettingsProvider>(context).tvMapOfGanres[id],
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 25,
        //  fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).currentFontColor,
      ),
    );
  }


  noData() {
    return Center(
      child: Container(
        child: Text(
          'Movies not found',
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 28.0,
            color: Provider.of<ThemeProvider>(context).currentMainColor,
          ),
        ),
      ),
    );
  }

  _buildResults(context) {
    List<Widget> list = [];
    int i=0;
    var films = Provider.of<SearchProvider>(context).listOfFilms;
    films.forEach((element){
      list.add(MovieCard(element));
          if (i == 5){
              list.add(
                Container(
                  height: 120,
                  child: AdmobBanner(
                    adUnitId: AddMobClass().getDrawerBannerAdUnitId(),
                    adSize: AdmobBannerSize.LARGE_BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                      if (event == AdmobAdEvent.opened) {
                        FirebaseAnalytics().logEvent(name: 'adMobDrawerClick');
                      }
                    },
                    onBannerCreated: (AdmobBannerController controller) {},
                  ),
                ),
              );
              i=0;
            }
          i++;
        });
    return ListView(
      children: list,
      controller: _scrollController,
    );
  }

  onTextChange() {
    if (textController.text.length >= 3) {
      setState(() {
        currentPage = 1;
        Provider.of<SearchProvider>(context, listen: false)
            .fetchData(textController.text, currentPage, widget.type);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        mySettings.changePage(0);
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: myColors.currentBackgroundColor,
        appBar: AppBar(
          title: Text(
            widget.type == "movie"
                ? AppLocalizations().translate(context, WordKeys.findYourMovie)
                : AppLocalizations().translate(context, WordKeys.findYourTV),
            style: TextStyle(
              fontFamily: "AmaticSC",
              fontSize: 30,
            ),
          ),
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
        body: _buildBody(context),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  buildInput() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
        child: TextField(
          controller: textController,
          cursorRadius: Radius.circular(15),
          cursorColor: Provider.of<ThemeProvider>(context).currentMainColor,
          decoration: new InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Provider.of<ThemeProvider>(context).currentSecondaryColor,
            ),
            prefix: SizedBox(
              width: 16,
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
            hintText: widget.type == "movie"
                ? AppLocalizations().translate(context, WordKeys.enterMovieName)
                : AppLocalizations().translate(context, WordKeys.enterTVName),
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

  _buildBody(BuildContext context) {
    return Stack(children: <Widget>[
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 24),
      //   child: buildInput(),
      // ),
      buildInput(),
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.107),
          child: _buildResults(context))
    ]);
  }

  _scrollListener() async {
    var provider = Provider.of<SearchProvider>(context, listen: false);
    if (provider.isLoading) return;
    if (Provider.of<SearchProvider>(context, listen: false).isLast) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ++currentPage;
      await Provider.of<SearchProvider>(context, listen: false)
          .fetchData(provider.oldValue, currentPage, widget.type);
      setState(() {
        provider.isLoading = false;
      });
    }
  }
}
