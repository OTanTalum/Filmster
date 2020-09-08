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
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/dialogWindow.dart';

import 'package:filmster/widgets/drawer.dart';

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
  List<Widget> movieTrend = [];
  bool isWeek = false;
  bool isTV = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initTrending();
  }

  initTrending() async {
    await Provider.of<TrendingProvider>(context, listen: false)
        .fetchData(currentPage, isTV ? "tv" : "movie", isWeek ? "week" : "day");
    setState(() {
      getCards();
    });
  }

  getCards() {
    movieTrend = [];
    int i = 0;
    isTV
        ? isWeek
            ? Provider.of<TrendingProvider>(context, listen: false)
                .trendingTVWeek
                .forEach((element) {
                bool hasGenre = false;
                element.ganres.forEach((element) {
                  if (Provider.of<SettingsProvider>(context, listen: false)
                      .tvArrayGenres
                      .contains(element)) {
                    hasGenre = true;
                  }
                });
                if (hasGenre||Provider.of<SettingsProvider>(context, listen: false)
                    .tvArrayGenres.isEmpty) {
                  i++;
                  movieTrend.add(movieCard(element));
                  if (i == 10) {
                    movieTrend.add(
                      AdmobBanner(
                        adUnitId: addMobClass().getBannerAdUnitId(),
                        adSize: AdmobBannerSize.FULL_BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic> args) {
                          ///todo something
                        },
                        onBannerCreated: (AdmobBannerController controller) {},
                      ),
                    );
                    i = 0;
                  }
                }
              })
            : Provider.of<TrendingProvider>(context, listen: false)
                .trendingTVDay
                .forEach((element) {
                bool hasGenre = false;
                element.ganres.forEach((element) {
                  if (Provider.of<SettingsProvider>(context, listen: false)
                      .tvArrayGenres
                      .contains(element)) {
                    hasGenre = true;
                  }
                });
                if (hasGenre||Provider.of<SettingsProvider>(context, listen: false)
                    .tvArrayGenres.isEmpty) {
                  i++;
                  movieTrend.add(movieCard(element));
                  if (i == 10) {
                    movieTrend.add(
                      AdmobBanner(
                        adUnitId: addMobClass().getBannerAdUnitId(),
                        adSize: AdmobBannerSize.FULL_BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic> args) {},
                        onBannerCreated: (AdmobBannerController controller) {},
                      ),
                    );
                    i = 0;
                  }
                }
              })
        : isWeek
            ? Provider.of<TrendingProvider>(context, listen: false)
                .trendingMoviesWeek
                .forEach((element) {
                bool hasGenre = false;
                element.ganres.forEach((element) {
                  if (Provider.of<SettingsProvider>(context, listen: false)
                      .movieArrayGenres
                      .contains(element)) {
                    hasGenre = true;
                  }
                });
                if (hasGenre||Provider.of<SettingsProvider>(context, listen: false)
                    .movieArrayGenres.isEmpty) {
                  i++;
                  movieTrend.add(movieCard(element));
                  if (i == 10) {
                    movieTrend.add(
                      AdmobBanner(
                        adUnitId: addMobClass().getBannerAdUnitId(),
                        adSize: AdmobBannerSize.FULL_BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic> args) {
                          ///todo something
                        },
                        onBannerCreated: (AdmobBannerController controller) {},
                      ),
                    );
                    i = 0;
                  }
                }
              })
            : Provider.of<TrendingProvider>(context, listen: false)
                .trendingMoviesDay
                .forEach((element) {
                  bool hasGenre = false;
                  element.ganres.forEach((element) {
                    if(Provider.of<SettingsProvider>(context, listen: false)
                        .movieArrayGenres.contains(element)){
                      hasGenre=true;
                    }
                  });
                if (hasGenre||Provider.of<SettingsProvider>(context, listen: false)
                    .movieArrayGenres.isEmpty) {
                  i++;
                  movieTrend.add(movieCard(element));
                  if (i == 10) {
                    movieTrend.add(
                      AdmobBanner(
                        adUnitId: addMobClass().getBannerAdUnitId(),
                        adSize: AdmobBannerSize.FULL_BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic> args) {},
                        onBannerCreated: (AdmobBannerController controller) {},
                      ),
                    );
                    i = 0;
                  }
                }
              });
  }

  @override
  Widget build(BuildContext context) {
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
              value: isTV,
              onChanged: (value) {
                setState(() {
                  isTV = value;
                  initTrending();
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
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => DialogWindow(
                  onDoneTap: () async {
                    Navigator.pop(context);
                  },
                  isTV: isTV,
                  title: "Filter",
                  body:
                      "Dispetcher optimized your route based on data from all orders",
                  imageH: 96,
                  imagew: 96,
                ),
              );
              setState(() {
                getCards();
              });
            },
            icon: Icon(Icons.filter_list),
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

    super.dispose();
  }

  movieCard(SearchResults movie) {
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                  id: movie.id.toString(), type: isTV ? "tv" : "movie")));
        },
        child: Image.network(
          "${Api().imageBannerAPI}${movie.poster}",
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5 * (3 / 2),
        ),
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
                              fontFamily: "AmaticSC",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ))),
                  ]),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        ///TODO add isWatched
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        ///TODO add isFavorite
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
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
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Provider.of<TrendingProvider>(context, listen: false).isLoading
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
                children: movieTrend,
              ),
      ),
    );
  }

  _scrollListener() async {
    var provider = Provider.of<TrendingProvider>(context, listen: false);
    if (Provider.of<TrendingProvider>(context, listen: false).isLast) return;
    if (Provider.of<TrendingProvider>(context, listen: false).isLoading) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ++currentPage;
      await Provider.of<TrendingProvider>(context, listen: false).fetchData(
          currentPage, isTV ? "tv" : "movie", isWeek ? "week" : "day");
      provider.isLoading = false;
      setState(() {
        getCards();
      });
    }
  }
}
