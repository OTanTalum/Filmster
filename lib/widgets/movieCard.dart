import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieCard extends StatelessWidget {

  final SearchResults film;

  MovieCard(this.film);

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProvider>(context);
    var provider = Provider.of<ThemeProvider>(context);
    List<Widget> list = [];
    if (film.ganres != null && film.ganres.isNotEmpty) {
      film.ganres.forEach((element) {
        list.add(buildGenres(element, context));
      });
    }
    List favoriteId = userProfile.currentType == "tv"
        ? userProfile.favoriteTVIds
        : userProfile.favoriteMovieIds;
    List markedId = userProfile.currentType == "tv"
        ? userProfile.markedTVListIds
        : userProfile.markedMovieListIds;
    List watchedId = userProfile.watchedMovieListIds;
    return Container(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  FilmDetailPage(id: film.id.toString(), type: userProfile.currentType)));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.26,
              color: provider.currentSecondaryColor,
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
                          color: provider.currentAcidColor,
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
                                    color: provider.currentMainColor,
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
                                    color: provider.currentFontColor,
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
                                children: list,
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
                  ]),
            )),
      ),
    );
  }

  buildGenres(id, context) {
    var userProfile = Provider.of<UserProvider>(context);
    var text = userProfile.currentType!="tv"
        ? Provider.of<SettingsProvider>(context).movieMapOfGanres[id]
        : Provider.of<SettingsProvider>(context).tvMapOfGanres[id];
    if(text!=null)
    return Text(
      text,
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 25,
        //  fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).currentFontColor,
      ),
    );
    else return Container();
  }

  _buildVoteBlock(icon, text, context) {
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
                fontSize: 25,
                //  fontWeight: FontWeight.bold,
                color: provider.currentFontColor,
              )))
    ]);
  }
}