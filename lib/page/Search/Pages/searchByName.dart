import 'dart:ui';
//import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/Widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/Widgets/UI/LIbraryActionButton.dart';
import 'package:filmster/Widgets/UI/movieCard.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library.dart';

class FilmsPage extends StatefulWidget {
  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  final textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  late LibraryProvider libraryProvider;
  late ThemeProvider themeProvider;
  late SearchProvider searchProvider;
  late SettingsProvider settingsProvider;
  int currentPage = 1;
  bool isLast = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    textController.addListener(onTextChange);
  }


  noData() {
    return Center(
      child: Container(
        child: Text(
          'Movies not found',
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 28.0,
            color: themeProvider.currentMainColor,
          ),
        ),
      ),
    );
  }

  _buildResults(context) {
    List<Widget> list = [];
    int i = 0;
    searchProvider.listOfFilms!.forEach((element) {
      list.add(
          MovieCard(
        film:element,
            scaffoldKey: scaffoldState,),
      );
      if (i == 5) {
        list.add(AddMobClass().buildSearchListBunner());
        i = 0;
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
        searchProvider.fetchData(textController.text, currentPage, libraryProvider.isMovie?"movie":"tv", scaffoldState);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    settingsProvider = Provider.of<SettingsProvider>(context);
    libraryProvider = Provider.of<LibraryProvider>(context);
    searchProvider = Provider.of<SearchProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        settingsProvider.changePage(Pages.SEARCH_PAGE);
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: themeProvider.currentBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations().translate(
                context,
                libraryProvider.isMovie
                    ? WordKeys.findYourMovie
                    : WordKeys.findYourTV)!,
            style: TextStyle(
              fontFamily: "AmaticSC",
              fontSize: 30,
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: LibraryActionButton.build(context: context, keyState: scaffoldState),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _buildBody(context),
      ),
    );
  }

  @override
  void dispose() {
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
          cursorColor: themeProvider.currentMainColor,
          decoration: new InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: themeProvider.currentSecondaryColor,
            ),
            prefix: SizedBox(
              width: 16,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: themeProvider.currentMainColor!,
                  width: 3.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: themeProvider.currentMainColor!, width: 1.0),
            ),
            hintStyle: TextStyle(
                color: themeProvider.currentSecondaryColor,
                fontFamily: "AmaticSC"),
            hintText: AppLocalizations().translate(
                context,
                libraryProvider.isMovie
                    ? WordKeys.enterMovieName
                    : WordKeys.enterTVName),
          ),
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontWeight: FontWeight.w700,
            textBaseline: null,
            color: themeProvider.currentFontColor,
            fontSize: 20.0,
          ),
        ));
  }

  _buildBody(BuildContext context) {
    return Stack(children: <Widget>[
      buildInput(),
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.107),
          child: _buildResults(context))
    ]);
  }

  _scrollListener() async {
    if (searchProvider.isLoading||searchProvider.isLast!) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ++currentPage;
      await Provider.of<SearchProvider>(context, listen: false)
          .fetchData(searchProvider.oldValue, currentPage, libraryProvider.isMovie?"movie":"tv", scaffoldState);
      setState(() {
        searchProvider.isLoading = false;
      });
    }
  }
}
