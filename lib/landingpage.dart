import 'package:alquran/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class landingpage extends StatefulWidget {
  const landingpage({Key? key}) : super(key: key);

  @override
  State<landingpage> createState() => _landingpageState();
}

class _landingpageState extends State<landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.only(
                  top: 100,
                ),
                child: Column(
                  children: [
                    Text(
                      "Quran App",
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("Learn Quran and Recite once everyday",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 50, left: 0),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 42, 2, 66),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0,
                      spreadRadius: 1,
                    )
                  ]),
              height: MediaQuery.of(context).size.width * 1.3,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 210, left: 19),
              child: Row(
                children: [],
              )),
          Container(
            margin: EdgeInsets.only(
              top: 220,
            ),
            child: Lottie.asset(
              "assets/ini.json",
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1.7,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: 560,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 97, 76, 10),
                      blurRadius: 10.0,
                      spreadRadius: 3,
                    )
                  ]),
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Center(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 190, 116, 12),
                  onPrimary: Color.fromARGB(255, 42, 2, 66),
                  shadowColor: Color.fromARGB(255, 42, 2, 66),
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  minimumSize: Size(400, 500), //////// HERE
                ),
                onPressed: () {
                  Get.to(Home());
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
