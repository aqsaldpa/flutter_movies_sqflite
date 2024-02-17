class Movies {
  int? id;
  String? title;
  String? director;
  String? summary;
  String? genres;

  Movies({this.id, this.title, this.director, this.summary, this.genres});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['director'] = director;
    map['summary'] = summary;
    map['genres'] = genres;

    return map;
  }

  Movies.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    director = map['director'];
    summary = map['summary'];
    genres = map['genres'];
  }
}
