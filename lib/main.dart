import 'package:flutter/material.dart';
import 'package:gitgym/data/workout_data.dart';
import 'package:gitgym/pages/home_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //open a hive box
  await Hive.openBox("workout_database");

  //open a workout page
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        title: "GitGym",
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}
