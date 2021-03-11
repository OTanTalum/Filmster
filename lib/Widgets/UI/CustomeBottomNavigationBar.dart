import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/page/HomePage/HomePage.dart';
import 'package:filmster/page/Search/searchPage.dart';
import 'package:filmster/page/loginPage.dart';
import 'package:filmster/page/profilePage.dart';
import 'package:filmster/page/settings_page.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/libraryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();

}
 class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>{

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
              _buildIcon(Pages.HOME_PAGE, HomePage(), Icons.home),
              _buildIcon(Pages.SEARCH_PAGE, SearchPage(), Icons.search),
              SizedBox(width: 24),
              _buildIcon(Pages.SETTINGS_PAGE, SettingsPage(), Icons.settings),
              _buildIcon(Pages.PROFILE_PAGE, Provider.of<LibraryProvider>(context, listen: false).currentUser==null
                  ? LoginPage()
                  : ProfilePage(),
              Icons.person),
            ],
          ),
        ),
      );
  }

  _buildIcon(Pages index, page, icon) {
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