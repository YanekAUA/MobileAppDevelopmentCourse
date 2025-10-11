class FavoriteMovie {
  String _title;
  DateTime _releaseDate;

  FavoriteMovie(this._title, this._releaseDate);

  DateTime getReleaseDate() => _releaseDate;
  String getTitle() => _title;
  String toString() => '$_title - Released in ${_releaseDate}';
}

void main() {
  // List of favorite movies
  List<FavoriteMovie> favoriteMovies = [
    FavoriteMovie('Inception', DateTime(2010, 7, 16, 20, 0)),
    FavoriteMovie('The Matrix', DateTime(1999, 3, 31, 22, 0)),
    FavoriteMovie('Interstellar', DateTime(2014, 11, 7, 18, 0)),
  ];

  // Print movie titles with their release years
  for (var movie in favoriteMovies) {
    print(movie);
  }
}
