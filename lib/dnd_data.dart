import 'main.dart';
import 'dnd.dart';
import 'dart:math';

bool customStats = false;

List<int> stats = []; // generated stat values
List<int> bonuses = []; // bonuses that can be changed by user
List<bool> selected = [false, false, false, false, false, false];
const List<String> statNames = ['Str', 'Dex', 'Con', 'Int', 'Wis', 'Cha'];
List<List<int>> arrays = [
  [17, 16, 12, 8, 8, 7],
  [17, 15, 14, 10, 7, 7],
  [17, 15, 13, 11, 9, 7],
  [17, 14, 12, 12, 10, 7],
  [16, 15, 14, 10, 8, 8],
  [16, 15, 14, 12, 7, 7],
  [16, 15, 12, 12, 10, 7],
  [15, 15, 14, 14, 9, 9],
];

List<int> findSelected() {
  final List<int> s = [];
  for (int i = 0; i < 6; i++) {
    if (selected[i]) s.add(i);
  }
  return s;
}

void generate(index) {
  customStats = false;
  bonuses = [0, 0, 0, 0, 0, 0];

  switch (index) {
    case 0: // 4d6 Drop Lowest
      {
        stats = [];
        for (int i = 0; i < 6; i++) {
          final dice = [for (int j = 0; j < 4; j++) d6];
          dice.sort();
          dice.removeAt(0); // drop lowest
          stats.add(dice.reduce((a, b) => a + b)); // append each stat to list
        }
      }
    case 1: // Standard Array
      {
        stats = [15, 14, 13, 12, 10, 8];
        stats.shuffle();
      }
    case 2: // Random Array
      {
        stats = arrays.random.toList();
        stats.shuffle();
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
    final List<int> betterStats = switch (rng.nextInt(13)) {
      0 => [0, 1, 2], // Barbarian
      _ => [
          (rng.nextDouble() + .75).toInt(), // 0 or 1 (str or dex)
          2, // con
          switch (rng.nextDouble()) {
            < .22 => 3,
            < .66 => 4,
            _ => 5
          } // int/wis/cha
        ],
    }; // randomly select 3 stats to prioritize
    final List<int> betterValues = stats.sublist(3); // highest 3 stats
    stats = stats.sublist(0, 3); // lowest 3 stats
    stats.shuffle();
    betterValues.shuffle();
    for (final stat in betterStats) {
      // loop through indices of prioritized stats
      stats.insert(stat, betterValues.removeAt(0));
    }

    final int highestEvenScore =
        stats.reduce((a, b) => a % 2 != 0 || (b > a && b % 2 == 0) ? b : a);
    final int highestOddScore =
        stats.reduce((a, b) => a % 2 == 0 || (b > a && b % 2 != 0) ? b : a);
    bonuses[stats.indexOf(highestEvenScore)] = 2;
    bonuses[stats.indexOf(highestOddScore)] = 1;
  }
}

List<String> getHighestStats() {
  final List<int> statTotals = [for (int i = 0; i < 6; i++) stats[i] + bonuses[i]];
  final List<String> bestScores = [];
  while (bestScores.length < 6) {
    final List<String> scores2pickfrom = [];
    final int maxScore = statTotals.reduce(max);
    for (int i = 0; i < statTotals.length; i++) {
      if (statTotals[i] == maxScore) {
        scores2pickfrom.add(statNames[i]);
      }
    }
    final String scoreName = scores2pickfrom.random;
    bestScores.add(scoreName);
    statTotals[statNames.indexOf(scoreName)] = 0;
  }
  return bestScores;
}

List<String> getRecommendations() {
  final List<String> bestScores = getHighestStats();

  final barbList = [
    'Barbarian',
    ['The Guardian Angel', 'The Furry Fury'].random,
  ];
  final intStrFighter = 'Fighter (${[
    'Eldritch Knight',
    'Psi Warrior',
    'with 3 Artificer levels',
  ].random})';
  final intDexFighter = 'Fighter (${[
    'Arcane Archer',
    'Eldritch Knight',
    'Psi Warrior',
    'with 1 Artificer level',
  ].random})';
  final strCleric = 'Cleric (${[
    'Forge',
    'Tempest',
    'Twilight',
    'War',
  ].random} Domain)';
  final dexCleric = 'Cleric (${[
    'Arcana',
    'Death',
    'Grave',
    'Light',
    'Peace',
    'Trickery',
  ].random} Domain)';
  final stranger =
      stats[1] >= 13 && rng.nextInt(3) > 0 ? 'Ranger (with 1 or 2 Fighter levels)' : 'Ranger';
  final wisWizard = 'Wizard (Dwarf, with one ${[
    'Forge',
    'Life',
    'Order',
    'Twilight',
  ].random} Cleric level)';

  return switch (bestScores) {
    ['Str', 'Dex', ..._] when stats[3] >= 13 => ['Barbarian', 'The Psychic Suplex'],
    ['Str', 'Dex', ..._] => barbList,
    ['Str', 'Con', 'Dex', ..._] => barbList,
    ['Str', 'Con', 'Int', ..._] => [intStrFighter, 'The Psychic Suplex'],
    ['Str', 'Int', ..._] => [intStrFighter, 'The Spellsword'],
    ['Str', 'Con', 'Wis', ..._] => [
        strCleric,
        'Fighter (Great Weapon Fighting Style)',
        'Ranger',
        if (stats[5] >= 12) 'Fighter (Samurai)',
        'The Favored Fighter',
      ],
    ['Str', 'Con', 'Cha', ..._] => [
        'Fighter (Great Weapon Fighting Style)',
        'Paladin',
        ['The Dragon Warrior', 'The Showoff'].random,
      ],
    ['Str', 'Con', ..._] => barbList..insert(1, 'Fighter (Great Weapon Fighting Style)'),
    ['Str', 'Wis', ..._] => [
        strCleric,
        stranger,
        if (stats[5] >= 12) 'Fighter (Samurai)',
        if (stats[1] >= 13)
          ['Teenage Mutant Ninja Tortle', 'The Turn 1 Terror', 'The Unseen Warden'].random
        else
          'The Favored Fighter',
      ],
    ['Str', 'Cha', 'Wis', ..._] => ['Paladin', 'God of Thunder'],
    ['Str', 'Cha', ..._] => [
        'Paladin',
        ['The Dragon Warrior', 'The Dragon Tamer', 'The Showoff'].random,
      ],
    ['Dex', 'Str', ..._] => barbList,
    ['Dex', 'Con', 'Str', ..._] => [
        'Fighter (Archery Fighting Style)',
        'Rogue',
        'Barbarian',
        [
          'The Guardian Angel',
          'The Superior Daggers',
          'The Dad',
        ].random,
      ],
    ['Dex', 'Con', 'Int', ..._] => [
        'Fighter (Archery Fighting Style)',
        'Rogue (Arcane Trickster)',
        'The Spellsword',
      ],
    ['Dex', 'Con', 'Wis', ..._] => [
        'Fighter (Archery Fighting Style)',
        'Rogue (Inquisitive)',
        'Ranger',
        if (stats[5] >= 12) 'Fighter (Samurai)',
        ['D&D Batman', 'The Turn 1 Terror'].random,
      ],
    ['Dex', 'Con', 'Cha', ..._] => [
        'Fighter (Archery Fighting Style)',
        'Rogue',
        'Bard',
        if (stats[4] >= 12) 'Fighter (Samurai)',
        'The Big Booming Blade',
      ],
    ['Dex', 'Con', ..._] => [
        'Fighter (Archery Fighting Style)',
        ['The Superior Daggers', 'The Dad'].random,
      ],
    ['Dex', 'Int', ..._] => [
        intDexFighter,
        'Rogue (Arcane Trickster)',
        'Wizard (Bladesinger)',
        'The Spellsword',
      ],
    ['Dex', 'Wis', ..._] => [
        'Monk',
        'Ranger',
        ['D&D Batman', 'The Turn 1 Terror', 'The All-Seeing Eye'].random,
      ],
    ['Dex', 'Cha', ..._] => [
        'Bard',
        if (stats[4] >= 12) 'Fighter (Samurai)',
        'Rogue (Swashbuckler)',
        'Warlock',
        'The Big Booming Blade',
      ],
    ['Con', 'Str', 'Dex', ..._] => barbList,
    ['Con', 'Str', 'Int', ..._] => [intStrFighter, 'The Psychic Suplex'],
    ['Con', 'Str', 'Wis', ..._] => [
        strCleric,
        if (stats[5] >= 12) 'Fighter (Samurai)',
        'The Favored Fighter',
      ],
    ['Con', 'Str', 'Cha', ..._] => [
        'Paladin',
        if (stats[4] >= 12) 'Fighter (Samurai)',
        ['The Dragon Warrior', 'The Showoff'].random,
      ],
    ['Con', 'Str', ..._] => barbList..insert(1, 'Fighter (Great Weapon Fighting Style)'),
    ['Con', 'Dex', 'Str', ..._] => [
        'Fighter (Archery Fighting Style)',
        'Rogue',
        ['The Superior Daggers', 'The Dad', 'The Guardian Angel'].random,
      ],
    ['Con', 'Dex', 'Int', ..._] => [
        'Artificer',
        if (rng.nextBool()) 'Fighter (Archery Fighting Style)' else intDexFighter,
        'Rogue',
        'Wizard',
        'The Spellsword',
      ],
    ['Con', 'Dex', 'Wis', ..._] => [
        if (bestScores[3] == 'Cha') 'Fighter (Samurai)' else 'Fighter (Archery Fighting Style)',
        'Ranger',
        'Rogue',
        ['D&D Batman', 'The Turn 1 Terror'].random,
      ],
    ['Con', 'Dex', 'Cha', ..._] => [
        'Bard',
        if (bestScores[3] == 'Wis') 'Fighter (Samurai)' else 'Fighter (Archery Fighting Style)',
        'Rogue (Swashbuckler)',
        'The Big Booming Blade',
      ],
    ['Con', 'Int', ..._] => [
        if (rng.nextBool()) ...['Artificer', 'Wizard'] else if (stats[4] >= 13)
          wisWizard
        else
          'Wizard (with one Artificer level)',
        if (bestScores[2] == 'Cha' || bestScores[3] == 'Cha')
          'Pocket-size Pain'
        else
          ['The Ice Porcupine', 'The Conch Shell', 'The Lightning Shooter'].random,
      ],
    ['Con', 'Wis', 'Str', ..._] => ['Druid', 'Ranger', 'The Telekinetic Tiger'],
    ['Con', 'Wis', 'Dex', ..._] => [
        dexCleric,
        'Druid',
        'Monk',
        'Ranger',
        ['The BBC', 'The All-Seeing Eye'].random,
      ],
    ['Con', 'Wis', 'Int', ..._] => ['Cleric (Knowledge Domain)', 'Druid', 'The Pet Detective'],
    ['Con', 'Wis', 'Cha', ..._] => [
        'Druid',
        ['The Diplomat', 'The Pet Detective'].random,
      ],
    ['Con', 'Cha', final third, ..._] => [
        'Bard',
        'Sorcerer',
        'Warlock',
        switch (third) {
          'Str' => ['The Mini-Nuke', 'The Conquistador', 'The Stick Figure'].random,
          'Dex' => ['The Sorlock', 'The Preacher', 'The Politician'].random,
          'Int' => 'The Edgelord',
          'Wis' || _ => ['The Big Succ', 'God of Thunder', 'God of Support'].random,
        },
      ],
    ['Int', 'Str', ..._] => [intStrFighter, 'The Spellsword'],
    ['Int', 'Dex', ..._] => [
        'Artificer',
        intDexFighter,
        'Rogue (Arcane Trickster)',
        'Wizard',
        ['The Ice Porcupine', 'The Conch Shell', 'The Lightning Shooter'].random,
      ],
    ['Int', 'Con', ..._] => [
        if (rng.nextBool()) 'Wizard (with one Artificer level)' else ...['Artificer', 'Wizard'],
        if (stats[5] >= 13 && rng.nextInt(3) > 0)
          'Pocket-size Pain'
        else
          ['The Ice Porcupine', 'The Conch Shell', 'The Lightning Shooter'].random,
      ],
    ['Int', 'Wis', ..._] => [
        wisWizard,
        ['The Ice Porcupine', 'The Conch Shell', 'The Lightning Shooter'].random,
      ],
    ['Int', 'Cha', ..._] => [
        'Bard',
        if (stats[1] >= 13) 'Rogue (Swashbuckler)',
        'Wizard',
        'Pocket-size Pain',
      ],
    ['Wis', 'Str', ..._] => [strCleric, stranger, 'The Favored Fighter'],
    ['Wis', 'Dex', ..._] => [
        dexCleric,
        'Druid',
        'Monk',
        'Ranger',
        ['The Platinum Star', 'The Platinum Star', 'The All-Seeing Eye'].random,
      ],
    ['Wis', 'Con', 'Str', ..._] => [strCleric, stranger, 'The Telekinetic Tiger'],
    ['Wis', 'Con', 'Dex', ..._] => [
        dexCleric,
        'Druid',
        'Monk',
        'Ranger',
        ['The Platinum Star', 'The BBC', 'The All-Seeing Eye'].random,
      ],
    ['Wis', 'Con', 'Cha', ..._] => [
        'Cleric (Dwarf, Order Domain)',
        'Ranger (Fey Wanderer)',
        'The Diplomat',
      ],
    ['Wis', 'Con', ..._] => [
        'Cleric (Dwarf, ${['Life', 'Nature'].random} Domain)',
        'Druid',
        'Ranger (Druidic Warrior Fighting Style)',
        'The Telekinetic Tiger',
      ],
    ['Wis', 'Int', ..._] => [
        'Cleric (Knowledge Domain)',
        if (stats[1] >= 13) 'The Pet Detective' else 'The Platinum Star',
      ],
    ['Wis', 'Cha', ..._] => [
        if (stats[0] >= 13) 'Cleric (Order Domain)' else 'Cleric (Dwarf, Order Domain)',
        'Ranger (Fey Wanderer)',
        if (stats[1] >= 13) ['The Diplomat', 'The Pet Detective'].random else 'God of Thunder',
      ],
    ['Cha', 'Str', ..._] => [
        'Paladin',
        if (stats[4] >= 13)
          'God of Thunder'
        else
          ['The Dragon Warrior', 'The Dragon Tamer', 'The Showoff'].random,
      ],
    ['Cha', 'Dex', ..._] => [
        'Bard',
        'Sorcerer',
        'Warlock',
        ['The Sorlock', 'The Preacher', 'The Politician'].random,
      ],
    ['Cha', 'Con', ..._] when stats[0] >= 13 => [
        'Bard',
        'Paladin',
        'Sorcerer',
        'Warlock',
        ['The Mini-Nuke', 'The Conquistador', 'The Stick Figure'].random,
      ],
    ['Cha', 'Con', ..._] => [
        'Bard',
        'Sorcerer',
        'Warlock',
        ['The Sorlock', 'The Preacher', 'The Politician'].random,
      ],
    ['Cha', 'Int', ..._] => [
        'Bard',
        if (stats[1] >= 13) 'Rogue (Swashbuckler, with one Hexblade Warlock level)',
        ['The Preacher', 'The Politician', 'The Edgelord'].random,
      ],
    ['Cha', 'Wis', ..._] => [
        'Bard',
        if (stats[1] >= 13)
          'Ranger (Fey Wanderer)'
        else
          'Ranger (Fey Wanderer, Druidic Warrior Fighting Style)',
        'Sorcerer',
        'Warlock',
        if (max(stats[0], stats[1]) >= 13)
          'The Shogun Pact'
        else
          ['The Big Succ', 'God of Thunder', 'God of Support'].random,
      ],
    _ => throw Exception("best scores were $bestScores which wasn't handled for some reason"),
  };
}
