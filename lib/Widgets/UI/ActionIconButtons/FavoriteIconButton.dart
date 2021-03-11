import 'package:filmster/model/search.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteIconButton extends StatelessWidget {
  final SearchResults? movie;
  final GlobalKey? keyState;

  FavoriteIconButton({this.movie, this.keyState});

  late LibraryProvider libraryProvider;
  late bool isFavorite;

  @override
  Widget build(BuildContext context) {
    libraryProvider =  Provider.of<LibraryProvider>(context);
    libraryProvider.favoriteMovieListIds.contains(movie!.id);

    isFavorite = libraryProvider.isMovie
        ? libraryProvider.favoriteMovieListIds.contains(movie!.id)
        : libraryProvider.favoriteTVIds.contains(movie!.id);

    return IconButton(
      onPressed: () async {
        await libraryProvider.markAsFavorite(movie!, isFavorite, keyState);
        libraryProvider.notify();
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
