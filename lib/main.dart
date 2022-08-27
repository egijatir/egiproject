import 'package:alquran/colors.dart';
import 'package:alquran/landingpage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: themeLight,
      darkTheme: themeDark,
      debugShowCheckedModeBanner: false,
      home: landingpage(),
    );
  }
}
