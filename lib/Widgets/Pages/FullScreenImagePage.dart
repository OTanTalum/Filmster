import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImagePage extends StatelessWidget {

  FullScreenImagePage({this.link});
  final String link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(link),
        enableRotation: true,
        loadingBuilder: (context, progress) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                  progress.expectedTotalBytes,
            ),
          ),
        ),
      )

      // Image.network(link,
      //   fit: BoxFit.cover,
      //   height: double.infinity,
      //   width: double.infinity,
      //   alignment: Alignment.center,
      // ),


    );
  }
}
