import 'package:filmster/model/search.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkedIconButton extends StatelessWidget {
  final SearchResults? movie;
  final GlobalKey? keyState;

  MarkedIconButton({this.movie, this.keyState});

  late UserProvider userProvider;
  late bool isMarked;

  @override
  Widget build(BuildContext context) {
    userProvider =  Provider.of<UserProvider>(context);
    userProvider.markedMovieListIds.contains(movie!.id);

    isMarked = userProvider.isMovie
        ? userProvider.markedMovieListIds.contains(movie!.id)
        : userProvider.markedTVListIds.contains(movie!.id);

    return IconButton(
      onPressed: () async {
        isMarked
            ? await userProvider.removeFromMarkedList(movie!, keyState)
            : await userProvider.mark(movie!, keyState);
        userProvider.notify();
      },
      icon: Icon(
        isMarked
            ? Icons.turned_in
            : Icons.turned_in_not,
        color: isMarked
            ? Provider.of<ThemeProvider>(context).currentMainColor
            : Colors.white,
      ),
    );
  }
}
