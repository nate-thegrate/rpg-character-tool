import 'main.dart';
import 'dnd.dart';
import 'dart:math';

List<int> stats = []; // generated stat values
List<int> bonuses = []; // bonuses that can be changed by user

bool customStats = false;
final List<String> statNames = ['Str', 'Dex', 'Con', 'Int', 'Wis', 'Cha'];
List<List<int>> arrays = [
  [18, 17, 8, 8, 7, 7],
  [18, 15, 14, 7, 7, 7],
  [18, 14, 13, 11, 7, 7],
  [18, 11, 11, 11, 11, 11],
  [17, 16, 10, 10, 9, 9],
  [17, 14, 12, 10, 10, 10],
  [16, 16, 16, 7, 7, 7],
  [16, 15, 14, 10, 8, 8],
  [16, 14, 13, 12, 10, 9],
  [16, 12, 12, 12, 12, 12],
  [15, 14, 14, 14, 9, 9],
  [15, 15, 15, 10, 10, 10],
  [15, 14, 12, 12, 12, 12],
  [14, 14, 14, 14, 14, 9]
];

void generate(index) {
  customStats = false;
  bonuses = [0, 0, 0, 0, 0, 0];

  switch (index) {
    case 0: // 4d6 Drop Lowest
      {
        stats = [];
        for (int i = 0; i < 6; i++) {
          List<int> dice = [];
          for (int j = 0; j < 4; j++) {
            dice.add(d6());
          }
          dice.sort();
          dice.removeAt(0); // drop lowest
          stats.add(dice.reduce((a, b) => a + b)); // append each stat to list
        }
        break;
      }
    case 1: // Standard Array
      {
        stats = [15, 14, 13, 12, 10, 8];
        stats.shuffle();
        break;
      }
    case 2: // Random Array
      {
        stats = pickRandom(arrays).toList();
        stats.shuffle();
        break;
      }
    case 3: // Custom
      {
        stats = [10, 10, 10, 10, 10, 10];
        customStats = true;
        return;
      }
  }

  if (autoArrange) {
    stats.sort();
    List<int> betterStats = []; // randomly select 3 stats to prioritize
    if (rng.nextInt(13) == 0) {
      betterStats = [0, 1, 2]; // Barbarian
    } else {
      int strDex = (rng.nextDouble() + .75).toInt();
      final int con = 2;
      double x = rng.nextDouble();
      int intWisCha = x < 2 / 9
          ? 3
          : x < 2 / 3
              ? 4
              : 5;
      betterStats = [strDex, con, intWisCha];
      List<int> betterValues = [stats[3], stats[4], stats[5]];
      // betterValues = highest 3 stats
      stats = [stats[0], stats[1], stats[2]];
      // remove betterValues from stats
      stats.shuffle();
      betterValues.shuffle();
      for (final stat in betterStats) {
        // loop through indices of prioritized stats
        stats.insert(stat, betterValues.removeAt(0));
      }
    }
    int highestEvenScore =
        stats.reduce((a, b) => a % 2 != 0 || (b > a && b % 2 == 0) ? b : a);
    int highestOddScore =
        stats.reduce((a, b) => a % 2 == 0 || (b > a && b % 2 != 0) ? b : a);
    bonuses[stats.indexOf(highestEvenScore)] = 2;
    bonuses[stats.indexOf(highestOddScore)] = 1;
  }
}

List<String> getHighestStats() {
  if (stats.length < 6 || bonuses.length < 6) {
    print("stat or bonus array is incomplete");
    return [];
  }
  List<int> statTotals = [0, 0, 0, 0, 0, 0];
  for (int i = 0; i < statTotals.length; i++) {
    statTotals[i] = stats[i] + bonuses[i];
  }
  List<String> bestScores = [];
  List<String> scores2pickfrom = [];
  while (bestScores.length < 6) {
    int maxScore = statTotals.reduce(max);
    for (int i = 0; i < statTotals.length; i++) {
      if (statTotals[i] == maxScore) {
        scores2pickfrom.add(statNames[i]);
      }
    }
    String scoreName = pickRandom(scores2pickfrom);
    bestScores.add(scoreName);
    statTotals[statNames.indexOf(scoreName)] = 0;
    scores2pickfrom = [];
  }
  return bestScores;
}

List<String> getRecommendations() {
  final List<String> bestScores = getHighestStats();
  for (int i = 2; i < bestScores.length; i++) {
    if (stats[statNames.indexOf(bestScores[i])] < 12) bestScores[i] = "";
  }
  List<String> r = []; // list of recommendations
  switch (bestScores[0]) {
    case 'Str': // highest ability is Strength
      {
        switch (bestScores[1]) {
          case 'Dex': // highest abilities: Str, Dex
            {
              r.add('Barbarian');
              if (bestScores[2] == 'Int' || bestScores[3] == 'Int')
                r.add('The Psychic Suplex');
              else
                r.add(pickRandom(['The Guardian Angel', 'The Furry Fury']));
              break;
            }
          case 'Con': // highest abilities: Str, Con
            {
              r.add('Barbarian');
              switch (bestScores[2]) {
                case 'Dex':
                  {
                    r.add(pickRandom(['The Guardian Angel', 'The Furry Fury']));
                    break;
                  }
                case 'Int': // Str, Con, Int
                  {
                    r.add('Fighter (${pickRandom([
                      'Eldritch Knight',
                      'Psi Warrior',
                      'with 3 Artificer levels',
                    ])})');
                    r.add('The Psychic Suplex');
                    break;
                  }
                case 'Wis': // Str, Con, Wis
                  {
                    r.addAll([
                      'Cleric (${pickRandom([
                        'Forge',
                        'Tempest',
                        'Twilight',
                        'War'
                      ])})',
                      'Ranger',
                    ]);
                    if (bestScores[3] == 'Cha') r.add('Fighter (Samurai)');
                    r.add('The Favored Fighter');
                    break;
                  }
                case 'Cha': // Str, Con, Cha
                  {
                    r.add('Paladin');
                    r.add(pickRandom(['The Dragon Warrior', 'The Showoff']));
                    break;
                  }
                default:
                  {
                    r.add(pickRandom(['The Guardian Angel', 'The Furry Fury']));
                    break;
                  }
              }
              break;
            }
          case 'Int': // highest abilities: Str, Int
            {
              r.add('Fighter (${pickRandom([
                'Eldritch Knight',
                'Psi Warrior',
                'with 3 Artificer levels',
              ])})');
              r.add('The Psychic Suplex');
              break;
            }
          case 'Wis': // highest abilities: Str, Wis
            {
              r.addAll([
                'Cleric (${pickRandom([
                  'Forge',
                  'Tempest',
                  'Twilight',
                  'War'
                ])})',
                'Ranger',
              ]);
              if (bestScores[2] == 'Cha' || bestScores[3] == 'Cha') {
                r.add('Fighter (Samurai)');
              }
              if (bestScores[2] == 'Dex' || bestScores[3] == 'Dex')
                r.add(pickRandom([
                  'Teenage Mutant Ninja Tortle',
                  'The Turn 1 Terror',
                  'The Unseen Warden'
                ]));
              else
                r.add('The Favored Fighter');
              break;
            }
          case 'Cha': // highest abilities: Str, Cha
            {
              r.add('Paladin');
              if (bestScores[2] == 'Wis')
                r.add('God of Thunder');
              else
                r.add(pickRandom(['The Dragon Warrior', 'The Showoff']));
              break;
            }
        }
        break;
      }
    case 'Dex': // highest ability is Dexterity
      {
        switch (bestScores[1]) {
          case 'Str': // highest abilities: Dex, Str
            {
              r.add('Barbarian');
              r.add(pickRandom(['The Guardian Angel', 'The Furry Fury']));
              break;
            }
          case 'Con': // highest abilities: Dex, Con
            {
              r.add('Fighter (Archery Fighting Style)');
              if (bestScores[2] == 'Int') {
                // Dex, Con, Cha
                r.add('Rogue (Arcane Trickster)');
                r.add('The Spellsword');
              } else if (bestScores[2] == 'Wis') {
                // Dex, Con, Wis
                r.addAll([
                  'Rogue (Inquisitive)',
                  'Ranger',
                ]);
                if (bestScores[3] == 'Cha') r.add('Fighter (Samurai)');
                r.add(pickRandom(['D&D Batman', 'The Turn 1 Terror']));
              } else {
                r.add('Rogue');
                if (bestScores[2] == 'Str') {
                  // Dex, Con, Str
                  r.add('Barbarian');
                  r.add(pickRandom([
                    'The Guardian Angel',
                    'The Superior Daggers',
                    'The Dad',
                  ]));
                } else if (bestScores[2] == 'Cha') {
                  // Dex, Con, Cha
                  r.add('Bard');
                  if (bestScores[3] == 'Wis') r.add('Fighter (Samurai)');
                  r.add('The Big Booming Blade');
                } else {
                  r.add(pickRandom(['The Superior Daggers', 'The Dad']));
                }
              }
              break;
            }
          case 'Int': // highest abilities: Dex, Int
            {
              r.addAll([
                'Rogue (Arcane Trickster)',
                'Wizard (Bladesinger)',
                'Fighter (${pickRandom([
                  'Arcane Archer',
                  'Eldritch Knight',
                  'Psi Warrior',
                  'with 3 Artificer levels',
                ])})',
              ]);
              r.add('The Spellsword');
              break;
            }
          case 'Wis': // highest abilities: Dex, Wis
            {
              r.addAll([
                'Monk',
                'Ranger',
              ]);
              r.add(pickRandom(['D&D Batman', 'The Turn 1 Terror']));
              break;
            }
          case 'Cha': // highest abilities: Dex, Cha
            {
              r.addAll(['Bard', 'Warlock', 'Rogue (Swashbuckler)']);
              if (bestScores[2] == 'Wis' || bestScores[3] == 'Wis')
                r.add('Fighter (Samurai)');
              r.add('The Big Booming Blade');
              break;
            }
        }
        break;
      }
    case 'Con': // highest ability is Constitution
      {
        switch (bestScores[1]) {
          case 'Str': // highest abilities: Con, Str
            {
              r.addAll(['Barbarian', 'Fighter (Great Weapon Fighting Style)']);
              switch (bestScores[2]) {
                case 'Dex': // Con, Str, Dex
                  {
                    r.add(pickRandom(['The Guardian Angel', 'The Furry Fury']));
                    break;
                  }
                case 'Int':
                  {
                    r.add('The Psychic Suplex');
                    break;
                  }
                case 'Wis': // Con, Str, Wis
                  {
                    r.add(
                      'Cleric (${pickRandom([
                        'Forge',
                        'Tempest',
                        'Twilight',
                        'War'
                      ])})',
                    );
                    if (bestScores[3] == 'Cha') r.add('Fighter (Samurai)');
                    r.add('The Favored Fighter');
                    break;
                  }
                case 'Cha': // Con, Str, Cha
                  {
                    r.add('Paladin');
                    if (bestScores[3] == 'Wis') r.add('Fighter (Samurai)');
                    r.add(pickRandom(['The Dragon Warrior', 'The Showoff']));
                    break;
                  }
                default:
                  {
                    r.add(pickRandom(['The Guardian Angel', 'The Furry Fury']));
                    break;
                  }
              }
              break;
            }
          case 'Dex': // highest abilities: Con, Dex
            {
              r.addAll(['Fighter (Archery Fighting Style)', 'Rogue']);
              switch (bestScores[2]) {
                case 'Str':
                  {
                    r.add(pickRandom([
                      'The Superior Daggers',
                      'The Dad',
                      'The Guardian Angel',
                    ]));
                    break;
                  }
                case 'Int': // Con, Dex, Int
                  {
                    r.addAll(['Wizard', 'Artificer']);
                    r.add('The Spellsword');
                    break;
                  }
                case 'Wis': // Con, Dex, Wis
                  {
                    r.add('Ranger');
                    if (bestScores[3] == 'Cha') r.add('Fighter (Samurai)');
                    r.add(pickRandom(['D&D Batman', 'The Turn 1 Terror']));
                    break;
                  }
                case 'Cha': // Con, Dex, Cha
                  {
                    r.addAll(['Rogue (Swashbuckler)', 'Bard']);
                    if (bestScores[3] == 'Wis') r.add('Fighter (Samurai)');
                    r.add('The Big Booming Blade');
                    break;
                  }
                default:
                  {
                    r.add(pickRandom(['The Superior Daggers', 'The Dad']));
                  }
              }
              break;
            }
          case 'Int': // highest abilities: Con, Int
            {
              r.addAll(['Wizard', 'Artificer']);
              if (bestScores[2] == 'Cha' || bestScores[3] == 'Cha')
                r.add('Pocket-size Pain');
              else
                r.add(pickRandom([
                  'The Ice Porcupine',
                  'The Conch Shell',
                  'The Lightning Shooter'
                ]));
              break;
            }
          case 'Wis': // highest abilities: Con, Wis
            {
              r.add('Druid');
              switch (bestScores[2]) {
                case 'Str': // Con, Wis, Str
                  {
                    r.add('Ranger');
                    r.add('The Telekinetic Tiger');
                    break;
                  }
                case 'Dex': // Con, Wis, Dex
                  {
                    r.addAll(['Monk', 'Ranger']);
                    r.add('The BBC');
                    break;
                  }
                case 'Int': // Con, Wis, Int
                  {
                    r.add('Cleric (Knowledge)');
                    r.add('The Pet Detective');
                    break;
                  }
                case 'Cha': // Con, Wis, Cha
                  {
                    r.add(pickRandom(
                        ['Master of All Trades', 'The Pet Detective']));
                    break;
                  }
                default:
                  {
                    r.add('The Telekinetic Tiger');
                    break;
                  }
              }
              break;
            }
          case 'Cha': // highest abilities: Con, Cha
            {
              r.addAll(['Sorcerer', 'Warlock', 'Bard']);
              switch (bestScores[2]) {
                case 'Str': // Con, Cha, Str
                  {
                    r.add(pickRandom([
                      'The Mini-Nuke',
                      'The Conquistador',
                      'The Stick Figure',
                    ]));
                    break;
                  }
                case 'Dex': // Con, Cha, Dex
                  {
                    r.add(pickRandom([
                      'The Sorlock',
                      'The Preacher',
                      'The Politician',
                    ]));
                    break;
                  }
                case 'Int':
                  {
                    r.add('The Edgelord');
                    break;
                  }
                case 'Wis': // Con, Cha, Wis
                  {
                    r.add(pickRandom(
                        ['The Big Succ', 'God of Thunder', 'God of Support']));
                    break;
                  }
                default:
                  {
                    r.add('The Edgelord');
                    break;
                  }
              }
              break;
            }
        }
        break;
      }
    case 'Int': // highest ability is Intelligence
      {
        switch (bestScores[1]) {
          case 'Str': // highest abilities: Int, Str
            {
              r.addAll([
                'Fighter (${pickRandom([
                  'Eldritch Knight',
                  'Psi Warrior',
                  'with 3 Artificer levels',
                ])})',
              ]);
              r.add(pickRandom([
                'The Ice Porcupine',
                'The Conch Shell',
                'The Lightning Shooter'
              ]));
              break;
            }
          case 'Dex': // highest abilities: Int, Dex
            {
              r.addAll([
                'Wizard',
                'Artificer',
                'Rogue (Arcane Trickster)',
                'Fighter (${pickRandom([
                  'Arcane Archer',
                  'Eldritch Knight',
                  'Psi Warrior',
                  'with 3 Artificer levels',
                ])})',
              ]);
              r.add(pickRandom([
                'The Ice Porcupine',
                'The Spellsword',
                'The Lightning Shooter'
              ]));
              break;
            }
          case 'Con': // highest abilities: Int, Con
            {
              r.addAll([
                'Wizard',
                'Artificer',
                'Wizard (with one Artificer level)',
              ]);
              if (bestScores[2] == 'Cha' || bestScores[3] == 'Cha')
                r.add('Pocket-size Pain');
              else
                r.add(pickRandom([
                  'The Ice Porcupine',
                  'The Conch Shell',
                  'The Lightning Shooter'
                ]));
              break;
            }
          case 'Wis': // highest abilities: Int, Wis
            {
              r.add(pickRandom([
                'Wizard (Dwarf, with one ${pickRandom([
                  'Forge',
                  'Life',
                  'Order',
                  'Twilight',
                ])} Cleric level)',
              ]));
              r.add(pickRandom([
                'The Ice Porcupine',
                'The Conch Shell',
                'The Lightning Shooter'
              ]));
              break;
            }
          case 'Cha': // highest abilities: Int, Cha
            {
              r.addAll(['Wizard', 'Bard']);
              if (bestScores[2] == 'Dex') {
                r.add('Rogue (Swashbuckler)');
              }
              r.add('Pocket-size Pain');
              break;
            }
        }
        break;
      }
    case 'Wis': // highest ability is Wisdom
      {
        switch (bestScores[1]) {
          case 'Str': // highest abilities: Wis, Str
            {
              r.addAll([
                'Cleric (${pickRandom([
                  'Forge',
                  'Tempest',
                  'Twilight',
                  'War',
                ])})',
                'Ranger',
              ]);
              r.add('The Favored Fighter');
              break;
            }
          case 'Dex': // highest abilities: Wis, Dex
            {
              r.addAll([
                'Cleric (${pickRandom([
                  'Arcana',
                  'Death',
                  'Grave',
                  'Light',
                  'Peace',
                  'Trickery',
                ])})',
                'Ranger',
                'Monk',
                'Druid',
              ]);
              r.add('The Bulletproof Kensei');
              break;
            }
          case 'Con': // highest abilities: Wis, Con
            {
              switch (bestScores[2]) {
                case 'Str': // Wis, Con, Str
                  {
                    r.addAll([
                      'Cleric (${pickRandom([
                        'Forge',
                        'Life',
                        'Nature',
                        'Order',
                        'Tempest',
                        'Twilight',
                        'War',
                      ])})',
                      'Ranger (with 1 or 2 Fighter levels)',
                    ]);
                    r.add('The Telekinetic Tiger');
                    break;
                  }
                case 'Dex': // Wis, Con, Dex
                  {
                    r.addAll(['Druid', 'Ranger', 'Monk']);
                    r.add(pickRandom(['The Bulletproof Kensei', 'The BBC']));
                    break;
                  }
                case 'Cha': // Wis, Con, Cha
                  {
                    r.add('Ranger (Fey Wanderer)');
                    r.add('Master of All Trades');
                    break;
                  }
                default:
                  {
                    r.addAll([
                      'Cleric (Dwarf, ${pickRandom([
                        'Life',
                        'Nature',
                        'Order',
                      ])} Domain)',
                      'Druid',
                      'Ranger (Druidic Warrior Fighting Style)',
                    ]);
                    r.add('The Telekinetic Tiger');
                    break;
                  }
              }
              break;
            }
          case 'Int': // highest abilities: Wis, Int
            {
              r.add('Cleric (Knowledge)');
              r.add('The Bulletproof Kensei');
              break;
            }
          case 'Cha': // highest abilities: Wis, Cha
            {
              r.addAll([
                'Ranger (Fey Wanderer)',
                'Cleric (Order)',
              ]);
              if (bestScores[2] == 'Dex' || bestScores[3] == 'Dex') {
                r.add('Master of All Trades');
              }
              r.add('Master of All Trades');
              break;
            }
        }
        break;
      }
    case 'Cha': // highest ability is Charisma
      {
        switch (bestScores[1]) {
          case 'Str': // highest abilities: Cha, Str
            {
              r.add('Paladin');
              if (bestScores[2] == 'Wis')
                r.add('God of Thunder');
              else
                r.add(pickRandom(['The Dragon Warrior', 'The Showoff']));
              break;
            }
          case 'Dex': // highest abilities: Cha, Dex
            {
              r.addAll(['Bard', 'Warlock', 'Sorcerer']);
              r.add(pickRandom([
                'The Sorlock',
                'The Preacher',
                'The Politician',
              ]));
              break;
            }
          case 'Con': // highest abilities: Cha, Con
            {
              r.addAll(['Bard', 'Sorcerer', 'Warlock']);
              switch (bestScores[2]) {
                case 'Str': // Cha, Con, Str
                  {
                    r.add('Paladin');
                    r.add(pickRandom([
                      'The Mini-Nuke',
                      'The Conquistador',
                      'The Stick Figure',
                    ]));
                    break;
                  }
                case 'Dex': // Cha, Con, Dex
                  {
                    r.add(pickRandom([
                      'The Sorlock',
                      'The Preacher',
                      'The Politician',
                    ]));
                    break;
                  }
                case 'Wis': // Cha, Con, Wis
                  {
                    r.add(pickRandom(
                        ['The Big Succ', 'God of Thunder', 'God of Support']));
                    break;
                  }
                default:
                  {
                    r.add('The Edgelord');
                    break;
                  }
              }
              break;
            }
          case 'Int': // highest abilities: Cha, Int
            {
              r.addAll([
                'Bard',
                'Rogue (Swashbuckler, with one Hexblade Warlock level)',
              ]);
              r.add(pickRandom(
                  ['The Preacher', 'The Politician', 'The Edgelord']));
              break;
            }
          case 'Wis': // highest abilities: Cha, Wis
            {
              r.add('Ranger (Fey Wanderer)');
              r.add('The Shogun Pact');
              break;
            }
        }
        break;
      }
  }
  return r;
}
