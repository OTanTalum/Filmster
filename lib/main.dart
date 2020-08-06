//Widgets
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/theme.dart';
import 'package:filmster/widgets/drawer.dart';
//Flutter
import 'package:flutter/material.dart';
//Pages

import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}

class MyHomePage extends StatefulWidget {


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context,listen: false).currentBackgroundColor,
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      drawer: DrawerMenu().build(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.LIGHT);
              },
              child: Text("Light!"),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.DARK);
              },
              child: Text("Dark!"),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.DARKER);
              },
              child: Text("Darker!"),
            ),
            Divider(height: 100,),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: Provider.of<ThemeProvider>(context,listen: false).currentMainColor,
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Provider.of<ThemeProvider>(context,listen: false).currentBackgroundColor,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add,
        color: Provider.of<ThemeProvider>(context,listen: false).currentMainColor,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
