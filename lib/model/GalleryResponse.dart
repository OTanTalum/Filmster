import 'package:filmster/model/Poster.dart';

class GalleryResponse {
  String? id;
  List<Poster>? backDropsList = [];
  List<Poster>? postersList = [];

  GalleryResponse({this.id, this.backDropsList, this.postersList});

  GalleryResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    if (json["backdrops"] != null && json["backdrops"].isNotEmpty) {
      json["backdrops"].forEach(
          (element) => backDropsList!.add(Poster.fromJson(element)));
    }
    if (json["posters"] != null && json["posters"].isNotEmpty) {
      json["posters"].forEach(
          (element) => postersList!.add(Poster.fromJson(element)));
    }
  }
}
