import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/Widgets/Dialogs/FIlterDialogWindow.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/providers/discoverProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/widgets/UI/moviePosterCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  UserProvider userProvider;
  DiscoverProvider discoverProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await initDiscover());
    _scrollController.addListener(_scrollListener);
  }

  initDiscover() async {
    setState(() {
      _isLoading = true;
    });
    await discoverProvider.loadDiscoveryData(userProvider.isMovie, context, scaffoldState);
    setState(() {
      _isLoading = false;
    });
  }

  loadPage(List<SearchResults> discoverList) {
    List<Widget> pageList = [];
    int i = 0;
    discoverList.forEach((element) {
      pageList.add(MoviePosterCard(movie: element, scaffoldKey:scaffoldState));
      i++;
      if (i == 10) {
        pageList.add(
          AdmobBanner(
            adUnitId: AddMobClass().getBannerAdUnitId(),
            adSize: AdmobBannerSize.FULL_BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              if (event == AdmobAdEvent.opened) {
                print('Admob banner opened!');
                FirebaseAnalytics().logEvent(name: 'adMobTrendingClick');
              }
            },
            onBannerCreated: (AdmobBannerController controller) {},
          ),
        );
        i = 0;
      }
    });
    return pageList;
  }

  getNextPage() async {
    setState(() {
      _isLoading = true;
    });
    ++discoverProvider.currentPage;
    await discoverProvider.loadDiscoveryData(userProvider.isMovie, context, scaffoldState);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    discoverProvider = Provider.of<DiscoverProvider>(context);
    var themeProfile = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: scaffoldState,
      backgroundColor: themeProfile.currentBackgroundColor,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn3",
        elevation: 2,
        backgroundColor: themeProfile.currentSecondaryColor,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => FilterDialogWindow(
              onDoneTap: () async {
                Navigator.pop(context);
              },
              imageH: 96,
              imagew: 96,
            ),
          );
          setState(() {
            discoverProvider.clear();
            discoverProvider.currentPage = 1;
          });
          await initDiscover();
        },
        child: Icon(Icons.movie_filter),
      ),
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _buildBody(BuildContext context) {
    List<Widget> listOfMovieCards = [];
    List movieList = !userProvider.isMovie
        ? discoverProvider.discoverTv
        : discoverProvider.discoverMovie;
    listOfMovieCards.addAll(loadPage(movieList));
    if (listOfMovieCards.length < 10 && _isLoading) getNextPage();
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: _isLoading
            ? Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        Provider.of<ThemeProvider>(context).currentMainColor),
                  ),
                ),
              )
            : Wrap(
                children: listOfMovieCards,
              ),
      ),
    );
  }

  _scrollListener() async {
    if (discoverProvider.isLast || _isLoading) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await getNextPage();
    }
  }
}
