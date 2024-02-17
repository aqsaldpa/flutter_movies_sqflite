// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:talennavi_posttest/data/database/db_helper.dart';
import 'package:talennavi_posttest/data/model/movies.dart';
import 'package:talennavi_posttest/screen/detail_movies.dart';
import 'package:talennavi_posttest/screen/widget/card_movies.dart';

class HomeListMovies extends StatefulWidget {
  const HomeListMovies({super.key});

  @override
  State<HomeListMovies> createState() => _HomeListMoviesState();
}

class _HomeListMoviesState extends State<HomeListMovies> {
  List<Movies> listMovies = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    super.initState();
    _getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Movies Collection"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextField(
              onChanged: (rslt) {
                _searchMovies(rslt);
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 228, 228, 228),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                hintText: "Search by title",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            listMovies.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: listMovies.length,
                        itemBuilder: (context, index) {
                          Movies movies = listMovies[index];
                          return InkWell(
                              onTap: () => _toEditMovies(movies),
                              child: CardMovies(
                                movies: listMovies[index],
                                func: () {
                                  _deleteMovies(listMovies[index], index);
                                },
                              ));
                        }),
                  )
                : const Text("Data Kosong")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toAddMovies();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getAllMovies() async {
    var list = await db.getAllMovies();
    setState(() {
      listMovies.clear();
      list!.forEach((movies) {
        listMovies.add(Movies.fromMap(movies));
      });
    });
  }

  Future<void> _toAddMovies() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DetailMoviesScreen()));
    if (result == "save") {
      await _getAllMovies();
    }
  }

  Future<void> _toEditMovies(Movies movies) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailMoviesScreen(movies: movies)));
    if (result == "update") {
      await _getAllMovies();
    }
  }

  Future<void> _deleteMovies(Movies movies, int position) async {
    await db.deleteMovies(movies.id!);
    setState(() {
      listMovies.removeAt(position);
    });
  }

  Future<void> _searchMovies(String title) async {
    var listSearch = await db.searchMovies(title);
    var list = await db.getAllMovies();
    if (title != '') {
      if (listSearch != null) {}
      setState(() {
        listMovies.clear();
        listSearch?.forEach((filter) {
          listMovies.add(Movies.fromMap(filter));
        });
      });
    } else {
      setState(() {
        listMovies.clear();
        list!.forEach((filter) {
          listMovies.add(Movies.fromMap(filter));
        });
      });
    }
  }
}
