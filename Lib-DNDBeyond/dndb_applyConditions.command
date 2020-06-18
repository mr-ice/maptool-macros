
[h: basicToon = dndb_getBasicToon ()]

[h: conditions = json.get (basicToon, "conditions")]
[h: log.debug (json.indent (conditions))]
[h: states = ""]
[h: clearStates = json.append ("", "Blinded", "Charmed", "Deafened", "Frightened", "Grappled",
							"Incapacitated", "Invisible", "Paralyzed", "Poisoned", "Restrained",
							"Prone", "Stunned", "Unconscious", "Exhaustion 1", "Exhaustion 2",
							"Exhaustion 3", "Exhaustion 4", "Exhaustion 5", "Exhaustion 6")]
[h, foreach (clearState, clearStates): setState (clearState, 0)]

[h, foreach (cond, conditions), code: {
	[h: conditionName = json.get (cond, "name")]
	[h, if (conditionName == "Exhaustion"): conditionName = conditionName + " " + json.get (cond, "level"); ""]

	[h: setState (conditionName, 0)]
	[h, switch (conditionName):
		case "Paralyzed": states = json.append (states, "Incapacitated");
		case "Petrified": states = json.append (states, "Incapacitated");
		case "Stunned": states = json.append (states, "Incapacitated");
		case "Unconscious": states = json.append (states, "Incapacitated", "Prone");
		default: "only because I have to put this here"
	]

	[h: states = json.append (states, conditionName)]
}]

[h: states = json.unique (states)]
[h, foreach (state, states): setState (state, 1)]