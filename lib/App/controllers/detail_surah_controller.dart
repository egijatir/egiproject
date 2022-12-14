import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'dart:convert';
import 'package:alquran/App/Data/Models/detailsurah.dart';

class DetailSurahController extends GetxController {
  Future<DetailSurah?> getDetailSurah() async {
    Uri url = Uri.parse("https://al-quran-pearl.vercel.app/surah/");
    var res = await http.get(url);
    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];
    return DetailSurah.fromJson(data);
  }
}
