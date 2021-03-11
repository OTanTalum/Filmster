import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ActionIconButtons/FavoriteIconButton.dart';
import 'ActionIconButtons/MarkedIconButton.dart';
import 'ActionIconButtons/WatchedIconButton.dart';

class MoviePosterCard extends StatelessWidget {
  MoviePosterCard({
    this.movie, this.scaffoldKey
  });

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final SearchResults? movie;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                    id: movie!.id.toString(),
                  )));
        },
        child: movie!.poster != null
            ?CachedNetworkImage(
        imageUrl: "${Api().imageBannerAPI}${movie!.poster}",
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5 * (3 / 2),
        )
            : Container(),
      ),
      Positioned(
        bottom: 0,
        child: Opacity(
          opacity: 0.7,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blueGrey[900],
            height: 50,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MarkedIconButton(movie: movie, keyState:scaffoldKey),
                FavoriteIconButton(movie: movie, keyState:scaffoldKey),
                WatchedIconButton(movie: movie, keyState:scaffoldKey)
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
