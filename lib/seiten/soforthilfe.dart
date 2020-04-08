// soforthilfe.dart
// 1
import "package:flutter/material.dart";

class Soforthilfe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soforthilfe"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text("Noch keine Soforthilfe verfügbar"),
          ),
        ),
      ),
    );
  }
}
