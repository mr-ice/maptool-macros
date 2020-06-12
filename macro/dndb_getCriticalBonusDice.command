[h: toon = arg(0)]
[h: weapon = arg(1)]

<!-- only way we know how to do this is by looking for known features -->
[h: bonusCritDice = 0]

<!-- Savage Attacks -->
[h: savageAttackFeatureArry = json.path.read (toon, "data.race..[?(@.definition.name == 'Savage Attacks')]")]
[h, if (json.length (savageAttackFeatureArry) > 0 && json.get(weapon, "attackType") == "Melee"): bonusCritDice = bonusCritDice + 1]

<!-- Brutal Critical -->
<!-- Get the barbarian class -->
[h: barbarianClassLevelArry = json.path.read (toon, "data.classes..[?(@.definition.name == 'Barbarian')]['level']")]

[h, if (json.length (barbarianClassLevelArry) > 0): barbarianClassLevel = json.get (barbarianClassLevelArry, 0)]

[h: brutalCrit = 0]
[h: log.debug ("barbarianClassLevel [raw]: " + barbarianClassLevel)]
[h, if (isNumber (barbarianClassLevel)): barbarianClassLevel = number (barbarianClassLevel); barbarianClassLevel = 0]
[h: log.debug ("barbarianClassLevel [number]: " + barbarianClassLevel)]
[h, if (barbarianClassLevel >= 9): brutalCrit = 1]
[h, if (barbarianClassLevel >= 13): brutalCrit = 2]
[h, if (barbarianClassLevel >= 17): brutalCrit = 3]
[h, if (json.get (weapon, "attackType") == "Melee"): bonusCritDice = bonusCritDice + brutalCrit]


[h: macro.return = bonusCritDice]