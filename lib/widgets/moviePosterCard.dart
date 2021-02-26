import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviePosterCard extends StatelessWidget {
  MoviePosterCard({
    this.movie,
  });

  final SearchResults movie;
  UserProvider userProvider;
  bool isFavorite;
  bool isMarked;
  bool isWatched;

  init() {
    if (userProvider.isMovie) {
      isFavorite = userProvider.favoriteMovieIds.contains(movie.id);
      isMarked = userProvider.markedMovieListIds.contains(movie.id);
      isWatched = userProvider.watchedMovieListIds.contains(movie.id);
    } else {
      isFavorite = userProvider.favoriteTVIds.contains(movie.id);
      isMarked = userProvider.markedTVListIds.contains(movie.id);
      isWatched = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    init();
    return Stack(children: [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FilmDetailPage(
                    id: movie.id.toString(),
                  )));
        },
        child: movie.poster != null
            ? Image.network(
                "${Api().imageBannerAPI}${movie.poster}",
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
                IconButton(
                  onPressed: () async {
                    isMarked
                        ? await userProvider.removeFromMarkedList(movie)
                        : await userProvider.mark(movie);
                    userProvider.notify();
                  },
                  icon: Icon(
                    isMarked ? Icons.turned_in : Icons.turned_in_not,
                    color: !isMarked ? Colors.white : Colors.lightGreen,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await userProvider.markAsFavorite(movie, isFavorite);
                    userProvider.notify();
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    isWatched
                        ? await userProvider.removeFromWatched(movie)
                        : await userProvider.markAsWatched(movie);
                    userProvider.notify();
                  },
                  icon: Icon(
                    isWatched ? Icons.visibility : Icons.visibility_off,
                    color: isWatched
                        ? Provider.of<ThemeProvider>(context).currentMainColor
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
