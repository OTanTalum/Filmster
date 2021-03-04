import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';


class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: SvgPicture.asset("assets/image/logoScreen.svg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover)
        ),
      ),
    );
  }
}
