import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/discoverProvider.dart';
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

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initDiscover());
    _scrollController.addListener(_scrollListener);
  }

  initDiscover() async {
    await Provider.of<DiscoverProvider>(context, listen: false).fetchData(
        Provider.of<UserProvider>(context, listen: false).currentType != "movie"
            ? "tv"
            : "movie",
    context
    );
  }

  loadPage(List<SearchResults> discoverList) {
    List<Widget> pageList = [];
    int i = 0;
    discoverList.forEach((element) {
        pageList.add(movieCard(element));
        i++;
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
    var discoverProvider = Provider.of<DiscoverProvider>(context, listen: false);
    discoverProvider.currentPage++;
    await discoverProvider.fetchData(
        Provider.of<UserProvider>(context, listen: false).currentType != "movie"
            ? "tv"
            : "movie",
    context);
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProvider>(context);
    var themeProfile = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProfile.currentBackgroundColor,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn3",
        elevation: 2,
        backgroundColor: themeProfile.currentSecondaryColor,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => DialogWindow(
              onDoneTap: () async {
                Navigator.pop(context);
              },
              isTV: userProfile.currentType != "movie",
              title: "Filter",
              imageH: 96,
              imagew: 96,
            ),
          );
          setState(() {
            Provider.of<DiscoverProvider>(context, listen: false).clear();
            Provider.of<DiscoverProvider>(context, listen: false).currentPage = 1;
          });
          await initDiscover();
          print(Provider.of<SettingsProvider>(context, listen:false).movieArrayGenres);
        },
        child: Icon(Icons.movie_filter),
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
    var userProfile = Provider.of<UserProvider>(context, listen: false);
    List favoriteId = userProfile.currentType == "tv"
        ? userProfile.favoriteTVIds
        : userProfile.favoriteMovieIds;
    List watchedId = userProfile.currentType == "tv"
        ? userProfile.watchTVListIds
        : userProfile.watchMovieListIds;
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                id: movie.id.toString(),
                type: Provider.of<UserProvider>(context).currentType !=
                    "movie"
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
                        await userProfile.markAsWatch(
                            movie.id, !watchedId.contains(movie.id));
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
                        await userProfile.markAsFavorite(
                            movie.id, !favoriteId.contains(movie.id));
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
    var discoverProvider = Provider.of<DiscoverProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    List<Widget> caramba = [];
    List movieList = userProvider.currentType != "movie"
        ? discoverProvider.discoverTv
        : discoverProvider.discoverMovie;
    caramba.addAll(loadPage(movieList));
    if (caramba.length < 10) getNextPage();
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: discoverProvider.isLoading
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
    if (Provider.of<DiscoverProvider>(context, listen: false).isLast) return;
    if (Provider.of<DiscoverProvider>(context, listen: false).isLoading) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await getNextPage();
    }
  }
}
