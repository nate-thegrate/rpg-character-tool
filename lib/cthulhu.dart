import 'package:flutter/material.dart';
import 'main.dart';
import 'cthulhu_data.dart';

bool autoAge = true;

class CthulhuHome extends StatefulWidget {
  const CthulhuHome({super.key});

  @override
  _CthulhuHomeState createState() => _CthulhuHomeState();
}

class _CthulhuHomeState extends State<CthulhuHome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);

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
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Quick Call of Cthulhu Character')),
      drawer: AppDrawer(controller: controller, animation: animation),
      body: Column(
        children: [
          const Expanded(
            child: Align(alignment: Alignment.bottomCenter, child: _StartButton()),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SwitchListTile(
                title: const Text('Compute age automatically?'),
                value: autoAge,
                onChanged: (value) => setState(() => autoAge = value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Text(
          'Make a character',
          style: TextStyle(fontSize: 18),
        ),
      ),
      onPressed: () {
        p = Player();
        if (autoAge) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AutoAgeDisplay()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualAge()));
        }
      },
    );
  }
}

class AutoAgeDisplay extends StatefulWidget {
  const AutoAgeDisplay({super.key});

  @override
  _AutoAgeDisplayState createState() => _AutoAgeDisplayState();
}

class _AutoAgeDisplayState extends State<AutoAgeDisplay> {
  @override
  Widget build(BuildContext context) {
    final List<PlayerStat> initialStats = [];
    for (final stat in p.stats) {
      initialStats.add(PlayerStat(stat.name, stat.val));
    }

    p.setAge();

    final pageData = Column(
      children: [
        const Text(
          '\nInitial Stat Values',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(height: 20),
        DataTable(
            headingRowHeight: 30,
            columns: const [DataColumn(label: Text('Stat')), DataColumn(label: Text('Value'))],
            rows: () {
              final List<DataRow> rows = [];
              for (int i = 0; i < initialStats.length; i++) {
                rows.add(DataRow(cells: [
                  DataCell(Text(statNames[i])),
                  DataCell(Text(initialStats[i].val.toString())),
                ]));
              }
              return rows;
            }()),
        Text('\nAge: ${p.age}\n'),
        Text(p.eduData),
        Text(p.showStatData()),
        ElevatedButton(
          child: const Text('Next'),
          onPressed: () {
            p.hpMovBuild();
            p.decideOccupation();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => CharacterScreen()));
          },
        ),
        Container(height: 25),
      ],
    );

    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        child: Container(alignment: Alignment.topCenter, child: pageData),
      ),
    );
  }
}

class ManualAge extends StatefulWidget {
  const ManualAge({super.key});

  @override
  _ManualAgeState createState() => _ManualAgeState();
}

class _ManualAgeState extends State<ManualAge> {
  final _formKey = GlobalKey<FormState>();
  int age = 0;

  final initialStats = DataTable(
      columns: const [DataColumn(label: Text('stat')), DataColumn(label: Text('value'))],
      rows: () {
        final List<DataRow> rows = [];
        final statNames = [
          'Strength',
          'Constitution',
          'Size',
          'Dexterity',
          'Appearance',
          'Intelligence',
          'Willpower',
          'Education',
        ];
        for (int i = 0; i < p.stats.length; i++) {
          rows.add(DataRow(cells: [
            DataCell(Text(statNames[i])),
            DataCell(Text(p.stats[i].val.toString())),
          ]));
        }
        return rows;
      }());

  final ageForm = TextFormField(
    keyboardType: TextInputType.number,
    decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
    onChanged: (text) {
      p.age = int.parse(text);
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Input an age';
      } else if (int.parse(value) < 15 || int.parse(value) > 89) {
        return 'Out of range\n15 - 89';
      }
      return null;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AdaptiveScaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const Text(
                  '\nInitial Stat Values',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                initialStats,
                Container(width: 100, margin: const EdgeInsets.only(top: 20), child: ageForm),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    child: const Text('Next'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        p.setAge();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StatReduceScreen()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatReduceScreen extends StatefulWidget {
  const StatReduceScreen({super.key});

  @override
  _StatReduceScreenState createState() => _StatReduceScreenState();
}

class _StatReduceScreenState extends State<StatReduceScreen> {
  Widget buttons() {
    updateFunction(int i) => (newMod) => setState(() {
          p.stats[i].val = newMod;
          p.reduceAmt -= 5;
          if (p.reduceAmt <= 0 ||
              (p.statGet('STR') < 10 && p.statGet('CON') < 10 && p.statGet('DEX') < 10)) {
            p.hpMovBuild();
            p.decideOccupation();
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CharacterScreen()),
            );
          }
        });

    if (p.age >= 40) {
      return Column(
        children: [
          StatReduceButton(i: 0, update: updateFunction(0), statValue: p.stats[0].val),
          StatReduceButton(i: 1, update: updateFunction(1), statValue: p.stats[1].val),
          StatReduceButton(i: 3, update: updateFunction(3), statValue: p.stats[3].val),
        ],
      );
    } else if (p.age < 20) {
      return Column(
        children: [
          StatReduceButton(i: 0, update: updateFunction(0), statValue: p.stats[0].val),
          StatReduceButton(i: 2, update: updateFunction(2), statValue: p.stats[2].val),
        ],
      );
    } else {
      return ElevatedButton(
          onPressed: () {
            p.hpMovBuild();
            p.decideOccupation();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => CharacterScreen()));
          },
          child: const Text('Next'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 20,
          ),
          Text(p.eduData),
          Text(p.showStatData()),
          buttons(),
          Container(height: 20),
          Text(() {
            return p.reduceAmt > 0
                ? 'Reduce the above stats by ${p.reduceAmt}, split however you like.'
                : '';
          }()),
        ],
      ),
    );
  }
}

class StatReduceButton extends StatelessWidget {
  const StatReduceButton(
      {super.key, required this.i, required this.update, required this.statValue});
  final int i;
  final ValueChanged<int> update;
  final int statValue;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
              width: totalWidth / 2 - 75,
              padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
              alignment: Alignment.centerRight,
              child: Text(statNames[i],
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(width: 40, child: Text(statValue.toString())),
          SizedBox(width: () {
            if (totalWidth < 400) {
              return totalWidth / 2 + 20;
            } else {
              return 220.toDouble();
            }
          }(), child: () {
            if (statValue >= 10) {
              return OutlinedButton(
                child: Text('Reduce ${statNames[i]} by 5'),
                onPressed: () => update(statValue - 5),
              );
            } else {
              return null;
            }
          }()),
        ],
      ),
    );
  }
}

class CharacterScreen extends StatelessWidget {
  CharacterScreen({super.key});

  final ideology = ideologyBeliefs.random;
  final person = significantPeople.random;
  final reason = significantReasons.random;
  final location = meaningfulLocations.random;
  final possession = treasuredPossessions.random;

  final boldHeader = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double tableWidth = screenWidth < 500 ? screenWidth : 250 + screenWidth / 2;

    final characteristics = DataTable(
        headingRowHeight: 30,
        columns: [
          DataColumn(label: Text('Stat', style: boldHeader)),
          DataColumn(label: Text('Value', style: boldHeader)),
          DataColumn(label: Text('Half', style: boldHeader)),
          DataColumn(label: Text('Fifth', style: boldHeader)),
        ],
        rows: () {
          final List<DataRow> rows = [];
          for (int i = 0; i < p.stats.length; i++) {
            rows.add(DataRow(cells: [
              DataCell(Text(statNames[i])),
              DataCell(Text(p.stats[i].val.toString())),
              DataCell(Text((p.stats[i].val ~/ 2).toString())),
              DataCell(Text((p.stats[i].val ~/ 5).toString())),
            ]));
          }
          return rows;
        }());

    final otherStats = Column(
      children: [
        DataList(left: 'Hit Points', right: p.hp.toString()),
        DataList(left: 'Sanity', right: p.statGet('POW').toString()),
        DataList(left: 'Magic Points', right: (p.statGet('POW') ~/ 5).toString()),
        DataList(left: 'Luck', right: p.luck.toString()),
        DataList(left: 'Age', right: p.age.toString()),
        DataList(left: 'Move Rate', right: p.mov.toString()),
        DataList(left: 'Build', right: p.build.toString()),
        DataList(left: 'Damage Bonus', right: p.dmgBonus.toString()),
        DataList(
          left: 'Best Occupation Choices',
          right: () {
            String text = p.bestJobs[0];
            for (int i = 1; i < p.bestJobs.length; i++) {
              text += ', ${p.bestJobs[i]}';
            }
            return text;
          }(),
          subtitle: 'choose one of these for the maximum Occupation Skill Points',
        ),
        DataList(left: 'Occupation Skill Points', right: p.jobSkillPoints.toString()),
        DataList(
            left: 'Personal Interest Skill Points', right: (p.statGet('INT') * 2).toString()),
      ],
    );

    final backstoryTitle = Container(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          children: [
            Container(width: tableWidth / 3),
            Container(
              width: tableWidth * 2 / 3,
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1.5, color: Color(0xFFcccccc)))),
              child: Text('Backstory', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ],
        ));

    final backstory = Column(
      children: [
        DataList(
          left: 'Ideology/Belief',
          right: ideology[0],
          subtitle: ideology[1],
        ),
        DataList(
          left: 'Significant Person',
          right: person[0],
          subtitle: person[1],
        ),
        DataList(
          left: 'Reason for their Significance',
          right: reason[0],
          subtitle: reason[1],
        ),
        DataList(
          left: 'Meaningful Location',
          right: location[0],
          subtitle: location[1],
        ),
        DataList(
          left: 'Treasured Possession',
          right: possession[0],
          subtitle: possession[1],
        ),
      ],
    );

    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Full Character Info')),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: tableWidth,
                margin: const EdgeInsets.only(top: 20),
                child: characteristics,
              ),
              Container(height: 30),
              SizedBox(
                width: tableWidth,
                child: Column(children: [
                  otherStats,
                  backstoryTitle,
                  backstory,
                  Container(height: 50),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
