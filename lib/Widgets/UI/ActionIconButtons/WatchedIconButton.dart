import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomSnackBar.dart';

class WatchedIconButton extends StatelessWidget {
  final SearchResults? movie;
  final GlobalKey<ScaffoldState>? keyState;

  WatchedIconButton({this.movie, this.keyState});

  late LibraryProvider libraryProvider;
  late bool isWatched;

  @override
  Widget build(BuildContext context) {
    libraryProvider =  Provider.of<LibraryProvider>(context);
    libraryProvider.watchedMovieListIds.contains(movie!.id);

    isWatched = libraryProvider.isMovie
        ? libraryProvider.watchedMovieListIds.contains(movie!.id)
        : libraryProvider.watchedTvListIds.contains(movie!.id);

    return IconButton(
      onPressed: () async {
        if(libraryProvider.currentUser==null){
          CustomSnackBar()
              .showSnackBar(title: "${AppLocalizations().translate(context, WordKeys.notAuthActionPressedError)}", state: keyState!);
          return;
        }
        isWatched
            ? await libraryProvider.removeFromWatched(movie!, keyState)
            : await libraryProvider.markAsWatched(movie!, keyState);
        libraryProvider.notify();
      },
      icon: Icon(
        isWatched ? Icons.visibility : Icons.visibility_off,
        color: isWatched
            ? Provider.of<ThemeProvider>(context).currentMainColor
            : Colors.white,
      ),
    );
  }
}
