import 'dart:ui';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/widgets/UI/movieCard.dart';
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
  UserProvider userProvider;
  ScrollController _scroll = ScrollController();
  TabController _tabController;
  List<Widget> list=[];


  @override
  void initState() {
    super.initState();
    initLists();
    _tabController =  new TabController(length: 3, vsync: this);
    _scroll.addListener(addMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scroll.dispose();
    _tabController.dispose();
  }

  initLists() async{
    await Provider.of<UserProvider>(context, listen: false).getFavoriteTv();
    await Provider.of<UserProvider>(context, listen: false).getFavoriteMovies();
    await Provider.of<UserProvider>(context, listen: false).getMarkedTVList();
    await Provider.of<UserProvider>(context, listen: false).getMarkedMovieList();
    await Provider.of<UserProvider>(context, listen: false).getLists();
  }

  addMore() async {
    if (_scroll.position.pixels ==
        _scroll.position.maxScrollExtent&&
        userProvider.totalPage>=userProvider.currentPage) {
      userProvider.currentPage++;
      await userProvider.getLists();
    }
  }

  List<Widget> renderLists(List<SearchResults> list){
    List<Widget> actionList=[];
    list.forEach((SearchResults element) {
      actionList.add(MovieCard(element, _scaffoldKey));
    });
    return actionList;
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);

    List<Widget> favoriteList = renderLists(userProvider.getFavoriteList());
    List<Widget> markedList = renderLists(userProvider.getMarkedList());
    List<Widget> watchedList = renderLists(userProvider.getWatchedList());

    return WillPopScope(
      onWillPop: () async {
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
                text: AppLocalizations().translate(context, WordKeys.watched),
              ),
            ],
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Row(children: [
                  Text(
                    AppLocalizations().translate(context, WordKeys.films),
                    style: TextStyle(
                      fontFamily: "AmaticSC",
                      fontSize: 22,
                    ),
                  ),
                  Switch(
                    value: !userProvider.isMovie,
                    onChanged: (value) {
                      setState(() {
                        userProvider.changeCurrentType();
                      });
                    },
                    activeTrackColor:
                    Provider.of<ThemeProvider>(context).currentSecondaryColor,
                    activeColor: Provider.of<ThemeProvider>(context).currentMainColor,
                  ),
                  Text(
                    AppLocalizations().translate(context, WordKeys.TV),
                    style: TextStyle(
                      fontFamily: "AmaticSC",
                      fontSize: 22,
                    ),
                  ),
                ]),
              ),
            ],
            title: Text(
              AppLocalizations().translate(context, WordKeys.library),
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
