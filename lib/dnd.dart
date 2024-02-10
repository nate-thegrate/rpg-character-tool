import 'package:flutter/material.dart';
import 'main.dart';
import 'dnd_data.dart';
import 'dnd_builds.dart';

bool autoArrange = true;

class DnDHome extends StatefulWidget {
  const DnDHome({super.key});

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
      duration: const Duration(seconds: 1),
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
    final List choices = ['4d6 Drop Lowest', 'Standard Array', 'Random Array', 'Custom'];
    final Widget generateChoices = Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: choices.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(choices[index]),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                generate(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatScreen()),
                );
              });
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );

    final bottomButtons = Column(children: [
      ListTile(
          title: const Text('View All Character Builds'),
          trailing: Container(
              margin: const EdgeInsets.only(right: 15), child: const Icon(Icons.view_list)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewBuilds()));
          }),
      ListTile(
          title: const Text('Edit Random Arrays'),
          trailing:
              Container(margin: const EdgeInsets.only(right: 15), child: const Icon(Icons.edit)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditArrays()));
          }),
      Tooltip(
        message: 'Allocate stats into a viable configuration',
        child: SwitchListTile(
          title: const Text('Auto-arrange stats?'),
          value: autoArrange,
          onChanged: (value) => setState(() => autoArrange = value),
        ),
      ),
    ]);

    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Random D&D 5e Character')),
      drawer: AppDrawer(controller: controller, animation: animation),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'How are we generating stats?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          generateChoices,
          bottomButtons,
        ],
      ),
    );
  }
}

class ViewBuilds extends StatelessWidget {
  const ViewBuilds({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: builds.length,
        itemBuilder: (BuildContext context, int index) {
          final b = builds[index];
          final String classes = b.classes.join(' / ');
          return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.name),
                  Text(
                    classes,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewBuild(i: index)),
                );
              });
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

class ViewBuild extends StatelessWidget {
  const ViewBuild({super.key, required this.i});
  final int i;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double textWidth = screenWidth < 500 ? screenWidth : 250 + screenWidth / 2;
    return AdaptiveScaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: textWidth,
          margin: EdgeInsets.only(left: (screenWidth - textWidth) / 2),
          child: buildScreen(builds[i]),
        ),
      ),
    );
  }
}

class EditArrays extends StatefulWidget {
  const EditArrays({super.key});

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

  Icon editIcon = const Icon(Icons.edit);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final saveIcon = Row(
      children: [
        const Text('Save', style: TextStyle(fontSize: 18)),
        IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: () {
              arrays = [];
              for (final array in _controller.text.split('\n')) {
                final List<String> stats = array.split(' ');
                final List<int> intStats = [];
                for (final stat in stats) {
                  final val = int.tryParse(stat);
                  if (val != null) intStats.add(val);
                }
                if (intStats.length == 6) {
                  arrays.add(intStats);
                }
              }
              Navigator.pop(context);
            }),
      ],
    );

    const description = Text(
      'Combines the fun randomness of rolling for stats with the fairness of arrays!\n\n',
      style: TextStyle(fontSize: 16),
    );

    final textBox = SizedBox(
        width: 250 + screenWidth / 5,
        child: TextField(
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              border: OutlineInputBorder()),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _controller,
        ));

    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Random Arrays'), actions: [
        saveIcon,
        Container(width: 12),
      ]),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              description,
              textBox,
            ],
          ),
        ),
      ),
    );
  }
}

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  Widget build(BuildContext context) {
    final s = findSelected();
    if (s.length == 2) {
      final tempStat = stats[s[0]];
      final tempBonus = bonuses[s[0]];
      stats[s[0]] = stats[s[1]];
      bonuses[s[0]] = bonuses[s[1]];
      stats[s[1]] = tempStat;
      bonuses[s[1]] = tempBonus;
      selected = [false, false, false, false, false, false];
    }

    statColumns(width) {
      if (customStats) {
        return [
          const DataColumn(
              label: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Stat'),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: (15 + width / 2).toDouble()),
            child: const Text('Score'),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: width / 2),
            child: const Text('Mod'),
          )),
        ];
      } else {
        return [
          const DataColumn(label: Text('Stat')),
          DataColumn(label: Container()),
          DataColumn(
              label: Container(
            padding: const EdgeInsets.only(left: 20),
            child: const Text('Bonus'),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: width),
            child: const Text('Final'),
          ))
        ];
      }
    }

    statRows(width) {
      final List<DataRow> rows = [];
      if (customStats) {
        for (int i = 0; i < 6; i++) {
          rows.add(DataRow(cells: [
            DataCell(Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                statNames[i],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    final int mod = ((stats[i] + bonuses[i]) / 2 - 5).floor();
                    return (mod > 0) ? '+$mod' : mod.toString();
                  }(),
                  style: const TextStyle(fontSize: 20),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            DataCell(SizedBox(
              width: 40,
              height: 30,
              child: Tooltip(
                message: 'press to swap stats',
                child: OutlinedButton(
                  onPressed: () => setState(() => selected[i] = !selected[i]),
                  style: selected[i]
                      ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey[900],
                          padding: EdgeInsets.zero,
                        )
                      : OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                  child: Text(stats[i].toString()),
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
                      final int mod = ((stats[i] + bonuses[i]) / 2 - 5).floor();
                      return (mod > 0) ? '+$mod' : mod.toString();
                    }(),
                    style: const TextStyle(fontSize: 20),
                  )),
            ])),
          ]));
        }
      }
      return rows;
    }

    recommendations(width) {
      final List<String> s = getRecommendations();
      const reg = TextStyle(fontSize: 18);
      const bold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
      final String buildName = s[s.length - 1];
      s[s.length - 1] = '“$buildName” (info below)';

      return SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text("Character idea${s.length > 1 ? 's' : ''}:", style: bold)),
            for (int i = 0; i < s.length; i++)
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(width: 20, child: Text(' •', style: bold)),
                    SizedBox(width: width - 60, child: Text(s[i], style: reg)),
                  ]),
                ),
              ),
            const SizedBox(height: 25),
            BuildCard(buildName),
          ],
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    double tableWidth = screenWidth;
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: () {
                if (screenWidth < 600) {
                  return 0.0;
                } else {
                  final double margin = (screenWidth - 600) / 3;
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
                  headingTextStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  columnSpacing: 20,
                  dataRowMinHeight: 75,
                  dataRowMaxHeight: 75,
                  columns: statColumns(tableWidth - 314),
                  rows: statRows(tableWidth - 330),
                ),
                recommendations(tableWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArrowIncrement extends StatelessWidget {
  const ArrowIncrement({super.key, required this.value, required this.update});
  final ValueChanged<int> update;
  final int value;

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
      SizedBox(width: 90, child: Center(child: Text(value.toString()))),
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
