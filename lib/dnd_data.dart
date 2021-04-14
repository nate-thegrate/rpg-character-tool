import 'main.dart';
import 'dnd.dart';
import 'dart:math';

List<int> stats = []; // generated stat values
List<int> bonuses = []; // bonuses that can be changed by user

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
final List<Build> builds = [
  Build(
    'The Sorlock',
    ['Sorcerer', 'Warlock'],
    ['decent Dexterity', 'high Charisma'],
    'A character of tremendous power, '
        'combining innate magic with an otherworldly pact. '
        'Mix & match subclasses for whatever flavor you want!',
    [
      'Take your first level as a Sorcerer, and then take one Warlock level.',
      'Now take the rest of your levels as a Sorcerer. '
          'Make sure you grab the Eldritch Adept feat as soon as you can.',
    ],
    [
      'As a Sorcerer, you have proficiency in Constitution saving throws '
          'to help maintain concentration on spells, '
          'and you have access to really cool options for spells & metamagic.',
      'Cast a Quickened Agonizing Blast for some amazing damage, '
          'and then do whatever you\'d like with your action.',
      'Divine Smite works great with a Sorcerer\'s full-caster spell slots.',
    ],
  ),
  Build(
    'The Dragon Warrior',
    ['Paladin', 'Sorcerer'],
    ['15 Strength', 'high Charisma'],
    'Fight with explosive power!',
    [
      'Take your first two levels as a Paladin.'
          'Now, you can take the rest of your levels as a '
          'Red Draconic Sorcerer, or you could get 6 Paladin levels first '
          'for Extra Attack and Aura of Protection.',
    ],
    [
      'Quicken a Green-Flame Blade. You can deal damage from your weapon, '
          'your Fighting Style, the cantrip, '
          'Elemental Affinity, and Divine Smite.',
      'And you still have a main action to use.',
      'Feel free to mix & match other subclasses and figure out other cool strategies!',
    ],
    race: 'Tiefling could be great for Flames of Phlegethos',
  ),
  Build(
    'The Showoff',
    ['Bard (College of Swords)', 'Paladin'],
    ['15 Strength', 'high Charisma'],
    'Add the power of a Sacred Oath to your massive list of talents.',
    [
      'Take your first two levels as a Paladin.',
      'From there, you can take the rest of your levels as a Bard in the '
          'College of Swords, or you could get 6 Paladin levels first '
          'for Extra Attack and Aura of Protection.',
      'Eventually, your character will either be '
          '2 Paladin levels and the rest in Bard, '
          'or 5 Bard levels and the rest in Paladin.',
    ],
    [
      'Divine Smite works great with a Bard\'s full-caster spell slots, '
          'and you can Smite & Blade Flourish on the same hit.',
      'Heavy Armor combined with Defensive Flourish '
          'makes you perfect for the front lines.',
    ],
  ),
  Build(
    'The Preacher',
    ['Bard', 'Sorcerer (Divine Soul)'],
    ['decent Dexterity', 'high Charisma'],
    'Nobody gives better holy sermons.',
    [
      'Take your first level as a Divine Soul Sorcerer, '
          'and then take the rest of your levels as a Bard.',
      'College of Glamour works great, '
          'and so would Creation, Eloquence, or Lore.',
    ],
    [
      'The dip into Sorcerer gives you a lot of awesome stuff '
          'for just one level.',
      'You get proficiency in Constitution saving throws, '
          'which helps you concentrate on spells.',
      'You also get a +2d4 to a save each short rest '
          'that doesn\'t take your reaction, '
          'and you can use your reaction for Absorb Elements and Shield.',
      'Spells like Fire Bolt, Guidance, Spare the Dying, Thaumaturgy, '
          'and Bless all work really well on a Bard.',
    ],
    race: 'Aasimar would really fit the theme',
  ),
  Build(
    'The Politician',
    ['Bard', 'Warlock'],
    ['decent Dexterity', 'high Charisma'],
    'You\'re able to destroy your opposition, '
        'and you only had to sell your soul a little bit.',
    [
      'Take one Warlock level and the rest as a Bard.',
      'College of Eloquence/Pact of the Fiend really fits the flavor, '
          'but feel free to mix & match subclasses.',
      'Make sure you grab the Eldritch Adept feat as soon as you can.',
    ],
    [
      'You now have all the social utility of a Bard, '
          'with all the power of Agonizing Blast.',
    ],
  ),
  Build(
    'The Edgelord',
    ['Bard (College of Whispers)', 'Warlock (Hexblade Patron)'],
    ['14 Dexterity', 'high Charisma'],
    'You may not injure all those you meet by edge of your sword, '
        'but your words are often far more dangerous.',
    [
      'Take one Hexblade Warlock level '
          'and the rest as a Bard in the College of Whispers.',
    ],
    [
      'Hex Warrior is the perfect complement for the College of Whispers, '
          'letting you focus on Charisma for attacks, spellcasting, '
          'and socializing, and Psychic Blades gets a whole lot better '
          'with the expanded critical range of Hexblade\'s Curse.',
      'Take Booming Blade, Green-Flame Blade, Shield, and Wrathful Smite, '
          'and you\'ll be set.',
    ],
  ),
  Build(
    'The Mini-Nuke',
    [
      'Bard (College of Whispers)',
      'Paladin (Oath of Vengeance)',
      'Warlock (Hexblade Patron)',
    ],
    ['15 Strength', 'high Charisma'],
    'Get ready for some triple-crit-smites!',
    [
      'Take one Paladin level to start.',
      'Take 5 Hexblade Warlock levels and then 2 more Paladin levels '
          '(for Oath of Vengeance).',
      'Then take the rest of your levels as a Bard '
          'in the College of Whispers.',
      'Make sure you pick up Elven Accuracy at some point.',
    ],
    [
      'With Hexblade\'s Curse, Vow of Enmity, and Elven Accuracy, '
          'you\'ll get a critical hit 27% of the time.',
      'Then you can use Divine Smite, Eldritch Smite, and Psychic Blades '
          'on the same hit for atrocious amonts of damage.',
    ],
    race: 'Elf or Half-Elf',
  ),
  Build(
    'The Conquistador',
    ['Paladin (Oath of Conquest)', 'Warlock (Hexblade Patron)'],
    ['15 Strength', 'high Charisma'],
    'Render your enemies frozen with terror, and then whack them to death.',
    [
      'Take one Paladin level to start, '
          'and then take a Hexblade Warlock level.',
      'Then continue with Paladin (Oath of Conquest) up to level 6, '
          'and then take 2 more levels of Hexblade (Pact of the Blade).',
      'Finally, take one more Paladin level, '
          'and you can continue with either class from there.',
    ],
    [
      'Your character will do really well at any level, '
          'but it really starts to shine once you hit Paladin 6 / Warlock 3.',
      'The Aura of Conquest immobilizes frightened enemies within 10 feet '
          'of you, and thanks to Hexblade, you can scare them and '
          'hit them with a reach weapon, and it all runs on Charisma.',
    ],
  ),
  Build(
    'The Stick Figure',
    ['Paladin', 'Warlock (Hexblade Patron)'],
    ['15 Strength', 'high Charisma'],
    'Who knew a simple weapon could be so awesome?',
    [
      'Take one Paladin level to start, '
          'and then take a Hexblade Warlock level.',
      'Then continue with Paladin from there.',
      'Pick whatever Sacred Oath looks good to you, '
          'and make sure you grab the Polearm Master feat at some point.',
    ],
    [
      'The spear runs on Charisma and gets an extra hit with Polearm Master.',
      'Each hit is damage-boosted by Dueling Fighting Style, '
          'Hexblade\'s Curse, Improved Divine Smite, and whatever spell '
          'you wanna cast (e.g. Divine Favor/Spirit Shroud/Holy Weapon)',
    ],
  ),
  Build(
    'The Shogun Pact',
    ['Fighter (Samurai)', 'Warlock (Hexblade Patron)'],
    ['15 Strength or 14 Dexterity', 'high Charisma'],
    'The good Samurais all have names for their swords.',
    [
      'Take one Fighter level, and then take a level of Hexblade Warlock.',
      'Then pick your favorite out of those two classes '
          'and take it to level 5.',
      'From there, which levels you take is up to you. '
          'Hexblade 5 is great thanks to Eldritch Smite, '
          'Samurai 7 is great if you have a good Wisdom score, '
          'and Samurai 11 is really good if you can make it there.',
      'Make sure you grab the Elven Accuracy feat as soon as you can.',
    ],
    [
      'This build gives you a lot of freedom to choose what you want to do.',
      'You can wear medium or heavy armor, '
          'and you can use a melee or a ranged weapon '
          '(and take feats like Great Weapon Master '
          'or Sharpshooter respectively).',
      'With Hexblade\'s Curse, Fighting spirit, and Elven Accuracy, '
          'you\'ll get a critical hit 27% of the time.',
    ],
    race: 'Elf or Half-Elf',
  ),
  Build(
    'The Big Booming Blade',
    ['Rogue (Swashbuckler)', 'Sorcerer (Wild Magic)'],
    ['high Dexterity', '13 Charisma'],
    '[description]',
    [
      'Take at least 3 levels as a Swashbuckler Rogue, '
          'and then take 5 levels as a Wild Magic Sorcerer.',
      'Then continue as a Rogue from there.',
    ],
    [
      'Tides of Chaos gives you free advantage for whenever '
          'Rakish Audacity fails, and you get to benefit from Sorcerer spells.',
      'You can quicken a Booming Blade, and then use your action '
          'to ready a second Booming Blade. This gives you Sneak Attack '
          'and Booming Blade damage twice in one round!',
    ],
  ),
  Build(
    'The Superior Daggers',
    ['Rogue', 'Fighter (Battle Master)'],
    ['high Dexterity'],
    '[description]',
    [
      'Take 3 levels as a Battle Master Fighter, and then do the rest as '
          'a Rogue.',
      'Do whichever Rogueish Archetype you like '
          '(Assassin, Inquisitive, and Thief all work well in this build).',
    ],
    [
      'You get 4 Superiority Dice as a Battle Master, and you can get a fifth '
          'with the Superior Technique Fighting Style.',
      'On your turn, use Quick Toss to get your Sneak Attack, '
          'and use your Action to ready another dagger.',
      'If you miss the Quick Toss, use Action Surge. '
          'This lets you get your Sneak Attack off twice each round!',
    ],
  ),
  Build(
    'The Ice Porcupine',
    ['Fighter', 'Wizard (School of Abjuration)'],
    ['13 Dexterity', 'high Intelligence'],
    '[description]',
    [
      'Take 1 Fighter level, and then do the rest as a Wizard.',
      'Make sure you grab the Heavy Armor Master feat at some point.',
    ],
    [
      'Cast Armor of Agathys for temporary hit points, '
          'and cast Absorb Elements & Stoneskin for damage reduction.',
      'These spells all recharge your Abjuration Ward, '
          'and any enemies near you have to eat through the Ward '
          'and the temporary HP, taking cold damage the whole time.',
      'Get the Superior Technique Fighting Style for Bait and Switch. '
          'You can eventually take a second Fighter level for Action Surge '
          'if you\'d like to.',
    ],
    race: 'Dwarf (Mark of Warding)',
  ),
  Build(
    'The Conch Shell',
    ['Artificer (Battle Smith)', 'Wizard (Bladesinging)'],
    ['high Intelligence'],
    '[description]',
    [
      'There are a few good ways to do level progression.',
      '1: Just take Bladesinger Wizard levels (don\'t multiclass).',
      '2: Take your first level as an Artificer. '
          'Then take two Bladesinger levels, '
          'and then continue as a Battle Smith Artificer from there.',
      '3: Take your first level as an Artificer. '
          'Take 5 Bladesinger levels and then two more '
          'Artificer (Battle Smith) levels. '
          'Then continue as a Bladesinger from there.',
    ],
    [
      'You get a 20+ Armor Class without wearing armor '
          'or investing in Strength or Dexterity.',
      'With +5 Intelligence, Bracers of Defense, and the Shield spell, '
          'you can have an AC of 31!',
      'Everything runs on your Intelligence: AC, weapon attack/damage '
          '(if you multiclass), spellcasting, and Constitution saving throws.',
    ],
    race: 'Tortle',
  ),
  Build(
    'Teenage Mutant Ninja Tortle',
    ['Barbarian', 'Monk'],
    ['high Strength', '13 Wisdom'],
    'Beef up your punches with some rage!',
    [
      'Take one Barbarian level and then two Monk levels.',
      'From there, you can continue with Monk levels or get the '
          'Unarmed Fighting Style and continue as a Barbarian or Fighter.',
    ],
    [
      'Monks get lots of attacks each turn, which synergizes really well '
          'with the Rage Damage Bonus.',
      'You can be a fantastic grappler & damage dealer, '
          'and as a Tortle you don\'t have to worry about Armor Class.',
    ],
    race: 'Tortle',
  ),
  Build(
    'The Holy Spirit',
    ['Cleric (Trickery Domain)', 'Monk (Way of the Astral Self)'],
    ['decent Dexterity', 'high Wisdom'],
    '[description]',
    [
      'Take 5 levels as an Astral Monk, and then take 5 levels '
          'as a Trickery Cleric. Then continue with Monk levels from there.',
    ],
    [
      'Free advantage via Invoke Duplicity is awesome, '
          'and spells like Mirror Image, Blink, and Spirit Shroud '
          'pair with a Monk beautifully.',
      'You get some great utility as a Cleric, and everything runs on Wisdom: '
          'Attacks, Armor Class, Stunning Strike, and spellcasting.',
    ],
  ),
  Build(
    'The Bulletproof Kensei',
    ['Cleric (Nature Domain)', 'Fighter', 'Monk (Way of the Kensei)'],
    ['13 Dexterity', 'high Wisdom'],
    'Who needs Martial Arts when you have a club and steel plates?',
    [
      'Take your first level as a Nature Cleric and grab a club & shield. '
          'Then take 6 Monk levels in the Way of the Kensei.',
      'Then take one Fighter level with the Dueling Fighting Style, '
          'and continue with the Monk class from there.',
    ],
    [
      'Once you hit Monk level 6, you can take advantage of Deft Strike '
          'and Ki-Fueled Attack to make a club attack as a bonus action, '
          'and the Fighter level lets you add Dueling damage to each hit.',
      'That\'s a total of 3d8 + 1d6 + 18 during one turn at level 8, '
          'and you\'re a character that can cast Shield of Faith to get '
          '22 AC and can Dodge as a bonus action.',
    ],
    race: 'Dwarf: your armor won\'t slow you down, and you can get '
        'Dwarven Fortitude for some great bonus action healing.',
  ),
  Build(
    'The Big Succ',
    ['Cleric (Life Domain)', 'Warlock (Celestial Patron)'],
    ['13 Wisdom', 'high Charisma'],
    'Who needs Martial Arts when you have a club and steel plates?',
    [
      'Take at least 2 Warlock levels, then one Life Domain Cleric level, '
          'and then continue as a Warlock.',
    ],
    [
      'Get Pact of the Chain, along with Investment of the Chain Master '
          '& Gift of the Ever-Living Ones.',
      'Cast Vampiric Touch or Enervation. The recovery you get each turn '
          'is boosted by Life Domain.',
      'If you ever actually get hurt, cast a Celestial-boosted Hellish Rebuke '
          'and then get 24 HP as a bonus action from Soul Cage.',
    ],
    race: 'Dwarf in heavy armor, or another race in medium armor',
  ),
  Build(
    'God of Thunder',
    ['Cleric (Tempest Domain)', 'Sorcerer (Storm Sorcery)'],
    ['13 Wisdom', 'high Charisma'],
    '[description]',
    [
      'Take 5 Sorcerer levels and then 2 Cleric levels. '
          'Then continue as a Sorcerer from there.',
    ],
    [
      'Use Transmuted Spell and Destructive Wrath '
          'whenever you feel like winning.',
    ],
    race: 'Be a Dwarf so you don\'t need Strength, '
        'or be another race and use a hammer for Booming Blade.',
  ),
  Build(
    'God of Support',
    ['Cleric (Order Domain)', 'Sorcerer (Divine Soul)'],
    ['13 Wisdom', 'high Charisma'],
    '[description]',
    [
      'Take 5 Sorcerer levels and then 1 Cleric level. '
          'Then continue as a Sorcerer from there.',
    ],
    [
      'You have a bunch of support spells at your disposal '
          'that work great with Metamagic, and they can take advantage of '
          'your Voice of Authority.',
    ],
    race: 'Dwarf in heavy armor, or another race in medium armor',
  ),
  Build(
    'Master of All Trades',
    [
      'Bard (College of Eloquence)',
      'Cleric (Knowledge Domain)',
      'Ranger (Fey Wanderer)',
      'Rogue (Scout)',
    ],
    ['14 Dexterity', 'high Wisdom', 'high Charisma'],
    'You\'re going to be the very best, like no one ever was.',
    [
      'Start of with a Rogue level. Then take a Cleric level, 3 Ranger levels, '
          '3 Bard levels, and then bring Rogue up to level 6.',
      'From there, you can level up whichever class you want to.',
      'Make sure you grab the Prodigy and Skill Expert feats '
          'as soon as you can.',
    ],
    [
      'You\'ll have Expertise in 9 skills by level 10, '
          'and 4 more skills by level 14.',
      'Every skill can get a bonus d4 via Guidance, all Charisma checks add '
          'your Wisdom modifier (thanks to Fey Wanderer), and '
          'Deception/Persuasion are guaranteed at least a 10 '
          '(Thanks to College of Eloquence)',
    ],
    race: 'Human (Mark of Finding) gives you a d4 bonus with '
        'Perception & Survival checks, and Pallid Elf gives advantage on '
        'Investigation & Insight.',
  ),
  Build(
    'The Psychic Suplex',
    ['Barbarian (Path of the Battlerager)', 'Fighter (Psi Warrior)'],
    ['high Strength', 'decent Dexterity', 'decent Intelligence'],
    '[description]',
    [
      'Take 1 Barbarian level and then 7 Psi Warrior Fighter levels.',
      'Then take Barbarian up to 3 for Path of the Battlerager, '
          'and continue with Fighter from there.',
      'Make sure you grab the Skill Expert feat as soon as you can '
          'so you get Expertise in Athletics.',
    ],
    [
      'Grapple two enemies with a +13 bonus and advantage, '
          'then fly up 60 feet and drop them. Nonmagical weapon resistance '
          'doesn\'t reduce fall damage, but your rage does.',
      'Get even higher if somebody casts Haste so you can Dash.',
    ],
    race: 'Tabaxi, so you get Feline Agility',
  ),
  Build(
    'D&D Batman',
    ['Monk (Way of Shadow)', 'Ranger (Gloom Stalker)'],
    ['high Dexterity', 'decent Wisdom'],
    'Darkness is your ally.',
    [
      'Take 5 Monk levels, then 4 Ranger levels, and then continue with Monk.',
    ],
    [
      'Invisibility, teleportation, and a bunch of Hunter\'s Mark-boosted '
          'attacks each turn.',
      'Use natural darkness, or take Eldritch Adept for Devil\'s Sight.',
    ],
  ),
  Build(
    'The Turn 1 Terror',
    ['Fighter', 'Ranger (Gloom Stalker)'],
    ['high Dexterity', 'decent Wisdom'],
    '[description]',
    [
      'Take 3-5 Ranger levels, then 2 Fighter levels, '
          'and then continue with either class.',
    ],
    [
      'Activate Dread Ambush, and then use Action Surge and do it again '
          'for some crazy good damage straight from the gate.',
    ],
  ),
  Build(
    'The Unseen Death',
    ['Cleric (War Domain)', 'Ranger'],
    ['high Strength', '13 Dexterity', 'decent Wisdom'],
    '[description]',
    [
      'Take 2 Cleric levels and then do Ranger from there.',
      'Make sure you grab the Great Weapon Master and Sentinel feats '
          'as soon as you can.',
    ],
    [
      'Cast Fog Cloud near a Favored Foe, and then hit them repeatedly.',
      'Blind Fighting Style gives you advantage, and Sentinel makes it '
          'so they can\'t escape.',
      'War Priest and Guided Strike are both super helpful.',
    ],
    race: 'Variant Human or Custom Lineage, '
        'so you can start with Great Weapon Master',
  ),
  Build(
    'The Pet Detective',
    ['Druid (Circle of the Shepherd)', 'Rogue (Inquisitive)'],
    ['14 Dexterity', 'high Wisdom'],
    '[description]',
    [
      'Take 2 Druid levels and then do Rogue from there.',
    ],
    [
      'Expertise and advantage on skill checks to talk to animals '
          'means they\'ll do whatever you want them to, which can open up '
          'a bunch of possibilities.',
      'The Entangle spell and the Hawk Spirit Totem set up Sneak Attack, '
          'and you can use Magic Stone to attack using your Wisdom.',
    ],
    race: 'Firbolg, so you can talk to animals with advantage',
  ),
  Build(
    'The Guardian Angel',
    ['Barbarian (Path of the Ancestral Guardian)'],
    ['high Strength', 'decent Dexterity'],
    '[description]',
    [
      'Take all your levels in the Barbarian class.',
      'Make sure you grab the Great Weapon Master feat as soon as you can.',
      'If a single class is too boring, you can take 3 levels of '
          'Champion Fighter to get more critical hits. '
          'You can grab the Piercer feat as well.',
    ],
    [
      'Rage & Reckless Attack with a pike, then fly up or into cover. '
          'Now they can\'t hit you, and they can\'t hit your friends.',
    ],
    race: 'Aarakocra',
  ),
  Build(
    'The Dad',
    ['Rogue (Thief)', 'Fighter (Banneret)'],
    ['high Dexterity'],
    'Rally your companions with some amazing dad jokes!',
    [
      'Take 3 Rogue levels and then do Fighter from there.',
      'Make sure you grab the Healer feat as soon as you can.',
    ],
    [
      'You don\'t need fancy magic to support your friends! Fast Hands & Healer lets you pop up an ally as a bonus action.',
      'Rallying Cry is another great way to do it.',
      'Take the Superior Technique Fighting Style and/or the Martial Adept '
          'feat, so you can perform supportive maneuvers (like Distracting '
          'Strike, Goading Attack, Maneuvering Attack, or Bait and Switch)',
    ],
    race: 'Human (for the ideal dad bod) or Kobold (\'Grovel, Cower, and Beg\' '
        'is just you making terrible puns)',
  ),
];

class Build {
  String name = '';
  List<String> classes = [];
  List<String> scores = [];
  String description = '';
  List<String> buildSteps = [];
  List<String> combatSteps = [];
  String race = '';

  Build(String name, List<String> classes, List<String> scores, String desc,
      List<String> build, List<String> combat,
      {String race = 'any'}) {
    this.name = name;
    this.classes = classes;
    this.scores = scores;
    this.description = desc;
    this.buildSteps = build;
    this.combatSteps = combat;
    this.race = race;
  }
}

void generate(index) {
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
      }
      break;
    case 1: // Standard Array
      {
        stats = [15, 14, 13, 12, 10, 8];
        stats.shuffle();
      }
      break;
    case 2: // Random Array
      {
        stats = pickRandom(arrays).toList();
        stats.shuffle();
      }
      break;
  }

  bonuses = [0, 0, 0, 0, 0, 0];

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
              else if (bestScores[2] == 'Con' || bestScores[3] == 'Con')
                r.add('The Guardian Angel');
              r.add('The Guardian Angel');
              break;
            }
          case 'Con': // highest abilities: Str, Con
            {
              r.add('Barbarian');
              switch (bestScores[2]) {
                case 'Dex':
                  {
                    r.add('The Guardian Angel');
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
                    r.add(pickRandom(
                        ['Teenage Mutant Ninja Tortle', 'The Unseen Death']));
                    break;
                  }
                case 'Cha': // Str, Con, Cha
                  {
                    r.add('Paladin');
                    r.add(pickRandom(['The Dragon Warrior', 'The Showoff']));
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
              if (bestScores[2] == 'Dex' || bestScores[3] == 'Dex')
                r.add('The Psychic Suplex');
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
                r.add(pickRandom(['The Turn 1 Terror', 'The Unseen Death']));
              else
                r.add('Teenage Mutant Ninja Tortle');
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
              r.add('The Guardian Angel');
              break;
            }
          case 'Con': // highest abilities: Dex, Con
            {
              r.add('Fighter (Archery Fighting Style)');
              if (bestScores[2] == 'Wis') {
                // Dex, Con, Wis
                r.addAll([
                  'Rogue (Inquisitive)',
                  'Ranger',
                ]);
                if (bestScores[3] == 'Cha') r.add('Fighter (Samurai)');
                r.add(pickRandom(['D&D Batman', 'The Turn 1 Terror']));
              } else {
                r.add('Rogue');
                if (bestScores[2] == 'Str') // Dex, Con, Str
                  r.add('Barbarian');
                else if (bestScores[2] == 'Cha') {
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
              r.add(pickRandom(['The Superior Daggers', 'The Dad']));
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
                    r.add(pickRandom(
                        ['Teenage Mutant Ninja Tortle', 'The Unseen Death']));
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
                    r.add('The Guardian Angel');
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
                    r.add('The Guardian Angel');
                    break;
                  }
                case 'Int': // Con, Dex, Int
                  {
                    r.addAll(['Wizard', 'Artificer']);
                    r.add(pickRandom(['The Superior Daggers', 'The Dad']));

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
              r.add(pickRandom(['The Ice Porcupine', 'The Conch Shell']));
              break;
            }
          case 'Wis': // highest abilities: Con, Wis
            {
              r.add('Druid');
              switch (bestScores[2]) {
                case 'Str':
                  {
                    r.add('Ranger');
                    r.add('The Bulletproof Kensei');
                    break;
                  }
                case 'Dex':
                  {
                    r.addAll(['Monk', 'Ranger']);
                    r.add(pickRandom(['The Pet Detective', 'The Holy Spirit']));
                    break;
                  }
                case 'Int':
                  {
                    r.add('Cleric (Knowledge)');
                    r.add('The Pet Detective');
                    break;
                  }
                case 'Cha':
                  {
                    r.add(pickRandom(
                        ['Master of All Trades', 'The Pet Detective']));
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
              r.add(pickRandom(['The Ice Porcupine', 'The Conch Shell']));
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
              r.add(pickRandom(['The Ice Porcupine', 'The Conch Shell']));
              break;
            }
          case 'Con': // highest abilities: Int, Con
            {
              r.addAll([
                'Wizard',
                'Artificer',
                'Wizard (with one Artificer level)',
              ]);
              r.add(pickRandom(['The Ice Porcupine', 'The Conch Shell']));
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
              r.add(pickRandom(['The Ice Porcupine', 'The Conch Shell']));
              break;
            }
          case 'Cha': // highest abilities: Int, Cha
            {
              r.addAll(['Wizard', 'Bard']);
              if (bestScores[2] == 'Dex') {
                r.add('Rogue (Swashbuckler)');
              }
              r.add(pickRandom(['The Ice Porcupine', 'The Conch Shell']));
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
              r.add('The Bulletproof Kensei');
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
              r.add('The Holy Spirit');
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
                    r.add('The Bulletproof Kensei');
                    break;
                  }
                case 'Dex': // Wis, Con, Dex
                  {
                    r.addAll(['Druid', 'Ranger', 'Monk']);
                    r.add(pickRandom([
                      'The Holy Spirit',
                      'The Bulletproof Kensei',
                      'The Pet Detective'
                    ]));
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
                    r.add('The Bulletproof Kensei');
                    break;
                  }
              }
              break;
            }
          case 'Int': // highest abilities: Wis, Int
            {
              r.add(
                'Cleric (Knowledge)',
              );
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
              r.add(pickRandom([
                'The Sorlock',
                'The Preacher',
                'The Politician',
              ]));
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
