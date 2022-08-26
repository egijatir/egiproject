import 'package:alquran/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appWhite = Color(0xFFFAF8FC);
const appLight = Color(0xFF9345F2);
const appOrange = Color(0xFFE6704A);

ThemeData appCerah = ThemeData(
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: appPurpleDark),
    brightness: Brightness.light,
    primaryColor: appPurple,
    scaffoldBackgroundColor: appWhite,
    appBarTheme: AppBarTheme(backgroundColor: appPurple),
    textTheme: TextTheme(
        bodyText1: TextStyle(color: appPurpleDark),
        bodyText2: TextStyle(color: appPurpleDark)));

ThemeData appDark = ThemeData(
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: appWhite),
    brightness: Brightness.dark,
    primaryColor: appPurple,
    scaffoldBackgroundColor: appPurpleDark,
    appBarTheme: AppBarTheme(backgroundColor: appPurpleDark),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: appWhite),
      bodyText2: TextStyle(color: appWhite),
    ));
