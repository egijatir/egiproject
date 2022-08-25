import 'dart:async';
import 'package:alquran/App/Data/Models/surah.dart';
import 'package:alquran/detailtiapsurah.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:alquran/App/controllers/home-controller.dart';
import 'package:get/get.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Al Quran App"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        backgroundColor: Color.fromARGB(255, 42, 2, 66),
      ),
      backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamualaikum",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.purpleAccent, Colors.deepPurple]),
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
                                width: 150,
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
                                            color: Colors.white, fontSize: 20)),
                                  ],
                                ),
                                SizedBox(height: 0),
                                Text(
                                  "Al-Fatihah",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Jus 2 , Ayat 5",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: Color.fromARGB(255, 42, 2, 66),
                  unselectedLabelColor: Colors.grey,
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
                          child: CircularProgressIndicator(),
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
                                Get.to(DetailTiapSurah(), arguments: surah);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Color.fromARGB(255, 42, 2, 66),
                                child: Text("${surah.number}"),
                              ),
                              title: Text(
                                "${surah.name?.transliteration?.id ?? ''}",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                  "${surah.numberOfVerses} Ayat ╽ ${surah.revelation?.id}",
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text("${surah.name?.short}",
                                  style: TextStyle(color: Colors.white)),
                            );
                          });
                    }),
                Text("data"),
                Text("data")
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
