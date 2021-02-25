import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/model/search.dart';

import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/discoverProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/dialogWindow.dart';
import 'package:filmster/widgets/movieCard.dart';

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
  UserProvider userProvider;
  DiscoverProvider discoverProvider;


  @override
  void initState() {
    super.initState();
    Future.microtask(() => initDiscover());
    _scrollController.addListener(_scrollListener);
  }

  initDiscover() async {
    await discoverProvider.fetchData(
        userProvider.isMovie
            ? "movie"
            : "tv",
    context
    );
  }

  loadPage(List<SearchResults> discoverList) {
    List<Widget> pageList = [];
    int i = 0;
    discoverList.forEach((element) {
        pageList.add(MovieCard(element));
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
    ++discoverProvider.currentPage;
    await discoverProvider.fetchData(
        userProvider.isMovie
            ? "movie"
            : "tv",
    context);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    discoverProvider = Provider.of<DiscoverProvider>(context);
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
              isTV: !userProvider.isMovie,
              title: "Filter",
              imageH: 96,
              imagew: 96,
            ),
          );
          setState(() {
            discoverProvider.clear();
            discoverProvider.currentPage = 1;
          });
          await initDiscover();
        },
        child: Icon(Icons.movie_filter),
      ),
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {

    _scrollController.dispose();
    super.dispose();
  }

/*  Widget movieCard(SearchResults movie) {
    var userProfile = Provider.of<UserProvider>(context, listen: false);
    List favoriteId = !userProfile.isMovie
        ? userProfile.favoriteTVIds
        : userProfile.favoriteMovieIds;
    List markedId = !userProfile.isMovie
        ? userProfile.markedTVListIds
        : userProfile.markedMovieListIds;
    List watchedId = userProfile.watchedMovieListIds;
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                id: movie.id.toString(),
                type: userProfile.isMovie
                    ? "movie"
                    : "tv",
              ))).then((value) => setState((){

          }));
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
                      await userProfile.mark(
                          movie.id, !markedId.contains(movie.id));
                    },
                    icon: Icon(
                      markedId.contains(movie.id)
                          ? Icons.turned_in
                          : Icons.turned_in_not,
                      color: !markedId.contains(movie.id)
                          ? Colors.white
                          : Colors.lightGreen,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await userProfile.markAsFavorite(
                          movie, favoriteId.contains(movie.id));
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
                  IconButton(
                    onPressed: () async {
                      await userProfile.markAsWatched(
                          movie.id, !watchedId.contains(movie.id));
                    },
                    icon: Icon(
                      watchedId.contains(movie.id)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: watchedId.contains(movie.id)
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
  }*/

  _buildBody(BuildContext context) {
    List<Widget> caramba = [];
    List movieList = !userProvider.isMovie
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
    if (discoverProvider.isLast||discoverProvider.isLoading) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await getNextPage();
    }
  }
}
