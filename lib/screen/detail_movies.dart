// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:talennavi_posttest/data/database/db_helper.dart';
import 'package:talennavi_posttest/data/model/movies.dart';

class DetailMoviesScreen extends StatefulWidget {
  final Movies? movies;
  const DetailMoviesScreen({super.key, this.movies});

  @override
  State<DetailMoviesScreen> createState() => _DetailMoviesScreenState();
}

class _DetailMoviesScreenState extends State<DetailMoviesScreen> {
  DbHelper db = DbHelper();
  final titleController = TextEditingController();
  final directorController = TextEditingController();
  final summaryController = TextEditingController();

  List<String> listGenres = [
    "Action",
    "Animation",
    "Drama",
    "Sci-Fi",
  ];

  List<String> selectedGenres = [];

  Future<void> updateInsertMovies() async {
    if (widget.movies != null) {
      await db.updateMovies(Movies.fromMap({
        'id': widget.movies?.id,
        'title': titleController.text,
        'director': directorController.text,
        'summary': summaryController.text,
        'genres': selectedGenres.join(",")
      }));
      Navigator.pop(context, "update");
    } else {
      await db.saveMovies(Movies(
        title: titleController.text,
        director: directorController.text,
        summary: summaryController.text,
        genres: selectedGenres.join(","),
      ));
      Navigator.pop(context, "save");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.movies != null) {
      titleController.text = widget.movies?.title ?? "";
      summaryController.text = widget.movies?.summary ?? "";
      directorController.text = widget.movies?.director ?? "";
      var genres = widget.movies?.genres ?? '';
      var existinggenres = genres.split(",");
      selectedGenres = existinggenres;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Detail Movies"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              filled: true,
              hintText: "Title",
              fillColor: Color.fromARGB(255, 228, 228, 228),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: directorController,
            decoration: const InputDecoration(
              filled: true,
              hintText: "Director",
              fillColor: Color.fromARGB(255, 228, 228, 228),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: summaryController,
            maxLines: 4,
            maxLength: 100,
            decoration: const InputDecoration(
              filled: true,
              hintText: "Summary",
              fillColor: Color.fromARGB(255, 228, 228, 228),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(children: _buildChoiceList()),
          ElevatedButton(
            onPressed: () {
              _clickButton();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(
              widget.movies != null ? "Update" : "Save",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in listGenres) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Colors.green,
          label: Text(item),
          selected: selectedGenres.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedGenres.contains(item)
                  ? selectedGenres.remove(item)
                  : selectedGenres.add(item);
            });
          },
        ),
      ));
    }
    return choices;
  }

  _clickButton() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Isi Judul Terlebih dahulu")));
    } else if (directorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Isi Director Terlebih dahulu")));
    } else if (summaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Isi Summary Terlebih dahulu")));
    } else if (selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih Genres Terlebih dahulu")));
    } else {
      updateInsertMovies();
    }
  }
}
