import 'package:filmster/model/Season.dart';
import 'package:filmster/model/film.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:filmster/providers/movieProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonsPage extends StatefulWidget {
  SeasonsPage({this.movie});
  final Film? movie;
  @override
  _SeasonsPageState createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
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
    widget.movie!.seasons!.forEach((Season element) {
      list.add(buildSeason(element));
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

  buildSeason(Season season){
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(12),
        color: themeProvider.currentSecondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: ()=>print("tap"),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width/3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(season.poster!=null?"${Api().imageBannerAPI}${season.poster}":"${Api().imageBannerAPI}${widget.movie!.poster}")
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
                        Text(season.name!,
                          style: TextStyle(
                            fontFamily: "NK170",
                            fontWeight: FontWeight.w500,
                            height: 1,
                            wordSpacing: 1,
                            letterSpacing: 0.5,
                            fontSize: 25.0,
                            color: themeProvider.currentFontColor,
                          ),),
                        if(season.airDate!=null)
                        Text(season.airDate!,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom:24.0),
                      child: Text("${season.episodeCount} episodes",
                        style: TextStyle(
                          fontFamily: "NK170",
                          fontWeight: FontWeight.w500,
                          height: 1,
                          wordSpacing: 1,
                          letterSpacing: 0.5,
                          fontSize: 20.0,
                          color: themeProvider.currentFontColor,
                        ),),
                    ),
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
