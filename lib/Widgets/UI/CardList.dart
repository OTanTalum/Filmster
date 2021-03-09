import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardList extends StatelessWidget {
  CardList(this.itemList, this.title);

  final List<SearchResults> itemList;
  final String title;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:12.0),
      child: Container(
          width: MediaQuery.of(context).size.width - 20,
          color: themeProvider.currentSecondaryColor,
          height: 317.0,
          child: Column(
            children: [
              Container(
                height: 40,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "MPLUSRounded1c",
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: themeProvider.currentMainColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  scrollDirection: Axis.horizontal,
                  children: _getChildrenFromList(context),
                ),
              ),
            ],
          )),
    );
  }

  _getChildrenFromList(context) {
    List<Widget> widgetList = [];
    itemList.forEach((element) {
      widgetList.add(card(element, context));
    });
    return widgetList;
  }

  card(SearchResults video, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => FilmDetailPage(id: video.id.toString()))),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: video.poster != null
              ? Container(
            width: 150,
                  child: Column(
                    children: [
                      Container(
                          height: 200,
                          child: Image.network(
                              '${Api().imageLowAPI}${video.poster}'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Text(
                          video.title ?? "-",
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: "AmaticSC",
                            fontSize: 24.0,
                            color: themeProvider.currentFontColor,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 139,
                  width: 100,
                  child: Icon(
                    Icons.do_not_disturb_on,
                    size: 100.0,
                    color: themeProvider.currentAcidColor,
                  ))),
    );
  }
}
