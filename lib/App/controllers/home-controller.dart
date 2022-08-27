import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HomeController extends GetxController {
  getAllSurah() async {
    Uri url = Uri.parse("https://al-quran-pearl.vercel.app/surah/");
    var res = await http.get(url);
    List data = (json.decode(res.body) as Map<String, dynamic>)["data"];
    print(data);
  }
}
