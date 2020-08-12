import 'package:dartpedia/dartpedia.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/widgets/progressBarWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:filmster/widgets/drawer.dart';

import 'package:filmster/model/film.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FilmDetailPage extends StatefulWidget {
  final String filmID;

  FilmDetailPage({Key key, this.filmID}) : super(key: key);

  @override
  FilmDetailPageState createState() => new FilmDetailPageState();
}

class FilmDetailPageState extends State<FilmDetailPage> {
  String imdbAPI = 'http://www.omdbapi.com/?apikey=827ba9b0&i=';
  Film film;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      setState(() {});
    });
    loadFilm();
  }

  loadFilm() async {
    final response = await http.get('$imdbAPI${widget.filmID}');
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      film = Film.fromJson(json.decode(response.body));
    } else {
      setState(() {
        film = null;
        isLoading = false;
      });
      throw Exception('Failed to load ');
    }
  }

  _buildHeader(String title){
    var provider = Provider.of<ThemeProvider>(context);
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.caveat(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: provider.currentMainColor,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    return film == null
        ? Container(
            color: provider.currentBackgroundColor,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: provider.currentBackgroundColor,
            appBar: AppBar(
              title: Text(
                film.title,
                style: GoogleFonts.caveat(
                  color: provider.currentFontColor,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6.0),
                child: LayoutBuilder(
                  builder: (_, constraints) => Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                        painter: Progress(
                            current:
                                scrollController?.offset?.toDouble() ?? 1.0,
                            allSize: scrollController.position.maxScrollExtent
                                ?.toDouble(),
                            colors: provider.currentMainColor,
                            height: 4,
                            width: MediaQuery.of(context).size.width)),
                  ),
                ),
              ),
            ),
            drawer: DrawerMenu().build(context),
            body: buildBody(context),
          );
  }

  _getIcon(name) {
    switch (name) {
      case 'G':
        return 'assets/icons/g.png';
      case 'PG':
        return 'assets/icons/pg.png';
      case 'PG-13':
        return 'assets/icons/pg-13.png';
      case 'R':
        return 'assets/icons/r.png';
      case 'Unrated':
        return 'assets/icons/Unrated.png';
      default:
        return 'assets/icons/NotRated.png';
    }
  }
  _buildInfo() {
    var provider = Provider.of<ThemeProvider>(context);
    List<String> listOfGanres = film.genre.split(",");
    List<Widget> listOfWidget = [];
    listOfGanres.forEach((element) {
      listOfWidget.add(
        Container(
          child: Text(
            "${element}",
            style: GoogleFonts.caveat(
              fontSize: 18.0,
              color: provider.currentFontColor,
            ),
          ),
        ),
      );
    });
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: provider.currentSecondaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildHeader("${film.title}"),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Icon(
                            Icons.today,
                            color: provider.currentFontColor,
                          ),
                          Text(
                            " ${film.year}",
                            style: GoogleFonts.caveat(
                              fontSize: 16.0,
                              color: provider.currentFontColor,
                            ),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Icon(
                            Icons.hourglass_empty,
                            color: provider.currentFontColor,
                          ),
                          Text(
                            " ${film.runtime}",
                            style: GoogleFonts.caveat(
                              fontSize: 16.0,
                              color: provider.currentFontColor,
                            ),
                          ),
                        ]),
                        Image.asset(
                          _getIcon(film.rated),
                          color: provider.currentFontColor,
                          height: 30,
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Image.asset('assets/icons/Genre.png',
                            color: provider.currentFontColor, height: 30)),
                    Text(
                      "Genre",
                      style: GoogleFonts.caveat(
                        fontSize: 20.0,
                        color: provider.currentMainColor,
                      ),
                    )
                  ],
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: listOfWidget,
                ),
                Container(),
              ],
            )),
      ),
    );
  }
  _buildRaitings() {
    var provider = Provider.of<ThemeProvider>(context);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: provider.currentBackgroundColor,
          ),
          child: film.raiting?.isNotEmpty ?? false
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: provider.currentSecondaryColor,
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: _buildHeader('Raitings'),
                    ),
                    film.raiting?.isNotEmpty ?? false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: getRaiting(film),
                          )
                        : Container(),
                    film.raiting?.isNotEmpty ?? false
                        ? Text(
                            'IMDB Votes : ${film.imdbV}',
                            style: GoogleFonts.caveat(
                              color: provider.currentFontColor,
                              fontSize: 18,
                            ),
                          )
                        : Container(),
                  ]))
              : Container(),
        ));
  }
  _buildWebLinkBlock() {
    var provider = Provider.of<ThemeProvider>(context);
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: provider.currentSecondaryColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: provider.currentSecondaryColor,
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: _buildHeader('${film.title} in Web'),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getWikiLinks(film),
                  getIMDB(film),
                ]),
          ]),
        ),
      ),
    );
  }
  _buildCreatorBlock() {
    var provider = Provider.of<ThemeProvider>(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child:Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: provider.currentSecondaryColor,
        ),
        child: Column(
            children: [
          _buildHeader("Director"),
              Text(
                film.director,
                style: GoogleFonts.caveat(
                  fontSize: 16.0,
                  color: provider.currentFontColor,
                ),
              )
        ]),
      ),
    ),);
  }

  buildBody(context) {
    return SingleChildScrollView(
        controller: scrollController,
        child: Stack(children: [
          IntrinsicHeight(
            child: Column(children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                child: Image.network(film.posters),
              ),
              _buildInfo(),
              _buildCreatorBlock(),
              film?.raiting != null && film?.raiting?.isNotEmpty
                  ? _buildRaitings()
                  : Container(),
             _buildWebLinkBlock(),
              //  Container( child: getDesc(movie),)
            ]),
          ),
        ]));
  }

  List<Widget> getRaiting(movie) {
    var provider = Provider.of<ThemeProvider>(context);
    List<Widget> rait = [];
    if (movie.raiting != null) {
      for (var i = 0; i < movie.raiting.length; i++) {
        String name = movie.raiting[i]['Source'];
        switch (name) {
          case 'Internet Movie Database':
            rait.add(Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/imdb.png',
                  color: provider.currentFontColor,
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    movie.raiting[i]["Value"],
                    style: GoogleFonts.caveat(
                        color: provider.currentFontColor),
                  ),
                )
              ],
            ));
            break;
          case 'Rotten Tomatoes':
            rait.add(Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/RT.png',
                  color: provider.currentFontColor,
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    movie.raiting[i]["Value"],
                    style: GoogleFonts.caveat(
                        color: provider.currentFontColor),
                  ),
                ),
              ],
            ));
            break;
          case 'Metacritic':
            rait.add(Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/MT.png',
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                  child: Text(
                    movie.raiting[i]["Value"],
                    style: GoogleFonts.caveat(
                        color: provider.currentFontColor),
                  ),
                ),
              ],
            ));
            break;
        }
      }
      return rait;
    } else
      return [Container()];
  }

  getIMDB(movie) {
    var provider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: () {
        launch('https://www.imdb.com/title/${movie.imdbid}');
      },
      child: Image.asset(
        'assets/icons/imdb.png',
        color: provider.currentFontColor,
        height: 35,
      ),
    );
  }

  getWikiLinks(movie) {
    var provider = Provider.of<ThemeProvider>(context);
    return FutureBuilder<WikipediaPage>(
        future: getWiki(movie.title),
        builder: (BuildContext context, AsyncSnapshot<WikipediaPage> snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                launch(snapshot.data.url);
              },
              child: Image.asset(
                'assets/icons/wiki.png',
                color: provider.currentFontColor,
                height: 30,
              ),
            );
          }
          return Container();
        });
  }

  Future<WikipediaPage> getWiki(String movie) async {
    var wikipediaPage = await wiki.page('$movie ');
    if (wikipediaPage.content.startsWith('Redirect to:')) {
      var array = wikipediaPage.content.split('This page is a redirect');
      array = array[0].split('Redirect to:');
      wikipediaPage = await wiki.page('${array[1]}');
    }
    return wikipediaPage;
  }
}
