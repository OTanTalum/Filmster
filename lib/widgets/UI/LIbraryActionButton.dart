import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/page/library.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryActionButton {
  static FloatingActionButton build(BuildContext context) {
   SettingsProvider settings =  Provider.of<SettingsProvider>(context);
   ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return FloatingActionButton(
      heroTag: "LibraryActionButton",
      onPressed: () {
        settings.changePage(Pages.LIBRARY_PAGE);
        if(Provider.of<UserProvider>(context, listen: false).currentUser!=null){
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
