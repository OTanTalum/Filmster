import 'package:filmster/model/search.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchedIconButton extends StatelessWidget {
  final SearchResults? movie;
  final GlobalKey? keyState;

  WatchedIconButton({this.movie, this.keyState});

  late UserProvider userProvider;
  late bool isWatched;

  @override
  Widget build(BuildContext context) {
    userProvider =  Provider.of<UserProvider>(context);
    userProvider.watchedMovieListIds.contains(movie!.id);

    isWatched = userProvider.isMovie
        ? userProvider.watchedMovieListIds.contains(movie!.id)
        : userProvider.watchedTvListIds.contains(movie!.id);

    return IconButton(
      onPressed: () async {
        isWatched
            ? await userProvider.removeFromWatched(movie!, keyState)
            : await userProvider.markAsWatched(movie!, keyState);
        userProvider.notify();
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
