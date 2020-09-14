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
    return Container(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  FilmDetailPage(id: film.id.toString(), type: "movie")));
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
                              ),
                            ]),
                            film.isAdult
                                ? Text("18+",
                                style: TextStyle(
                                  fontFamily: "AmaticSC",
                                  fontSize: 30,
                                  color: provider.currentAcidColor,
                                  fontWeight: FontWeight.w700,
                                ))
                                : Container(),
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
                            await userProfile.markAsFavorite(film.id,
                                !userProfile.favoriteIds.contains(film.id));
                          },
                          icon: Icon(
                            userProfile.favoriteIds.contains(film.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: userProfile.favoriteIds.contains(film.id)
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            await userProfile.markAsWatch(film.id, !userProfile.watchListIds.contains(film.id));
                          },
                          icon: Icon(
                            userProfile.watchListIds.contains(film.id)
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: !userProfile.watchListIds.contains(film.id)
                                ? Colors.white
                                : Colors.lightGreen,
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
    return Text(
      Provider.of<SettingsProvider>(context).movieMapOfGanres[id],
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 25,
        //  fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).currentFontColor,
      ),
    );
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