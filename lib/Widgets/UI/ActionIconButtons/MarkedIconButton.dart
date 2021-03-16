import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomSnackBar.dart';

class MarkedIconButton extends StatelessWidget {
  final SearchResults? movie;
  final GlobalKey<ScaffoldState>? keyState;

  MarkedIconButton({this.movie, this.keyState});

  late LibraryProvider libraryProvider;
  late bool isMarked;

  @override
  Widget build(BuildContext context) {
    libraryProvider =  Provider.of<LibraryProvider>(context);
    libraryProvider.markedMovieListIds.contains(movie!.id);

    isMarked = libraryProvider.isMovie
        ? libraryProvider.markedMovieListIds.contains(movie!.id)
        : libraryProvider.markedTVListIds.contains(movie!.id);

    return IconButton(
      onPressed: () async {
        if(libraryProvider.currentUser==null){
          CustomSnackBar()
              .showSnackBar(title: "${AppLocalizations().translate(context, WordKeys.notAuthActionPressedError)}", state: keyState!);
          return;
        }
        isMarked
            ? await libraryProvider.removeFromMarkedList(movie!, keyState)
            : await libraryProvider.mark(movie!, keyState);
        libraryProvider.notify();
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
