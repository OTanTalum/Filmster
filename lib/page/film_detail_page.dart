
import 'package:filmster/Widgets/Pages/FullScreenImagePage.dart';
import 'package:filmster/Widgets/UI/ActionIconButtons/FavoriteIconButton.dart';
import 'package:filmster/Widgets/UI/ActionIconButtons/MarkedIconButton.dart';
import 'package:filmster/Widgets/UI/ActionIconButtons/WatchedIconButton.dart';
import 'package:filmster/Widgets/UI/CardList.dart';
import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/Widgets/UI/movieBanner.dart';
import 'package:filmster/Widgets/UI/progressBarWidget.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/Poster.dart';
import 'package:filmster/providers/movieProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'dart:async';
import 'package:filmster/model/film.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FilmDetailPage extends StatefulWidget {
  final String? id;

  FilmDetailPage({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  FilmDetailPageState createState() => new FilmDetailPageState();
}

class FilmDetailPageState extends State<FilmDetailPage> {
  ScrollController scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Poster>? images = [];
  List<Widget> posterList = [];
  late ThemeProvider themeProvider;
  late LibraryProvider libraryProvider;
  late MovieProvider movieProvider;
  Film? film;
  bool isLoading = true;

  @override
  void initState() {
    scrollController.addListener(() {
      setState(() {});
    });
    super.initState();
    Future.microtask(() async {
      var response = libraryProvider.isMovie
          ? await Api().getFilmDetail(widget.id)
          : await Api().getTvDetail(widget.id);
      if (hasError(response)) {
        CustomSnackBar()
            .showSnackBar(title: response.massage, state: _scaffoldKey);
        isLoading = false;
      } else {
        film = response;
        var imageResponse = libraryProvider.isMovie
            ? await Api().getFilmImages(widget.id)
            : await Api().getTvImages(widget.id);
        if (hasError(imageResponse)) {
          CustomSnackBar()
              .showSnackBar(title: response.massage, state: _scaffoldKey);
        } else {
          images = imageResponse.backDropsList;
          posterList = [];
          images!.forEach((Poster element) async {
            posterList.add(
                imageLoader('${Api().imageGalleryAPI}${element.filePath}'));
          });
        }
      }
      libraryProvider.isMovie
          ? await movieProvider.getSimilarMovie(widget.id, _scaffoldKey)
          : await movieProvider.getSimilarTv(widget.id, _scaffoldKey);
      libraryProvider.isMovie
          ? await movieProvider.getRecommendedMovie(widget.id, _scaffoldKey)
          : await movieProvider.getRecommendedTv(widget.id, _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    });
  }

  hasError(response) {
    return response.runtimeType == BasicResponse();
  }

  double tryGetFullScrolSize() {
    try {
      return scrollController.position.maxScrollExtent.toDouble();
    } catch (e) {
      print(e);
      return 100.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _buildHeader(String title, double size) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Cuprum",
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          fontSize: size,
          color: themeProvider.currentHeaderColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    libraryProvider = Provider.of<LibraryProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    movieProvider = Provider.of<MovieProvider>(context);
    return film == null
        ? Container(
            color: themeProvider.currentBackgroundColor,
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      Provider.of<ThemeProvider>(context).currentMainColor)),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: themeProvider.currentBackgroundColor,
            appBar: AppBar(
              title: Text(
                film!.title == null && film!.originalTitle != null
                    ? "${film!.title} 18+"
                    : "${film!.title} ",
                style: TextStyle(
                  fontFamily: "AmaticSC",
                  fontSize: 33,
                  color: themeProvider.currentFontColor,
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
                            current: scrollController.offset.toDouble(),
                            allSize: tryGetFullScrolSize(),
                            colors: themeProvider.currentMainColor,
                            height: 4,
                            width: MediaQuery.of(context).size.width,
                            radius: 7.0)),
                  ),
                ),
              ),
              actions: <Widget>[
                MarkedIconButton(
                    movie: film!.toSearchResults(), keyState: _scaffoldKey),
                FavoriteIconButton(
                    movie: film!.toSearchResults(), keyState: _scaffoldKey),
                WatchedIconButton(
                    movie: film!.toSearchResults(), keyState: _scaffoldKey)
              ],
            ),
            //drawer: DrawerMenu().build(context),
            body: buildBody(context),
          );
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
                child: film!.backdrop != null
                    ? MovieBanner("${Api().imageBannerAPI}${film!.backdrop}")
                    : MovieBanner("${Api().imageBannerAPI}${film!.poster}")),
            _buildInfo(),
            _buildDescriptionBlock(),
            _buildMovieDetail(),
            if (posterList != null && posterList.isNotEmpty) _buildGallery(),
            AddMobClass().buildAdMobBanner(),
            SizedBox(
              height: 10,
            ),
            if(movieProvider.similarList.isNotEmpty)CardList(movieProvider.similarList, "Similar Movie", film!.id!, _scaffoldKey),
            if(movieProvider.recommendedList.isNotEmpty) CardList(movieProvider.recommendedList, "Recommended Movie", film!.id!, _scaffoldKey),
            //_buildWebLinkBlock(),
            //Container( child: getDesc(movie),)
          ]),
          Positioned(
            left: 15,
            top: 120,
            child: Container(
              child: Image.network(
                "${Api().imageBannerAPI}${film!.poster}",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
          ),
        ]));
  }
  
  _buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
              colors: [
                themeProvider.currentBackgroundColor!,
                themeProvider.currentSecondaryColor!
              ],
              stops: [0.4, 1],
            )),
        child: Row(children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.4),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 22, top: 10),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildVoteBlock(Icons.person, film!.voteCount),
                          SizedBox(
                            width: 30,
                          ),
                          _buildVoteBlock(Icons.grade, film!.voteAverage),
                        ],
                      ),
                       _buildVoteBlock(Icons.trending_up, film!.popularity.toString()),
                    ],
                  )),
              _buildDevider(),
            ],
          ),
        ]),
      ),
    );
  }

  _buildDescriptionBlock() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: themeProvider.currentSecondaryColor,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: _buildHeader("${film!.title}", 30),
            ),
            film!.title != film!.originalTitle
                ? Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 16),
                    child: _buildHeader("${film!.originalTitle}", 27))
                : Container(),
            film!.tagline != null && film!.tagline!.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      "\"${film!.tagline}\"",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: 20.0,
                        color: themeProvider.currentFontColor,
                      ),
                    ),
                  )
                : Container(),
            _buildDevider(),
            film!.overview != null && film!.overview!.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "\t${film!.overview}",
                      style: TextStyle(
                        fontFamily: "Cuprum",
                        fontWeight: FontWeight.w300,
                        height: 1.1,
                        wordSpacing: 1,
                        letterSpacing: 0.5,
                        fontSize: 21.0,
                        color: themeProvider.currentFontColor,
                      ),
                    ),
                  )
                : Container(),
            film!.overview != null && film!.overview!.isNotEmpty
                ? _buildDevider()
                : Container(),
            SizedBox(
              height: 10,
            )
          ]),
    );
  }

  _buildMovieDetail() {
    String genres = '';
    if (film!.ganres != null && film!.ganres!.isNotEmpty) {
      film!.ganres!.forEach((element) {
        genres += Provider.of<SettingsProvider>(context)
            .getOneGenre(context, element["id"])!;
        genres += ", ";
      });
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: themeProvider.currentSecondaryColor,
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _buildHeader("Movie Detail", 30)),
            _buildDevider(),
            buildOneField(genres, "${AppLocalizations().translate(context, WordKeys.genre)!}:"),
            Row(
              children: <Widget>[
                film!.companies!.isNotEmpty && film!.companies![0].logo != null
                    ? Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.network(
                    "${Api().imageBannerAPI}${film!.companies![0].logo}",
                    width: 100,
                  ),
                )
                    : Container(),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      buildOneField(film!.companies![0].name, "Company:"),
                      buildOneField(film?.countrys![0].name, "Country:"),
                    ],
                  ),
                ),
              ],
            ),
            buildOneField(film!.status, "Status:"),
            buildOneField(film!.budget, "Budget:"),
            buildOneField(film!.revenue, "Revenue:"),
            buildOneField(film!.release, "Release Date:"),
            buildOneField("${film!.runtime} m", "Runtime:"),
          ],
        ),
      ),
    );
  }

  _buildGallery() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: posterList,
      ),
    );
  }

  buildGenres(BuildContext context, id) {
    return Text(
      Provider.of<SettingsProvider>(context).getOneGenre(context, id)!,
      style: TextStyle(
        fontFamily: "Cuprum",
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: themeProvider.currentFontColor,
      ),
    );
  }

  _buildVoteBlock(icon, text) {
    return Row(children: [
      Icon(
        icon,
        color: themeProvider.currentFontColor,
      ),
      Container(
          padding: EdgeInsets.only(left: 5),
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "AmaticSC",
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: themeProvider.currentFontColor,
              )))
    ]);
  }

  _buildWebLinkBlock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(25)),
          color: themeProvider.currentSecondaryColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: themeProvider.currentSecondaryColor,
          ),
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: _buildHeader('${film!.title} in Web', 25)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // getWikiLinks(film),
                  getIMDB(film),
                ]),
            film!.homepage != null
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: GestureDetector(
                onTap: () => {},
                child: Text(
                  film!.homepage!,
                  style: TextStyle(
                    fontFamily: "MPLUSRounded1c",
                    fontSize: 20.0,
                    color: themeProvider.currentFontColor,
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

  buildOneField(field, String fieldName) {
    return field != null && field != 0
        ?   Column(children: [
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      fieldName,
                      style: TextStyle(
                        fontFamily: "Cuprum",
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: themeProvider.currentFontColor,
                      ),
                    ),
                    if(fieldName=="${AppLocalizations().translate(context, WordKeys.genre)!}:")
                      SizedBox(width: 100,),
                    Expanded(
                      child: Text(
                        field.toString(),
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Cuprum",
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: themeProvider.currentFontColor,
                        ),
                      ),
                    ),
                  ]),
                ),
                _buildDevider()
              ])
        : Container();
  }


  imageLoader(String link) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FullScreenImagePage(link: link))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Image.network(link),
      ),
    );
  }

  List<Widget> getRaiting(movie) {
    List<Widget> rait = [];
    if (movie.raiting != null) {
      for (var i = 0; i < movie.raiting.length; i++) {
        String? name = movie.raiting[i]['Source'];
        switch (name) {
          case 'Internet Movie Database':
            rait.add(Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/imdb.png',
                  color: themeProvider.currentFontColor,
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    movie.raiting[i]["Value"],
                    style: TextStyle(
                        fontFamily: "MPLUSRounded1c",
                        fontWeight: FontWeight.w300,
                        color: themeProvider.currentFontColor),
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
                  color: themeProvider.currentFontColor,
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    movie.raiting[i]["Value"],
                    style: TextStyle(
                        fontFamily: "MPLUSRounded1c",
                        fontWeight: FontWeight.w300,
                        color: themeProvider.currentFontColor),
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
                        color: themeProvider.currentFontColor),
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
    return InkWell(
      onTap: () {
        launch('https://www.imdb.com/title/${movie.imdbid}');
      },
      child: Image.asset(
        'assets/icons/imdb.png',
        color: themeProvider.currentFontColor,
        height: 35,
      ),
    );
  }

  _buildDevider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: themeProvider.currentBackgroundColor,
        height: 1,
        thickness: 1,
        indent: 10,
        endIndent: 10,
      ),
    );
  }

// getWikiLinks(Film movie) {
//   var provider = Provider.of<ThemeProvider>(context);
//   return FutureBuilder<WikipediaPage>(
//       future: getWiki(movie.originalTitle),
//       builder: (BuildContext context, AsyncSnapshot<WikipediaPage> snapshot) {
//         if (snapshot.hasData) {
//           return InkWell(
//             onTap: () {
//               launch(snapshot.data.url);
//             },
//             child: Image.asset(
//               'assets/icons/wiki.png',
//               color: provider.currentFontColor,
//               height: 30,
//             ),
//           );
//         }
//         return Container();
//       });
// }

// Future<WikipediaPage> getWiki(String movie) async {
//   var wikipediaPage = await wiki.page('$movie ');
//   if (wikipediaPage.content.startsWith('Redirect to:')) {
//     var array = wikipediaPage.content.split('This page is a redirect');
//     array = array[0].split('Redirect to:');
//     wikipediaPage = await wiki.page('${array[1]}');
//   }
//   return wikipediaPage;
// }
}