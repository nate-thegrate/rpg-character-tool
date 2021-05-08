import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'dnd_data.dart';
import 'dnd_builds.dart';

final ThemeData dndTheme = ThemeData(primarySwatch: Colors.green);
bool autoArrange = true;

class DnDHome extends StatefulWidget {
  @override
  _DnDHomeState createState() => _DnDHomeState();
}

class _DnDHomeState extends State<DnDHome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    ).drive(Tween(begin: 0, end: 2));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget generateChoices() {
      final List choices = [
        '4d6 Drop Lowest',
        'Standard Array',
        'Random Array',
        'Custom'
      ];
      return Flexible(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: choices.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(choices[index]),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {
                  generate(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatScreen()),
                  );
                });
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      );
    }

    final bottomButtons = Column(children: [
      ListTile(
          title: Text('View All Character Builds'),
          trailing: Container(
              margin: EdgeInsets.only(right: 15), child: Icon(Icons.view_list)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ViewBuilds()));
          }),
      ListTile(
          title: Text('Edit Random Arrays'),
          trailing: Container(
              margin: EdgeInsets.only(right: 15), child: Icon(Icons.edit)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EditArrays()));
          }),
      Tooltip(
        message: 'Allocate stats into a viable configuration',
        child: SwitchListTile(
          title: Text('Auto-arrange stats?'),
          value: autoArrange,
          onChanged: (value) => setState(() => autoArrange = value),
        ),
      ),
    ]);

    return Theme(
      data: dndTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Make a Random 5e Character'),
        ),
        drawer: appDrawer(context, controller, animation),
        body: Column(
          children: [
            generateChoices(),
            bottomButtons,
          ],
        ),
      ),
    );
  }
}

class ViewBuilds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: dndTheme,
      child: Scaffold(
        appBar: AppBar(),
        body: Scrollbar(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: builds.length,
            itemBuilder: (BuildContext context, int index) {
              final b = builds[index];
              return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.name),
                      Text(
                        () {
                          String classes = b.classes[0];
                          for (int i = 1; i < b.classes.length; i++) {
                            classes += ' / ${b.classes[i]}';
                          }
                          return classes;
                        }(),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewBuild(i: index)),
                    );
                  });
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }
}

class ViewBuild extends StatelessWidget {
  final int i;

  ViewBuild({required this.i});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double textWidth = screenWidth < 500 ? screenWidth : 250 + screenWidth / 2;
    return Theme(
      data: dndTheme,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
              width: textWidth,
              margin: EdgeInsets.only(left: (screenWidth - textWidth) / 2),
              child: buildScreen(builds[i])),
        ),
      ),
    );
  }
}

class EditArrays extends StatefulWidget {
  @override
  _EditArraysState createState() => _EditArraysState();
}

class _EditArraysState extends State<EditArrays> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    String arrayText = '';
    for (final array in arrays) {
      for (int i = 0; i < array.length; i++) {
        arrayText += '${array[i]}${i < array.length - 1 ? ' ' : ''}';
      }
      arrayText += '\n';
    }
    _controller.text = arrayText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Icon editIcon = Icon(Icons.edit);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final saveIcon = Row(
      children: [
        Text('Save', style: TextStyle(fontSize: 18)),
        IconButton(
            icon: Icon(Icons.check_rounded),
            onPressed: () {
              String txt = _controller.text;
              List<String> tempArrays = txt.split('\n');
              arrays = [];
              for (final array in tempArrays) {
                List<String> stats = array.split(' ');
                List<int> intStats = [];
                for (final stat in stats) {
                  try {
                    intStats.add(int.parse(stat));
                  } catch (e) {}
                }
                if (intStats.length == 6) {
                  arrays.add(intStats);
                }
              }
              Navigator.pop(context);
            }),
      ],
    );

    final description = Text(
      'Combines the fun randomness of rolling for stats with the fairness of arrays!\n\n',
      style: TextStyle(fontSize: 16),
    );

    final textBox = Container(
        width: 250 + screenWidth / 5,
        child: TextField(
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              border: OutlineInputBorder()),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _controller,
        ));

    return Theme(
      data: dndTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Random Arrays'), actions: [
          saveIcon,
          Container(width: 12),
        ]),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                description,
                textBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatScreen extends StatefulWidget {
  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  Widget build(BuildContext context) {
    var s = findSelected();
    if (s.length == 2) {
      var tempStat = stats[s[0]];
      var tempBonus = bonuses[s[0]];
      stats[s[0]] = stats[s[1]];
      bonuses[s[0]] = bonuses[s[1]];
      stats[s[1]] = tempStat;
      bonuses[s[1]] = tempBonus;
      selected = [false, false, false, false, false, false];
    }

    statColumns(width) {
      if (customStats)
        return [
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('Stat'),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: (15 + width / 2).toDouble()),
            child: Text('Score'),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: width / 2),
            child: Text('Mod'),
          )),
        ];
      else
        return [
          DataColumn(label: Text('Stat')),
          DataColumn(label: Container()),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: 20),
            child: Text('Bonus'),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: width),
            child: Text('Final'),
          ))
        ];
    }

    statRows(width) {
      List<DataRow> rows = [];
      if (customStats) {
        for (int i = 0; i < 6; i++) {
          rows.add(DataRow(cells: [
            DataCell(Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                statNames[i],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )),
            DataCell(Container(
              margin: EdgeInsets.only(left: width / 2),
              child: ArrowIncrement(
                value: stats[i],
                update: (stat) => setState(() => stats[i] = stat),
              ),
            )),
            DataCell(
              Container(
                width: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB((width / 2), 0, 30, 0),
                child: Text(
                  () {
                    int mod = ((stats[i] + bonuses[i]) / 2 - 5).floor();
                    return (mod > 0) ? '+$mod' : mod.toString();
                  }(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ]));
        }
      } else {
        for (int i = 0; i < 6; i++) {
          rows.add(DataRow(cells: [
            DataCell(Text(
              statNames[i],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            DataCell(Container(
              width: 40,
              height: 30,
              child: Tooltip(
                message: 'press to swap stats',
                child: OutlinedButton(
                  onPressed: () => setState(() => selected[i] = !selected[i]),
                  child: Text(stats[i].toString()),
                  style: () {
                    if (selected[i])
                      return OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                      );
                    else
                      return null;
                  }(),
                ),
              ),
            )),
            DataCell(ArrowIncrement(
              value: bonuses[i],
              update: (bonus) => setState(() => bonuses[i] = bonus),
            )),
            DataCell(Row(children: [
              Container(width: width),
              Container(
                width: 25,
                alignment: Alignment.center,
                child: Text((stats[i] + bonuses[i]).toString()),
              ),
              Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    () {
                      int mod = ((stats[i] + bonuses[i]) / 2 - 5).floor();
                      return (mod > 0) ? '+$mod' : mod.toString();
                    }(),
                    style: TextStyle(fontSize: 20),
                  )),
            ])),
          ]));
        }
      }
      return rows;
    }

    recommendations(width) {
      List<String> s = getRecommendations();
      final reg = TextStyle(fontSize: 18);
      final bold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
      List<Widget> w = [
        Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child:
                Text("Character idea${s.length > 1 ? 's' : ''}:", style: bold)),
      ];

      String buildName = s[s.length - 1];
      s[s.length - 1] = '“$buildName” (info below)';
      for (int i = 0; i < s.length; i++) {
        w.add(InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 20, child: Text(' •', style: bold)),
              Container(width: width - 60, child: Text(s[i], style: reg)),
            ]),
          ),
        ));
      }

      w.add(Container(height: 25));
      w.add(buildCard(buildName));

      return Container(width: width, child: Column(children: w));
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double tableWidth = screenWidth;
    return Theme(
      data: dndTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Stats')),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: () {
                  if (screenWidth < 600) {
                    return 0.0;
                  } else {
                    double margin = (screenWidth - 600) / 3;
                    tableWidth = screenWidth - margin * 2;
                    return margin;
                  }
                }(),
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    headingRowHeight: 50,
                    headingTextStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    columnSpacing: 20,
                    dataRowHeight: 75,
                    columns: statColumns(tableWidth - 314),
                    rows: statRows(tableWidth - 330),
                  ),
                  recommendations(tableWidth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArrowIncrement extends StatelessWidget {
  final ValueChanged<int> update;
  final int value;

  ArrowIncrement({required this.value, required this.update});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          tooltip: 'decrease bonus by 1',
          onPressed: () => update(value - 1),
        ),
      ),
      Container(width: 90, child: Center(child: Text(value.toString()))),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.keyboard_arrow_up_rounded),
          tooltip: 'increase bonus by 1',
          onPressed: () => update(value + 1),
        ),
      ),
    ]);
  }
}
