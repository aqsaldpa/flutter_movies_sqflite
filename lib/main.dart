import 'package:flutter/material.dart';
import 'package:talennavi_posttest/screen/home_list_movies.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Post Test TalentNavi",
      home: HomeListMovies(),
    );
  }
}
