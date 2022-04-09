import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingDataElement() => SpinKitFoldingCube(
      color: Colors.black,
      size: 50.0,
    );

Widget imageError() => Image.asset(
      "assets/error/errorImage.png",
    );

Widget iconError() =>
    ClipOval(child: Image.asset("assets/error/emptyUser.webp"));
