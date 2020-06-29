[h: toon = arg (0)]
[h: modifier = arg (1)]

<!-- For now, we assume its of type 'bonus'. We may need to revisit this if we find others -->
[h: bonus = 0]
<!-- Check fixedValue. If its numeric, use that. -->
[h: fixedValue = json.get (modifier, "fixedValue")]
[h, if (fixedValue != "" && isNumber (fixedValue)): bonus = fixedValue]

<!-- If nothing found in fixedValue, check value -->
[h: value = json.get (modifier, "value")]
[h, if (value != "" && isNumber (value)): bonus = value]

<!-- Still nothing? check statId and apply the bonus for the relevant stat bonus -->
[h: statId = json.get (modifier, "statId")]
[h, if (statId != "" && isNumber (statId)), code: {
	[h: statBonus = 0]
	[h: abilities = dndb_getAbilities (toon)]
	[h, switch (statId):
		case 1: statBonus = json.get (abilities, "strBonus");
		case 2: statBonus = json.get (abilities, "dexBonus");
		case 3: statBonus = json.get (abilities, "conBonus");
		case 4: statBonus = json.get (abilities, "intBonus");
		case 5: statBonus = json.get (abilities, "wisBonus");
		case 6: statBonus = json.get (abilities, "chaBonus")]
	[h, if (statBonus > 0): bonus = statBonus]
}]

<!-- Quickdraw  -- uses proficiency but doesnt say proficiency. so its just an edge-case now -->
[h, if (json.get (modifier, "id") == 2722177): bonus = dndb_getProficiencyBonus (toon); ""]

<!-- return default bonus of 0 -->
[h: macro.return = bonus]