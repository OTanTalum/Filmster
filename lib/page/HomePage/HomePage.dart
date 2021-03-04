import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/widgets/UI/LIbraryActionButton.dart';
import 'package:filmster/widgets/UI/movieCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Tabs/discoverPage.dart';
import 'Tabs/trendingPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  int currentPage = 1;
  List<Widget> movieTrend = [];

  @override
  void initState() {
    super.initState();
    _tabController =  new TabController(length: 3, vsync: this);
    _scrollController.addListener(addMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  addMore() async {
    var provider =  Provider.of<UserProvider>(context, listen: false);
    if ( _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent&&
        provider.totalPage!>=provider.currentPage && !provider.isLoading) {
      provider.currentPage++;
      await provider.getChristian(scaffoldState);
    }
  }

  ///TODO 3. Attribution
  ///You shall use the TMDb logo to identify your use of the TMDb APIs.
  ///You shall place the following notice prominently on your application: "This product uses the TMDb API but is not endorsed or certified by TMDb."
  ///Any use of the TMDb logo in your application shall be less prominent than the logo or mark that primarily describes the application and your use of the TMDb logo shall not imply any endorsement by TMDb.

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Widget> christianList = [];
    userProvider.christianMovie.forEach((element) {
      christianList.add(MovieCard(element, scaffoldState));
    });
    return Scaffold(
      key: scaffoldState,
      backgroundColor: myColors.currentBackgroundColor,
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: myColors.currentMainColor,
          tabs: [
            Tab(
              text: AppLocalizations().translate(context, WordKeys.trending),

            ),
            Tab(
              text: AppLocalizations().translate(context, WordKeys.discover),
            ),
            Tab(
              icon: Icon(Icons.highlight),
            ),
          ],
        ),
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Filmster',
                style: TextStyle(fontFamily: "AmaticSC", fontSize: 34),
              ),
            ]),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: LibraryActionButton.build(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //drawer: DrawerMenu().build(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          TrendingPage(),
          DiscoverPage(),
          SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: christianList,
              )),
        ],
      ),
    );
  }
}
