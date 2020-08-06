import 'package:filmster/main.dart';
import 'package:filmster/page/films.dart';
import 'package:flutter/material.dart';

class DrawerMenu {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
                child: Text(
                  'Hello ;)',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                onTap:() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (_) => MyHomePage()));
                },
                title: Text('Home'),
              ),
               ListTile(
                 onTap:() {
                   Navigator.of(context)
                       .push(MaterialPageRoute(
                       builder: (_) => FilmsPage()));
                   },
                  title: Text('Films'),
               ),
              ListTile(
                title: Text('In progress'),
              ),
              ListTile(
                title: Text('In progress'),
              ),
            ],
        )
    );
  }
}
