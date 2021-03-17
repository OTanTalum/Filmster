import 'dart:ui';
import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/Widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/Widgets/UI/movieCard.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late LibraryProvider libraryProvider;
  ScrollController _scroll = ScrollController();
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    initLists();
    _tabController =  new TabController(length:3, vsync: this);
    _scroll.addListener(addMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scroll.dispose();
    _tabController!.dispose();
  }

  initLists() async{
    await Provider.of<LibraryProvider>(context, listen: false).getFavoriteTv(_scaffoldKey);
    await Provider.of<LibraryProvider>(context, listen: false).getFavoriteMovies(_scaffoldKey);
    await Provider.of<LibraryProvider>(context, listen: false).getMarkedTVList(_scaffoldKey);
    await Provider.of<LibraryProvider>(context, listen: false).getMarkedMovieList(_scaffoldKey);
    await Provider.of<LibraryProvider>(context, listen: false).getLists(_scaffoldKey);
  }

  addMore() async {
    if (_scroll.position.pixels ==
        _scroll.position.maxScrollExtent&&
        libraryProvider.totalWatchedPage!>=libraryProvider.currentPage) {
      libraryProvider.currentPage++;
      await libraryProvider.getLists(_scaffoldKey);
    }
  }

  List<Widget> renderLists(List<SearchResults> list){
    List<Widget> actionList=[];
    list.forEach((SearchResults element) {
      actionList.add(
          MovieCard(
            film:element,
            scaffoldKey: _scaffoldKey,),
      );
    });
    return actionList;
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    libraryProvider = Provider.of<LibraryProvider>(context);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);

    List<Widget> favoriteList = renderLists(libraryProvider.getFavoriteList());
    List<Widget> markedList = renderLists(libraryProvider.getMarkedList());
    List<Widget> watchedList = renderLists(libraryProvider.getWatchedList());

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        mySettings.changePage(mySettings.prevPage!);
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
                text: AppLocalizations().translate(context, WordKeys.watched),
              ),
            ],
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Row(children: [
                  Text(
                    AppLocalizations().translate(context, WordKeys.films)!,
                    style: TextStyle(
                      fontFamily: "AmaticSC",
                      fontSize: 22,
                    ),
                  ),
                  Switch(
                    value: !libraryProvider.isMovie,
                    onChanged: (value) {
                      setState(() {
                        libraryProvider.changeCurrentType();
                      });
                    },
                    activeTrackColor:
                    Provider.of<ThemeProvider>(context).currentSecondaryColor,
                    activeColor: Provider.of<ThemeProvider>(context).currentMainColor,
                  ),
                  Text(
                    AppLocalizations().translate(context, WordKeys.TV)!,
                    style: TextStyle(
                      fontFamily: "AmaticSC",
                      fontSize: 22,
                    ),
                  ),
                ]),
              ),
            ],
            title: Text(
              AppLocalizations().translate(context, WordKeys.library)!,
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 30,
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            elevation: 0,
            backgroundColor: myColors.currentSecondaryColor,
            child: Icon(
              Icons.favorite,
              color: mySettings.currentPage==Pages.LIBRARY_PAGE
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
              children: favoriteList,
            )),
            SingleChildScrollView(
                child: Column(
              children: markedList,
            )),
            SingleChildScrollView(
              controller: _scroll,
                child: Column(
                  children: watchedList,
                )),
            ],
          ),
        ),
    );
  }
}
