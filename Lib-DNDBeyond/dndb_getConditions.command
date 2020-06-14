[h: toon = arg(0)]

<!-- Conditions are nothing more than array of magic numbers. As of now, they -->
<!-- do not provide any modifiers. -->

[h: conditionsMap = json.append ("", 
			json.set ("", "name", "Blinded", "id", "1"),
			json.set ("", "name", "Charmed", "id", "2"),
			json.set ("", "name", "Deafened", "id", "3"),
			json.set ("", "name", "Exhaustion", "id", "4"),
			json.set ("", "name", "Frightened", "id", "5"),
			json.set ("", "name", "Grappled", "id", "6"),
			json.set ("", "name", "Incapacitated", "id", "7"),
			json.set ("", "name", "Invisible", "id", "8"),
			json.set ("", "name", "Paralyzed", "id", "9"),
			json.set ("", "name", "Petrified", "id", "10"),
			json.set ("", "name", "Poisoned", "id", "11"),
			json.set ("", "name", "Prone", "id", "12"),
			json.set ("", "name", "Restrained", "id", "13"),
			json.set ("", "name", "Stunned", "id", "14"),
			json.set ("", "name", "Unconscious", "id", "15"))]

[h: toonConditions = json.path.read (toon, "data.conditions")]
[h: conditions = "[]"]
[h, foreach (toonCondition, toonConditions), code: {
	[h: id = json.get (toonCondition, "id")]
	<!-- Dont use condition as a var name -->
	[h: cond = json.path.read (conditionsMap, ".[?(@.id == '" + id + "')]")]
	[h: cond = json.get (cond, 0)]
	[h: level = json.get (toonCondition, "level")]
	[h, if (level != ""): cond = json.set (cond, "level", level)]
	[h: conditions = json.append (conditions, cond)]
}]

[h: macro.return = conditions]