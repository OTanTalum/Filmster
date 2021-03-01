import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieCard extends StatelessWidget {

  MovieCard(this.film, this.scaffoldKey);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final SearchResults film;

  UserProvider userProvider;
  ThemeProvider themeProvider;
  bool isFavorite;
  bool isMarked;
  bool isWatched;


  init() {
    if (userProvider.isMovie) {
      isFavorite = userProvider.favoriteMovieIds.contains(film.id);
      isMarked = userProvider.markedMovieListIds.contains(film.id);
      isWatched = userProvider.watchedMovieListIds.contains(film.id);
    } else {
      isFavorite = userProvider.favoriteTVIds.contains(film.id);
      isMarked = userProvider.markedTVListIds.contains(film.id);
      isWatched = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    init();
    List<Widget> widgetListOfGenres = [];
    if (film.ganres != null && film.ganres.isNotEmpty) {
      film.ganres.forEach((element) {
        widgetListOfGenres.add(buildGenres(element, context));
      });
    }
    return Container(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  FilmDetailPage(id: film.id.toString())));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.3,
              color: themeProvider.currentSecondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    film.poster != null
                        ? Image.network(
                      "${Api().imageBannerAPI}${film.poster}",
                      fit: BoxFit.fill,
                      height: 200,
                      width: 130,
                    )
                        : Container(
                        height: 139,
                        width: 100,
                        child: Icon(
                          Icons.do_not_disturb_on,
                          size: 100.0,
                          color: themeProvider.currentAcidColor,
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.47,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(children: [
                              film.title!=null?
                              Expanded(
                                child: Text(
                                  film.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: "AmaticSC",
                                    fontSize: 27,
                                    color: themeProvider.currentMainColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ):Container(),
                            ]),
                            Expanded(
                                child: Text(
                                  film.release ?? "-",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "AmaticSC",
                                    color: themeProvider.currentFontColor,
                                  ),
                                )),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.46,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 6,
                                children: widgetListOfGenres,
                              ),
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                              children: <Widget>[
                                _buildVoteBlock(Icons.trending_up, film
                                    .popularity.toString(), context),
                                _buildVoteBlock(Icons.grade, film.voteAverage, context),
                              ],
                            )
                          ]),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            isMarked
                                ? await userProvider.removeFromMarkedList(film, scaffoldKey)
                                : await userProvider.mark(film, scaffoldKey);
                          },
                          icon: Icon(
                           isMarked
                                ? Icons.turned_in
                                : Icons.turned_in_not,
                            color: !isMarked
                                ? Colors.white
                                : themeProvider.currentMainColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await userProvider.markAsFavorite(
                                film, isFavorite, scaffoldKey);
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            isWatched
                            ? await userProvider.removeFromWatched(film, scaffoldKey)
                            : await userProvider.markAsWatched(film, scaffoldKey);
                          },
                          icon: Icon(
                           isWatched
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:isWatched
                                ? themeProvider.currentMainColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ]),
            )),
      ),
    );
  }

  buildGenres(id, context) {
    if(Provider.of<SettingsProvider>(context).getOneGenre(context, id)!=null)
    return Text(
      Provider.of<SettingsProvider>(context).getOneGenre(context, id),
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 25,
        color: themeProvider.currentFontColor,
      ),
    );
    else return Container();
  }

  _buildVoteBlock(icon, text, context) {
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
                fontSize: 25,
                //  fontWeight: FontWeight.bold,
                color: themeProvider.currentFontColor,
              )))
    ]);
  }
}