import 'dart:async';
import 'package:alquran/App/Data/Models/surah.dart';
import 'package:alquran/App/Data/Models/juz.dart' as juz;
import 'package:alquran/App/Data/db/bookmark.dart';
import 'package:alquran/colors.dart';
import 'package:alquran/detailtiapjuz.dart';
import 'package:alquran/detailtiapsurah.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse("https://al-quran-pearl.vercel.app/surah/");
    var res = await http.get(url);
    List? data = (json.decode(res.body) as Map<String, dynamic>)["data"];
    if (data == null || data.isEmpty) {
      return [];
    } else {
      return data.map((e) => Surah.fromJson(e)).toList();
    }
  }

  static Future<List<juz.Juz>> getAllJuz() async {
    List<juz.Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      Uri url = await Uri.parse("https://al-quran-pearl.vercel.app/juz/${i}");

      var res = await http.get(url);
      Map<String, dynamic> data =
          (json.decode(res.body) as Map<String, dynamic>)["data"];
      juz.Juz juzi = juz.Juz.fromJson(data);
      allJuz.add(juzi);
    }
    return allJuz;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Al Quran App"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        //  ,
      ),
      // backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamualaikum",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<Map<String, dynamic>?>(
                future: Homeee().getLastRead(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [appLight, appPurple]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.16,
                            width: MediaQuery.of(context).size.width * 1,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 40),
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: Image.asset(
                                        "assets/quran.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.menu_book_rounded,
                                                color: Colors.white,
                                              )),
                                          Text("Terakhir Di Baca",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: 0),
                                      Text(
                                        "Loading .....",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    ;
                  }
                  Map<String, dynamic>? lastRead = snapshot.data;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [appLight, appPurple]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {},
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: Image.asset(
                                      "assets/quran.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.menu_book_rounded,
                                              color: Colors.white,
                                            )),
                                        Text("Terakhir Di Baca",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                      ],
                                    ),
                                    SizedBox(height: 0),
                                    if (lastRead != null)
                                      Text(
                                        "${lastRead['surah']}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    Text(
                                      lastRead == null
                                          ? "Belum Ada Data"
                                          : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              TabBar(
                  indicatorColor: Color.fromARGB(255, 42, 2, 66),
                  unselectedLabelColor: Colors.grey,
                  labelColor: Get.isDarkMode ? appWhite : Colors.black,
                  tabs: [
                    Tab(
                      text: "Surah",
                    ),
                    Tab(
                      text: "Juz",
                    ),
                    Tab(
                      text: "Bookmark",
                    ),
                  ]),
              Expanded(
                  child: TabBarView(children: [
                FutureBuilder<List<Surah>>(
                    future: _HomeState.getAllSurah(),
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
                          itemCount: Snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = Snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.to(() => (DetailTiapSurah()),
                                    arguments: surah);
                              },
                              leading: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/oct.png"))),
                                child: Center(
                                    child: Text(
                                  "${surah.number}",
                                  style: TextStyle(
                                      color: Get.isDarkMode
                                          ? appWhite
                                          : Colors.black),
                                )),
                              ),
                              title: Text(
                                "${surah.name?.transliteration?.id ?? ''}",
                                style: TextStyle(),
                              ),
                              subtitle: Text(
                                  "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
                                  style: TextStyle()),
                              trailing: Text("${surah.name?.short}",
                                  style: TextStyle()),
                            );
                          });
                    }),
                FutureBuilder<List<juz.Juz>>(
                  future: _HomeState.getAllJuz(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Get.isDarkMode ? appWhite : Colors.black,
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Text("Missing Data");
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          juz.Juz semuajuz = snapshot.data![index];
                          return ListTile(
                            onTap: () {
                              Get.to(() => (DetailTiapJuz()),
                                  arguments: semuajuz);
                            },
                            leading: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/oct.png"))),
                              child: Center(
                                  child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    color: Get.isDarkMode
                                        ? appWhite
                                        : Colors.black),
                              )),
                            ),
                            title: Text(
                              "Juz ${index + 1}",
                              textAlign: TextAlign.left,
                              style: TextStyle(),
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mulai Dari ${semuajuz.juzStartInfo}",
                                    style: TextStyle()),
                                Text("Sampai Dengan ${semuajuz.juzEndInfo}",
                                    style: TextStyle()),
                              ],
                            ),
                          );
                        });
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: Homeee().getBookmark(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data?.length == 0) {
                      return Center(
                        child: Text("BookMark Belum Tersedia"),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data![index];
                        return ListTile(
                          onTap: () {
                            print(index);
                          },
                          leading: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/oct.png"))),
                            child: Center(
                                child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                  color:
                                      Get.isDarkMode ? appWhite : Colors.black),
                            )),
                          ),
                          // leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text("${data['surah']}"),
                          subtitle:
                              Text("Ayat ${data['ayat']} | Juz ${data['juz']}"),
                          trailing: IconButton(
                              onPressed: () {
                                Homeee().deleteBookmark(data['id']);
                              },
                              icon: Icon(Icons.delete)),
                        );
                      },
                    );
                  },
                ),
              ]))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.isDarkMode
              ? Get.changeTheme(themeDark)
              : Get.changeTheme(themeLight);
        },
        child: Icon(
          Icons.color_lens,
          color: Get.isDarkMode ? appPurpleDark : appWhite,
        ),
      ),
    );
  }
}

class Homeee extends GetxController {
  DatabaseManager database = DatabaseManager.instance;
  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allbookmarks =
        await db.query("bookmark", where: "last_read == 0");
    return allbookmarks;
  }

  deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    Get.snackbar("Berhasil", "Berhasil Menghapus");
    update();
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read == 1");
    if (dataLastRead.length == 0) {
      return null;
    } else {}
    return dataLastRead.first;
  }
}
