import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:math';

var cocTheme = ThemeData(primarySwatch: Colors.purple);
bool autoAge = true;
Player p = Player();
int reduceAmt = 0;
final List<String> statNames = [
  'Strength',
  'Constitution',
  'Size',
  'Dexterity',
  'Appearance',
  'Intelligence',
  'Willpower',
  'Education',
];

class Job {
  String name = '';
  List<String> reqs = [];

  Job(String n, List<String> r) {
    this.name = n;
    this.reqs = r;
  }

  @override
  String toString() {
    return '{$name: $reqs}';
  }
}

class PlayerStat {
  String name = '';
  int val = 0;

  PlayerStat(String n, int v) {
    this.name = n;
    this.val = v;
  }

  @override
  String toString() {
    return '{$name: $val}';
  }
}

class Player {
  List<PlayerStat> stats = [
    PlayerStat('str', (d6() + d6() + d6()) * 5),
    PlayerStat('con', (d6() + d6() + d6()) * 5),
    PlayerStat('siz', (d6() + d6() + 6) * 5),
    PlayerStat('dex', (d6() + d6() + d6()) * 5),
    PlayerStat('app', (d6() + d6() + d6()) * 5),
    PlayerStat('int', (d6() + d6() + 6) * 5),
    PlayerStat('pow', (d6() + d6() + d6()) * 5),
    PlayerStat('edu', (d6() + d6() + 6) * 5)
  ];

  int statGet(String s) {
    for (var score in stats) {
      if (score.name == s) {
        return score.val;
      }
    }
    return -1;
  }

  void statSet(String s, int x) {
    for (var i = 0; i < stats.length; i++) {
      if (stats[i].name == s) {
        stats[i].val = x;
        return;
      }
    }
  }

  bool isIn(String s, List<PlayerStat> p) {
    for (var score in p) {
      if (score.name == s) {
        return true;
      }
    }
    return false;
  }

  int age = 0;
  int luck = 0;
  int hp = 0;
  int mov = 0;
  int build = 0;
  String dmgBonus = '';
  List<String> bestJobs = [];
  int jobSkillPoints = 0;

  String eduData = '';

  List<PlayerStat> statData = [
    PlayerStat('str', 0),
    PlayerStat('con', 0),
    PlayerStat('siz', 0),
    PlayerStat('dex', 0),
    PlayerStat('app', 0),
    PlayerStat('int', 0),
    PlayerStat('pow', 0),
    PlayerStat('edu', 0)
  ];

  void addtoStatData(String stat, int amt) {
    for (var i = 0; i < 8; i++) {
      if (statData[i].name == stat) {
        statData[i].val += amt;
        return;
      }
    }
  }

  String showStatData() {
    String data = '';
    for (var stat in statData) {
      if (stat.val != 0) {
        if (stat.val > 0) {
          data += '${stat.name} was increased by ${stat.val}\n';
        } else {
          data += '${stat.name} was decreased by ${-stat.val}\n';
        }
      }
    }
    return data;
  }

  bool alterStat(String stat, int amt, {int max = 90}) {
    if (statGet(stat) + amt > max) {
      if (max == 99) {
        addtoStatData(stat, 99 - statGet(stat));
        statSet(stat, 99);
      } else {
        print('cannot bring $stat over 90');
        return false;
      }
    } else {
      addtoStatData(stat, amt);
      statSet(stat, statGet(stat) + amt);
    }
    return true;
  }

  void eduImprovement(int numChecks) {
    int numSuccesses = 0;
    for (var i = 0; i < numChecks; i++) {
      if (rng.nextInt(100) >= statGet('edu')) {
        numSuccesses += 1;
        alterStat('edu', rng.nextInt(10) + 1, max: 99);
      }
    }
    var s = numChecks > 1 ? 's' : '';
    var es = numSuccesses != 1 ? 'es' : '';
    eduData = '$numChecks edu improvement check$s, $numSuccesses success$es';
  }

  void statReduce(int amt, List<PlayerStat> bestAttributes) {
    List<String> reduceStats = [];
    if (isIn('pow', bestAttributes)) {
      reduceStats = ['str', 'dex', 'con'];
    } else if (isIn('dex', bestAttributes)) {
      reduceStats = ['str', 'con', 'dex'];
    } else if (isIn('str', bestAttributes)) {
      reduceStats = ['dex', 'con', 'str'];
    } else {
      reduceStats = ['str', 'dex', 'con'];
    }

    while (amt > 0) {
      if (statGet(reduceStats[0]) < 10) {
        reduceStats.removeAt(0);
      }
      if (reduceStats.length == 0) {
        return;
      }
      alterStat(reduceStats[0], -5);
      amt -= 5;
    }
  }

  void setAge() {
    var bestAttributes = stats.toList();
    for (var i in [5, 2, 1]) {
      bestAttributes.removeAt(i);
    } // remove stats that don't affect job skills
    var bestValue = bestAttributes.reduce((a, b) => (a.val > b.val) ? a : b);
    for (var i = bestAttributes.toList().length - 1; i >= 0; i--) {
      if (bestAttributes[i].val < bestValue.val) {
        bestAttributes.removeAt(i);
      } // remove non-optimal job skills
    }
    var mod = 1 /
        (1 + exp(-3 - (statGet('int') - statGet('pow') - statGet('edu')) / 16));
    age = (isIn('edu', bestAttributes))
        ? (20 + 20 * mod).toInt()
        : (isIn('app', bestAttributes))
            ? (15 + 10 * mod).toInt()
            : (15 + 64 * mod).toInt();

    if (age < 20) {
      luck = [(d6() + d6() + d6()) * 5, (d6() + d6() + d6()) * 5].reduce(max);
      if (isIn('str', bestAttributes)) {
        alterStat('siz', -5);
      } else {
        alterStat('str', -5);
      }
      alterStat('edu', -5);
    } else {
      luck = (d6() + d6() + d6()) * 5;
      if (age < 40) {
        eduImprovement(1);
      } else if (age < 50) {
        statReduce(5, bestAttributes);
        alterStat('app', -5);
        eduImprovement(2);
        mov -= 1;
      } else if (age < 60) {
        statReduce(10, bestAttributes);
        alterStat('app', -10);
        eduImprovement(3);
        mov -= 2;
      } else if (age < 70) {
        statReduce(20, bestAttributes);
        alterStat('app', -15);
        eduImprovement(4);
        mov -= 3;
      } else if (age < 80) {
        statReduce(40, bestAttributes);
        alterStat('app', -20);
        eduImprovement(4);
        mov -= 4;
      } else {
        statReduce(80, bestAttributes);
        alterStat('app', -25);
        eduImprovement(4);
        mov -= 5;
      }
    }
  }

  void hpMovBuild() {
    hp = (statGet('siz') + statGet('con')) ~/ 10;
    if (statGet('dex') < statGet('siz') && statGet('str') < statGet('siz')) {
      mov += 7;
    } else if (statGet('dex') > statGet('siz') &&
        statGet('str') > statGet('siz')) {
      mov += 9;
    } else {
      mov += 8;
    }
    final thicc = statGet('str') + statGet('siz');
    build = (thicc < 65)
        ? -2
        : (thicc < 85)
            ? -1
            : (thicc < 125)
                ? 0
                : (thicc < 165)
                    ? 1
                    : 2;
    final damageBonuses = <String>['-2', '-1', '0', '+1d4', '+1d6'];
    dmgBonus = damageBonuses[build + 2];
  }

  void decideOccupation() {
    var bestAttributes = stats.toList();
    for (var i in [5, 2, 1]) {
      bestAttributes.removeAt(i);
    } // remove stats that don't affect job skills
    final bestValue = bestAttributes.reduce((a, b) => (a.val > b.val) ? a : b);
    for (var i = bestAttributes.toList().length - 1; i >= 0; i--) {
      if (bestAttributes[i].val < bestValue.val) {
        bestAttributes.removeAt(i);
      } // remove non-optimal job skills
    }
    List<Job> jobs = [
      Job('Antiquarian', ['edu']),
      Job('Artist', ['pow', 'dex']),
      Job('Athlete', ['dex', 'str']),
      Job('Author', ['edu']),
      Job('Clergy', ['edu']),
      Job('Criminal', ['dex', 'str']),
      Job('Dilletante', ['app']),
      Job('Doctor', ['edu']),
      Job('Drifter', ['app', 'dex', 'str']),
      Job('Engineer', ['edu']),
      Job('Entertainer', ['app']),
      Job('Farmer', ['dex', 'str']),
      Job('Hacker', ['edu']),
      Job('Journalist', ['edu']),
      Job('Lawyer', ['edu']),
      Job('Librarian', ['edu']),
      Job('Military Officer', ['dex', 'str']),
      Job('Missionary', ['edu']),
      Job('Musician', ['dex', 'pow']),
      Job('Parapsychologist', ['edu']),
      Job('Pilot', ['dex']),
      Job('Police Detective', ['dex', 'str']),
      Job('Police Officer', ['dex', 'str']),
      Job('Private Investigator', ['dex', 'str']),
      Job('Professor', ['edu']),
      Job('Soldier', ['dex', 'str']),
      Job('Tribe Member', ['dex', 'str']),
      Job('Zealot', ['app', 'pow'])
    ];
    for (var i = 0; i < jobs.length; i++) {
      bool isBestJob = false;
      for (var attribute in jobs[i].reqs) {
        if (isIn(attribute, bestAttributes)) {
          isBestJob = true;
          break;
        }
      }
      if (isBestJob) {
        bestJobs.add(jobs[i].name);
      }
    }
    jobSkillPoints = 2 * statGet('edu') + 2 * bestValue.val;
  }
}

class CthulhuHome extends StatefulWidget {
  @override
  _CthulhuHomeState createState() => _CthulhuHomeState();
}

class _CthulhuHomeState extends State<CthulhuHome> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: cocTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Quick Call of Cthulhu Character')),
        drawer: appDrawer(context),
        body: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  child: Padding(
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
                          context,
                          MaterialPageRoute(
                            builder: (context) => AutoAgeDisplay(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManualAge(),
                          ));
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SwitchListTile(
                  title: Text('Compute age automatically?'),
                  value: autoAge,
                  onChanged: (value) => setState(() => autoAge = value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoAgeDisplay extends StatefulWidget {
  @override
  _AutoAgeDisplayState createState() => _AutoAgeDisplayState();
}

class _AutoAgeDisplayState extends State<AutoAgeDisplay> {
  @override
  Widget build(BuildContext context) {
    List<PlayerStat> initialStats = [];
    for (var stat in p.stats) {
      initialStats.add(PlayerStat(stat.name, stat.val));
    }

    p.setAge();
    return Theme(
      data: cocTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('')),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  '\nInitial Stat Values',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(height: 20),
                DataTable(
                    headingRowHeight: 30,
                    columns: [
                      DataColumn(label: Text('Stat')),
                      DataColumn(label: Text('Value'))
                    ],
                    rows: (() {
                      List<DataRow> rows = [];
                      for (var i = 0; i < initialStats.length; i++) {
                        rows.add(DataRow(cells: [
                          DataCell(Text(statNames[i])),
                          DataCell(Text(initialStats[i].val.toString())),
                        ]));
                      }
                      return rows;
                    }())),
                Text('\nAge: ${p.age}\n'),
                Text(p.eduData),
                Text(p.showStatData()),
                ElevatedButton(
                  child: Text('Next'),
                  onPressed: () {
                    p.hpMovBuild();
                    p.decideOccupation();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CharacterScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManualAge extends StatefulWidget {
  @override
  _ManualAgeState createState() => _ManualAgeState();
}

class _ManualAgeState extends State<ManualAge> {
  final _formKey = GlobalKey<FormState>();
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Theme(
        data: cocTheme,
        child: Scaffold(
          appBar: AppBar(title: Text('')),
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text(
                    '\nInitial Stat Values',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DataTable(
                      columns: [
                        DataColumn(label: Text('stat')),
                        DataColumn(label: Text('value'))
                      ],
                      rows: (() {
                        List<DataRow> rows = [];
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
                        for (var i = 0; i < p.stats.length; i++) {
                          rows.add(DataRow(cells: [
                            DataCell(Text(statNames[i])),
                            DataCell(Text(p.stats[i].val.toString())),
                          ]));
                        }
                        return rows;
                      }())),
                  Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Age', border: OutlineInputBorder()),
                      onChanged: (text) {
                        age = int.parse(text);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Input an age';
                        } else if (int.parse(value) < 15 ||
                            int.parse(value) > 89) {
                          return 'Out of range\n15 - 89';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                        child: Text('Next'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (age < 20) {
                              reduceAmt = 5;
                              p.luck = [
                                (d6() + d6() + d6()) * 5,
                                (d6() + d6() + d6()) * 5
                              ].reduce(max);
                              p.alterStat('edu', -5);
                            } else {
                              p.luck = (d6() + d6() + d6()) * 5;
                              if (age < 40) {
                                p.eduImprovement(1);
                              } else if (age < 50) {
                                reduceAmt = 5;
                                p.alterStat('app', -5);
                                p.eduImprovement(2);
                                p.mov -= 1;
                              } else if (age < 60) {
                                reduceAmt = 10;
                                p.alterStat('app', -10);
                                p.eduImprovement(3);
                                p.mov -= 2;
                              } else if (age < 70) {
                                reduceAmt = 20;
                                p.alterStat('app', -15);
                                p.eduImprovement(4);
                                p.mov -= 3;
                              } else if (age < 80) {
                                reduceAmt = 40;
                                p.alterStat('app', -20);
                                p.eduImprovement(4);
                                p.mov -= 4;
                              } else {
                                reduceAmt = 80;
                                p.alterStat('app', -25);
                                p.eduImprovement(4);
                                p.mov -= 5;
                              }
                            }
                            p.age = age;
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatReduceScreen(
                                    player: p,
                                    reduceAmt: reduceAmt,
                                  ),
                                ));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatReduceScreen extends StatefulWidget {
  final Player player;
  final int reduceAmt;
  StatReduceScreen({required this.player, required this.reduceAmt});

  @override
  _StatReduceScreenState createState() => _StatReduceScreenState();
}

class _StatReduceScreenState extends State<StatReduceScreen> {
  @override
  Widget build(BuildContext context) {
    print(reduceAmt);
    return Theme(
        data: cocTheme,
        child: Scaffold(
          appBar: AppBar(
            title: Text(''),
          ),
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              Text(p.eduData),
              Text(p.showStatData()),
              (() {
                updateFunction(int i) => (newMod) => setState(() {
                      p.stats[i].val = newMod;
                      reduceAmt -= 5;
                      if (reduceAmt <= 0 ||
                          (p.statGet('str') < 10 &&
                              p.statGet('con') < 10 &&
                              p.statGet('dex') < 10)) {
                        p.hpMovBuild();
                        p.decideOccupation();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CharacterScreen()));
                      }
                    });
                if (p.age >= 40) {
                  return Column(
                    children: [
                      StatReduceButton(
                          i: 0,
                          update: updateFunction(0),
                          statValue: p.stats[0].val),
                      StatReduceButton(
                          i: 1,
                          update: updateFunction(1),
                          statValue: p.stats[1].val),
                      StatReduceButton(
                          i: 3,
                          update: updateFunction(3),
                          statValue: p.stats[3].val),
                    ],
                  );
                } else if (p.age < 20) {
                  return Column(
                    children: [
                      StatReduceButton(
                          i: 0,
                          update: updateFunction(0),
                          statValue: p.stats[0].val),
                      StatReduceButton(
                          i: 2,
                          update: updateFunction(2),
                          statValue: p.stats[2].val),
                    ],
                  );
                } else {
                  return ElevatedButton(
                      onPressed: () {
                        p.hpMovBuild();
                        p.decideOccupation();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CharacterScreen()));
                      },
                      child: Text('Next'));
                }
              })(),
              Container(height: 20),
              Text(() {
                return (reduceAmt > 0)
                    ? 'Reduce the above stats by $reduceAmt, split however you like.'
                    : "";
              }()),
            ],
          ),
        ));
  }
}

class StatReduceButton extends StatelessWidget {
  final int i;
  final ValueChanged<int> update;
  final int statValue;

  StatReduceButton(
      {required this.i, required this.update, required this.statValue});

  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
              width: totalWidth / 2 - 75,
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              alignment: Alignment.centerRight,
              child: Text(statNames[i],
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Container(width: 40, child: Text(statValue.toString())),
          Container(width: () {
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

class CharacterScreen extends StatefulWidget {
  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final List<List<String>> ideologyBeliefs = [
    [
      "There is a higher power that you worship and pray to.",
      "Vishnu, Jesus Christ, Haile Selassie I"
    ],
    [
      "Mankind can do just fine without religions.",
      "staunch atheist, humanist, secularist"
    ],
    [
      "Science has all the answers. (pick a particular aspect of interest)",
      "evolution, cryogenics, space exploration"
    ],
    ["A belief in fate", "karma, the class system, superstitious"],
    [
      "Member of a society or secret society",
      "Freemason, Women's Institute, Anonymous"
    ],
    [
      "There is evil in society that should be rooted out.",
      "drugs, violence, racism"
    ],
    ["The occult", "astrology, spiritualism, tarot"],
    ["Politics", "conservative, socialist, liberal"],
    [
      "\"Money is power, and I'm going to get all I can\"",
      "greedy, enterprising, ruthless"
    ],
    ["Campaigner/Activist", "feminism, equal rights, union power"]
  ];
  final List<List<String>> significantPeople = [
    ["Parent", "mother, father, stepmother"],
    ["Grandparent", "maternal grandmother, paternal grandfather"],
    ["Sibling", "brother, half-brother, stepsister"],
    ["Child", "son or daughter"],
    ["Partner", "spouse, fiancé, lover"],
    [
      "Person who taught you your highest occupational skill. Identify the skill and consider who taught you",
      "a schoolteacher, the person you apprenticed with, your father"
    ],
    ["Childhood friend", "classmate, neighbor, imaginary friend"],
    [
      "A famous person. Your idol or hero. You may never have even met.",
      "film star, politician, musician"
    ],
    ["A fellow investigator in your game.", "Pick one or choose randomly."],
    ["An NPC in the game.", "Ask the Keeper to pick one for you."]
  ];
  final List<List<String>> significantReasons = [
    [
      "You are indebted to them.",
      "financially, they protected you through hard times, got you your first job"
    ],
    ["They taught you something.", "a skill, to love, to be a man"],
    [
      "They give your life meaning.",
      "you aspire to be like them, you seek to be with them, you seek to make them happy"
    ],
    [
      "You wronged them and seek reconciliation.",
      "stole money from them, informed the police about them, refused to help when they were desperate"
    ],
    [
      "Shared experience",
      "you lived through hard times together, you grew up together, you served in the war together"
    ],
    [
      "You seek to prove yourself to them.",
      "by getting a good job, by finding a good spouse, by getting an education"
    ],
    ["You idolize them.", "for their fame, their beauty, their work"],
    [
      "A feeling of regret",
      "you should have died in their place, you fell out over something you said, you didn't step up and help them when you had the chance"
    ],
    [
      "They had a flaw, and you wish to prove yourself better than them.",
      "lazy, drunk, unloving"
    ],
    [
      "They have crossed you and you seek revenge.",
      "death of a loved one, your financial ruin, marital breakup"
    ],
  ];
  final List<List<String>> meaningfulLocations = [
    ["Your seat of learning", "school, university"],
    ["Your hometown", "rural village, market town, busy city"],
    [
      "The place you met your first love",
      "a music concert, on holiday, a bomb shelter"
    ],
    [
      "A place for quiet contemplation",
      "the library, country walks on your estate, fishing"
    ],
    ["A place for socializing", "gentleman's club, local bar, uncle's house"],
    [
      "A place connected with your ideology/belief",
      "parish church, Mecca, Stonehenge"
    ],
    ["The grave of a significant person", "a parent, a child, a lover"],
    [
      "Your family home",
      "a country estate, a rented flat, the orphanage in which you were raised"
    ],
    [
      "The place you were the happiest in your life",
      "the park bench where you first kissed, your university"
    ],
    ["Your workplace", "the office, library, bank"]
  ];
  final List<List<String>> treasuredPossessions = [
    [
      "An item connected with your highest skill",
      "expensive suit, false ID, brass knuckles"
    ],
    ["An essential item for your occupation", "doctor's bag, car, lock picks"],
    ["A memento from your childhood", "comics, pocketknife, lucky coin"],
    [
      "A memento of a departed person",
      "jewelry, a photograph in your wallet, a letter"
    ],
    [
      "Something given to you by your Significant Person",
      "a ring, a diary, a map"
    ],
    ["Your collection", "bus tickets, stuffed animals, records"],
    [
      "Something you found but you don't know what it is—you seek answers",
      "a letter you found in a cupboard written in an unknown language, "
          "a curious pipe of unknown origin found among your late father's effects, "
          "a curious silver ball you dug up in your garden"
    ],
    ["A sporting item", "cricket bat, a signed baseball, a fishing rod"],
    [
      "A weapon",
      "service revolver, your old hunting rifle, the hidden knife in your boot"
    ],
    ["A pet", "a dog, a cat, a tortise"]
  ];

  List<String> rngText(List<List<String>> array) {
    return array[rng.nextInt(array.length)];
  }

  @override
  Widget build(BuildContext context) {
    final ideology = rngText(ideologyBeliefs);
    final person = rngText(significantPeople);
    final reason = rngText(significantReasons);
    final location = rngText(meaningfulLocations);
    final possession = rngText(treasuredPossessions);
    final screenWidth = MediaQuery.of(context).size.width;
    double tableWidth =
        (screenWidth < 500) ? screenWidth : 500 + (screenWidth - 500) / 2;
    return Theme(
      data: cocTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Full Character Info')),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: tableWidth,
                  margin: EdgeInsets.only(top: 20),
                  child: DataTable(
                      headingRowHeight: 30,
                      columns: [
                        DataColumn(label: Text('Stat')),
                        DataColumn(label: Text('Value')),
                        DataColumn(label: Text('Half')),
                        DataColumn(label: Text('Fifth')),
                      ],
                      rows: (() {
                        List<DataRow> rows = [];
                        for (var i = 0; i < p.stats.length; i++) {
                          rows.add(DataRow(cells: [
                            DataCell(Text(statNames[i])),
                            DataCell(Text(p.stats[i].val.toString())),
                            DataCell(Text((p.stats[i].val ~/ 2).toString())),
                            DataCell(Text((p.stats[i].val ~/ 5).toString())),
                          ]));
                        }
                        return rows;
                      }())),
                ),
                Container(height: 30),
                Container(
                  width: tableWidth,
                  child: Column(children: [
                    DataList(left: 'Hit Points', right: p.hp.toString()),
                    DataList(
                        left: 'Sanity', right: p.statGet('pow').toString()),
                    DataList(
                        left: 'Magic Points',
                        right: (p.statGet('pow') / 5).toString()),
                    DataList(left: 'Luck', right: p.luck.toString()),
                    DataList(left: 'Age', right: p.age.toString()),
                    DataList(left: 'Move Rate', right: p.mov.toString()),
                    DataList(left: 'Build', right: p.build.toString()),
                    DataList(
                        left: 'Damage Bonus', right: p.dmgBonus.toString()),
                    DataList(
                      left: 'Best Occupation Choices',
                      right: () {
                        String text = '${p.bestJobs[0]}';
                        for (var i = 1; i < p.bestJobs.length; i++) {
                          text += ", ${p.bestJobs[i]}";
                        }
                        return text;
                      }(),
                      subtitle:
                          'choose one of these for the maximum Occupation Skill Points',
                    ),
                    DataList(
                        left: 'Occupation Skill Points',
                        right: p.jobSkillPoints.toString()),
                    DataList(
                        left: 'Personal Interest Skill Points',
                        right: (p.statGet('int') * 2).toString()),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Container(width: tableWidth / 3),
                            Container(
                              width: tableWidth * 2 / 3,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.5,
                                          color: Color(0xFFcccccc)))),
                              child: Text('Backstory',
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                          ],
                        )),
                    DataList(
                        left: 'Ideology/Belief',
                        right: ideology[0],
                        subtitle: ideology[1]),
                    DataList(
                        left: 'Significant Person',
                        right: person[0],
                        subtitle: person[1]),
                    DataList(
                        left: 'Reason for their Significance',
                        right: reason[0],
                        subtitle: reason[1]),
                    DataList(
                        left: 'Meaningful Location',
                        right: location[0],
                        subtitle: location[1]),
                    DataList(
                        left: 'Treasured Possession',
                        right: possession[0],
                        subtitle: possession[1]),
                    Container(height: 50),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DataList extends StatelessWidget {
  final String left;
  final String right;
  final String subtitle;

  DataList({required this.left, required this.right, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double totalWidth =
        (screenWidth < 500) ? screenWidth : 500 + (screenWidth - 500) / 2;
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Container(
                width: totalWidth / 3,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Text(left,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
              width: totalWidth * 2 / 3,
              padding: EdgeInsets.only(right: 10),
              child: () {
                if (subtitle == '') {
                  return Text(right);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(right),
                      Text(subtitle,
                          style: TextStyle(color: Colors.grey, fontSize: 13))
                    ],
                  );
                }
              }(),
            ),
          ],
        ),
      ),
    );
  }
}
