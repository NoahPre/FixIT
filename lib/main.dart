//main.dart
// 1
import "package:flutter/material.dart";
// 2
import "./seiten/home.dart";
import "./klassen/thema.dart";

main() => runApp(FixIt());

class FixIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      // wird in /klassen/thema.dart definiert
      theme: thema,
    );
  }
}
