import 'package:filmster/model/search.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteIconButton extends StatelessWidget {
  final SearchResults movie;
  final GlobalKey keyState;

  FavoriteIconButton({this.movie, this.keyState});

  UserProvider userProvider;
  bool isFavorite;

  @override
  Widget build(BuildContext context) {
    userProvider =  Provider.of<UserProvider>(context);
    userProvider.favoriteMovieListIds.contains(movie.id);

    isFavorite = userProvider.isMovie
        ? userProvider.favoriteMovieListIds.contains(movie.id)
        : userProvider.favoriteTVIds.contains(movie.id);

    return IconButton(
      onPressed: () async {
        await userProvider.markAsFavorite(movie, isFavorite, keyState);
        userProvider.notify();
      },
      icon: Icon(
        isFavorite
            ? Icons.favorite
            : Icons.favorite_border,
        color: isFavorite
            ? Colors.red
            : Colors.white,
      ),
    );
  }
}
