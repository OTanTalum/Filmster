import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/api.dart';

import 'package:filmster/widgets/drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FilmsPage extends StatefulWidget {
  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  final textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLast = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    textController.addListener(onTextChange);
  }

  _buildVoteBlock(icon, text) {
    var provider = Provider.of<ThemeProvider>(context);
    return Row(
        children: [
          Icon(
           icon,
            color: provider.currentFontColor,
          ),
          Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "AmaticSC",
                    fontSize: 25,
                    //  fontWeight: FontWeight.bold,
                    color: provider.currentFontColor,
                  )))
        ]);
  }

  buildGenres(id) {
    return Text(
      Provider.of<SettingsProvider>(context).mapOfGanres[id],
       style:  TextStyle(
          fontFamily: "AmaticSC",
          fontSize: 25,
          //  fontWeight: FontWeight.bold,
          color: Provider.of<ThemeProvider>(context).currentMainColor,
        ),
    );
  }

  _buildFilm(SearchResults film) {
    var provider = Provider.of<ThemeProvider>(context);
    List<Widget> list=[];
    if(film.ganres!=null&& film.ganres.isNotEmpty) {
       film.ganres.forEach((element) {
         print(element);
         print(Provider.of<SettingsProvider>(context).mapOfGanres[element]);
         list.add(buildGenres(element));
       }) ;
      }
    return Container(
      child: GestureDetector(
        onTap: () async {
//          Navigator.of(context).pushReplacement(
//              MaterialPageRoute(builder: (_) => FilmDetailPage(filmID: film.imdbid)));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              height: MediaQuery.of(context).size.height*0.28,
              decoration: BoxDecoration(
                color: provider.currentSecondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                film.poster != null
                    ? Image.network(
                      "${Api().imageBannerAPI}${film.poster}",
                        height: 150,
                        width: 100,
                      )
                    : Container(
                        height: 150,
                        width: 100,
                        child: Icon(
                          Icons.do_not_disturb_on,
                          size: 100.0,
                          color: provider.currentAcidColor,
                        )),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width*0.55,
                    child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          child: Text(
                              film.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                              style: TextStyle(
                                fontFamily: "AmaticSC",
                                fontSize: 25,
                                color: provider.currentMainColor,
                              ),
                          ),
                        ),
                      ),
                     film.title!=film.originalTitle
                         ? Expanded(
                          child: Text(film.originalTitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "AmaticSC",
                                fontSize: 23,
                              //  fontWeight: FontWeight.bold,
                                color: provider.currentFontColor,
                              ),
                          ),
                     )
                      :Container(),
                      Expanded(
                          child: Text(
                            film.release??"-",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "AmaticSC",
                              color: provider.currentFontColor,
                            ),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width*0.46,
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 6,
                          children: list,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _buildVoteBlock(Icons.trending_up, film.popularity.toString()),
                          SizedBox(width:10),
                          _buildVoteBlock( Icons.grade, film.voteAverage),
                        ],
                      )
//                      Padding(
//                          padding: EdgeInsets.symmetric(
//                              vertical: 5.0, horizontal: 5.0),
//                          child: Text(
//                            film.type,
//                            style: TextStyle(
//                              color: provider.currentFontColor,
//                            ),
//                          ))
                    ]),
                ),
              ]),
            )),
      ),
    );
  }

  noData() {
    return Center(
      child: Container(
        child: Text(
          'Movies not found',
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 28.0,
            color: Provider.of<ThemeProvider>(context).currentMainColor,
          ),
        ),
      ),
    );
  }


  _buildResults(context) {
    List<Widget> list = [];
    var films = Provider.of<SearchProvider>(context).listOfFilms;
              films.forEach(
                  (element) => list.add(_buildFilm(element)));
              return ListView(
                  children: list,
                controller: _scrollController,
              );
//    return FutureBuilder<bool>(
//        future: fetchData(textController.text),
//        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//          if (snapshot.hasData) {
//            if (snapshot.data == null) {
//              _noData = true;
//              return noData();
//            } else {
//              _noData = false;
//              var films = Provider.of<SearchProvider>(context).listOfFilms;
//              films.forEach(
//                  (element) => list.add(_buildFilm(element)));
//              return ListView(
//                  children: list,
//                controller: _scrollController,
//              );
//            }
//          }
////          else if(snapshot.hasData && snapshot.data.search==null)
////            return noData();
//          return Center(
//              child:Container(
//                padding: EdgeInsets.only(top: 60),
//              height: 50, width: 50, child: CircularProgressIndicator()));
//        });
  }

  onTextChange() {
    if (textController.text.length >= 3) {
      setState(() {
        currentPage = 1;
        Provider.of<SearchProvider>(context, listen: false).fetchData(textController.text, currentPage);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeProvider>(context).currentBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Find your films',
          style: TextStyle(
            fontFamily: "AmaticSC"
          ),
        ),
      ),
      drawer: DrawerMenu().build(context),
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  buildInput() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
        child: TextField(
          controller: textController,
          cursorRadius: Radius.circular(15),
          cursorColor: Provider.of<ThemeProvider>(context).currentMainColor,
          decoration: new InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Provider.of<ThemeProvider>(context).currentSecondaryColor,
            ),
            prefix: SizedBox(
              width: 16,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: Provider.of<ThemeProvider>(context).currentMainColor,
                  width: 3.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: Provider.of<ThemeProvider>(context).currentMainColor,
                  width: 1.0),
            ),
            hintStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).currentSecondaryColor,
              fontFamily: "AmaticSC"
            ),
            hintText: 'Enter movie name',
          ),
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontWeight: FontWeight.w700,
            textBaseline: null,
            color: Provider.of<ThemeProvider>(context).currentFontColor,
            fontSize: 20.0,
          ),
        ));
  }

  _buildBody(BuildContext context) {
    //List<Widget> list = [];
//    Provider.of<SearchProvider>(context).listOfFilms.forEach((element) {
//      list.add(_buildFilm(element));
//    });
    return  Stack(
          children: <Widget>[
            buildInput(),
            Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.105, left: 24, right: 24),
            child: _buildResults(context))
      ]
    );
  }

  _scrollListener() async {
    var provider = Provider.of<SearchProvider>(context, listen: false);
    if(provider.isLoading)
      return;
    if (Provider.of<SearchProvider>(context, listen: false).isLast) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("____");
      ++currentPage;
      await Provider.of<SearchProvider>(context, listen: false).fetchData(provider.oldValue, currentPage);
      setState(() {
        provider.isLoading = false;
      });
    }
  }
}
