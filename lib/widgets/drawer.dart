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
                  'Hi, man ;)',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                onTap:() {
                  Navigator.pushNamed(context, '/welcome');
                },
                title: Text('Home'),
              ),
               ListTile(
                 onTap:() {
                   Navigator.pushNamed(context, '/films');
                   },
                  title: Text('Films'),
               ),
              ListTile(
                title: Text('Shows'),
              ),
              ListTile(
                title: Text('Library'),
              ),
            ],
        )
    );
  }
}
