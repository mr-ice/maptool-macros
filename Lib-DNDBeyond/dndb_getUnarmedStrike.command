[h: toon = arg(0)]

<!-- Build it like our simplified weapon json -->
<!-- Do I need the toon? Maybe there are class mods that apply a damage die. -->
[h: unarmedStrike = json.set ("",
	"name", "Unarmed Strike",
	"attackType", "Melee",
	"dmgDie", "1",
	"dmgDice", "1",
	"dmgType", "Bludgeoning",
	"bonus", "0",
	"range", "5",
	"longRange", "5",
	"type", "Unarmed",
	"properties", "[]",
	"proficient", "1",
	"isMonk", "true")]

[h: macro.return = unarmedStrike]