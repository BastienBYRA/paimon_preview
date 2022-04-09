import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paimon_preview/backup/boss.dart';
import 'package:paimon_preview/backup/characters.dart';
import 'package:paimon_preview/common/image.dart';
import 'package:paimon_preview/firebase.dart';
import 'package:paimon_preview/models/boss.dart';
import 'package:paimon_preview/models/character.dart';
import 'package:paimon_preview/pages/character_page.dart';
import 'package:paimon_preview/pages/boss_page.dart';

import '../services/impact_moe_API.dart';
import 'roulette_page.dart';
import 'package:firedart/firedart.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool connectionState = false;
  bool duringOperation = false;

  List<Character> listChar = [];

  ///Get ALL Characters
  List<Character> charactersDisplay = []; //Get ALL Characters to show
  List<Character> charactersPageDisplay =
      []; //Get ALL Characters to show to a SPECIFIC page
  List<String> charactersName = []; //Get NAME of ALL Characters

  //Know state about data
  bool dataLoadAPI = false;
  bool errorDataAPI = false;

  bool dataLoadBoss = false;
  bool errorDataBoss = false;

  //if the API doesn't work, use the data inside the app
  bool dataInsideApp = false;

  int pageIndex = 0;

  // List<dynamic> listBos2 = [];
  List<Boss> listBoss = [];

  late List<Widget> screen = [];

  bool reachEndChar = false;
  bool reachEndBoss = false;

  bool retryLoad = false;

  @override
  void initState() {
    tryConnection();
    loadDataCharacters();
    if (Platform.isWindows) {
      loadDataBossParticular();
    } else {
      loadDataBossNatural();
    }

    super.initState();
  }

  loadDataCharacters() async {
    dynamic dataJSON;
    try {
      await GenshinAPI.getCharacters().then((id) {
        dataJSON = (jsonDecode(id));
      });

      for (var i = 0; i < dataJSON.length; i++) {
        if ((dataJSON[i]['rarity'] != "") == true &&
            (dataJSON[i]['weapon'] != "") == true &&
            (dataJSON[i]['description'] != "") == true &&
            (dataJSON[i]['constellation'] != "") == true &&
            !dataJSON[i]['name'].toString().contains("Traveler")) {
          listChar.add(Character.fromMap(dataJSON[i]));
          charactersName.add(dataJSON[i]['name']);
        } else if (dataJSON[i]['name']
            .toString()
            .contains("Traveler (Anemo)")) {
          travelerCase(dataJSON[i]);
        }
      }
      charactersDisplay = listChar;
      setState(() {
        errorDataAPI = false;
        dataLoadAPI = true;
        reachEndChar = true;
      });
    } on Exception catch (_, e) {
      setState(() {
        errorDataAPI = true;
        reachEndBoss = true;
      });
    }
  }

  tryConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connectionState = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connectionState = false;
        errorDataAPI = true;
        errorDataBoss = true;
      });
    }
  }

  /// Load the data with FireDart, for the device not compatible with Firebase, like Windows
  loadDataBossParticular() async {
    try {
      int compteur = 0;

      /// To avoid problem if Firestore is already initialize
      try {
        Firestore.initialize(idProject);
      } catch (e) {}

      List<dynamic> temp =
          await Firestore.instance.collection("weeklyboss").get();

      temp.forEach((element) {
        Boss boss = Boss(
            id: compteur,
            name: element['name'],
            icon: element['icon'],
            image: element['image'],
            location: element['location'],
            map: element['map']);
        listBoss.add(boss);
        compteur++;
      });

      setState(() {
        errorDataBoss = false;
        dataLoadBoss = true;
        listBoss;
        // screen;
        reachEndBoss = true;
      });
    } catch (e) {
      setState(() {
        errorDataBoss = true;
        dataLoadBoss = false;
        reachEndBoss = true;
      });
    }
  }

  //Load the firebase data
  loadDataBossNatural() async {
    int compteur = 0;
    try {
      await FirebaseFirestore.instance
          .collection('weeklyboss')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Boss boss = Boss(
              id: compteur,
              name: doc['name'],
              icon: doc['icon'],
              image: doc['image'],
              location: doc['location'],
              map: doc['map']);
          listBoss.add(boss);
          compteur++;
        });
      });

      setState(() {
        errorDataBoss = false;
        dataLoadBoss = true;
        listBoss;
        // screen;
        reachEndBoss = true;
      });
    } catch (e) {
      setState(() {
        errorDataBoss = true;
        dataLoadBoss = false;
        reachEndBoss = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: (errorDataAPI == false &&
                errorDataBoss == false &&
                reachEndBoss == true &&
                reachEndChar == true)
            ? AppBar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: (pageIndex == 0)
                    ? Text("Character")
                    : (pageIndex == 1)
                        ? Text("Spinner")
                        : Text("Boss"),
              )
            : null,
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/navbar/character.png"),
                ),
                label: "Character",
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/navbar/wheel.png"),
                ),
                label: "Spinner",
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/navbar/boss2.png"),
                ),
                label: "Boss",
              ),
            ],
            currentIndex: pageIndex,
            onTap: (index) => setState(() {
                  pageIndex = index;
                })),
        body: ((reachEndBoss == false ||
                reachEndChar == false ||
                retryLoad == true)
            ? loadingDataPage()
            : (errorDataAPI == true ||
                    connectionState == false ||
                    errorDataBoss == true)
                ? dataFailedPage(heightScreen, widthScreen)
                : (reachEndBoss == true && reachEndChar == true)
                    ? IndexedStack(
                        index: pageIndex,
                        children: [
                          CharacterPage(listChar, dataInsideApp),
                          RoulettePage(listChar, dataInsideApp, listBoss),
                          BossPage(listBoss)
                        ],
                      )
                    : loadingDataPage()));
  }

  Widget loadingDataPage() => SafeArea(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loadingDataElement(),
          SizedBox(
            height: 10,
          ),
          Text("Paimon fishing for data, wait !")
        ],
      )));

  Widget dataFailedPage(double heightScreen, double widthScreen) => Center(
          child: SingleChildScrollView(
              child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Image.asset(
                  'assets/paimon/paimon-confuse.gif',
                  height: heightScreen * 0.30,
                  width: widthScreen * 0.80,
                ),
              ),
              SizedBox(height: 10),
              (connectionState == false)
                  ? Text(
                      "Please, connect to internet to proceed with the latest data.",
                      textAlign: TextAlign.center,
                    )
                  : (errorDataAPI == true && errorDataBoss == false)
                      ? Text(
                          "An error occured during the request to the API (impact.moe).",
                          textAlign: TextAlign.center,
                        )
                      : (errorDataAPI == false && errorDataBoss == true)
                          ? Text(
                              "An error occured during the request to the Firebase database.",
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "An error occured during the request to the API (impact.moe) and the Firebase database.",
                              textAlign: TextAlign.center,
                            ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      retryLoad = true;
                      reachEndChar = false;
                      reachEndBoss = false;

                      (connectionState == false) ? tryConnection() : null;
                      (errorDataAPI == true) ? loadDataCharacters() : null;
                      if (Platform.isWindows) {
                        (errorDataBoss == true)
                            ? loadDataBossParticular()
                            : null;
                      } else {
                        (errorDataBoss == true) ? loadDataBossNatural() : null;
                      }

                      retryLoad = false;
                    });
                  },
                  child: Text("Retry")),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      reachEndChar = false;
                      reachEndBoss = false;
                      connectionState = true;

                      retryLoad = true;

                      (errorDataAPI == true)
                          ? loadDataInsideAppCharacters()
                          : null;
                      (errorDataBoss == true)
                          ? loadDataInsideAppCharacters()
                          : null;
                      retryLoad = false;
                    });
                  },
                  child: Text("Use data inside the application (1.0 to 2.5)"))
            ]),
      )));

  errorMessage() {
    final snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Data failed to load !",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: (Colors.red.shade300));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  travelerCase(dynamic data) {
    Character traveler = Character.fromMap(data);
    traveler.name = "Traveler";
    traveler.element = "All";
    traveler.region = null;
    listChar.add(traveler);
  }

  loadDataInsideAppCharacters() async {
    listChar.clear();

    dynamic dataJSON = characterjson;
    dataJSON = jsonEncode(dataJSON);
    dataJSON = jsonDecode(dataJSON);

    try {
      for (var i = 0; i < dataJSON.length; i++) {
        if ((dataJSON[i]['icon'] != "") == true &&
            !dataJSON[i]['name'].toString().contains("Traveler") &&
            !dataJSON[i]['name'].toString().contains("Paimon")) {
          listChar.add(Character.fromMap(dataJSON[i]));
          charactersName.add(dataJSON[i]['name']);
        } else if (dataJSON[i]['name']
            .toString()
            .contains("Traveler (Anemo)")) {
          travelerCase(dataJSON[i]);
        }
      }

      charactersDisplay = listChar;
      dataInsideApp = true;
      setState(() {
        errorDataAPI = false;
        dataLoadAPI = true;
        dataInsideApp = true;
        reachEndChar = true;
      });
    } on Exception catch (_, e) {
      setState(() => errorDataAPI = true);
    }
  }

  loadDataInsideAppBoss() async {
    listBoss.clear();

    dynamic dataJSON = bossJSON;
    dataJSON = jsonEncode(dataJSON);
    dataJSON = jsonDecode(dataJSON);

    int compteur = 0;

    try {
      dataJSON.forEach((element) {
        Boss boss = Boss(
            id: compteur,
            name: element['name'],
            icon: element['icon'],
            image: element['image'],
            location: element['location'],
            map: element['map']);
        listBoss.add(boss);
        compteur++;
      });
      setState(() {
        errorDataBoss = false;
        dataLoadBoss = true;
        listBoss;
        screen;
        reachEndBoss = true;
      });
    } catch (e) {
      setState(() {
        errorDataBoss = true;
        dataLoadBoss = false;
      });
    }
  }
}
