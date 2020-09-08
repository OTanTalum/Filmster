
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
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
      {this.onDoneTap, this.title, this.isTV, this.body, this.imagew, this.imageH});


  @override
  _DialogWindowState createState() => _DialogWindowState();

}
class _DialogWindowState extends State<DialogWindow>{



  @override
  Widget build(BuildContext context) {
    var colors = Provider.of<ThemeProvider>(context);
    List <Widget> list=[];
    widget.isTV
        ? Provider
        .of<SettingsProvider>(context,
        listen: false)
        .tvMapOfGanres
        .forEach((key, value) {
      list.add(
          Container(
                  padding: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width*0.3,
                height: 24,
                child: CheckboxListTile(
                  title: Text("$value",
                    style: TextStyle(
                      color: colors.currentFontColor,
                      fontFamily: "AmaticSC",
                    ),
                  ),
                  value: Provider.of<SettingsProvider>(context, listen: false).tvFilter["$key"],
                  onChanged: (bool value) {
                    setState(() {
                      Provider.of<SettingsProvider>(context, listen: false).tvFilter["$key"]=!Provider.of<SettingsProvider>(context, listen: false).tvFilter["$key"];
                    });
                  },
                  secondary: const Icon(Icons.hourglass_empty),
                )
              )
      );
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
                      fontSize: 20
                    ),
                  ),
                  activeColor: colors.currentMainColor,
                  value: Provider.of<SettingsProvider>(context, listen: false)
                      .movieFilter["$key"],
                  onChanged: (bool value) {
                    setState(() {
                      Provider.of<SettingsProvider>(context,listen: false).movieFilter["$key"] =
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
            height: 442,
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
                    height: 392,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Genres",
                              style: TextStyle(
                                  fontSize: 26,
                                  color: colors.currentFontColor,
                                fontFamily: "AmaticSC",
                              ),
                            ),
                            Wrap(
                                children:list
                            ),
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
                              padding: const EdgeInsets.only(bottom:40.0),
                              child:  ButtonBar(
                                  children:[
                                  RaisedButton(
                                    onPressed:(){
                                      Provider.of<SettingsProvider>(context,listen: false).saveFilter(widget.isTV);
                                      Navigator.of(context).pop();
                                    },
                                    child:Text("Done",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: colors.currentFontColor,
                                        fontFamily: "AmaticSC",
                                      ),),
                                    color: colors.currentSecondaryColor,
                                  )
                                  ],
                                  alignment:MainAxisAlignment.center,
                                  mainAxisSize:MainAxisSize.max
                              )
                            )
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
