// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paimon_preview/common/image.dart';
import 'package:paimon_preview/services/impact_moe_API.dart';
import 'dart:math' as math;

import '../models/character.dart';

class CharacterPage extends StatefulWidget {
  CharacterPage(this.listChar, this.dataInsideApp, {Key? key})
      : super(key: key);

  List<Character> listChar;
  bool dataInsideApp;

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  List<Character> charactersDisplay = [];

  /// Get ALL Characters to show
  bool dataLoad = false;

  /// Verify the data has correcty been loaded

  List<String> sortType = ['Name', 'Element', 'Rarity'];

  ///The differents way the [charactersDisplay] can be sort
  bool sortAscend = true;

  /// Sort by ascending or descending
  String sort = 'Name';

  /// Default [charactersDisplay] type is Name

  /// this variable determnines whether the back-to-top button is shown or not
  bool _showBackToTopButton = false;

  /// scroll controller for Character card
  ScrollController scrollCharacter = ScrollController();

  /// scroll controller for Detail about a character
  ScrollController scrollDetailsChar = ScrollController();

  late int selectChar;

  /// Position of the [Character] in the [widget.listChar] that we will show the detail, [widthScreen] >= 1000
  bool selectCharInitialize = false;

  /// Verify if [selectChar] is null or not

  @override
  void initState() {
    super.initState();
    loadData();

    // scrollCharacter.addListener(() {
    //   setState(() {
    //     if (scrollCharacter.offset >= 200) {
    //       _showBackToTopButton = true; // show the back-to-top button
    //     } else {
    //       _showBackToTopButton = false; // hide the back-to-top button
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    scrollCharacter.dispose();
  }

  loadData() {
    setState(() {
      // charactersDisplay = ;
      charactersDisplay = List.from(widget.listChar);
      dataLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
        // backgroundColor: Colors.grey[100],

        /// Problem, don't dissepear when we change the view between Phone/PC

        // floatingActionButton: _showBackToTopButton == false
        //     ? null
        //     : FloatingActionButton(
        //         backgroundColor: Colors.white,
        //         onPressed: scrollToTop,
        //         child: const Icon(
        //           Icons.arrow_upward,
        //           color: Colors.black,
        //         ),
        //       ),

        //Data not already loaded
        body: (dataLoad == false)
            ? const SafeArea(
                child: Center(
                child: SpinKitFoldingCube(
                  color: Colors.black,
                  size: 50.0,
                ),
              ))

            /// The view for the user with a screen width size ([widthScreen]) lower than 1000 pixels
            : (dataLoad == true && widthScreen < 1000)
                ? SingleChildScrollView(
                    controller: scrollCharacter,
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: searchTextField()),
                      Container(
                          padding:
                              EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          child: DropDownMenu(widthScreen)),
                      SizedBox(
                        height: 5,
                      ),

                      /// If the [charactersDisplay] list is empty
                      (charactersDisplay.isEmpty)
                          ? emptyListDisplay(heightScreen, widthScreen)

                          /// If there are at least one [Characters] in [charactersDisplay]
                          : GridView.count(
                              crossAxisCount: (widthScreen < 350)
                                  ? 1
                                  : (widthScreen >= 350 && widthScreen < 700)
                                      ? 2
                                      : (widthScreen >= 700 &&
                                              widthScreen < 1000)
                                          ? 3
                                          : 4,
                              scrollDirection: Axis.vertical,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              children: charactersDisplay
                                  .map(
                                    (element) => CardCharacterWithDialog(
                                        element, heightScreen, widthScreen),
                                  )
                                  .toList(),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                  )

                /// The view for the user with a screen width size ([widthScreen]) greater or equals than 1000 pixels
                : (dataLoad == true && widthScreen >= 1000)
                    ? SafeArea(
                        child: Row(
                        children: [
                          Flexible(
                              child: SingleChildScrollView(
                            controller: scrollCharacter,
                            child: Column(children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 30),
                                  child: searchTextField()),
                              Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  child: DropDownMenu(widthScreen)),

                              /// If the [charactersDisplay] list is empty
                              (charactersDisplay.isEmpty)
                                  ? emptyListDisplay(heightScreen, widthScreen)

                                  /// If there are at least one [Characters] in [charactersDisplay]
                                  : Scrollbar(
                                      child: GridView.builder(
                                      itemCount: charactersDisplay.length,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: (widthScreen < 350)
                                            ? 1
                                            : (widthScreen >= 350 &&
                                                    widthScreen < 700)
                                                ? 2
                                                : (widthScreen >= 700 &&
                                                        widthScreen < 1500)
                                                    ? 3
                                                    : 4,
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectCharInitialize = true;
                                                selectChar = widget.listChar
                                                    .indexOf(charactersDisplay[
                                                        index]);
                                              });
                                            },
                                            child: CardCharacter(
                                                charactersDisplay[index],
                                                heightScreen,
                                                widthScreen));
                                      },
                                    ))
                            ]),
                          )),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.grey.shade500,
                          ),
                          SingleChildScrollView(
                            controller: scrollDetailsChar,
                            child: Container(
                              width: widthScreen * 0.40,
                              child: Column(children: [
                                (selectCharInitialize == true)
                                    ? CharacterDetail(
                                        widget.listChar[selectChar],
                                        widthScreen,
                                        heightScreen)
                                    : Container()
                              ]),
                            ),
                          )
                        ],
                      ))
                    : Center(
                        child: SafeArea(
                          child: SpinKitFoldingCube(
                            color: Colors.black,
                            size: 50.0,
                          ),
                        ),
                      ));
  }

  /// Show the differents detail about the [Character] selected, for the [widthScreen] >= 1000
  Widget CharacterDetail(
          Character element, double widthScreen, double heightScreen) =>
      SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 10),
          // Stack(children: [
          Container(
              height: 500,
              child: Image.network(element.image!,
                  errorBuilder: (context, error, stackTrace) {
                return imageError();
              }, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: loadingDataElement());
              })),
          // ]),
          Text(element.name!),
          Container(
              width: widthScreen * 0.7,
              child: Column(children: [
                Row(
                  children: [
                    Text("Element : "),
                    Text(element.element!),
                    Spacer(),
                    elementChar(element.element!, heightScreen)
                  ],
                ),
                Row(children: [
                  Text("Rarity : "),
                  rarityChar(element.rarity!),
                ]),
                SizedBox(height: 5),
                Row(children: [Text("Weapon : "), Text(element.weapon!)]),
                SizedBox(height: 5),
                Row(children: [
                  Text("Faction : "),
                  Text(element.faction!),
                ]),
                SizedBox(
                  height: 5,
                ),
                Center(child: Container(child: Text(element.description!))),
                SizedBox(
                  height: 20,
                ),
                VoiceCharacter(element)
              ])),
        ],
      ));

  /// Generate the differents [item] with the List [sortType]
  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));

  /// Show a drop down menu with differents item, can change the [Character] position in the [charactersDisplay] depending of [sort]
  Widget DropDownMenu(double widthScreen) => ListTile(
      title: Text("Sort by"),
      trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          // borderRadius: BorderRadius.circular(10)),
          width: (widthScreen > 350) ? 200 : 100,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              isExpanded: true,
              value: sort,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 25,
              items: sortType.map(buildMenuItem).toList(),
              onChanged: (value) => setState(() {
                sort = value!;
                if (sortAscend == true) {
                  sortCaractersAscending(charactersDisplay, sort);
                } else {
                  sortCaractersDescending(charactersDisplay, sort);
                }
              }),
            ),
          )));

  /// Show a Card for each [element] in [charactersDisplay]
  Widget CardCharacter(
          Character element, double heightScreen, double widthScreen) =>
      Container(
        decoration: BoxDecoration(
          color: (element.element == "Pyro")
              ? Colors.red
              : (element.element == "Hydro")
                  ? Colors.blue
                  : (element.element == "Electro")
                      ? Colors.purple
                      : (element.element == "Cryo")
                          ? Color.fromARGB(255, 135, 195, 243)
                          : (element.element == "Anemo")
                              ? Color.fromARGB(255, 123, 224, 126)
                              : (element.element == "Geo")
                                  ? Colors.orange
                                  : (element.element == "Dendro")
                                      ? Colors.green
                                      : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: (element.element == "Pyro")
                  ? Colors.red.withOpacity(0.8)
                  : (element.element == "Hydro")
                      ? Colors.blue.withOpacity(0.8)
                      : (element.element == "Electro")
                          ? Colors.purple.withOpacity(0.8)
                          : (element.element == "Cryo")
                              ? Color.fromARGB(255, 135, 195, 243)
                                  .withOpacity(0.8)
                              : (element.element == "Anemo")
                                  ? Color.fromARGB(255, 123, 224, 126)
                                      .withOpacity(0.8)
                                  : (element.element == "Geo")
                                      ? Colors.orange.withOpacity(0.8)
                                      : (element.element == "Dendro")
                                          ? Colors.green.withOpacity(0.8)
                                          : Colors.white.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              child: Image.network(element.icon!,
                  errorBuilder: (context, error, stackTrace) {
                return iconError();
              }, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: loadingDataElement());
              }),
              backgroundColor: Colors.transparent,
            ),
            Text(element.name!),
            Flexible(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(element.description!,
                  maxLines: maxLinesDependingOfWidthScreen(widthScreen),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
            ))
          ],
        )),
      );

  /// Show the differents detail about the [Character] selected, for the [widthScreen] < 1000
  Widget CardCharacterWithDialog(
          Character element, double heightScreen, double widthScreen) =>
      GestureDetector(
          onTap: () {
            setState(() {
              selectCharInitialize = true;
              selectChar = widget.listChar.indexOf(element);
            });
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    scrollable: true,
                    // backgroundColor: Color.fromARGB(255, 42, 42, 42),
                    title: Center(
                        child: Column(children: [
                      Stack(children: [
                        Container(
                            height: 500,
                            child: Image.network(
                              element.image!,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/error/errorImage.png",
                                );
                              },
                            ))
                      ]),
                      Text(element.name!)
                    ])),
                    content: Container(
                        width: widthScreen * 0.7,
                        child: Column(children: [
                          Row(
                            children: [
                              Text("Element : "),
                              Text(element.element!),
                              Spacer(),
                              elementChar(element.element!, heightScreen)
                            ],
                          ),
                          Row(children: [
                            Text("Rarity : "),
                            rarityChar(element.rarity!),
                          ]),
                          SizedBox(height: 5),
                          Row(children: [
                            Text("Weapon : "),
                            Text(element.weapon!)
                          ]),
                          SizedBox(height: 5),
                          Row(children: [
                            Text("Faction : "),
                            Text(element.faction!),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                              child:
                                  Container(child: Text(element.description!))),
                          SizedBox(
                            height: 20,
                          ),
                          VoiceCharacter(element)
                        ])),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close')),
                    ],
                  );
                });
          },
          child: CardCharacter(element, heightScreen, widthScreen));

  /// add the number of [rarity] as stars in the detail of the [Character] selected
  Widget rarityChar(int rarity) => Row(
        children: [
          for (var j = 0; j < rarity; j++) ...[
            Icon(
              Icons.star,
              color: Colors.yellow,
            )
          ]
        ],
      );

  /// Depending of the element of the [Character], call the adapted image in the detail of the [Character] selected
  Widget elementChar(String element, double heightScreen) => Row(
        children: [
          (element == "Pyro")
              ? const Image(
                  image: AssetImage('assets/element/Element_Pyro.png'),
                  height: 40,
                )
              : (element == "Hydro")
                  ? const Image(
                      image: AssetImage('assets/element/Element_Hydro.png'),
                      height: 40,
                    )
                  : (element == "Electro")
                      ? const Image(
                          image:
                              AssetImage('assets/element/Element_Electro.png'),
                          height: 40,
                        )
                      : (element == "Cryo")
                          ? const Image(
                              image:
                                  AssetImage('assets/element/Element_Cryo.png'),
                              height: 40,
                            )
                          : (element == "Anemo")
                              ? const Image(
                                  image: AssetImage(
                                      'assets/element/Element_Anemo.png'),
                                  height: 40,
                                )
                              : (element == "Geo")
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/element/Element_Geo.png'),
                                      height: 40,
                                    )
                                  : (element == "Dendro")
                                      ? const Image(
                                          image: AssetImage(
                                              'assets/element/Element_Dendro.png'),
                                          height: 40,
                                        )
                                      : const Text("Unknown")
        ],
      );

  /// Show the voice actor of the [Character] selected, next to a flog
  VoiceCharacter(Character element) => Column(
        children: [
          Row(children: [
            Image.asset(
              'assets/country/US.png',
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("English voice : "),
            Flexible(child: Text(element.englishVA!)),
          ]),
          SizedBox(height: 5),
          Row(children: [
            Image.asset(
              'assets/country/Japan.png',
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Japanese voice : "),
            Flexible(child: Text(element.japaneseVA!)),
          ]),
          SizedBox(height: 5),
          Row(children: [
            Image.asset(
              'assets/country/China.png',
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Chinese voice : "),
            Flexible(child: Text(element.chineseVA!)),
          ]),
          SizedBox(height: 5),
          Row(children: [
            Image.asset(
              'assets/country/SK.png',
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Korean voice : "),
            Flexible(child: Text(element.koreanVA!)),
          ]),
        ],
      );

  /// TextField allowing to do more precise reasearch about the [Character] in [charactersDisplay], add/remove Character in the list
  Widget searchTextField() => TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: "Character name",
            fillColor: Colors.white70),
        onChanged: (value) {
          value = value.toLowerCase();
          setState(() {
            charactersDisplay = widget.listChar.where((search) {
              var characterName = search.name!.toLowerCase();
              return characterName.contains(value);
            }).toList();
          });
        },
      );

  /// If the [charactersDisplay] is empty, show a message
  Widget emptyListDisplay(double heightScreen, double widthScreen) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Image.asset(
              'assets/paimon/paimon_what.webp',
              height: heightScreen * 0.25,
              width: widthScreen * 0.80,
            ),
          ),
          SizedBox(height: 10),
          Text("There is no character")
        ],
      );

  /// Sort the [list] by [Character] [name], ascending
  void sortCaractersAscending(List<Character> list, String sort) {
    if (sort == "Name") {
      list.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sort == "Element") {
      list.sort((a, b) => a.element!.compareTo(b.element!));
    } else if (sort == "Rarity") {
      list.sort((a, b) => a.rarity!.compareTo(b.rarity!));
    }
  }

  /// Sort the [list] by [Character] [name], descending
  void sortCaractersDescending(List<Character> list, String sort) {
    if (sort == "Name") {
      list.sort((b, a) => a.name!.compareTo(b.name!));
    } else if (sort == "Element") {
      list.sort((b, a) => a.element!.compareTo(b.element!));
    } else if (sort == "Rarity") {
      list.sort((b, a) => a.rarity!.compareTo(b.rarity!));
    }
  }

  /// Go to the top of the page
  void scrollToTop() {
    scrollCharacter.animateTo(0,
        duration: const Duration(milliseconds: 800), curve: Curves.decelerate);
  }

  /// Depending of the [widthScreen] of the screen, adapt the number of lines
  int maxLinesDependingOfWidthScreen(double widthScreen) {
    int value = 2;
    (widthScreen < 240)
        ? value = 2
        : (widthScreen >= 240 && widthScreen < 280)
            ? value = 4
            : (widthScreen >= 280 && widthScreen < 350)
                ? value = 6
                : (widthScreen >= 350 && widthScreen < 450)
                    ? value = 2
                    : (widthScreen >= 450 && widthScreen < 600)
                        ? value = 4
                        : (widthScreen > 600 && widthScreen <= 700)
                            ? value = 7
                            : (widthScreen > 700 && widthScreen <= 850)
                                ? value = 4
                                : (widthScreen > 850 && widthScreen < 1000)
                                    ? value = 7
                                    : (widthScreen >= 1000 &&
                                            widthScreen <= 1150)
                                        ? value = 2
                                        : (widthScreen > 1150 &&
                                                widthScreen <= 1300)
                                            ? value = 4
                                            : (widthScreen > 1300 &&
                                                    widthScreen <= 1500)
                                                ? value = 4
                                                : (widthScreen > 1500 &&
                                                        widthScreen <= 1700)
                                                    ? value = 3
                                                    : (widthScreen > 1700 &&
                                                            widthScreen <= 2500)
                                                        ? value = 5
                                                        : value = 8;
    return value;
  }
}
