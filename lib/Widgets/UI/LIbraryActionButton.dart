import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/page/library.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryActionButton {
  static FloatingActionButton build({
    required BuildContext context,
    required GlobalKey<ScaffoldState> keyState}) {
   SettingsProvider settings =  Provider.of<SettingsProvider>(context);
   ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    LibraryProvider libraryProvider =  Provider.of<LibraryProvider>(context);
    return FloatingActionButton(
      heroTag: "LibraryActionButton",
      onPressed: () {
        if(libraryProvider.currentUser==null){
          CustomSnackBar()
              .showSnackBar(title: "${AppLocalizations().translate(context, WordKeys.notAuthActionPressedError)}", state: keyState);
          return;
        }
        settings.changePage(Pages.LIBRARY_PAGE);
        if(Provider.of<LibraryProvider>(context, listen: false).currentUser!=null){
          print(settings.currentPage);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LibraryPage()));
        }
      },
      elevation: 10,
      backgroundColor: themeProvider.currentSecondaryColor,
      child: Icon(
          Icons.favorite,
          color: settings.currentPage==Pages.LIBRARY_PAGE
              ? themeProvider.currentMainColor
              : themeProvider.currentFontColor
      ),
    );
  }
}
