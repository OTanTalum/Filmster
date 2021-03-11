//
// //import 'package:admob_flutter/admob_flutter.dart';
// import 'package:filmster/localization/languages/workKeys.dart';
// import 'package:filmster/localization/localization.dart';
// import 'package:filmster/page/HomePage/HomePage.dart';
// import 'package:filmster/page/Search/Pages/searchByName.dart';
// import 'package:filmster/page/settings_page.dart';
// import 'package:filmster/providers/settingsProvider.dart';
// import 'package:filmster/providers/themeProvider.dart';
// import 'package:filmster/setting/adMob.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:package_info/package_info.dart';
//
// class DrawerMenu {
//   String? version;
//   String? buildNumber;
//
//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<ThemeProvider>(context);
//     return Drawer(
//       child: Container(
//         height: double.infinity,
//         color: provider.currentBackgroundColor,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     child: DrawerHeader(
//                       decoration: BoxDecoration(
//                         color: provider.currentMainColor,
//                       ),
//                       child: Text(
//                         '\' "" "\' ',
//                         style: TextStyle(
//                           fontFamily: "MPLUSRounded1c",
//                           color: provider.currentFontColor,
//                           fontWeight: FontWeight.w300,
//                           fontSize: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(builder: (_) => HomePage()));
//                     },
//                     title: Text(
//                       AppLocalizations().translate(context, WordKeys.home)!,
//                       style: TextStyle(
//                         fontFamily: "AmaticSC",
//                         fontWeight: FontWeight.bold,
//                         fontSize: 27.0,
//                         color: provider.currentFontColor,
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (_) => FilmsPage()));
//                     },
//                     title: Text(
//                       AppLocalizations().translate(context, WordKeys.films)!,
//                       style: TextStyle(
//                         fontFamily: "AmaticSC",
//                         fontWeight: FontWeight.bold,
//                         fontSize: 27.0,
//                         color: provider.currentFontColor,
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (_) => FilmsPage()));
//
//                     },
//                     title: Text(
//                       AppLocalizations().translate(context, WordKeys.TV)!,
//                       style: TextStyle(
//                         fontFamily: "AmaticSC",
//                         fontWeight: FontWeight.bold,
//                         fontSize: 27.0,
//                         color: provider.currentFontColor,
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => SettingsPage()));
//                     },
//                     title: Text(
//                       AppLocalizations().translate(context, WordKeys.settings)!,
//                       style: TextStyle(
//                         fontFamily: "AmaticSC",
//                         fontWeight: FontWeight.bold,
//                         fontSize: 27.0,
//                         color: provider.currentFontColor,
//                       ),
//                     ),
//                   ),
// //                  ListTile(
// //                    onTap: () {
// // //                      Navigator.of(context).pushReplacement(
// // //                          MaterialPageRoute(builder: (_) => LoginPage()));
// //                    },
// //                    title: Text(
// //                      AppLocalizations().translate(context, WordKeys.login),
// //                      style: TextStyle(
// //                        fontFamily: "AmaticSC",
// //                        fontWeight: FontWeight.bold,
// //                        fontSize: 27.0,
// //                        color: provider.currentFontColor,
// //                      ),
// //                    ),
// //                  ),
//                 ]),
//             SizedBox(
//               height: 24,
//             ),
//             Column(
//               children: [
//                // AdmobBanner(
//                //    adUnitId: AddMobClass().getDrawerBannerAdUnitId(),
//                //    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
//                //    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//                //      if(event==AdmobAdEvent.opened) {
//                //        print('Admob banner opened!');
//                //        FirebaseAnalytics().logEvent(name: 'adMobDrawerClick');
//                //      }
//                //    },
//                //    onBannerCreated: (AdmobBannerController controller) {
//                //    },
//                //  ),
//                 Center(
//                   child: FutureBuilder<String>(
//                     future: getVersion(),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<String> snapshot) {
//                       if (snapshot.hasData) {
//                         return Container(
//                             child: Text(
//                           "Version: ${snapshot.data}",
//                           style: TextStyle(
//                             fontFamily: "AmaticSC",
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.0,
//                             color: provider.currentFontColor,
//                           ),
//                         ));
//                       }
//                       return Container();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<String> getVersion() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     return "${packageInfo.version}+${packageInfo.buildNumber}";
//   }
// }
