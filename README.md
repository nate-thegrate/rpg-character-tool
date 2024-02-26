### [RPG.nate-thegrate.com](https://rpg.nate-thegrate.com) 

This is a resource made for Dungeons & Dragons and Call of Cthulhu. (More tabletop roleplaying games may be added in the future!)

<br>

### Save to your Desktop

You can download via Microsoft Edge or Google Chrome:  
![PWA download](/pwa.png)

<br>

# D&D

### Auto-Configure Stats

Assigning stats at random can lead to potentially undesirable outcomes, e.g. a really low Constitution score. This app gives the option to automatically allocate stats into a viable configuration.

### Random Arrays

The standard methods for determining character stats are outlined below:

| 4d6 Drop Lowest | Standard Array | Point Buy |
|---|---|---|
| For each stat, roll four 6-sided dice and add the highest 3 results together | Take the values 15, 14, 13, 12, 10, and 8 and assign them however you'd like | Similar to Standard Array, but you can tweak the numbers if you want (e.g. change the 13 to a 12 and change the 8 to a 9) |
|   |   |   |
| Pro: randomness can be really fun & exciting | Pro: fast, easy, and fair | Pro: fair, provides some variety |
| Con: can create unfair power discrepancies | Con: boring/monotonous | Con: tedious/time consuming |

Randomized arrays are a great way to get all of the benefits with none of the drawbacks! Just take a bunch of similarly effective arrays (this app includes a bunch and supports copy/paste) and pick one at random.

### Character Ideas

After stats are generated, the app will display some great character suggestions based on the results!

<br>

# Call of Cthulhu

Making a character in Call of Cthulhu 7th edition is a pretty lengthy process:

1. Determine your characteristics: STR, CON, SIZ, DEX, APP, INT, POW, and EDU
2. Pick an age and apply its effects
3. Use your characteristics to determine Sanity Points, Magic Points, Luck, Hit Points, and Move Rate
4. Choose an occupation based on your characteristics
5. Determine how many Skill Points you can allocate based on your occupation and Intelligence score
6. Create a backstory, either using your own ideas or by referencing the rulebook

This app does it in a couple seconds.

(Note: it's assumed that you have the [7th Edition Investigator's Handbook](https://www.drivethrurpg.com/product/167631/Call-of-Cthulhu-Investigator-Handbook-7th-Edition). You'll need it to determine occupation skills, finances, and equipment.)

<br>

# Coding Highlights

This app was made using [Flutter](https://flutter.dev/). All its code is written in Dart and can be found in the [lib](https://github.com/nate-thegrate/character_quickgen/tree/master/lib) folder, and some highlights have been included below.

### D&D

For me, the most interesting part of the D&D section was using the `generate()` function to automatically arrange the ability scores. 13 character classes with 112 published subclasses provides a whole bunch of variety, not to mention all the options that come from racial features, multiclassing, and feats.

Luckily, there is a general pattern that character creation follows. I implemented it using the pseudocode below:

```
generate 6 stats based on user input

priority stats = array of 3 stats [_, _, _]

1/13th of the time:
  Do stats for a Barbarian: [Strength, Dexterity, Constitution]
else:
  First priority stat is Strength 25% of the time, Dexterity 75%
  Second priority stat is always Constitution
  Third priority stat is chosen between Intelligence, Wisdom, and Charisma
    (with a slight bias toward Wisdom & away from Intelligence)

Put the highest 3 generated stats into each priority stat in random order
The lower 3 stats fill in the rest
```

This method ensures a nice spread of potential outcomes, allowing for every character type to come into play. From there, it's easy to sort the stats by value and create suitable character recommendations.

### Call of Cthulhu

Call of Cthulhu character creation involves a whole lot more information, so I made a `Player` class to keep the data organized.

Everything that needed to be done was explicitly laid out in the Investigator's Handbook, so the main thing for me to figure out was how to automatically determine a character's age.

Aging in Call of Cthulhu does a few things to the character: most notably, it reduces stats like Appearance and gives you the chance to improve your education (the lower your current education, the higher the chance of improvement). How well a character can resist going insane impacts whether they're able to be used over a long period of time, and thus what their starting age ought to be.

Adding up all the relevant stats results in a bell curve, so I used a [sigmoid function](https://en.wikipedia.org/wiki/Sigmoid_function) to even out the distribution. This method is implemented in the `setAge()` function in [lib/cthulu_data.dart](https://github.com/nate-thegrate/character_quickgen/blob/master/lib/cthulhu_data.dart#L330).
