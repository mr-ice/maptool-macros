<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
[h: character = arg(0)]

[h: classArry = json.path.read (character, "data.classes")]
<!--Subtract by one for div operation -->
[h: totalClassLevel = -1]
[h, foreach (classDef, classArry), code: {
	[h: totalClassLevel = totalClassLevel + json.get (classDef, "level")]
}]
[h: profBase = round(math.floor(totalClassLevel / 4))]
<!-- add one, viola -->
[h: proficiency = profBase + 2]
[r: proficiency]
[h: macro.return = proficiency]