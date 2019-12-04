//alternatives main.dart mit mehreren Seiten

// import 'package:flutter/material.dart';

// import './placeholder_widget.dart';
// import "./Fehlermeldungsvorlage.dart";

// // Test
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fix It',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         textTheme: TextTheme(title: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
//       ),
//       home: MyHomePage(title: 'Fix It Home Page'),
//     );
//   }
// }

// class _Page {
//   _Page({this.widget});
//   final StatefulWidget widget;
// }

// List<_Page> _allPages = <_Page>[
//   _Page(widget: Fehlermeldungsvorlage()),
//   // _Page(widget: PlaceholderWidget("Screen 2")),
//   // _Page(widget: PlaceholderWidget("Screen 3")),
// ];

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   TabController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TabController(vsync: this, length: _allPages.length);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       floatingActionButton: FloatingActionButton.extended(
//         elevation: 4.0,
//         icon: const Icon(Icons.add),
//         label: const Text('Add a task'),
//         onPressed: () {
//           print("Add a task");
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: TabBarView(
//           controller: _controller,
//           children: _allPages.map<Widget>((_Page page) {
//             return SafeArea(
//               top: false,
//               bottom: false,
//               child: Container(
//                   key: ObjectKey(page.widget),
//                   padding: const EdgeInsets.all(12.0),
//                   child: page.widget),
//             );
//           }).toList()),
//       bottomNavigationBar: BottomAppBar(
//         child: new Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             IconButton(
//                 icon: Icon(Icons.menu),
//                 onPressed: () {
//                   _showModal();
//                 }),
//             IconButton(
//               icon: Icon(Icons.search),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showModal() {
//     showModalBottomSheet<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return new Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               new ListTile(
//                 leading: new Icon(Icons.music_note),
//                 title: new Text('Screen 1'),
//                 onTap: () {
//                   _controller.animateTo(0);
//                   Navigator.pop(context);
//                 },
//               ),
//               new ListTile(
//                 leading: new Icon(Icons.photo_album),
//                 title: new Text('Screen 2'),
//                 onTap: () {
//                   _controller.animateTo(1);
//                   Navigator.pop(context);
//                 },
//               ),
//               new ListTile(
//                 leading: new Icon(Icons.videocam),
//                 title: new Text('Screen 3'),
//                 onTap: () {
//                   _controller.animateTo(2);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }