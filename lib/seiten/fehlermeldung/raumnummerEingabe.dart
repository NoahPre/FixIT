// raumnummerEingabe.dart
// 1
import "package:flutter/material.dart";

class RaumnummerEingabe extends StatefulWidget {
  final updateText;

  RaumnummerEingabe({this.updateText});

  @override
  _RaumnummerEingabeState createState() => _RaumnummerEingabeState();
}

class _RaumnummerEingabeState extends State<RaumnummerEingabe> {
  TextEditingController _raumController = TextEditingController();
  FocusNode _raumNode = FocusNode();
  String _dropdownButtonText = "";

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        DropdownButton(
          icon: Icon(Icons.arrow_drop_down),
          value: _dropdownButtonText,
          hint: Text("Präfix"),
          items: [
            "",
            "K",
            "N",
            "Z",
          ].map((value) {
            return DropdownMenuItem(
              child: Text(value),
              value: value,
            );
          }).toList(),
          onChanged: (String value) {
            widget.updateText(
              textInTextfield: value + _raumController.text,
            );
            setState(() {
              _dropdownButtonText = value;
            });
          },
        ),
        SizedBox(
          width: _size.width * 0.04,
        ),
        Flexible(
          child: TextField(
            controller: _raumController,
            decoration: InputDecoration(
              labelText: "Raumnummer",
              hintText: "",
            ),
            focusNode: _raumNode,
            keyboardType: TextInputType.number,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            onChanged: (_) => widget.updateText(
              textInTextfield: _dropdownButtonText + _raumController.text,
            ),
          ),
        ),
      ],
    );
  }
}
