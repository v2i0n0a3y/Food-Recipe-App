import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:products_manager/nav_bar.dart';

import 'Dynamic/recipee.dart';
import 'Dynamic/vinay.dart';
import 'explore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}