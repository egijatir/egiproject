import 'package:alquran/App/Data/Models/surah.dart';
import 'package:alquran/App/Data/Models/detailsurah.dart' as detail;
import 'package:alquran/detailtiapsurah.dart';
import 'package:alquran/App/Data/Models/juz.dart' as juz;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:alquran/App/controllers/home-controller.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:alquran/App/controllers/detail_surah_controller.dart';
import 'package:alquran/colors.dart';

class DetailTiapJuz extends StatefulWidget {
  const DetailTiapJuz({Key? key}) : super(key: key);

  @override
  State<DetailTiapJuz> createState() => _DetailTiapJuzState();
}

class _DetailTiapJuzState extends State<DetailTiapJuz> {
  final juz.Juz semuajuz = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Juz ${semuajuz.juz}"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: semuajuz.verses?.length ?? 0,
        itemBuilder: (context, index) {
          juz.Verses ayat = semuajuz.verses![index];
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                          "assets/oct.png",
                        ))),
                        child: Center(
                            child: Text(
                          "${ayat.number?.inSurah}",
                          style: TextStyle(color: appPurpleDark),
                        )),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.bookmark_add_outlined,
                                  color: appPurpleDark)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.play_circle_outline_outlined,
                                  color: appPurpleDark))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "${ayat?.text?.arab}",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "${ayat?.text?.transliteration?.en}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "${ayat?.translation?.id}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
