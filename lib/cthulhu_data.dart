import 'dart:math';
import 'main.dart';
import 'cthulhu.dart';

Player p = Player();

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
    "Person who taught you your highest occupational skill. Identify the skill and consider who taught you.",
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
    PlayerStat('STR', (d6() + d6() + d6()) * 5),
    PlayerStat('CON', (d6() + d6() + d6()) * 5),
    PlayerStat('SIZ', (d6() + d6() + 6) * 5),
    PlayerStat('DEX', (d6() + d6() + d6()) * 5),
    PlayerStat('APP', (d6() + d6() + d6()) * 5),
    PlayerStat('INT', (d6() + d6() + 6) * 5),
    PlayerStat('POW', (d6() + d6() + d6()) * 5),
    PlayerStat('EDU', (d6() + d6() + 6) * 5)
  ];

  int statGet(String s) {
    for (final score in stats) {
      if (score.name == s) {
        return score.val;
      }
    }
    return -1;
  }

  void statSet(String s, int x) {
    for (int i = 0; i < stats.length; i++) {
      if (stats[i].name == s) {
        stats[i].val = x;
        return;
      }
    }
  }

  bool isIn(String s, List<PlayerStat> bestAttributes) {
    for (final score in bestAttributes) {
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

  int reduceAmt = 0;

  String eduData = '';

  List<PlayerStat> statData = [
    PlayerStat('STR', 0),
    PlayerStat('CON', 0),
    PlayerStat('SIZ', 0),
    PlayerStat('DEX', 0),
    PlayerStat('APP', 0),
    PlayerStat('INT', 0),
    PlayerStat('POW', 0),
    PlayerStat('EDU', 0)
  ];

  void addtoStatData(String stat, int amt) {
    for (int i = 0; i < 8; i++) {
      if (statData[i].name == stat) {
        statData[i].val += amt;
        return;
      }
    }
  }

  String showStatData() {
    String data = '';
    for (final stat in statData) {
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
        // EDU improvement
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
    for (int i = 0; i < numChecks; i++) {
      if (rng.nextInt(100) >= statGet('EDU')) {
        numSuccesses += 1;
        alterStat('EDU', rng.nextInt(10) + 1, max: 99);
      }
    }
    eduData = '$numChecks edu improvement check${numChecks > 1 ? 's' : ''}, '
        '$numSuccesses success${numSuccesses != 1 ? 'es' : ''}';
  }

  void statReduce(int amt, List<PlayerStat> bestAttributes) {
    List<String> reduceStats = [];
    // the order to reduce stats in if age is 40 or greater.
    // front of list = not valuable, back of list = more valuable
    if (isIn('POW', bestAttributes)) {
      reduceStats = ['STR', 'DEX', 'CON'];
    } else if (isIn('DEX', bestAttributes)) {
      reduceStats = ['STR', 'CON', 'DEX'];
    } else if (isIn('STR', bestAttributes)) {
      reduceStats = ['DEX', 'CON', 'STR'];
    } else {
      reduceStats = ['STR', 'DEX', 'CON'];
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
    if (autoAge) {
      List<PlayerStat> bestAttributes = stats.toList();
      for (final i in [5, 2, 1]) {
        bestAttributes.removeAt(i);
      } // remove stats that don't affect job skills
      PlayerStat bestValue =
          bestAttributes.reduce((a, b) => (a.val > b.val) ? a : b);
      for (int i = bestAttributes.toList().length - 1; i >= 0; i--) {
        if (bestAttributes[i].val < bestValue.val) {
          bestAttributes.removeAt(i);
        } // remove non-optimal job skills
      }
      double mod = 1 /
          (1 +
              exp(-3 -
                  (statGet('INT') - statGet('POW') - statGet('EDU')) / 16));
      // value of mod is between 0 and 1
      // more educated & less likely to go insane = want to be younger
      // uses a sigmoid function to evenly distribute the probability of each age

      age = (isIn('EDU', bestAttributes))
          ? (20 + 20 * mod).toInt()
          // someone with high EDU won't benefit from older age
          // and would want to avoid the teenage EDU debuff
          : (isIn('APP', bestAttributes))
              // high APP + low EDU = ideal teen
              ? (15 + 10 * mod).toInt()
              : (15 + 64 * mod).toInt();

      if (age < 20) {
        luck = [(d6() + d6() + d6()) * 5, (d6() + d6() + d6()) * 5].reduce(max);
        if (isIn('STR', bestAttributes)) {
          alterStat('SIZ', -5);
        } else {
          alterStat('STR', -5);
        }
        alterStat('EDU', -5);
      } else {
        luck = (d6() + d6() + d6()) * 5;
        if (age < 40) {
          eduImprovement(1);
        } else if (age < 50) {
          statReduce(5, bestAttributes);
          alterStat('APP', -5);
          eduImprovement(2);
          mov -= 1;
        } else if (age < 60) {
          statReduce(10, bestAttributes);
          alterStat('APP', -10);
          eduImprovement(3);
          mov -= 2;
        } else if (age < 70) {
          statReduce(20, bestAttributes);
          alterStat('APP', -15);
          eduImprovement(4);
          mov -= 3;
        } else if (age < 80) {
          statReduce(40, bestAttributes);
          alterStat('APP', -20);
          eduImprovement(4);
          mov -= 4;
        } else {
          statReduce(80, bestAttributes);
          alterStat('APP', -25);
          eduImprovement(4);
          mov -= 5;
        }
      }
    } else {
      if (age < 20) {
        luck = [(d6() + d6() + d6()) * 5, (d6() + d6() + d6()) * 5].reduce(max);
        alterStat('EDU', -5);
        reduceAmt = 5;
      } else {
        luck = (d6() + d6() + d6()) * 5;
        if (age < 40) {
          eduImprovement(1);
        } else if (age < 50) {
          reduceAmt = 5;
          alterStat('APP', -5);
          eduImprovement(2);
          mov -= 1;
        } else if (age < 60) {
          reduceAmt = 10;
          alterStat('APP', -10);
          eduImprovement(3);
          mov -= 2;
        } else if (age < 70) {
          reduceAmt = 20;
          alterStat('APP', -15);
          eduImprovement(4);
          mov -= 3;
        } else if (age < 80) {
          reduceAmt = 40;
          alterStat('APP', -20);
          eduImprovement(4);
          mov -= 4;
        } else {
          reduceAmt = 80;
          alterStat('APP', -25);
          eduImprovement(4);
          mov -= 5;
        }
      }
    }
  }

  void hpMovBuild() {
    hp = (statGet('SIZ') + statGet('CON')) ~/ 10;
    if (statGet('DEX') < statGet('SIZ') && statGet('STR') < statGet('SIZ')) {
      mov += 7;
    } else if (statGet('DEX') > statGet('SIZ') &&
        statGet('STR') > statGet('SIZ')) {
      mov += 9;
    } else {
      mov += 8;
    }
    final thicc = statGet('STR') + statGet('SIZ');
    build = (thicc < 65)
        ? -2
        : (thicc < 85)
            ? -1
            : (thicc < 125)
                ? 0
                : (thicc < 165)
                    ? 1
                    : 2;
    final List<String> damageBonuses = ['-2', '-1', '0', '+1d4', '+1d6'];
    dmgBonus = damageBonuses[build + 2];
  }

  void decideOccupation() {
    List<PlayerStat> bestAttributes = stats.toList();
    for (final i in [5, 2, 1]) {
      bestAttributes.removeAt(i);
    } // remove stats that don't affect job skills
    final bestValue = bestAttributes.reduce((a, b) => (a.val > b.val) ? a : b);
    for (int i = bestAttributes.toList().length - 1; i >= 0; i--) {
      if (bestAttributes[i].val < bestValue.val) {
        bestAttributes.removeAt(i);
      } // remove non-optimal job skills
    }
    List<Job> jobs = [
      Job('Antiquarian', ['EDU']),
      Job('Artist', ['POW', 'DEX']),
      Job('Athlete', ['DEX', 'STR']),
      Job('Author', ['EDU']),
      Job('Clergy', ['EDU']),
      Job('Criminal', ['DEX', 'STR']),
      Job('Dilletante', ['APP']),
      Job('Doctor', ['EDU']),
      Job('Drifter', ['APP', 'DEX', 'STR']),
      Job('Engineer', ['EDU']),
      Job('Entertainer', ['APP']),
      Job('Farmer', ['DEX', 'STR']),
      Job('Hacker', ['EDU']),
      Job('Journalist', ['EDU']),
      Job('Lawyer', ['EDU']),
      Job('Librarian', ['EDU']),
      Job('Military Officer', ['DEX', 'STR']),
      Job('Missionary', ['EDU']),
      Job('Musician', ['DEX', 'POW']),
      Job('Parapsychologist', ['EDU']),
      Job('Pilot', ['DEX']),
      Job('Police Detective', ['DEX', 'STR']),
      Job('Police Officer', ['DEX', 'STR']),
      Job('Private Investigator', ['DEX', 'STR']),
      Job('Professor', ['EDU']),
      Job('Soldier', ['DEX', 'STR']),
      Job('Tribe Member', ['DEX', 'STR']),
      Job('Zealot', ['APP', 'POW'])
    ];
    for (int i = 0; i < jobs.length; i++) {
      bool isBestJob = false;
      for (final attribute in jobs[i].reqs) {
        if (isIn(attribute, bestAttributes)) {
          isBestJob = true;
          break;
        }
      }
      if (isBestJob) {
        bestJobs.add(jobs[i].name);
      }
    }
    jobSkillPoints = 2 * statGet('EDU') + 2 * bestValue.val;
  }
}
