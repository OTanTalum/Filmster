
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/trendingProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';

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
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initTrending();
  }

  initTrending() async {
    await Provider.of<TrendingProvider>(context, listen: false).fetchData(currentPage, "movie", "week");
   setState(() {
     getCards();
   });
  }

  getCards(){
    movieTrend=[];
    int i=0;
    Provider
        .of<TrendingProvider>(context, listen: false)
        .trendingMovies
        .forEach((element) {
          i++;
      movieTrend.add(MovieCard(element));
      if(i==10){
        movieTrend.add(
          AdmobBanner(
            adUnitId: addMobClass().getBannerAdUnitId(),
            adSize: AdmobBannerSize.FULL_BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              ///todo something
            },
            onBannerCreated: (AdmobBannerController controller) {},
          ),);
        i=0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Provider.of<ThemeProvider>(context).currentBackgroundColor,
      appBar: AppBar(
   leading: Switch(
     value: isSwitched,
     onChanged: (value){
       setState(() {
         isSwitched=value;
         print(isSwitched);
       });
     },
     activeTrackColor: Provider.of<ThemeProvider>(context).currentSecondaryColor,
     activeColor: Provider.of<ThemeProvider>(context).currentMainColor,
   ),
        title: Text(
          'Trending Movie',
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 22,
          ),
        ),
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


  Widget MovieCard(SearchResults movie) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => FilmDetailPage(id: movie.id.toString())));
      },
      child: Image.network(
        "${Api().imageBannerAPI}${movie.poster}",
        width: MediaQuery
            .of(context)
            .size
            .width * 0.5,
      ),
    );
  }

  _buildBody(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
              child:Wrap(
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
      await Provider.of<TrendingProvider>(context, listen: false)
          .fetchData(currentPage, "movie", "week");
      provider.isLoading = false;
      setState(() {
        getCards();
      });
    }
  }
}
