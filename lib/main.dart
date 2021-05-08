import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dnd.dart';
import 'cthulhu.dart';
import 'dart:math';

void main() => runApp(MyApp());

Random rng = Random();

int d6() => rng.nextInt(6) + 1;

dynamic pickRandom(List array) => array[rng.nextInt(array.length)];

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

Drawer appDrawer(context, controller, animation) {
  return Drawer(
      child: Column(children: [
    Expanded(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => controller
                    ..reset()
                    ..forward(),
                  child: RotationTransition(
                    turns: animation,
                    child: Icon(
                      Icons.casino,
                      size: 75,
                      color: () {
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
                      }(),
                    ),
                  ),
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
        ],
      ),
    ),
    Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: 180,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10),
                  child: Text('Made using Flutter')),
              FlutterLogo(),
            ],
          ),
          Container(height: 10),
          Text('Thanks to the people of /r/3d6 '
              'for some awesome character ideas!'),
        ],
      ),
    )
  ]));
}

class DataList extends StatelessWidget {
  final String left;
  final dynamic right;
  final String subtitle;

  DataList({required this.left, required this.right, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double totalWidth = screenWidth < 500 ? screenWidth : 250 + screenWidth / 2;
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Container(
                width: totalWidth / 4,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Text(left,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
              width: totalWidth * 3 / 4,
              padding: EdgeInsets.only(right: 10),
              child: () {
                List<Widget> items = [];
                if (right.runtimeType == String)
                  items.add(Text(right));
                else
                  for (final s in right)
                    items.add(Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(s)));

                if (subtitle != '')
                  items.add(Text(subtitle,
                      style: TextStyle(color: Colors.grey, fontSize: 13)));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items,
                );
              }(),
            ),
          ],
        ),
      ),
    );
  }
}
