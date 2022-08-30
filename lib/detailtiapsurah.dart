import 'package:alquran/App/Data/Models/surah.dart';
import 'package:alquran/App/Data/Models/detailsurah.dart' as detail;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:convert';

import 'package:alquran/colors.dart';
import 'package:just_audio/just_audio.dart';

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

  static void playAudio(String? url) async {
    if (url != null) {
      try {
        final player = AudioPlayer();
        await player.setUrl(url);
        await player.play();
      } on PlayerException catch (e) {
        Get.defaultDialog(
            title: "terjadi Kesalahan", middleText: e.message.toString());
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
            title: "terjadi Kesalahan",
            middleText: "Connection aborted: ${e.message}");
        ;
      } catch (e) {
        Get.defaultDialog(
            title: "terjadi Kesalahan",
            middleText: "Tidak  Dapat Memutar Audioa");
      }
    } else {
      Get.defaultDialog(
          title: "terjadi Kesalahan", middleText: "Url Audio Salah");
    }
  }

  //
  final Surah surah = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: appWhite),
                  ),
                  Text("SURAH ${surah.name?.translation?.id?.toUpperCase()}",
                      style: TextStyle(fontSize: 14, color: appWhite)),
                  Text(
                      "SURAH ${surah.numberOfVerses} , Ayat ${surah.revelation?.id}",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder<detail.DetailSurah>(
              future:
                  _DetailTiapSurahState.getDetailSurah(surah.number.toString()),
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
                                color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      "${index + 1}",
                                      style: TextStyle(color: appPurpleDark),
                                    )),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.bookmark_add_outlined,
                                              color: appPurpleDark)),
                                      IconButton(
                                          onPressed: () {
                                            _DetailTiapSurahState.playAudio(
                                                ayat?.audio?.primary);
                                          },
                                          icon: Icon(
                                              Icons
                                                  .play_circle_outline_outlined,
                                              color: appPurpleDark))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  "${ayat?.text?.arab}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 30,
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      );
                    });
              })
        ],
      ),
    );
  }
}
