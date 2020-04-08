import "package:flutter/material.dart";

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wie funktioniert's"),
      ),
      body: Image(
        image: AssetImage("assets/MeldeAblauf.jpg"),
      ),
    );
  }
}
