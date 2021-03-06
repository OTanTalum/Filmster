import 'package:filmster/model/Episode.dart';
import 'package:filmster/model/Season.dart';
import 'package:filmster/model/search.dart';

class Film {
  bool? isAdult;
  String? title;
  String? backdrop;
  Map? toColection;
  int? budget;
  List? ganres = [];
  String? homepage;
  String? id;
  String? imdbId;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  String? popularity;
  String? poster;
  List<Company>? companies = [];
  List<Country>? countrys = [];
  String? release;
  int? revenue;
  int? runtime;
  List<Language>? spoken = [];
  String? status;
  String? tagline;
  bool? video;
  String? voteAverage;
  String? voteCount;
  String? type;
  List <Season>? seasons=[];
  int? numberOfEpisodes;
  int? numberOfSeasons;
  Episode? lastEpisode;
  Episode? nextEpisode;
  String? lastAirDate;
  List <String>? languages =[];
  bool? isInProduction;


  Film({
    this.title,
    this.isAdult,
    this.backdrop,
    this.toColection,
    this.budget,
    this.ganres,
    this.homepage,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.poster,
    this.companies,
    this.countrys,
    this.release,
    this.revenue,
    this.imdbId,
    this.runtime,
    this.spoken,
    this.status,
    this.tagline,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.type,
    this.seasons,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.lastEpisode,
    this.nextEpisode,
    this.lastAirDate,
    this.languages,
    this.isInProduction,
  });

  Film.fromJson(Map<String, dynamic> json) {
    if(json['title']!=null) {
      title = json['title'];
    }else {
      title = json['name'];
    }
    isAdult = json['adult'];
    backdrop = json['backdrop_path'];
    toColection = json['belongs_to_collection'];
    budget = json['budget'];
    if (json['genres'] != null)
      json['genres'].forEach((genre) => ganres!.add(genre));
    homepage = json['homepage'];
    id = json['id'].toString();
    imdbId = json['imdb_id'];
    originalLanguage = json['original_language'];

    if(json['original_title']!=null) {
      originalTitle = json['original_title'];
    } else{
    originalTitle = json['original_name'];
    }
    overview = json['overview'];
    popularity = json['popularity'].toString();
    poster = json['poster_path'];
    if (json['production_companies'] != null)
      json['production_companies']
          .forEach((element) => companies!.add(Company.fromJson(element)));
    if (json['production_countries'] != null)
      json['production_countries']
          .forEach((element) => countrys!.add(Country.fromJson(element)));
    if(json['release_date']!=null)
      release = json['release_date'];
    else {
      release = json['first_air_date'];
    }
    revenue = json['revenue'];
    if(json['runtime']!=null) {
      runtime = json['runtime'];
    }
    else if(json['episode_run_time']!=null && json['episode_run_time'].isNotEmpty){
      runtime = json['episode_run_time'].first;
    }
    if (json['spoken_languages'] != null)
      json['spoken_languages']
          .forEach((element) => spoken!.add(Language.fromJson(element)));
    status = json['status'];
    tagline = json['tagline'];
    video = json['video'];
    voteAverage = json['vote_average'].toString();
    voteCount = json['vote_count'].toString();

    ///Only for TV part
    ///
    ///

    type = json["type"];
    if(json['seasons']!=null&&json['seasons'].isNotEmpty) {
      json['seasons'].forEach((element){
      seasons?.add(Season.fromJson(element));
    });
    }
    numberOfSeasons=json['number_of_seasons'];
    numberOfEpisodes=json['number_of_episodes'];
    lastAirDate=json['last_air_date'];
    isInProduction=json['in_production'];
    if(json['languages']!=null&&json['languages'].isNotEmpty) {
      json['languages'].forEach((element){
        languages?.add(element);
      });
    }
    if(json['last_episode_to_air']!=null)
      lastEpisode = Episode.fromJson(json['last_episode_to_air']);
    if(json['next_episode_to_air']!=null)
      nextEpisode = Episode.fromJson(json['next_episode_to_air']);
  }

  SearchResults toSearchResults(){
    return SearchResults()
      ..id = int.parse(this.id!)
      ..popularity = double.parse(this.popularity!)
      ..voteCount = int.parse(this.voteCount!)
      ..poster = this.poster
      ..backdrop = this.backdrop
      ..language = this.originalLanguage
      ..ganres = this.ganres
      ..title = this.title
      ..originalTitle = this.originalTitle
      ..voteAverage = this.voteAverage
      ..overview = this.voteAverage
      ..release = this.release;
  }
}

class Company {
  String? id;
  String? logo;
  String? name;
  String? originalCountry;

  Company({
    this.id,
    this.logo,
    this.name,
    this.originalCountry,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    if (json['logo_path'] != null) {
      logo = json['logo_path'];
    }
    name = json['name'];
    originalCountry = json['origin_country'];
  }
}

class Country {
  String? code;
  String? name;

  Country({
    this.name,
    this.code,
  });

  Country.fromJson(Map<String, dynamic> json) {
    code = json['iso_3166_1'];
    name = json['name'];
  }
}

class Language {
  String? code;
  String? name;

  Language({
    this.name,
    this.code,
  });

  Language.fromJson(Map<String, dynamic> json) {
    code = json['iso_639_1'];
    name = json['name'];
  }
}
