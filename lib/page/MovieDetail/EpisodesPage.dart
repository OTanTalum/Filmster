import 'package:filmster/model/Episode.dart';
import 'package:filmster/model/Season.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:filmster/providers/movieProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/setting/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodesPage extends StatelessWidget {
  EpisodesPage({required this.poster});
  final String poster;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late ThemeProvider themeProvider;
  late LibraryProvider libraryProvider;
  late MovieProvider movieProvider;

  @override
  Widget build(BuildContext context) {
    libraryProvider = Provider.of<LibraryProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    movieProvider = Provider.of<MovieProvider>(context);
    List<Widget> list=[];
    movieProvider.season!.episodes.forEach((Episode element) {
      list.add(buildEpisodes(element, context));
    });
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: themeProvider.currentBackgroundColor,
        appBar: AppBar(
            title: Text(
              "Seasons & Episodes",
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 33,
                color: themeProvider.currentFontColor,
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: list,
          ),
        ));
  }


  buildEpisodes(Episode episode, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 200,
          width: MediaQuery.of(context).size.width - 24,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(episode.poster != null
                    ? "${Api().imageBannerAPI}${episode.poster}"
                    : "${Api().imageBannerAPI}${poster}"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: themeProvider.currentSecondaryColor!,
                  offset: new Offset(3.0, 5.0),
                  blurRadius: 5.0,
                  spreadRadius: 0.7)
            ],
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width - 24,
            decoration: BoxDecoration(
              color: Colors.black,
              // themeProvider.currentTheme != MyThemes.Loft
              //     ? themeProvider.currentBackgroundColor
              //     :
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        Center(
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(episode.name!,
                      style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: themeProvider.currentTheme == MyThemes.Loft
                            ? themeProvider.currentBackgroundColor
                            : themeProvider.currentFontColor,
                      )),
                  SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(episode.airDate ?? "-",
                            style: TextStyle(
                              fontFamily: "AmaticSC",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.currentTheme == MyThemes.Loft
                                  ? themeProvider.currentBackgroundColor
                                  : themeProvider.currentFontColor,
                            )),
                        Text(
                            "${episode.seasonNumber}\tEpisode ${episode.episodeNumber}",
                            style: TextStyle(
                              fontFamily: "AmaticSC",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.currentTheme == MyThemes.Loft
                                  ? themeProvider.currentBackgroundColor
                                  : themeProvider.currentFontColor,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ))
      ]),
    );
  }


  buildEpisode(Episode episode, context){
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(12),
        color: themeProvider.currentSecondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async{
              },
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width/3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(episode.poster!=null
                          ?"${Api().imageBannerAPI}${episode.poster}"
                          :"${Api().imageBannerAPI}${poster}")
                  ),
                ),
              ),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Container(
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(episode.name!,
                          style: TextStyle(
                            fontFamily: "NK170",
                            fontWeight: FontWeight.w500,
                            height: 1,
                            wordSpacing: 1,
                            letterSpacing: 0.5,
                            fontSize: 25.0,
                            color: themeProvider.currentFontColor,
                          ),),
                        if(episode.airDate!=null)
                          Text(episode.airDate!,
                            style: TextStyle(
                              fontFamily: "NK170",
                              fontWeight: FontWeight.w500,
                              height: 1,
                              wordSpacing: 1,
                              letterSpacing: 0.5,
                              fontSize: 25.0,
                              color: themeProvider.currentFontColor,
                            ),),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom:24.0),
                    //   child: Text("${season.episodeCount} episodes",
                    //     style: TextStyle(
                    //       fontFamily: "NK170",
                    //       fontWeight: FontWeight.w500,
                    //       height: 1,
                    //       wordSpacing: 1,
                    //       letterSpacing: 0.5,
                    //       fontSize: 20.0,
                    //       color: themeProvider.currentFontColor,
                    //     ),),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

