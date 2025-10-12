/*
Create an application to calculate your final grade based on criteria mentioned in Syllabus.
Participation and attendance (10%) (will be graded 0-100)
4 Homework assignments (20%) (each homework will be graded 0-100)
Group Presentation (10%) (will be graded 0-100)
Midterm Exam 1 10% (will be graded 0-100)
Midterm Exam 2 20% (will be graded 0-100)
Final Project (30%) (will be graded 0-100)
Screenshot attached as a sample, feel free to change UI ( and create better one :) 
By Default all values are 100 and user can change any value, when user tap CALCULATE result should be calculated and shown, user can add 4 homework grades, and reset added homework grades.
To get a 100 grade.
Language Dart only.
Correct working solution without crashes, with handled edge cases.
High quality of code.
It is beneficial,
 to create a little bit complex UI component for homework with add/remove buttons.
To save results in memory (Database, File, Preferences), the user will not need to input values after killing and reopening the application. (shared_preferences, Hive)
*/

import 'package:flutter/material.dart';

import 'src/views/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized before using plugins
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Grade Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
