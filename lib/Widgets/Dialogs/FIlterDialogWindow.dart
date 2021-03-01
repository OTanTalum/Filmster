import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/model/Genre.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterDialogWindow extends StatefulWidget {
  final onDoneTap;
  double imageH;
  double imagew;

  FilterDialogWindow(
      {this.onDoneTap,
      this.imagew,
      this.imageH});

  @override
  _FilterDialogWindowState createState() => _FilterDialogWindowState();
}

class _FilterDialogWindowState extends State<FilterDialogWindow> {
  ThemeProvider themeProvider;
  UserProvider userProvider;
  SettingsProvider settingsProvider;
  String selectedValue;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    settingsProvider = Provider.of<SettingsProvider>(context);
    List<Widget> list = [];

    userProvider.isMovie
        ? settingsProvider.movieListOfGenres.forEach((Genre genre) {
      list.add(_buildOneMovieGenre(genre));
    })
        : settingsProvider.tvListOfGenres.forEach((Genre genre) {
      list.add(_buildOneTVGenre(genre));
    });

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          type: MaterialType.canvas,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              color: themeProvider.currentBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.close,
                            color: themeProvider.currentFontColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(children: [
                                Text(
                                  AppLocalizations()
                                      .translate(context, WordKeys.day),
                                  style: TextStyle(
                                    fontFamily: "AmaticSC",
                                    color: themeProvider.currentFontColor,
                                    fontSize: 22,
                                  ),
                                ),
                                Switch(
                                  value: userProvider.currentPeriod == "week",
                                  onChanged: (value) {
                                    setState(() {
                                      userProvider.changeCurrentPeriod(
                                          userProvider.currentPeriod == "week"
                                              ? "day"
                                              : "week");
                                    });
                                  },
                                  activeTrackColor:
                                  themeProvider.currentSecondaryColor,
                                  activeColor: themeProvider.currentMainColor,
                                ),
                                Text(
                                  AppLocalizations()
                                      .translate(context, WordKeys.week),
                                  style: TextStyle(
                                    fontFamily: "AmaticSC",
                                    color: themeProvider.currentFontColor,
                                    fontSize: 22,
                                  ),
                                ),
                              ]),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(children: [
                                  Text(
                                    AppLocalizations()
                                        .translate(context, WordKeys.films),
                                    style: TextStyle(
                                      fontFamily: "AmaticSC",
                                      color: themeProvider.currentFontColor,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Switch(
                                    value: !userProvider.isMovie,
                                    onChanged: (value) {
                                      setState(() {
                                        userProvider.changeCurrentType();
                                      });
                                    },
                                    activeTrackColor:
                                    themeProvider.currentSecondaryColor,
                                    activeColor: themeProvider.currentMainColor,
                                  ),
                                  Text(
                                    AppLocalizations()
                                        .translate(context, WordKeys.TV),
                                    style: TextStyle(
                                      fontFamily: "AmaticSC",
                                      color: themeProvider.currentFontColor,
                                      fontSize: 22,
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                          _buildDevider(),
                          Text(
                            "Genres",
                            style: TextStyle(
                              fontSize: 26,
                              color: themeProvider.currentFontColor,
                              fontFamily: "AmaticSC",
                            ),
                          ),
                          Wrap(children: list),
                          _buildDevider(),
                          _buildYearPicker(),
                          _buildDevider(),
                          _buildDoneButton(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPicker() {
    showModalBottomSheet(
        backgroundColor: themeProvider.currentSecondaryColor,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              CupertinoPicker(
                backgroundColor: themeProvider.currentSecondaryColor,
                onSelectedItemChanged: (value) {
                  setState(() {
                    selectedValue = (1940 + value).toString();
                  });
                },
                itemExtent: 82.0,
                children: [
                  for (int i = 1940; i <= DateTime.now().year; i++)
                    Text(
                      i.toString(),
                      style: TextStyle(
                        fontSize: 62,
                        color: themeProvider.currentFontColor,
                        fontFamily: "AmaticSC",
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: RaisedButton(
                    color: themeProvider.currentMainColor,
                    onPressed: () => {
                      settingsProvider.saveYearFilter(selectedValue),
                      Navigator.pop(context),
                    },
                    child: Text(
                      "Enter",
                      style: TextStyle(
                        fontSize: 22,
                        color: themeProvider.currentFontColor,
                        fontFamily: "AmaticSC",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _buildDevider() {
    var provider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: provider.currentSecondaryColor,
        height: 1,
        thickness: 1,
        indent: 10,
        endIndent: 10,
      ),
    );
  }

  _buildYearPicker(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 12, horizontal: 8),
          child: Text(
            "Year : ${settingsProvider.currentYear == null ? "None" : settingsProvider.currentYear}",
            style: TextStyle(
              fontSize: 36,
              color: themeProvider.currentFontColor,
              fontFamily: "AmaticSC",
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 140,
              child: RaisedButton(
                color: themeProvider.currentSecondaryColor,
                onPressed: showPicker,
                child: Text(
                  "Change Year",
                  style: TextStyle(
                    fontSize: 26,
                    color: themeProvider.currentFontColor,
                    fontFamily: "AmaticSC",
                  ),
                ),
              ),
            ),
            Container(
              width: 140,
              child: RaisedButton(
                color: themeProvider.currentSecondaryColor,
                onPressed: () => {
                  selectedValue = null,
                  settingsProvider
                      .saveYearFilter(selectedValue),
                },
                child: Text(
                  "Delete Year Filter",
                  style: TextStyle(
                    fontSize: 22,
                    color: themeProvider.currentFontColor,
                    fontFamily: "AmaticSC",
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding _buildDoneButton(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: ButtonBar(
          children: [
            RaisedButton(
              onPressed: () {

                Navigator.of(context).pop();
              },
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 20,
                  color: themeProvider.currentFontColor,
                  fontFamily: "AmaticSC",
                ),
              ),
              color: themeProvider.currentSecondaryColor,
            )
          ],
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max),
    );
  }

  Widget _buildOneTVGenre(Genre genre) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 48,
      child: CheckboxListTile(
        title: Text(genre.name,
          style: TextStyle(
              color: themeProvider.currentFontColor,
              fontFamily: "AmaticSC",
              fontSize: 20),
        ),
        value: settingsProvider.tvFilter[genre],
        onChanged: (bool value) {
          setState(() {
            settingsProvider.changeTVGenreStatus(genre);
          });
        },
      ),
    );
  }

  Widget _buildOneMovieGenre(Genre genre) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 48,
      child: CheckboxListTile(
        title: Text(genre.name,
          style: TextStyle(
              color: themeProvider.currentFontColor,
              fontFamily: "AmaticSC",
              fontSize: 20),
        ),
        activeColor: themeProvider.currentMainColor,
        value: settingsProvider.movieFilter[genre],
        onChanged: (bool value) {
          setState(() {
            settingsProvider.changeMovieGenreStatus(genre);
          });
        },
      ),
    );
  }
}
