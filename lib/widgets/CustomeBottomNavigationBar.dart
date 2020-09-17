
import 'package:filmster/page/loginPage.dart';
import 'package:filmster/page/profilePage.dart';
import 'package:filmster/page/searchByName.dart';
import 'package:filmster/page/searchPage.dart';
import 'package:filmster/page/settings_page.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
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
              _buildIcon(0, MyHomePage(), Icons.home),
              _buildIcon(1, SearchPage(), Icons.search),
              SizedBox(width: 24),
              _buildIcon(2, SettingsPage(), Icons.settings),
              _buildIcon(3, Provider.of<UserProvider>(context, listen: false).currentUser==null
                  ? LoginPage()
                  : ProfilePage(),
              Icons.person),
            ],
          ),
        ),
      );
  }

  _buildIcon(int index, page, icon) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    return IconButton(
      onPressed: () {
        if (Provider.of<SettingsProvider>(context, listen: false).currentPage !=
            index) {
          Provider.of<SettingsProvider>(context, listen: false)
              .changePage(index);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => page),
              (Route<dynamic> route) => false);
        }
      },
      icon: Icon(
       icon,
        color: Provider.of<SettingsProvider>(context).currentPage == index
            ? myColors.currentMainColor
            : myColors.currentFontColor,
        size: 36,
      ),
    );
  }
}