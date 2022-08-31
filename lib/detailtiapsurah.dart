import 'dart:async';
import 'package:alquran/App/Data/Models/surah.dart';
import 'package:alquran/App/Data/Models/detailsurah.dart' as detail;
import 'package:alquran/App/Data/db/bookmark.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:alquran/colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';

class DetailTiapSurah extends StatefulWidget {
  const DetailTiapSurah({Key? key}) : super(key: key);

  @override
  State<DetailTiapSurah> createState() => _DetailTiapSurahState();
}

class _DetailTiapSurahState extends State<DetailTiapSurah> {
  static RxString kondisiAudio = "stop".obs;
  final player = AudioPlayer();
  static Future<detail.DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://al-quran-pearl.vercel.app/surah/$id");
    var res = await http.get(url);
    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];
    return detail.DetailSurah.fromJson(data);
  }

  DatabaseManager database = DatabaseManager.instance;
  void addBookmark(bool TerakhirDibaca, detail.DetailSurah surah,
      detail.Verse ayat, int indexAyat) async {
    Database db = await database.db;
    bool flagExist = false;
    if (TerakhirDibaca == true) {
      await db.delete("bookmark", where: "last_read= 1");
    } else {
      List checkData = await db.query("bookmark",
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "")}' and ayat=${ayat.number!.inSurah!} and juz=${ayat.meta!.juz!} and via='surah' and index_ayat=$indexAyat and last_read=0");
      if (checkData.length != 0) {
        flagExist = true;
      }
    }
    if (flagExist == false) {
      await db.insert(
        "bookmark",
        {
          "surah": "${surah.name!.transliteration!.id!.replaceAll("'", "")}",
          "ayat": ayat.number!.inSurah!,
          "juz": ayat.meta!.juz!,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": TerakhirDibaca == true ? 1 : 0
        },
      );
      Get.back();
      Get.snackbar("Berhasil", "Berhasil Menambahkan");
    } else {
      Get.back();
      Get.snackbar("Gagal", "Surah Sudah DiTambahkan Sebelumnya");
    }
    var data = await db.query("bookmark");
    print(data);
  }

  void pauseAudio() async {
    try {
      await player.pause();
      kondisiAudio.value = "pause";
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "${e.message}");
      ;
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Tidak  Dapat Memutar Audio");
    }
  }

  void stopAudio() async {
    try {
      await player.stop();
      kondisiAudio.value = "stop";
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "${e.message}");
      ;
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Tidak  Dapat Memutar Audio");
    }
  }

  void resumeAudio() async {
    try {
      kondisiAudio.value = "playing";
      await player.play();
      kondisiAudio.value = "stop";
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "${e.message}");
      ;
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Tidak  Dapat Memutar Audio");
    }
  }

  void playAudio(String? url) async {
    if (url != null) {
      try {
        await player.stop();
        await player.setUrl(url);
        kondisiAudio.value = "playing";
        await player.play();
        kondisiAudio.value = "stop";
        await player.stop();
      } on PlayerException catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan", middleText: e.message.toString());
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan", middleText: "${e.message}");
        ;
      } catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan",
            middleText: "Tidak  Dapat Memutar Audio");
      }
    } else {
      Get.defaultDialog(
          title: "terjadi Kesalahan", middleText: "Url Audio Salah");
    }
    @override
    void onClosed() {
      player.stop();
      player.dispose();
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
                    child: CircularProgressIndicator(
                      color: Get.isDarkMode ? appWhite : Colors.black,
                    ),
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
                                  Obx(
                                    () => Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Get.defaultDialog(
                                                  title: "BookMark",
                                                  middleText:
                                                      "Pilih Jenis BookMark",
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        addBookmark(
                                                            true,
                                                            Snapshot.data!,
                                                            ayat!,
                                                            index);
                                                      },
                                                      child: Text(
                                                          "Terakhir Dibaca"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  appPurple),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        addBookmark(
                                                            false,
                                                            Snapshot.data!,
                                                            ayat!,
                                                            index);
                                                      },
                                                      child: Text("BookMark"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  appPurple),
                                                    )
                                                  ]);
                                            },
                                            icon: Icon(
                                                Icons.bookmark_add_outlined,
                                                color: appPurpleDark)),
                                        (_DetailTiapSurahState
                                                    .kondisiAudio.value ==
                                                "stop")
                                            ? IconButton(
                                                onPressed: () {
                                                  playAudio(
                                                      ayat?.audio?.primary);
                                                },
                                                icon: Icon(
                                                    Icons
                                                        .play_circle_outline_outlined,
                                                    color: appPurpleDark))
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (_DetailTiapSurahState
                                                              .kondisiAudio
                                                              .value ==
                                                          "playing")
                                                      ? IconButton(
                                                          onPressed: () {
                                                            pauseAudio();
                                                          },
                                                          icon: Icon(
                                                              Icons.pause,
                                                              color:
                                                                  appPurpleDark))
                                                      : IconButton(
                                                          onPressed: () {
                                                            resumeAudio();
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .play_circle_outline_outlined,
                                                              color:
                                                                  appPurpleDark)),
                                                  IconButton(
                                                      onPressed: () {
                                                        stopAudio();
                                                      },
                                                      icon: Icon(Icons.stop,
                                                          color:
                                                              appPurpleDark)),
                                                ],
                                              ),
                                      ],
                                    ),
                                  )
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
