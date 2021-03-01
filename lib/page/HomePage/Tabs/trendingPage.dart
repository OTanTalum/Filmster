import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/trendingProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/widgets/UI/moviePosterCard.dart';
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
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

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
            : "day",
    scaffoldState);
  }

  loadPage(List<SearchResults> trendingList) {
    List<Widget> pageList = [];
    int i = 0;
    trendingList.forEach((element) {
      i++;
      pageList.add(MoviePosterCard(movie:element));
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
            : "day",
    scaffoldState);
  }

  @override
  Widget build(BuildContext context) {
    var themeProfile = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: scaffoldState,
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
    caramba.addAll(loadPage(movieList));
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