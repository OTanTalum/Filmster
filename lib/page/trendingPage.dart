import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/trendingProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/dialogWindow.dart';

import 'package:filmster/widgets/drawer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isWeek = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initTrending());
    _scrollController.addListener(_scrollListener);
  }

  initTrending() async {
    await Provider.of<TrendingProvider>(context, listen: false)
        .fetchData(
        currentPage,
        Provider.of<UserProvider>(context,listen: false).currentType!="movie"
            ? "tv"
            : "movie",
        isWeek
            ? "week"
            : "day"
    );
  }

  loadPage(List<SearchResults> trendingList, List<int> arrayGenres) {
    List<Widget> pageList = [];
    int i = 0;
    trendingList.forEach((element) {
      int hasGenre = 0;
      element.ganres.forEach((genre) {
        if (arrayGenres.contains(genre)) {
          ++hasGenre;
        }
      });
      if (hasGenre == arrayGenres.length || arrayGenres.isEmpty) {
        i++;
        pageList.add(movieCard(element));
        if (i == 10) {
          pageList.add(
            AdmobBanner(
              adUnitId: AddMobClass().getBannerAdUnitId(),
              adSize: AdmobBannerSize.FULL_BANNER,
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                if (event == AdmobAdEvent.opened) {
                  print('Admob banner opened!');
                  FirebaseAnalytics().logEvent(name: 'adMobTrendingClick');
                }
              },
              onBannerCreated: (AdmobBannerController controller) {},
            ),
          );
          i = 0;
        }
      }
    });
    return pageList;
  }

  getNextPage() async {
    ++currentPage;
    await Provider.of<TrendingProvider>(context, listen: false)
        .fetchData(currentPage,  Provider.of<UserProvider>(context, listen: false).currentType!="movie"
        ? "tv"
        : "movie", isWeek ? "week" : "day");
    Provider.of<TrendingProvider>(context, listen: false).isLoading = false;
    Provider.of<TrendingProvider>(context, listen: false).notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeProvider>(context).currentBackgroundColor,
      appBar: AppBar(
        leading: null,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text(
              AppLocalizations().translate(context, WordKeys.day),
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 22,
              ),
            ),
            Switch(
              value: isWeek,
              onChanged: (value) {
                setState(() {
                  isWeek = value;
                  initTrending();
                });
              },
              activeTrackColor:
                  Provider.of<ThemeProvider>(context).currentSecondaryColor,
              activeColor: Provider.of<ThemeProvider>(context).currentMainColor,
            ),
            Text(
              AppLocalizations().translate(context, WordKeys.week),
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 22,
              ),
            ),
          ]),
          Row(children: [
            Text(
              AppLocalizations().translate(context, WordKeys.films),
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 22,
              ),
            ),
            Switch(
              value: userProfile.currentType != "movie",
              onChanged: (value) {
                setState(() {
                  userProfile.changeCurrentType(
                      userProfile.currentType == "movie" ? "tv" : "movie");
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
          Expanded(
            child: IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => DialogWindow(
                    onDoneTap: () async {
                      Navigator.pop(context);
                    },
                    isTV:  Provider.of<UserProvider>(context).currentType!="movie",
                    title: "Filter",
                    body:
                        "Dispetcher optimized your route based on data from all orders",
                    imageH: 96,
                    imagew: 96,
                  ),
                );
                setState(() {
                  Provider.of<TrendingProvider>(context, listen: false).clear();
                  currentPage = 1;
                });
                await initTrending();
              },
              icon: Icon(Icons.movie_filter),
            ),
          )
        ]),
      ),
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _scrollController.dispose();
    super.dispose();
  }

  Widget movieCard(SearchResults movie) {
    var userProfile = Provider.of<UserProvider>(context);
    List favoriteId = userProfile.currentType=="tv"
        ? userProfile.favoriteTVIds
        : userProfile.favoriteMovieIds;
    List watchedId = userProfile.currentType=="tv"
        ? userProfile.watchTVListIds
        : userProfile.watchMovieListIds;
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                  id: movie.id.toString(), type:  Provider.of<UserProvider>(context).currentType!="movie"
                  ? "tv"
                  : "movie", )));
        },
        child: movie.poster != null
            ? Image.network(
                "${Api().imageBannerAPI}${movie.poster}",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5 * (3 / 2),
              )
            : Container(),
      ),
      Positioned(
        bottom: 0,
        child: Opacity(
          opacity: 0.7,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.blueGrey[900],
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.white,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(movie.popularity.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "MPLUSRounded1c",
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: Colors.white,
                            ))),
                  ]),
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        await userProfile.markAsWatch(movie.id,
                            !watchedId.contains(movie.id));
                      },
                      icon: Icon(
                        watchedId.contains(movie.id)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: !watchedId.contains(movie.id)
                            ? Colors.white
                            : Colors.lightGreen,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        await userProfile.markAsFavorite(movie.id,
                            !favoriteId.contains(movie.id));
                      },
                      icon: Icon(
                        favoriteId.contains(movie.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteId.contains(movie.id)
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      )
    ]);
  }

  _buildBody(BuildContext context) {
    List<Widget> caramba = [];
    List movieList =  Provider.of<UserProvider>(context).currentType!="movie"
    ? isWeek
            ? Provider.of<TrendingProvider>(context).trendingTVWeek
            : Provider.of<TrendingProvider>(context).trendingTVDay
        : isWeek
            ? Provider.of<TrendingProvider>(context).trendingMoviesWeek
            : Provider.of<TrendingProvider>(context).trendingMoviesDay;
    caramba.addAll(loadPage(
        movieList,
        Provider.of<UserProvider>(context).currentType!="movie"
            ? Provider.of<SettingsProvider>(context).tvArrayGenres
            : Provider.of<SettingsProvider>(context).movieArrayGenres));
    if (caramba.length < 10) getNextPage();
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Provider.of<TrendingProvider>(context).isLoading
            ? Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Provider.of<ThemeProvider>(context)
                              .currentMainColor)),
                ),
              )
            : Wrap(
                children: caramba,
              ),
      ),
    );
  }

  _scrollListener() async {
    if (Provider.of<TrendingProvider>(context, listen: false).isLast) return;
    if (Provider.of<TrendingProvider>(context, listen: false).isLoading) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await getNextPage();
    }
  }
}
