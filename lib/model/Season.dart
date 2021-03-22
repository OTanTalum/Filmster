import 'package:filmster/model/Episode.dart';

class Season {
  late int? id;
  late String? airDate;
  late int? episodeCount;
  late String? name;
  late String? overview;
  late String? poster;
  late int? seasonNumber;
  List<Episode> episodes=[];

  Season({this.id, this.poster, this.airDate, this.episodeCount, this.name,
      this.overview, this.seasonNumber, required this.episodes});

  Season.fromJson(Map<String, dynamic> json){
    if(json['id']!=null) {
      id = json['id'];
    }else if(json['_id']!=null){
      id = json['_id'];
    }
    airDate =json['air_date'];
    episodeCount = json['episode_count'];
    name=json['name'];
    overview=json['overview'];
    poster=json['poster_path'];
    seasonNumber=json['season_number'];
    if(json["episodes"]!=null&&json["episodes"].isNotEmpty)
      json["episodes"].forEach((element){
        episodes.add(Episode.fromJson(element));
      });
  }
}
