class Episode{
  late int? id;
  late String? airDate;
  late int? episodeNumber;
  late String? name;
  late String? overview;
  late String? poster;
  late int? seasonNumber;
  late String? prod_code;
  late num? voteAverage;
  late int? voteCount;

  Episode({this.id, this.poster, this.airDate, this.episodeNumber, this.name,
  this.overview, this.seasonNumber});

  Episode.fromJson(Map<String, dynamic> json){
  id=json['id'];
  airDate =json['air_date'];
  episodeNumber= json['episode_number'];
  name=json['name'];
  prod_code=json['production_code'];
  overview=json['overview'];
  poster=json['still_path'];
  seasonNumber=json['season_number'];
  voteCount=json['vote_count'];
  voteAverage=json['vote_average'];
  }


}