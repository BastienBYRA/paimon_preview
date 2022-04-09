import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:paimon_preview/common/image.dart';
import 'package:paimon_preview/firebase.dart';
import 'package:paimon_preview/models/boss.dart';

class BossPage extends StatefulWidget {
  BossPage(this.listBoss, {Key? key}) : super(key: key);

  List<Boss> listBoss;

  @override
  _BossPageState createState() => _BossPageState();
}

class _BossPageState extends State<BossPage> {
  bool loadData = false;
  // List<dynamic> widget.listBoss = [];
  late int selectBoss;
  bool selectBossInitialize = false;

  List<Boss> bossDisplay = [];

  // scroll controller
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   loadFirestore();
  //   setState(() {
  //     loadData = true;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      bossDisplay = widget.listBoss;
    });
  }

  // loadFirestore() async {
  //   Firestore.initialize(idProject);
  //   widget.listBoss = await Firestore.instance.collection("weeklyboss").get();
  //   setState(() => widget.listBoss);
  // }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: (widthScreen < 1000)
          ? SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                GridView.builder(
                    scrollDirection: Axis.vertical,
                    // physics: ScrollPhysics(),
                    primary: true,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (widthScreen < 300)
                          ? 1
                          : (widthScreen >= 300 && widthScreen < 650)
                              ? 2
                              : 3,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: bossDisplay.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectBoss = bossDisplay[index].id!;
                              selectBossInitialize = true;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    scrollable: true,
                                    // backgroundColor: Color.fromARGB(255, 42, 42, 42),
                                    title: Center(
                                        child: Column(
                                      children: [
                                        Container(
                                            //   child: ClipRRect(
                                            // borderRadius:
                                            //     BorderRadius.circular(15.0),
                                            // child: Expanded(
                                            child: Image.network(
                                                bossDisplay[index]
                                                    .image
                                                    .toString(),
                                                fit: BoxFit.cover, errorBuilder:
                                                    (context, error,
                                                        stackTrace) {
                                          return imageError();
                                        }, loadingBuilder: (context, child,
                                                    loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child: loadingDataElement());
                                        })),
                                        Text(
                                            bossDisplay[index].name.toString()),
                                        SizedBox(height: 10),
                                        ListTile(
                                            title: Text("Location"),
                                            trailing: Text(bossDisplay[index]
                                                .location
                                                .toString())),
                                        Image.network(
                                            bossDisplay[selectBoss]
                                                .map
                                                .toString(),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                          return imageError();
                                        }, loadingBuilder: (context, child,
                                                loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child: loadingDataElement());
                                        })
                                      ],
                                    )));
                              },
                            );
                          },
                          child: bossCard(index, widthScreen, heightScreen));
                    })
              ]))

          ///--------------------
          //////--------------------
          //////--------------------
          ///
          : SafeArea(
              child: Row(children: [
                Flexible(
                    // child: SingleChildScrollView(
                    //     clipBehavior: Clip.none,
                    //     controller: _scrollController2,
                    child: SingleChildScrollView(
                        child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: TextField(
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
                              bossDisplay = widget.listBoss.where((search) {
                                var bossName = search.name!.toLowerCase();
                                return bossName.contains(value);
                              }).toList();
                            });
                          },
                        )),
                    (bossDisplay.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (widthScreen < 650)
                                      ? 2
                                      : (widthScreen < 1400 &&
                                              widthScreen >= 650)
                                          ? 3
                                          : 4,
                                  mainAxisSpacing: 30,
                                  crossAxisSpacing: 20,
                                ),
                                itemCount: bossDisplay.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectBoss = bossDisplay[index].id!;
                                          selectBossInitialize = true;
                                        });
                                      },
                                      child: bossCard(
                                          index, widthScreen, heightScreen));
                                }),
                          )
                        : SafeArea(
                            child: Center(
                                child: Column(
                            children: [
                              Image.asset(
                                "assets/paimon/paimon_what.webp",
                                height: heightScreen * 0.20,
                                width: widthScreen * 0.80,
                              ),
                              Text("There is no boss")
                            ],
                          )))
                  ],
                )
                        // )
                        )),
                VerticalDivider(
                  thickness: 1,
                  color: Colors.grey.shade500,
                ),
                Container(
                  width: widthScreen * 0.40,
                  // color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: (selectBossInitialize == true)
                      ? SingleChildScrollView(
                          controller: _scrollController3,
                          child: Column(
                            children: [
                              Text(
                                "Boss information",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                          widget.listBoss[selectBoss].image
                                              .toString(),
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                        return imageError();
                                      }, loadingBuilder: (context, child,
                                              loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: loadingDataElement());
                                      }))),
                              Text(widget.listBoss[selectBoss].name!),
                              SizedBox(height: 10),
                              ListTile(
                                  title: Text("Location"),
                                  trailing: Text(widget
                                      .listBoss[selectBoss].location
                                      .toString())),
                              Image.network(widget.listBoss[selectBoss].map!,
                                  errorBuilder: (context, error, stackTrace) {
                                return imageError();
                              }, loadingBuilder:
                                      (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: loadingDataElement());
                              })
                            ],
                          ))
                      // )
                      // Text("oui")
                      : Container(),
                )
              ]),
            ),
    );
  }

  Widget bossCard(int index, double widthScreen, double heightScreen) =>
      Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
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
              Container(
                  child: Image.network(bossDisplay[index].icon!,
                      width: (widthScreen < 300)
                          ? widthScreen * 0.80
                          : (widthScreen < 650 && widthScreen >= 300)
                              ? widthScreen * 0.40
                              : (widthScreen >= 650 && widthScreen < 1000)
                                  ? widthScreen * 0.27
                                  : (widthScreen < 1400 && widthScreen >= 1000)
                                      ? widthScreen * 0.14
                                      : widthScreen * 0.11,
                      errorBuilder: (context, error, stackTrace) {
                return iconError();
              }, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: loadingDataElement());
              })),
              Text(bossDisplay[index].name!),
            ],
          )));
}
