import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dartpedia/dartpedia.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/widgets/movieBanner.dart';
import 'package:filmster/widgets/progressBarWidget.dart';
import 'dart:async';

import 'package:filmster/widgets/drawer.dart';

import 'package:filmster/model/film.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FilmDetailPage extends StatefulWidget {
  final String id;
  final String type;

  FilmDetailPage({
    Key key,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  FilmDetailPageState createState() => new FilmDetailPageState();
}

class FilmDetailPageState extends State<FilmDetailPage> {
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
    setState(() {
      isLoading = true;
    });
    film = await Api().getFilmDetail(widget.id, widget.type);
    setState(() {
      isLoading = false;
    });
  }

  _buildHeader(String title, double size) {
    var provider = Provider.of<ThemeProvider>(context);
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "MPLUSRounded1c",
          fontWeight: FontWeight.w700,
          fontSize: size,
          color: provider.currentMainColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    var userProfile = Provider.of<UserProvider>(context);
    List favoriteId =
    // userProfile.currentType == "tv"
    //     ? userProfile.favoriteTVIds
    //    :
    userProfile.favoriteMovieIds;
    List markedId =
    // userProfile.currentType == "tv"
    //     ? userProfile.markedTVListIds
    //     :
    userProfile.markedMovieListIds;
    List watchedId = userProfile.watchedListIds;
    return film == null
        ? Container(
            color: provider.currentBackgroundColor,
            child: Center(
              child: CircularProgressIndicator(
                  valueColor:AlwaysStoppedAnimation(
                      Provider.of<ThemeProvider>(context).currentMainColor
                  )
              ),
            ),
          )
        : Scaffold(
            backgroundColor: provider.currentBackgroundColor,
            appBar: AppBar(
              title: Text(
                film.title==null&&film.originalTitle!=null
                    ? "${film.title} 18+"
                  : "${film.title} ",
                style: TextStyle(
                  fontFamily: "AmaticSC",
                  fontSize: 33,
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
                            current: scrollController.offset?.toDouble() ?? 1.0,
                            allSize: scrollController.position?.maxScrollExtent
                                    ?.toDouble() ??
                                200,
                            colors: provider.currentMainColor,
                            height: 4,
                            width: MediaQuery.of(context).size.width,
                            radius: 7.0)),
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    await userProfile.mark(
                        film.id, !markedId.contains(film.id));
                  },
                  icon: Icon(
                    markedId.contains(film.id)
                        ? Icons.turned_in
                        : Icons.turned_in_not,
                    color: !markedId.contains(film.id)
                        ? Colors.white
                        : Provider.of<ThemeProvider>(context).currentMainColor,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await userProfile.markAsFavorite(
                        film.id, !favoriteId.contains(film.id));
                  },
                  icon: Icon(
                    favoriteId.contains(film.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoriteId.contains(film.id)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await userProfile.markAsWatched(
                        film.id, !watchedId.contains(film.id));
                  },
                  icon: Icon(
                    watchedId.contains(film.id)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: watchedId.contains(film.id)
                        ? Provider.of<ThemeProvider>(context).currentMainColor
                        : Colors.white,
                  ),
                ),
              ],
            ),
            //drawer: DrawerMenu().build(context),
            body: buildBody(context),
          );
  }

  buildGenres(id) {
    return Text(
      widget.type=="movie"
          ? Provider.of<SettingsProvider>(context).movieMapOfGanres[id]
          : Provider.of<SettingsProvider>(context).tvMapOfGanres[id],
      style: TextStyle(
        fontFamily: "MPLUSRounded1c",
        fontSize: 20,
          fontWeight: FontWeight.w300,
        color: Provider.of<ThemeProvider>(context).currentFontColor,
      ),
    );
  }

  _buildVoteBlock(icon, text) {
    var provider = Provider.of<ThemeProvider>(context);
    return Row(children: [
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: provider.currentFontColor,
              )))
    ]);
  }

  _buildInfo() {
    var provider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
              colors: [
                provider.currentBackgroundColor,
                provider.currentSecondaryColor
              ],
              stops: [0.4, 1],
            )),
        child: Row(children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.4),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 22, top: 22),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Icon(
                          Icons.today,
                          color: provider.currentFontColor,
                        ),
                        Text(
                          " ${film.release}",
                          style: TextStyle(
                            fontFamily: "AmaticSC",
                            fontSize: 20.0,
                            color: provider.currentFontColor,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.hourglass_empty,
                          color: provider.currentFontColor,
                        ),
                        Text(
                          " ${film.runtime}",
                          style: TextStyle(
                            fontFamily: "AmaticSC",
                            fontSize: 20.0,
                            color: provider.currentFontColor,
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          _buildVoteBlock(
                              Icons.trending_up, film.popularity.toString()),
                          SizedBox(
                            width: 15,
                          ),
                          _buildVoteBlock(Icons.grade, film.voteAverage),
                        ],
                      )
                    ],
                  )),
              _buildDevider(),
            ],
          ),
        ]),
      ),
    );
  }

  _buildWebLinkBlock() {
    var provider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(25)),
          color: provider.currentSecondaryColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: provider.currentSecondaryColor,
          ),
          child: Column(
              children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: _buildHeader('${film.title} in Web', 25)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getWikiLinks(film),
                  getIMDB(film),
                ]),
            film.homepage != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: GestureDetector(
                      onTap: () => {},
                      child: Text(
                        film.homepage,
                        style: TextStyle(
                          fontFamily: "MPLUSRounded1c",
                          fontSize: 20.0,
                          color: provider.currentFontColor,
                        ),
                      ),
                    ),
                  )
                : Container()
          ]),
        ),
      ),
    );
  }

  _buildCreatorBlock() {
    var provider = Provider.of<ThemeProvider>(context);
    List<Widget> list = [];
    if (film.ganres != null && film.ganres.isNotEmpty) {
      film.ganres.forEach((element) {
          list.add(buildGenres(element["id"]));
      });
    }
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: provider.currentSecondaryColor,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("${film.title}", 30),
            film.title != film.originalTitle
                ? _buildHeader("${film.originalTitle}", 22)
                : Container(),
            film.tagline != null && film.tagline.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      "\"${film.tagline}\"",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: 20.0,
                        color: provider.currentFontColor,
                      ),
                    ),
                  )
                : Container(),
            _buildDevider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 6,
                children: list,
              ),
            ),
            _buildDevider(),
            film.overview != null && film.overview.isNotEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "\t${film.overview}",
                      style: TextStyle(
                        fontFamily: "MPLUSRounded1c",
                        fontWeight: FontWeight.w300,
                        fontSize: 17.0,
                        color: provider.currentFontColor,
                      ),
                    ),
                  )
                : Container(),
            film.overview != null && film.overview.isNotEmpty
                ? _buildDevider()
                : Container(),
            SizedBox(
              height: 10,
            )
          ]),
    );
  }

  _buildDevider() {
    var provider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: provider.currentBackgroundColor,
        height: 1,
        thickness: 1,
        indent: 10,
        endIndent: 10,
      ),
    );
  }

  _buildProduction() {
    var provider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
      ),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: provider.currentSecondaryColor,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Production", 26),
            Row(
              children: <Widget>[
                film.companies.isNotEmpty&& film.companies[0].logo != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Image.network(
                          "${Api().imageBannerAPI}${film.companies[0].logo}",
                          width: 100,
                        ),
                      )
                    : Container(),
                Expanded(
                    child: Column(
                  children: <Widget>[
                      _buildDevider(),
                    buildOneField(film.status, "Status:"),
                    film.status != null && film.status != 0
                        ? _buildDevider()
                        : Container(),
                    buildOneField(film.budget, "Budget:"),
                      film.budget != null && film.budget != 0
                          ? _buildDevider()
                          : Container(),
                    buildOneField(film.revenue, "Revenue:"),
                    film.revenue != null && film.revenue != 0
                        ? _buildDevider()
                        : Container(),
                  ],
                ),
                ),
              ],
            ),
            film.companies.isNotEmpty&&film.companies[0]!= null
                ? buildOneField(film.companies[0].name, "Company:")
                : Container(),
            film.companies.isNotEmpty&& film.companies[0] != null
                ? _buildDevider()
                : Container(),
           film.countrys.isNotEmpty
                ? buildOneField(film?.countrys[0].name, "Country:")
                : Container(),
           film.countrys.isNotEmpty && film?.countrys[0] != null
                ? _buildDevider()
                : Container(),
            SizedBox(
              height: 10,
            )
          ]),
    );
  }

  buildOneField(field, String fieldName) {
    var provider = Provider.of<ThemeProvider>(context);
    return field != null && field != 0
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fieldName,
                    style: TextStyle(
                      fontFamily: "MPLUSRounded1c",
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: provider.currentFontColor,
                    ),
                  ),
                  Text(
                    field.toString(),
                    style: TextStyle(
                      fontFamily: "MPLUSRounded1c",
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: provider.currentFontColor,
                    ),
                  ),
                ]),
          )
        : Container();
  }

  buildBody(context) {
    return SingleChildScrollView(
        controller: scrollController,
        child: Stack(children: [
          Column(children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                //child: Image.network("${Api().imageBannerAPI}${film.poster}",),
                child: film.backdrop!=null
                    ? MovieBanner("${Api().imageBannerAPI}${film.backdrop}")
                    : MovieBanner("${Api().imageBannerAPI}${film.poster}")
            ),
            _buildInfo(),
            _buildCreatorBlock(),
            SizedBox(
              height: 20,
            ),
            _buildProduction(),
            _buildBannerField(),
            _buildWebLinkBlock(),
            //  Container( child: getDesc(movie),)
          ]),
          Positioned(
            left: 15,
            top: 120,
            child: Container(
              child: Image.network(
                "${Api().imageBannerAPI}${film.poster}",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
          ),
        ]));
  }

  _buildBannerField(){
    return AdmobBanner(
      adUnitId: AddMobClass().getMovieDetailBannerAdUnitId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if(event==AdmobAdEvent.opened) {
          print('Admob banner opened!');
          FirebaseAnalytics().logEvent(name: 'adMobMovieDetailClick');
        }
      },
      onBannerCreated: (AdmobBannerController controller) {
      },
    );
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
                    style: TextStyle(
                        fontFamily: "MPLUSRounded1c",
                        fontWeight: FontWeight.w300,
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
                    style: TextStyle(
                        fontFamily: "MPLUSRounded1c",
                        fontWeight: FontWeight.w300,
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
                    style: TextStyle(
                        fontFamily: "MPLUSRounded1c",
                        fontWeight: FontWeight.w300,
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

  getWikiLinks(Film movie) {
    var provider = Provider.of<ThemeProvider>(context);
    return FutureBuilder<WikipediaPage>(
        future: getWiki(movie.originalTitle),
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
