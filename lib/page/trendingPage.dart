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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initTrending());
    _scrollController.addListener(_scrollListener);
  }

  initTrending() async {
    await Provider.of<TrendingProvider>(context, listen: false).fetchData(
        Provider.of<UserProvider>(context, listen: false).isMovie
            ? "movie"
            : "tv",
        Provider.of<UserProvider>(context, listen: false).currentPeriod != "day"
            ? "week"
            : "day");
  }

  loadPage(List<SearchResults> trendingList, List<int> arrayGenres) {
    List<Widget> pageList = [];
    int i = 0;
    trendingList.forEach((element) {
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
    });
    return pageList;
  }

  getNextPage() async {
    var trendProvider = Provider.of<TrendingProvider>(context, listen: false);
    trendProvider.currentPage++;
    await trendProvider.fetchData(
        !Provider.of<UserProvider>(context, listen: false).isMovie
            ? "tv"
            : "movie",
        Provider.of<UserProvider>(context, listen: false).currentPeriod != "day"
            ? "week"
            : "day");
  }

  @override
  Widget build(BuildContext context) {
    var themeProfile = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProfile.currentBackgroundColor,
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
    List favoriteId = !userProfile.isMovie
        ? userProfile.favoriteTVIds
        : userProfile.favoriteMovieIds;
    List markedId = !userProfile.isMovie
        ? userProfile.markedTVListIds
        : userProfile.markedMovieListIds;
    List watchedId = userProfile.watchedMovieListIds;
    bool marked = markedId.contains(movie.id);
    bool isFavorite = favoriteId.contains(movie.id);
    bool watched = watchedId.contains(movie.id);
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                    id: movie.id.toString(),
                    type: !Provider.of<UserProvider>(context).isMovie
                        ? "tv"
                        : "movie",
                  )));
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
                  IconButton(
                    onPressed: () async {
                      setState(() {
                      marked=!marked;
                    });
                      await userProfile.mark(
                          movie, !markedId.contains(movie.id));

                    },
                    icon: Icon(
                     marked
                          ? Icons.turned_in
                          : Icons.turned_in_not,
                      color: !marked
                          ? Colors.white
                          : Colors.lightGreen,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await userProfile.markAsFavorite(
                          movie, favoriteId.contains(movie.id));
                      setState(() {
                        isFavorite=!isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        watched=!watched;
                      });
                      await userProfile.markAsWatched(
                          movie, watchedId.contains(movie.id));
                    },
                    icon: Icon(
                      watched
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: watched
                          ? Provider.of<ThemeProvider>(context).currentMainColor
                          : Colors.white,
                    ),
                  ),
                ],
              ),
          ),
        ),
      )
    ]);
  }

  _buildBody(BuildContext context) {
    var trendingProvider = Provider.of<TrendingProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    List<Widget> caramba = [];
    List movieList = !userProvider.isMovie
        ? userProvider.currentPeriod != "day"
            ? trendingProvider.trendingTVWeek
            : trendingProvider.trendingTVDay
        : userProvider.currentPeriod != "day"
            ? trendingProvider.trendingMoviesWeek
            : trendingProvider.trendingMoviesDay;
    caramba.addAll(loadPage(
        movieList,
        !userProvider.isMovie
            ? Provider.of<SettingsProvider>(context).tvArrayGenres
            : Provider.of<SettingsProvider>(context).movieArrayGenres));
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: trendingProvider.isLoading
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
