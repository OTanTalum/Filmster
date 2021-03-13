class Season {
  late int? id;
  late String? airDate;
  late int? episodeCount;
  late String? name;
  late String? overview;
  late String? poster;
  late int? seasonNumber;

  Season({this.id, this.poster, this.airDate, this.episodeCount, this.name,
      this.overview, this.seasonNumber});

  Season.fromJson(Map<String, dynamic> json){
    id=json['id'];
    airDate =json['air_date'];
    episodeCount = json['episode_count'];
    name=json['name'];
    overview=json['overview'];
    poster=json['poster_path'];
    seasonNumber=json['season_number'];
  }
}
