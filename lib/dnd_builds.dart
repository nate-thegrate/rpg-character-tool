import 'package:character_quickgen/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
      'Cast an Agonizing Blast with your action, '
          'and then quicken another spell (maybe a second Eldritch blast!)',
      'Divine Smite works great with a Sorcerer\'s full-caster spell slots.',
    ],
  ),
  Build(
    'The Dragon Warrior',
    ['Paladin', 'Sorcerer'],
    ['high Strength', 'high Charisma'],
    'Fight with explosive power!',
    [
      'Take your first two levels as a Paladin.',
      'Now, you can take the rest of your levels as a '
          'Red Draconic Sorcerer, or you could get 6 Paladin levels first '
          'for Extra Attack and Aura of Protection.',
    ],
    [
      'Quicken a Green-Flame Blade. You can deal damage from your weapon, '
          'your Fighting Style, the cantrip, '
          'Elemental Affinity, and Divine Smite.',
      'And you still have a main action to use.',
      'You can also quicken Hold Person to get some awesome crit-Smites.',
      'Feel free to mix & match other subclasses '
          'and figure out other cool strategies!',
    ],
    race: 'Tiefling could be great for Flames of Phlegethos',
  ),
  Build(
    'The Dragon Tamer',
    ['Paladin (Oath of the Crown)', 'Warlock (Genie Patron)'],
    ['decent Strength', 'high Charisma'],
    'Fight with explosive power!',
    [
      'Take your first 6 levels as a Paladin.',
      'Then take 3-5 Warlock levels, '
          'and continue with either class from there.',
      'Be sure to grab the Sentinel feat as soon as you can.',
    ],
    [
      'Blind Fighting Style means that both you and the dragon have '
          'blindsight, and you can fight side-by-side to gain its '
          'Magic Resistance trait.',
      'Choose the Marid Genie, and get Pact of the Chain '
          'for a Pseudodragon familiar.',
      'Cast Fog Cloud centered on an opponent and move up to them, '
          'and have your Pseudodragon sting them.',
      'You can prevent their escape with Sentinel, Compelled Duel, '
          'and/or Champion Challenge.',
      'With the boost from Investment of the Chain Master, '
          'there\'s a decent chance that the Pseudodragon can knock your '
          'opponent out, letting you get a massive critical Divine Smite.',
      'This build works especially well if you have a party member with '
          'Darkness or Fog Cloud, so you can concentrate on Compelled Duel.',
    ],
    race: 'Half-Orc, or Variant Human/Custom Lineage for Sentinel',
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
          'Toll the Dead, and Bless all work really well on a Bard.',
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
      'Make sure you grab the Telekinetic or Polearm Master feat '
          'at some point.',
    ],
    [
      'This character does really well at any level, '
          'but it really starts to shine once you hit Paladin 7 / Warlock 3.',
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
    'While they partied, you studied the blade.',
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
    '',
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
    '',
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
    'The Dad',
    ['Rogue (Thief)', 'Fighter (Banneret)'],
    ['high Dexterity'],
    'Rally your companions with some amazing dad jokes!',
    [
      'Take 3 Rogue levels and then do Fighter from there.',
      'Make sure you grab the Healer feat as soon as you can.',
    ],
    [
      'You don\'t need fancy magic to support your friends! '
          'Fast Hands & Healer lets you pop up an ally as a bonus action.',
      'Rallying Cry is another great way to do it.',
      'Take the Superior Technique Fighting Style and/or the Martial Adept '
          'feat, so you can perform supportive maneuvers (like Distracting '
          'Strike, Goading Attack, Maneuvering Attack, or Bait and Switch)',
    ],
  ),
  Build(
    'Pocket-size Pain',
    ['Wizard (School of Evocation)', 'Warlock (Hexblade Patron)'],
    ['high Intelligence', '13 Charisma'],
    'Being a runt doesn\'t matter if your enemies are all dead.',
    [
      'Take 5 Evocation Wizard levels and then one Hexblade Warlock level. '
          'Then continue as a Wizard from there.',
    ],
    [
      'Magic missile is awesome. It always hits, and since each missile '
          'uses the same damage roll, it isn\'t hard '
          'to get the damage numbers up super high.',
      'Cast an overchanneled Bestow Curse through your familiar, '
          'and then use Hexblade\'s Curse & Fury of the Small.',
      'A level 7, magic missile will deal an average of '
          '355.5 damage on a single turn!',
      'Some DMs will rule that magic missile uses multiple damage rolls, '
          'which means that Fury of the Small and Empowered Evocation '
          'only apply once. This reduces the average total damage to 168.5.',
      'Other DMs will have the enemy cast a level 1 shield spell. '
          'This reduces the average total damage to 0.',
    ],
    race: 'Goblin',
  ),
  Build(
    'The Ice Porcupine',
    ['Fighter', 'Wizard (School of Abjuration)'],
    ['13 Dexterity', 'high Intelligence'],
    'You\'ll be such a good tank that they\'ll forget you\'re a Wizard.',
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
    'Avoid damage with nothing but a turtle shell and a big brain.',
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
    'The Lightning Shooter',
    ['Artificer (Armorer)', 'Fighter'],
    ['13 Strength or Dexterity', 'high Intelligence'],
    'pew pew!',
    [
      'Take 5 Armorer Artificer levels, and then one Fighter level. '
          'Then continue as an Artificer from there.',
    ],
    [
      'Your Lightning Launcher counts as a simple ranged weapon, '
          'so it can benefit from Sharpshooter and the Archery Fighting Style, '
          'and it runs on your Intelligence.',
      'You can infuse it with a +1 attack/damage bonus, '
          'which is awesome when paired with Sharpshooter.',
    ],
    race: 'Variant Human or Custom Lineage, to get Sharpshooter',
  ),
  Build(
    'The Spellsword',
    ['Fighter (Eldritch Knight)'],
    ['high Dexterity', 'decent Intelligence'],
    'Weapons + Magic = fun times.',
    [
      'Take all your levels as an Eldritch Knight.',
      'Make sure you grab the Sentinel feat as soon as you can.',
    ],
    [
      'There are a bunch of great ways to use this build.',
      'You can take Blind Fighting Style and Cast Fog Cloud near an enemy. '
          'You\'ll get advantage, and Sentinel makes it '
          'so they can\'t escape.',
      'You could also take the Dueling Fighting Style '
          '(in place of Blind Fighting or as a feat). '
          'Cast Shadow Blade or Spirit Shroud, '
          'and use Action Surge for some awesome damage.',
      'Mirror Image is great for fighting in melee, '
          'especially since it can help trigger your Sentinel attack.',
    ],
    race: 'Be an Elf/Half-Elf to get Elven Accuracy, '
        'or do Variant Human/Custom Lineage for a head start on feats.',
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
    'The Bulletproof Kensei',
    ['Cleric (Nature Domain)', 'Fighter', 'Monk (Way of the Kensei)'],
    ['13 Dexterity', 'high Wisdom'],
    'Who needs Martial Arts when you have a club and steel plates?',
    [
      'Take your first level as a Nature Cleric and grab a club & shield. '
          'Then take 6 Monk levels in the Way of the Kensei.',
      'Then take one Fighter level with the Dueling Fighting Style, '
          'and continue as a Cleric from there.',
    ],
    [
      'Once you hit Monk level 6, you can take advantage of Deft Strike '
          'and Ki-Fueled Attack to make a club attack as a bonus action, '
          'and the Fighter level lets you add Dueling damage to every hit.',
      'That\'s a total of 3d8 + 1d6 + 18 during one turn at level 8.',
      'You\'re a character that can cast Shield of Faith to get '
          '22 AC and can Dodge as a bonus action, '
          'and your attacks and Stunning Strikes both run on Wisdom.',
    ],
    race: 'Dwarf—your armor won\'t slow you down, and you can get '
        'Dwarven Fortitude for some great bonus action healing.',
  ),
  Build(
    'The BBC',
    ['Cleric (Arcana Domain)'],
    ['14 Dexterity', 'high Wisdom'],
    'There\'s nothing quite like a girthy wooden shaft, '
        'enchanted and wielded by a Booming Blade Cleric.',
    [
      'Take all your levels as an Arcana Domain Cleric.',
      'Max out your Wisdom and then grab the War Caster feat.',
    ],
    [
      'Since Booming Blade and Green-Flame Blade have 2 damage rolls, '
          'they can benefit twice from Potent Spellcasting.',
      'If you cast Shillelagh and Spiritual Weapon, '
          'you can deal damage with your Wisdom mod 4 times in one turn!',
      'Being a Cleric provides a lot of utility, and the level 17 '
          'Arcana Domain feature is amazing (if you get that far).',
    ],
    race: 'Variant Human/Custom Lineage '
        '(grab Magic Initiate to get Shillelagh right away) '
        'or Wood Elf (to qualify for Wood Elf Magic)',
  ),
  Build(
    'The Telekinetic Tiger',
    ['Druid (Circle of the Moon)'],
    ['high Wisdom'],
    'The only thing scarier than a ferocious beast '
        'is a ferocious beast with mind powers.',
    [
      'Take all your levels as a Druid (Circle of the Moon).',
      'Make sure you grab the Telekinetic feat as soon as you can.',
    ],
    [
      'Wild Shape usually doesn\'t give you anything to do '
          'with your bonus action, and since you retain your Wisdom score, '
          'the Telekinetic feat is a perfect fit.',
      'Shove an enemy prone with your mind, '
          'and then charge at them with advantage.',
      'You can also take a Barbarian level, '
          'since your Telekinesis still functions while raging.',
    ],
    race: 'Variant Human/Custom Lineage '
        '(grab Magic Initiate to get Shillelagh right away) '
        'or Wood Elf (to qualify for Wood Elf Magic)',
  ),
  Build(
    'The Favored Fighter',
    ['Cleric (War Domain)', 'Fighter (Battle Master)'],
    ['high Strength', 'decent Wisdom'],
    '',
    [
      'Take 5 levels as a Fighter, and then take a Cleric level. '
          'You can continue as a Cleric from there, '
          'or you can take Fighter to level 11 first.',
    ],
    [
      'Being a Cleric gives some really nice utility, even with just 1 level.',
      'Great Weapon Fighting, Divine Favor, Spirit Shroud, Action Surge, '
          'and War Priest make you a super solid damage dealer.',
    ],
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
    'Death will come about at your whim.',
    [
      'Take 5 Sorcerer levels and then 2 Cleric levels. '
          'Then continue as a Sorcerer from there.',
    ],
    [
      'Use Transmuted Spell and Destructive Wrath '
          'whenever you feel like winning.',
      'The Cleric levels also give some awesome spells. '
          'Use subtle spell on Command, Healing Word, and Thaumaturgy '
          'to convince NPCs to worship you.',
    ],
    race: 'Be a Dwarf so you don\'t need Strength, '
        'or be another race and use a hammer for Booming Blade.',
  ),
  Build(
    'God of Support',
    ['Cleric (Order Domain)', 'Sorcerer (Divine Soul)'],
    ['13 Wisdom', 'high Charisma'],
    '',
    [
      'Take 5 Sorcerer levels and then 1 Cleric level. '
          'Then continue as a Sorcerer from there.',
    ],
    [
      'You have a bunch of support spells at your disposal '
          'that work great with Metamagic, and they can take advantage of '
          'your Voice of Authority.',
      'The Cleric level also helps you to remember a few more spells. '
          'Use subtle spell on Command, Healing Word, and Thaumaturgy '
          'to convince NPCs to worship you.',
    ],
    race: 'Dwarf in heavy armor, or another race in medium armor',
  ),
  Build(
    'The All-Seeing Eye',
    [
      'Cleric (Peace Domain)',
      'Rogue (Soulknife)',
    ],
    ['high Dexterity', 'high Wisdom'],
    '',
    [
      'Take 1 Cleric level, and then go Rogue from there.',
      'Make sure you grab the Observant feat as soon as you can.',
    ],
    [
      'Not only do you have Perception Expertise, but your sight is enhanced '
          'with Darkvision, Hunter\'s Intuition, Faerie Fire, Guidance, '
          'Emboldening Bond, Observant, and Psi-Bolstered Knack, '
          'for a passive Perception of 24 '
          'and an average Perception check of 31 at level 5.',
    ],
    race: 'Human or Half-Orc (Mark of Finding)',
  ),
  Build(
    'The Diplomat',
    ['Bard (College of Eloquence)', 'Ranger (Fey Wanderer)'],
    ['14 Dexterity', 'high Wisdom', 'high Charisma'],
    'Become the ultimate negotiator.',
    [
      'Take 5 Bard levels and 4 Ranger levels, and then continue as a Bard.',
    ],
    [
      'When it comes time to make a Persuasion check, you\'ll have '
          'Expertise, Silver Tongue, Otherworldly Glamour, Ever Hospitable, '
          'and charming spells, giving yourself an average of 33 '
          'for each Persuasion roll.',
      'If you want to go overboard, you can take a Cleric (Peace Domain) '
          'level, 3 Paladin (Oath of Redemption) levels, and/or '
          '3 Warlock levels to get Persuasion boosts from '
          'Emboldening Bond, Emissary of Peace, and Pact of the Talisman.'
    ],
    race: 'Halfling (Mark of Hospitality)',
  ),
  Build(
    'The Psychic Suplex',
    ['Barbarian (Path of the Battlerager)', 'Fighter (Psi Warrior)'],
    ['high Strength', 'decent Dexterity', 'decent Intelligence'],
    'Take someone for a ride (against their will).',
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
    race: 'Dwarf (Duergar) could be nice, since Duergar Magic '
        'and Dwarven Resilience both work well with this build.',
  ),
  Build(
    'The Turn 1 Terror',
    ['Fighter', 'Ranger (Gloom Stalker)'],
    ['high Dexterity', 'decent Wisdom'],
    '',
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
    'The Unseen Warden',
    ['Cleric (War Domain)', 'Ranger'],
    ['high Strength', '13 Dexterity', 'decent Wisdom'],
    '',
    [
      'Take 2 Cleric levels and then do Ranger from there.',
      'Make sure you grab the Great Weapon Master and Sentinel feats '
          'as soon as you can.',
    ],
    [
      'Cast Fog Cloud, and then hit repeatedly.',
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
    'Call in animals whenever you need a favor.',
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
    'Protect yourself and everyone else with the power of flight.',
    [
      'Take all your levels in the Barbarian class.',
      'Make sure you grab the Great Weapon Master feat as soon as you can.',
    ],
    [
      'Rage & Reckless Attack with a pike, then fly up or into cover. '
          'Now they can\'t hit you, and they can\'t hit your friends.',
      'Works really well if the enemy is forced to run past your companions '
          'to get to you, provoking a bunch of opportunity attacks.',
      'Alternatively, you can pick a non-flying race, take 5 Barbarian levels, '
          'and then take 4 Echo Knight Fighter levels '
          'to achieve a similar effect.',
    ],
    race: 'Aarakocra or Protector Aasimar',
  ),
  Build(
    'The Furry Fury',
    ['Barbarian (Path of the Beast)'],
    ['high Strength', 'decent Dexterity'],
    'Dish out a furry flurry in a hurry.',
    [
      'Take all your levels in the Barbarian class.',
      'Make sure you max out your Strength as soon as you can.',
    ],
    [
      'With your fangs and claws, '
          'you can make 4 rage-boosted attacks each turn.',
      'Take the Martial Adept feat for a Disarming/Distracting/Menacing attack '
          'that you can use whenever you get a critical hit.',
      'This build is especially great if you have '
          'a friendly Paladin or Bard with Crusader\'s Mantle nearby.',
    ],
    race: 'Shifter (Longtooth)',
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

Build getBuild(String buildName) {
  for (final build in builds) {
    if (build.name == buildName) {
      return build;
    }
  }
  return Build('Unable to find $buildName', [], [], '', [], []);
}

Widget buildCard(String buildName) {
  final Build b = getBuild(buildName);
  String classes = b.classes[0];
  for (int i = 1; i < b.classes.length; i++) classes += ' / ${b.classes[i]}';

  List<Widget> buildSteps = [];

  for (final step in b.buildSteps) {
    buildSteps.add(Text(step, style: TextStyle(fontSize: 16)));
    buildSteps.add(Container(height: 5));
  }

  List<Widget> combatSteps = [];

  for (final step in b.combatSteps) {
    combatSteps.add(Container(height: 5));
    combatSteps.add(Text(step, style: TextStyle(fontSize: 16)));
  }

  List<Widget> items = [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(b.name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[900])),
        Container(width: 30),
        Flexible(
            child: Text(classes,
                style: TextStyle(fontSize: 16, color: Color(0xFF608062)))),
      ],
    ),
    Container(height: 15),
    Text(b.description, style: TextStyle(fontSize: 16)),
    Container(height: 5),
    Text('Race: ${b.race}', style: TextStyle(fontSize: 16)),
    Container(height: 20),
    Text('Character Levels',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[900])),
    Container(height: 5),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildSteps,
    ),
    Container(height: 20),
    Text('Strategy/Evaluation',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[900])),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: combatSteps,
    ),
  ];

  if (b.description == '') {
    items.removeAt(3);
    items.removeAt(3);
  } // remove empty descriptions

  return Container(
    padding: EdgeInsets.all(25),
    color: Colors.green[50],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    ),
  );
}

Column buildScreen(Build b) {
  return Column(
    children: [
      Container(height: 20),
      Text(b.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Container(height: 10),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(b.description)),
      Container(height: 10),
      DataList(
          left: 'Class${b.classes.length > 1 ? 'es' : ''}', right: b.classes),
      DataList(left: 'Race', right: b.race),
      DataList(left: 'Ability Scores', right: b.scores),
      DataList(left: 'Levels', right: b.buildSteps),
      DataList(
          left: 'Strateg${b.combatSteps.length > 1 ? 'ies' : 'y'}',
          right: b.combatSteps),
    ],
  );
}
