import 'dart:async';
import 'dart:convert';

class Film{
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writerdirector;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String posters;
  final List raiting;
  final String metasc;
  final String imdbR;
  final String imdbV;
  final String imdbid;
  final String type;
  final String dvd;
  final String boxOff;
  final String prod;
  final String website;


  Film({
    this.title,
    this.year,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writerdirector,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.posters,
    this.raiting,
    this.metasc,
    this.imdbR,
    this.imdbV,
    this.imdbid,
    this.type,
    this.dvd,
    this.boxOff,
    this.prod,
    this.website,
  });


  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      title: json['Title'],
      year: json['Year'],
      rated: json['Rated'],
      released: json['Released'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      director: json['Director'],
      writerdirector: json['Writer'],
      actors: json['Actors'],
      plot: json['Plot'],
      language: json['Language'],
      country: json['Country'],
      awards: json['Awards'],
      posters: json['Poster'],
      raiting: json['Ratings'],
      metasc: json['Metascore'],
      imdbR: json['imdbRating'],
      imdbV: json['imdbVotes'],
      imdbid: json['imdbID'],
      type: json['Type'],
      dvd: json['DVD'],
      boxOff: json['BoxOffice'],
      prod: json['Production'],
      website: json['Website'],
    );
  }
}