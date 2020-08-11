import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:filmster/model/film.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/themeProvider.dart';

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
  bool _noData = true;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLast = false;
  String oldValue='';

  String imdbAPI = 'http://www.omdbapi.com/?apikey=827ba9b0&type=movie&s=';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    textController.addListener(onTextChange);
  }

  _buildFilm(Film film) {
    var provider = Provider.of<ThemeProvider>(context);
    return Container(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => FilmDetailPage(film: film)));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: provider.currentSecondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 165,
              //     color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(children: <Widget>[
                film.posters != 'N/A'
                    ? Image.network(
                        film.posters,
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
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 5),
                          width: MediaQuery.of(context).size.width * 0.9 - 140,
                          child: Text(film.title,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lifeSavers(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: provider.currentFontColor,
                              ))),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          child: Text(
                            film.year,
                            style: GoogleFonts.lifeSavers(
                              color: provider.currentFontColor,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          child: Text(
                            film.type,
                            style: GoogleFonts.lifeSavers(
                              color: provider.currentFontColor,
                            ),
                          ))
                    ])
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
          style: GoogleFonts.lifeSavers(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
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
        fetchData(textController.text);
      });
    }
  }

   Future<bool> fetchData(text) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final response =
          await http.get('$imdbAPI${textController.text}&page=${currentPage}');
      if (response.statusCode == 200) {
        _noData = false;
        setState(() {
          oldValue=text;
          isLoading = false;
        });
        List<Film> list = Search.fromJson(json.decode(response.body)).search;
          Provider.of<SearchProvider>(context, listen: false).addFilms(list, currentPage);
          print(Search.fromJson(json.decode(response.body)).total??0);
        Provider.of<SearchProvider>(context, listen: false).changeIsLast(
            (Search.fromJson(json.decode(response.body)).total??0)<currentPage*10
        );

        return ( Search.fromJson(json.decode(response.body)).total??0)<currentPage*10;
      } else {
        _noData = true;
        setState(() {
          oldValue=text;
          isLoading = false;
        });
        throw Exception('Failed to load ');
      }
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
          style: GoogleFonts.lifeSavers(),
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
            ),
            hintText: 'Enter movie name',
          ),
          style: GoogleFonts.lifeSavers(
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
            child:_noData ? noData() : _buildResults(context))
      ]
    );
  }

  _scrollListener() async {
    if(isLoading)
      return;
    if (Provider.of<SearchProvider>(context, listen: false).isLast) return;
    print("OK");
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ++currentPage;
      await fetchData(oldValue);
      setState(() {
        isLoading = false;
      });
    }
  }
}
