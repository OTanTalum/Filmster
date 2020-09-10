
import 'package:filmster/page/films.dart';
import 'package:filmster/page/settings_page.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class CustomeBottomNavigationBar extends StatefulWidget {

  @override
  _CustomeBottomNavigationBarState createState() => _CustomeBottomNavigationBarState();

}
 class _CustomeBottomNavigationBarState extends State<CustomeBottomNavigationBar>{


  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    return BottomAppBar(
        color: myColors.currentBackgroundColor,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .changePage(0);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => MyHomePage()));
                },
                icon: Icon(
                  Icons.home,
                  color: Provider
                      .of<SettingsProvider>(context)
                      .currentPage == 0
                      ? myColors.currentMainColor
                      : myColors.currentFontColor,
                  size: 36,
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .changePage(1);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FilmsPage(type: "movie")));
                },
                icon: Icon(
                  Icons.search,
                  color: Provider
                      .of<SettingsProvider>(context)
                      .currentPage == 1
                      ? myColors.currentMainColor
                      : myColors.currentFontColor,
                  size: 36,
                ),
              ),
              SizedBox(width: 24),
              IconButton(
                onPressed: () {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .changePage(2);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SettingsPage()));
                },
                icon: Icon(
                  Icons.settings,
                  color: Provider
                      .of<SettingsProvider>(context)
                      .currentPage == 2
                      ? myColors.currentMainColor
                      : myColors.currentFontColor,
                  size: 36,
                ),
              ),

              Opacity(
                opacity: 0.5,
                child: IconButton(
                  onPressed: () {
                  //   Provider.of<SettingsProvider>(context, listen:false).changePage(3);
                  },
                  icon: Icon(
                    Icons.account_box,
                    color: Provider
                        .of<SettingsProvider>(context)
                        .currentPage == 3
                        ? myColors.currentMainColor
                        : myColors.currentFontColor,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}