// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:talennavi_posttest/data/model/movies.dart';

class CardMovies extends StatefulWidget {
  Movies movies;
  Function func;
  CardMovies({super.key, required this.movies, required this.func});

  @override
  State<CardMovies> createState() => _CardMoviesState();
}

class _CardMoviesState extends State<CardMovies> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movies.title ?? "-",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.movies.director ?? "-"),
            Text(widget.movies.summary ?? "-"),
            const SizedBox(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: Text(widget.movies.genres ?? "")),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text(
                              "Apakah anda yakin menghapus data ini?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Tidak")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.func.call();
                                },
                                child: const Text("Ya"))
                          ],
                        );
                      });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
