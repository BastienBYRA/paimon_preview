// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:paimon_preview/common/image.dart';
import 'package:paimon_preview/models/boss.dart';
import 'package:paimon_preview/models/character.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:paimon_preview/models/team.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RoulettePage extends StatefulWidget {
  RoulettePage(this.listChar, this.dataInsideApp, this.listBoss, {Key? key})
      : super(key: key);

  List<Character> listChar;
  bool dataInsideApp;
  List<Boss> listBoss;

  @override
  _RoulettePageState createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage> {
  StreamController<int> controller = StreamController<int>.broadcast();
  StreamController<int> controllerBoss = StreamController<int>.broadcast();
  ScrollController _scrollController = ScrollController();
  ScrollController _mainScrollController = ScrollController();
  int nbTeam = 0;

  //List character the user have in game
  List<Character> haveCharacter = [];
  //List character the user can obtain in the wheel
  List<Character> rollCharacter = [];
  //Show the current team in a ListView
  List<Character> currentTeam = [];

  List<Boss> haveBoss = [];
  List<Boss> rollBoss = [];
  Boss currentBoss = Boss();
  bool bossSelected = false;

  bool loadData = false;

  bool pickBoss = false;

  bool wheelPage = true;
  bool clickButton = false;

  int value = 0;

  bool pickAllOrNothing = true;

  // Team actualTeam = Team(team: []);
  List<Team> listTeam = [];
  bool showMore = false;
  bool btnShowMore = false;

  bool switchEverything = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.listChar.forEach((element) {
        element.rarity != 0 ? haveCharacter.add(element) : null;
      });
      rollCharacter = List.from(haveCharacter);

      haveBoss = widget.listBoss;
      rollBoss = List.from(haveBoss);

      loadData = true;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
        // backgroundColor: Colors.grey[100],
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          // animatedIcon: ,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          children: [
            SpeedDialChild(
                child: (wheelPage == true)
                    ? Icon(Icons.check_box)
                    : Icon(Icons.circle),
                label: (wheelPage == true) ? "Character" : "Spinner",
                onTap: () {
                  setState(() {
                    wheelPage = !wheelPage;
                  });
                }),
            SpeedDialChild(
                child: Icon(Icons.restart_alt),
                label: "Reset the spinner",
                onTap: () {
                  setState(() {
                    rollCharacter = List.from(haveCharacter);
                    currentTeam.clear();
                  });
                }),
            // SpeedDialChild(
            //     child: (pickBoss == false)
            //         ? Icon(Icons.groups)
            //         : Icon(Icons.person),
            //     label: (pickBoss == false) ? "Pick 1 boss" : "Pick 1 character",
            //     onTap: () {
            //       setState(() {
            //         pickBoss = !pickBoss;
            //       });
            //     }),
          ],
        ),
        body: (loadData == false)
            ? SafeArea(
                child: Center(
                child: SpinKitFoldingCube(
                  color: Colors.black,
                  size: 50.0,
                ),
              ))

            //Page wheel characters for mobile and tiny computer screen
            : (wheelPage == true && pickBoss == false && widthScreen < 1000)
                ? SafeArea(
                    child: Center(
                        child: SingleChildScrollView(
                            controller: _mainScrollController,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (rollCharacter.length > 1)
                                    ? wheelCharacters(heightScreen)
                                    : Text("Need at least two characters !"),
                                SizedBox(height: 15),
                                (btnShowMore == true)
                                    ? showMoreButton()
                                    : Container(),
                                currentTeamCharacter(widthScreen),
                                (listTeam.isNotEmpty && showMore == true)
                                    ? previousTeam(widthScreen)
                                    : Container(),
                              ],
                            ))))

                //Page wheel characters for normal computer screen
                : (wheelPage == true &&
                        pickBoss == false &&
                        widthScreen >= 1000)
                    ? SafeArea(
                        child: Row(children: [
                        Expanded(
                            child: Container(
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (rollCharacter.length > 1)
                                  ? wheelCharacters(heightScreen)
                                  : Text("Need at least two characters !"),
                              SizedBox(height: 10),
                              currentTeamCharacter(widthScreen)
                            ],
                          ),
                        )),
                        VerticalDivider(),
                        Container(
                            width: widthScreen * 0.40,
                            child: SingleChildScrollView(
                              child: Column(children: [
                                // SizedBox(height: 20),
                                Text("Previous team"),
                                (listTeam.isNotEmpty)
                                    ? previousTeam(widthScreen)
                                    : Column(children: [
                                        SizedBox(height: 20),
                                        Text("There are no team")
                                      ]),
                              ]),
                            ))
                      ]))

                    //Screen Boss selection
                    // : (wheelPage == true &&
                    //         pickBoss == true &&
                    //         widthScreen >= 1000)
                    //     ? SafeArea(
                    //         child: Row(children: [
                    //         Expanded(
                    //             child: Container(
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               (rollCharacter.length > 1)
                    //                   ? wheelBoss(heightScreen)
                    //                   : Text("No data about characters"),
                    //               SizedBox(height: 10),
                    //               (bossSelected == true)
                    //                   ? currentTeamBoss(widthScreen)
                    //                   : Container()
                    //             ],
                    //           ),
                    //         )),
                    //         VerticalDivider(),
                    //         Container(
                    //             // color: Colors.blue,
                    //             width: widthScreen * 0.40,
                    //             child: SingleChildScrollView(
                    //               child: Column(children: [
                    //                 // SizedBox(height: 20),
                    //                 Text("Previous team & Boss"),
                    //                 (listTeam.isNotEmpty)
                    //                     ? previousTeam(widthScreen)
                    //                     : Column(children: [
                    //                         SizedBox(height: 20),
                    //                         Text("There are no team or Boss")
                    //                       ]),
                    //               ]),
                    //             ))
                    //       ]))
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Container(
                          child: Column(children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: ListTile(
                              title: (switchEverything == true)
                                  ? Text("Disable all characters")
                                  : Text("Enable all characters"),
                              trailing: CupertinoSwitch(
                                value: (switchEverything),
                                onChanged: (value) {
                                  setState(() {
                                    (value == false)
                                        ? switchToFalseAll()
                                        : switchToTrueAll();
                                    switchEverything = !switchEverything;
                                  });
                                },
                              ),
                            )),
                            Divider(),
                            for (var i = 0;
                                i < widget.listChar.length;
                                i++) ...[
                              (widget.listChar[i].rarity != 0)
                                  ? ListTile(
                                      leading: SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Image.network(
                                            widget.listChar[i].icon.toString(),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return iconError();
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                  child: loadingDataElement());
                                            },
                                            height: 60,
                                            width: 60,
                                          )),
                                      title: Text(
                                          widget.listChar[i].name.toString()),
                                      trailing: CupertinoSwitch(
                                        value: (haveCharacter
                                            .contains(widget.listChar[i])),
                                        onChanged: (value) {
                                          setState(() {
                                            (value == false)
                                                ? switchToTrue(i)
                                                : switchToFalse(i);
                                          });
                                        },
                                      ))
                                  : Container(),
                              (widget.listChar[i].rarity != 0)
                                  ? Divider()
                                  : Container(),
                            ],
                            SizedBox(
                              height: 75,
                            )
                          ]),
                        ),
                      ));
  }

  Widget wheelCharacters(double heightScreen) => Column(
        children: [
          Container(
            height: heightScreen * 0.40,
            child: FortuneWheel(
              onAnimationEnd: () {
                setState(() {
                  if (rollCharacter.length <= 2) {
                    if (currentTeam.length < 4) {
                      currentTeam.add(rollCharacter[value]);
                      rollCharacter = List.from(haveCharacter);
                    } else {
                      listTeam.add(Team.addListCharacter(currentTeam));
                      currentTeam.clear();
                      currentTeam.add(rollCharacter[value]);
                      btnShowMore = true;
                      rollCharacter = List.from(haveCharacter);
                    }

                    const snackBar = SnackBar(
                      content: Text(
                          'Stay only one character, reset the spinner.',
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: Colors.white,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (currentTeam.length < 4) {
                    setState(() {
                      currentTeam.add(rollCharacter[value]);
                      rollCharacter.remove(rollCharacter[value]);
                    });
                  } else {
                    setState(() {
                      listTeam.add(Team.addListCharacter(currentTeam));
                      currentTeam.clear();
                      currentTeam.add(rollCharacter[value]);
                      btnShowMore = true;
                      rollCharacter.remove(rollCharacter[value]);
                    });
                  }
                });
              },
              animateFirst: false,
              selected: controller.stream,
              physics: CircularPanPhysics(
                duration: Duration(seconds: 1),
                curve: Curves.decelerate,
              ),
              items: [
                for (var character in rollCharacter)
                  FortuneItem(
                    child: Text(character.name.toString()),
                    style: FortuneItemStyle(
                        color: (character.element == "Pyro")
                            ? Colors.red
                            : (character.element == "Hydro")
                                ? Colors.blue
                                : (character.element == "Electro")
                                    ? Colors.purple
                                    : (character.element == "Cryo")
                                        ? Color.fromARGB(255, 135, 195, 243)
                                        : (character.element == "Anemo")
                                            ? Color.fromARGB(255, 123, 224, 126)
                                            : (character.element == "Geo")
                                                ? Colors.orange
                                                : (character.element ==
                                                        "Dendro")
                                                    ? Colors.green
                                                    : Colors.black,
                        borderColor: Colors.black,
                        borderWidth: 2),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () {
                setState(() {
                  value = Fortune.randomInt(0, rollCharacter.length);
                  controller.add(value);
                });
              },
              child: Text("Roll")),
        ],
      );

  Widget currentTeamCharacter(double widthScreen) => ListTile(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (var character in currentTeam)
            Column(
              children: [
                Image.network(
                  character.icon.toString(),
                  errorBuilder: (context, error, stackTrace) {
                    return iconError();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: loadingDataElement());
                  },
                  width: (widthScreen >= 500) ? null : widthScreen * 0.20,
                ),
                (widthScreen >= 430)
                    ? Text((character.name!.length < 13)
                        ? character.name.toString()
                        : character.name!.substring(0, 10) + '...')
                    : Container(),
              ],
            )
        ]),
      );

  Widget currentTeamBoss(double widthScreen) => ListTile(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            children: [
              Image.network(
                currentBoss.icon.toString(),
                errorBuilder: (context, error, stackTrace) {
                  return iconError();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: loadingDataElement());
                },
                width: (widthScreen >= 500) ? null : widthScreen * 0.20,
              ),
              (widthScreen >= 430)
                  ? Text((currentBoss.name!.length < 13)
                      ? currentBoss.name.toString()
                      : currentBoss.name!.substring(0, 10) + '...')
                  : Container(),
            ],
          )
        ]),
      );

  Widget previousTeam(double widthScreen) => Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20);
            },
            reverse: true,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            itemCount: listTeam.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        // spreadRadius: 5,
                        blurRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: (widthScreen >= 460)
                      ? EdgeInsets.only(
                          top: 5,
                        )
                      : null,
                  child: ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var character in listTeam[index].listCharacter!)
                            Column(
                              children: [
                                Image.network(character.icon.toString(),
                                    errorBuilder: (context, error, stackTrace) {
                                  return iconError();
                                }, loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(child: loadingDataElement());
                                },
                                    width: (widthScreen >= 650 &&
                                            widthScreen < 1000)
                                        ? null
                                        : (widthScreen >= 1000)
                                            ? widthScreen * 0.07
                                            : widthScreen * 0.15),
                                (widthScreen >= 460 && widthScreen < 800)
                                    ? Text((character.name!.length < 13)
                                        ? character.name.toString()
                                        : character.name!.substring(0, 10) +
                                            '...')
                                    : (widthScreen >= 800 && widthScreen < 1000)
                                        ? Text((character.name.toString()))
                                        : (widthScreen >= 1000 &&
                                                widthScreen < 1100)
                                            ? Text((character.name!.length < 9)
                                                ? character.name.toString()
                                                : character.name!.substring(0, 7) +
                                                    '...')
                                            : (widthScreen >= 1100 &&
                                                    widthScreen < 1300)
                                                ? Text((character.name!.length < 11)
                                                    ? character.name.toString()
                                                    : character.name!.substring(0, 9) +
                                                        '...')
                                                : (widthScreen >= 1300 &&
                                                        widthScreen < 1500)
                                                    ? Text((character.name!.length < 13)
                                                        ? character.name
                                                            .toString()
                                                        : character.name!
                                                                .substring(
                                                                    0, 11) +
                                                            '...')
                                                    : (widthScreen >= 1500 &&
                                                            widthScreen < 1700)
                                                        ? Text((character.name!
                                                                    .length <
                                                                17)
                                                            ? character.name
                                                                .toString()
                                                            : character.name!
                                                                    .substring(0, 15) +
                                                                '...')
                                                        : (widthScreen >= 1700)
                                                            ? Text((character.name.toString()))
                                                            : Container()
                              ],
                            )
                        ]),
                  ));
            })
      ]);

  Widget wheelBoss(double heightScreen) => Column(
        children: [
          Container(
            height: heightScreen * 0.40,
            child: FortuneWheel(
              onAnimationEnd: () {
                setState(() {
                  if (rollBoss.length <= 2) {
                    if (bossSelected == false) {
                      currentBoss = rollBoss[value];
                      rollBoss = List.from(haveBoss);
                      setState(() {
                        bossSelected = true;
                      });
                    } else {
                      listTeam.add(Team.addCharacter(
                          Character.bossToChar(rollBoss[value])));
                      currentBoss = rollBoss[value];
                      btnShowMore = true;
                      rollBoss = List.from(haveBoss);
                    }

                    const snackBar = SnackBar(
                      content: Text(
                          'Stay only one character, reset the spinner.',
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: Colors.white,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (bossSelected == false) {
                    currentBoss = rollBoss[value];
                    rollBoss.remove(rollBoss[value]);
                    setState(() {
                      bossSelected = true;
                    });
                  } else {
                    listTeam.add(Team.addCharacter(
                        Character.bossToChar(rollBoss[value])));
                    currentBoss = rollBoss[value];
                    btnShowMore = true;
                    rollBoss.remove(rollBoss[value]);
                  }
                });
              },
              animateFirst: false,
              selected: controllerBoss.stream,
              physics: CircularPanPhysics(
                duration: Duration(seconds: 1),
                curve: Curves.decelerate,
              ),
              items: [
                for (var boss in rollBoss)
                  FortuneItem(
                    child: Text(boss.name.toString()),
                    style: FortuneItemStyle(
                        color: (haveBoss.indexOf(boss) & 7 == 0)
                            ? Colors.red
                            : (haveBoss.indexOf(boss) & 7 == 1)
                                ? Colors.blue
                                : (haveBoss.indexOf(boss) & 7 == 2)
                                    ? Colors.purple
                                    : (haveBoss.indexOf(boss) & 7 == 3)
                                        ? Color.fromARGB(255, 135, 195, 243)
                                        : (haveBoss.indexOf(boss) & 7 == 4)
                                            ? Color.fromARGB(255, 123, 224, 126)
                                            : (haveBoss.indexOf(boss) & 7 == 5)
                                                ? Colors.orange
                                                : (haveBoss.indexOf(boss) & 7 ==
                                                        6)
                                                    ? Colors.green
                                                    : Colors.black,
                        borderColor: Colors.black,
                        borderWidth: 2),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () {
                setState(() {
                  controller.onCancel;
                  controller.onResume;
                  controller.stream.listen((event) {});

                  controllerBoss.stream.listen((event) {});

                  value = Fortune.randomInt(0, rollBoss.length);
                  controllerBoss.add(value);
                });
              },
              child: Text("Roll")),
        ],
      );

  Widget showMoreButton() => Row(
        children: [
          Spacer(),
          Text("Show more"),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      showMore = !showMore;
                    });
                  },
                  icon: Icon(Icons.add)))
        ],
      );

  void switchToTrue(int position) {
    setState(() {
      haveCharacter.remove(widget.listChar[position]);
      rollCharacter.remove(widget.listChar[position]);
    });
  }

  void switchToFalse(int position) {
    setState(() {
      haveCharacter.add(widget.listChar[position]);
      rollCharacter.add(widget.listChar[position]);
    });
  }

  void switchToTrueAll() {
    setState(() {
      haveCharacter = List.from(widget.listChar);
      rollCharacter = List.from(widget.listChar);
    });
  }

  void switchToFalseAll() {
    setState(() {
      haveCharacter.clear();
      rollCharacter.clear();
    });
  }
}
