class Poster{
  double aspectRatio;
  int height;
  int width;
  String filePath;
  double voteAverage;
  int voteCount;

  Poster({
    this.aspectRatio,
    this.height,
    this.width,
    this.voteAverage,
    this.voteCount,
    this.filePath
});

  Poster.fromJson(Map<String, dynamic> json){
    aspectRatio=json["aspect_ratio"];
    filePath= json["file_path"];
    height = json["height"];
    width = json['width'];
    voteCount = json["vote_count"];
    voteAverage = json['vote_average'];
  }
}