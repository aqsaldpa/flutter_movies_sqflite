// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:talennavi_posttest/data/model/movies.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  final String tableName = "table_movies";
  final String columnID = "id";
  final String columnTitle = "title";
  final String columnDirector = "director";
  final String columnSummary = "summary";
  final String columnGenres = "genres";

  DbHelper._internal();
  factory DbHelper() => _instance;

  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'movies.db');

    return await openDatabase(path, version: 2, onCreate: _oncreate);
  }

  Future<void> _oncreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnID INTEGER PRIMARY KEY, "
        "$columnTitle TEXT,"
        "$columnSummary TEXT,"
        "$columnDirector TEXT,"
        "$columnGenres TEXT )";

    await db.execute(sql);
  }

  Future<int> saveMovies(Movies movies) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, movies.toMap());
  }

  Future<List?> getAllMovies() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName, columns: [
      columnID,
      columnTitle,
      columnSummary,
      columnDirector,
      columnGenres,
    ]);
    return result.toList();
  }

  Future<int?> updateMovies(Movies movies) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, movies.toMap(),
        where: "$columnID = ?", whereArgs: [movies.id]);
  }

  Future<List?> searchMovies(String title) async {
    var dbClient = await _db;
    return await dbClient!
        .query(tableName, where: "$columnTitle = ?", whereArgs: [title]);
  }

  Future<int?> deleteMovies(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableName, where: "$columnID = ? ", whereArgs: [id]);
  }
}
