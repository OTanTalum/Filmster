import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/trendingProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogWindow extends StatefulWidget {
  var onDoneTap;
  String title;
  String body;
  bool isTV;
  double imageH;
  double imagew;

  DialogWindow(
      {this.onDoneTap,
      this.title,
      this.isTV,
      this.body,
      this.imagew,
      this.imageH});

  @override
  _DialogWindowState createState() => _DialogWindowState();
}

class _DialogWindowState extends State<DialogWindow> {
  String selectedValue;

  showPicker() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    var colors = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
            .currentSecondaryColor,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              CupertinoPicker(
                backgroundColor: colors.currentSecondaryColor,
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
                        color: colors.currentFontColor,
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
                    color: colors.currentMainColor,
                    onPressed: () => {
                      settingsProvider.saveYearFilter(selectedValue),
                      Navigator.pop(context),
                    },
                    child: Text(
                      "Enter",
                      style: TextStyle(
                        fontSize: 22,
                        color: colors.currentFontColor,
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

  @override
  Widget build(BuildContext context) {
    var colors = Provider.of<ThemeProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    List<Widget> list = [];
    widget.isTV
        ? Provider.of<SettingsProvider>(context, listen: false)
            .tvMapOfGanres
            .forEach((key, value) {
            list.add(Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 48,
                child: CheckboxListTile(
                  title: Text(
                    "$value",
                    style: TextStyle(
                        color: colors.currentFontColor,
                        fontFamily: "AmaticSC",
                        fontSize: 20),
                  ),
                  value: Provider.of<SettingsProvider>(context, listen: false)
                      .tvFilter["$key"],
                  onChanged: (bool value) {
                    setState(() {
                      Provider.of<SettingsProvider>(context, listen: false)
                              .tvFilter["$key"] =
                          !Provider.of<SettingsProvider>(context, listen: false)
                              .tvFilter["$key"];
                    });
                  },
                )));
          })
        : Provider.of<SettingsProvider>(context, listen: false)
            .movieMapOfGanres
            .forEach((key, value) {
            list.add(
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 48,
                child: CheckboxListTile(
                  title: Text(
                    "$value",
                    style: TextStyle(
                        color: colors.currentFontColor,
                        fontFamily: "AmaticSC",
                        fontSize: 20),
                  ),
                  activeColor: colors.currentMainColor,
                  value: Provider.of<SettingsProvider>(context, listen: false)
                      .movieFilter["$key"],
                  onChanged: (bool value) {
                    setState(() {
                      Provider.of<SettingsProvider>(context, listen: false)
                              .movieFilter["$key"] =
                          !Provider.of<SettingsProvider>(context, listen: false)
                              .movieFilter["$key"];
                    });
                  },
                ),
              ),
            );
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
              color: colors.currentBackgroundColor,
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
                            color: colors.currentFontColor,
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
                                    color: colors.currentFontColor,
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
                                      colors.currentSecondaryColor,
                                  activeColor: colors.currentMainColor,
                                ),
                                Text(
                                  AppLocalizations()
                                      .translate(context, WordKeys.week),
                                  style: TextStyle(
                                    fontFamily: "AmaticSC",
                                    color: colors.currentFontColor,
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
                                      color: colors.currentFontColor,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Switch(
                                    value: userProvider.currentType != "movie",
                                    onChanged: (value) {
                                      setState(() {
                                        userProvider.changeCurrentType(
                                            userProvider.currentType == "movie"
                                                ? "tv"
                                                : "movie");
                                      });
                                    },
                                    activeTrackColor:
                                        colors.currentSecondaryColor,
                                    activeColor: colors.currentMainColor,
                                  ),
                                  Text(
                                    AppLocalizations()
                                        .translate(context, WordKeys.TV),
                                    style: TextStyle(
                                      fontFamily: "AmaticSC",
                                      color: colors.currentFontColor,
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
                              color: colors.currentFontColor,
                              fontFamily: "AmaticSC",
                            ),
                          ),
                          Wrap(children: list),
                          _buildDevider(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: Text(
                              "Year : ${settingsProvider.currentYear == null ? "None" : settingsProvider.currentYear}",
                              style: TextStyle(
                                fontSize: 36,
                                color: colors.currentFontColor,
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
                                  color: colors.currentSecondaryColor,
                                  onPressed: showPicker,
                                  child: Text(
                                    "Change Year",
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: colors.currentFontColor,
                                      fontFamily: "AmaticSC",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 140,
                                child: RaisedButton(
                                  color: colors.currentSecondaryColor,
                                  onPressed: () => {
                                    selectedValue = null,
                                    settingsProvider
                                        .saveYearFilter(selectedValue),
                                  },
                                  child: Text(
                                    "Delete Year Filter",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: colors.currentFontColor,
                                      fontFamily: "AmaticSC",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _buildDevider(),
//                            Text(widget.title,
//                              style: TextStyle(
//                                fontSize: 24,
//                                  color: colors.currentFontColor,
//                                fontFamily: "AmaticSC",
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(top:8.0,bottom: 24, left: 24, right: 24),
//                              child: Text(widget.body,
//                                style: TextStyle(
//                                    fontSize: 16,
//                                    color: colors.currentFontColor,
//                                  fontFamily: "AmaticSC",
//                                ),
//                              ),
//                            ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: ButtonBar(
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Provider.of<SettingsProvider>(context,
                                                listen: false)
                                            .saveFilter(widget.isTV);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: colors.currentFontColor,
                                          fontFamily: "AmaticSC",
                                        ),
                                      ),
                                      color: colors.currentSecondaryColor,
                                    )
                                  ],
                                  alignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max))
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
}
