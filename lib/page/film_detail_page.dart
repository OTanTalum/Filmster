import 'package:dartpedia/dartpedia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:filmster/widgets/drawer.dart';

import 'package:filmster/model/film.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;
import 'package:url_launcher/url_launcher.dart';

class FilmDetailPage extends StatefulWidget {
  final String arguments;

  FilmDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  FilmDetailPageState createState() => new FilmDetailPageState();
}

class FilmDetailPageState extends State<FilmDetailPage> {

  String imdbAPI = 'http://www.omdbapi.com/?apikey=827ba9b0&i=';

  @override
  Widget build(BuildContext context) {
    return
    FutureBuilder <Film>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<Film> snapshot) {
          if (snapshot.hasData) {
            return buildPage(snapshot.data);
          }
          else
            return CircularProgressIndicator();
        }
    );
  }

  buildPage(movie){
    return Scaffold(
      appBar: AppBar(
        title: Text(
            movie.title
        ),
      ),
      drawer: DrawerMenu().build(context),
      body: buildBody(movie),
    );
  }

  _getIcon(name){
    switch(name){
      case 'G': return 'assets/icons/g.png';
      case 'PG': return 'assets/icons/pg.png';
      case 'PG-13': return 'assets/icons/pg-13.png';
      case 'R': return 'assets/icons/r.png';
      case 'Unrated': return 'assets/icons/Unrated.png';
      default : return 'assets/icons/NotRated.png';
    }
  }

  buildBody(movie) {
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 980,
            ),
            child: IntrinsicHeight(
                child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Image.network(movie.posters),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                        child: Container(
                            height: 150,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                         //     color: Color(0xff2b2c32),
                              border: Border.all(
                                color: Colors.deepOrangeAccent,
                                width: 4,
                              ),
                        //      borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:EdgeInsets.symmetric(vertical: 7.0),
                                  child:Text(
                                  " ${movie.title}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0,
                                      color: Color(0xff2b2c32),
                                    ),
                                )),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Icon(
                                            Icons.today,
                                            color: Color(0xff2b2c32),
                                          ),
                                          Text(
                                            " ${movie.year}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xff2b2c32),
                                            ),
                                          ),
                                        ]),
                                        Row(children: <Widget>[
                                          Icon(
                                            Icons.hourglass_empty,
                                            color: Color(0xff2b2c32),
                                          ),
                                          Text(
                                            " ${movie.runtime}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xff2b2c32),
                                            ),
                                          ),
                                        ]),
                                        Image.asset(
                                          _getIcon(movie.rated),
                                          height: 30,
                                        )
                                      ],
                                    )),
                                 Padding(
                                  padding:EdgeInsets.symmetric(vertical: 7.0),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Image.asset('assets/icons/Genre.png',
                                      height: 30)),
                                      Text(
                                        "${movie.genre}",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xff2b2c32),
                                        ),
                                      )
                                    ],
                                  ),
                                  ),

                              ],

                            )
                        ),
                      ),Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                              height: 150,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //     color: Color(0xff2b2c32),
                                border: Border.all(
                                  color: Colors.deepOrangeAccent,
                                  width: 4,
                                ),
                                //      borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                  color: Colors.white,
                                  child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Text(
                                            'Raitings',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: getRaiting(movie),
                                            ),
                                        Text('IMDB Votes : ${movie.imdbV}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),),
                                      ])))),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          height: 150,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //     color: Color(0xff2b2c32),
                            border: Border.all(
                              color: Colors.deepOrangeAccent,
                              width: 4,
                            ),
                            //      borderRadius: BorderRadius.circular(20),
                          ),
                            child: Container(
                                color: Colors.white,
                                child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Text(
                                          '${movie.title} in Web',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          children: <Widget>[
                                            getWikiLinks(movie),
                                            getIMDB(movie),
                                          ])
                                      ,
                                    ])))),
                      //  Container( child: getDesc(movie),)
                    ]
                )
            )
        )
    );
  }

  List <Widget> getRaiting(movie){
    List <Widget> rait=[];
    if(movie.raiting!=null){
      for(var i=0; i<movie.raiting.length;i++){
        String name =movie.raiting[i]['Source'];
        switch(name){
          case 'Internet Movie Database':
            rait.add(
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/imdb.png',
                      height: 35,
                    ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                   child: Text(movie.raiting[i]["Value"])
                )
                  ],
            ));
            break;
          case 'Rotten Tomatoes':
            rait.add(
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/RT.png',
                      height: 35,
                    ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                   child: Text(movie.raiting[i]["Value"])
                )
                  ],
                ));
            break;
          case 'Metacritic':
            rait.add(
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/MT.png',
                      height: 35,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child:  Text(movie.raiting[i]["Value"])
                    )


                  ],
                ));
            break;
        }
      }
      return rait;
    }
  }

  getIMDB(movie){
   return InkWell(
      onTap: (){
        launch('https://www.imdb.com/title/${movie.imdbid}');
      },
      child: Image.asset(
        'assets/icons/imdb.png',
        height: 35,
      ),
    );
  }


  getWikiLinks(movie){
    return FutureBuilder <WikipediaPage>(
        future: getWiki(movie.title),
        builder: (BuildContext context, AsyncSnapshot<WikipediaPage> snapshot) {
          if (snapshot.hasData) {
            return    InkWell(
                        onTap: (){
                          launch(snapshot.data.url);
                        },
                       child: Image.asset(
                          'assets/icons/wiki.png',
                          height: 30,
                        ),
                      );
          }
          return Container();
  });
  }

  Future<WikipediaPage> getWiki(String movie)async {
    var wikipediaPage = await wiki.page('$movie ');
    if(wikipediaPage.content.startsWith('Redirect to:')){
      var array = wikipediaPage.content.split('This page is a redirect');
      array=array[0].split('Redirect to:');
      wikipediaPage = await wiki.page('${array[1]}');
    }
    return wikipediaPage;
  }

  Future<Film> fetchData() async {
    final response = await http.get('$imdbAPI${widget.arguments} ');
    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ');
    }
  }

}
