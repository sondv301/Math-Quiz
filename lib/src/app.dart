import 'package:flutter/material.dart';
import 'package:math_quiz/src/ui/home/view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Math Quiz',
      home: HomePage(),
    );
  }
}
