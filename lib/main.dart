import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dnd.dart';
import 'cthulhu.dart';
import 'dart:math';

void main() => runApp(MyApp());

var rng = new Random();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DnDHome(),
      routes: <String, WidgetBuilder>{
        'D&D': (BuildContext context) => DnDHome(),
        'CoC': (BuildContext context) => CthulhuHome(),
      },
    );
  }
}

Drawer appDrawer(context) {
  return Drawer(
      child: ListView(children: <Widget>[
    DrawerHeader(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Icon(
            Icons.casino,
            size: 75,
            color: (() {
              switch (ModalRoute.of(context)?.settings.name) {
                case 'CoC':
                  {
                    return Colors.purple;
                  }
                default:
                  {
                    return Colors.green;
                  }
              }
            }()),
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text('Quick & Easy Character Generation'))),
        ],
      ),
    ),
    ListTile(
      title: Text('D&D 5th Edition'),
      onTap: () => Navigator.pushReplacementNamed(context, 'D&D'),
    ),
    ListTile(
      title: Text('Call of Cthulhu 7th Edition'),
      onTap: () => Navigator.pushReplacementNamed(context, 'CoC'),
    )
  ]));
}

int d6() {
  return rng.nextInt(6) + 1;
}
