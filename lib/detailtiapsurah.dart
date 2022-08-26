import 'package:alquran/App/Data/Models/surah.dart';
import 'package:alquran/App/Data/Models/detailsurah.dart' as detail;
import 'package:alquran/detailtiapsurah.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:alquran/App/controllers/home-controller.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:alquran/App/controllers/detail_surah_controller.dart';
import 'package:alquran/colors.dart';

class DetailTiapSurah extends StatefulWidget {
  const DetailTiapSurah({Key? key}) : super(key: key);

  @override
  State<DetailTiapSurah> createState() => _DetailTiapSurahState();
}

class _DetailTiapSurahState extends State<DetailTiapSurah> {
  static Future<detail.DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://al-quran-pearl.vercel.app/surah/$id");
    var res = await http.get(url);
    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];
    return detail.DetailSurah.fromJson(data);
  }

  final Surah surah = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SURAH ${surah.name?.transliteration?.id?.toUpperCase()}"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [appLight, appPurple]),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "SURAH ${surah.name?.transliteration?.id?.toUpperCase()}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("SURAH ${surah.name?.translation?.id?.toUpperCase()}",
                      style: TextStyle(fontSize: 14)),
                  Text(
                      "SURAH ${surah.numberOfVerses} , Ayat ${surah.revelation}",
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: FutureBuilder<detail.DetailSurah>(
                  future: _DetailTiapSurahState.getDetailSurah(
                      surah.number.toString()),
                  builder: (context, Snapshot) {
                    if (Snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!Snapshot.hasData) {
                      return Text("Ga ada Data");
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Snapshot.data?.verses?.length ?? 0,
                        itemBuilder: (contex, index) {
                          detail.Verse? ayat = Snapshot.data?.verses?[index];
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Get.isDarkMode
                                        ? appPurpleDark
                                        : Colors.black),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        decoration: BoxDecoration(
                                            color: appWhite,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/oct.png"))),
                                        child: Text("${index + 1}"),
                                      ),
                                      // CircleAvatar(
                                      //
                                      // ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  Icons.bookmark_add_outlined)),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons
                                                  .play_circle_outline_outlined))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                "${ayat?.text?.arab}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "${ayat?.text?.transliteration?.en}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "${ayat?.translation?.id}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          );
                        });
                  }))
        ],
      ),
    );
  }
}
