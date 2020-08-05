import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:filmster/model/search.dart';
import 'package:filmster/page/film_detail_page.dart';

import 'package:filmster/widgets/drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilmsPage extends StatefulWidget {

  @override
  _FilmsPageState createState() => _FilmsPageState();

}

class _FilmsPageState extends State<FilmsPage> {

  final textController = TextEditingController();
  bool _noData = true;


  String imdbAPI = 'http://www.omdbapi.com/?apikey=827ba9b0&type=movie&s=';


  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    textController.addListener(onTextChange);
  }

  _buildFilm(element) {
    return InkWell(
        onTap: () async{
          Navigator.of(context).pushNamed('/filmDeatil', arguments: element['imdbID']);
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.deepOrange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              height: 165,
              //     color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                  children: <Widget>[
                    element['Poster'] != 'N/A' ?
                    Image.network(
                      element['Poster'],
                      height: 150,
                      width: 100,
                    ) :
                    Container(
                        height: 150,
                        width: 100,
                        child: Icon(
                          Icons.do_not_disturb_on,
                          size: 100.0,
                          color: Colors.deepOrange,
                        )),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.9 - 140,
                              child: Text(
                                  element['Title'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              child: Text(
                                element['Year'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
//                      Container(
//                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
//                          child:Text(
//                      element['Genre']
//                          )),
//                    Text(
//                      element['Country']
//                    ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              child: Text(
                                element['Type'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))

//)
                        ])
                  ]
              ),
            )
        ));
  }

  noData() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      alignment: Alignment.topCenter,
      child: Text('Movies not found',
        style: TextStyle(
          color: Colors.white,
        ),),
    );
  }

  _buildResults(context) {
    List<Widget> list = new List<Widget>();
    return FutureBuilder <Search>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<Search> snapshot) {
          if (snapshot.hasData) {
            list.clear();
            if(snapshot.data.search==null){
              _noData = true;
              return noData();
            }
            else {
              _noData = false;
              var films = snapshot.data.search;
              films.forEach((element) => list.add(_buildFilm(element)));
              return Column(children: list);
            }
          }
//          else if(snapshot.hasData && snapshot.data.search==null)
//            return noData();
          return CircularProgressIndicator();
        }
    );
  }

  onTextChange() {
    print(textController.text);
    if (textController.text.length >= 3)
      setState(() {
        fetchData();
      });
  }

  Future<Search> fetchData() async {
    final response = await http.get('$imdbAPI${textController.text}');
    if (response.statusCode == 200) {
      _noData = false;
      print(json.decode(response.body));
      return Search.fromJson(json.decode(response.body));
    } else {
      _noData = true;
      throw Exception('Failed to load ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find your films'),
      ),
      drawer: DrawerMenu().build(context),
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  buildInput() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
        child: TextField(
          controller: textController,
          cursorRadius: Radius.circular(6000),
          cursorColor: Colors.deepOrange,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            hintText: 'Enter movie title',
            focusColor: Colors.orange,
            hoverColor: Colors.white,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        )
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 980,
            ),
            child: IntrinsicHeight(
                child: Column(
                    children: <Widget>[
                      buildInput(),
                      Expanded(
                        // A flexible child that will grow to fit the viewport but
                        // still be at least as big as necessary to fit its contents.
                        child: _noData
                            ? noData()
                            : _buildResults(context),
                      ),
                    ]
                )
            )
        )
    );
  }
}
