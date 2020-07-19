[h: effectsMap = json.set ("",
					"atkDefAdv", "Attackers have advantage",
					"atkAtkDis", "Attacks have disadvantage",
					"charmed", "Can't harm charmer",
					"srcAbilityAdv", "Attacker ability checks have advantage vs target",
					"srcSeeAbilityDis", "Ability checks have disadvantage while attacker is in sight",
					"cannotClose", "Target cannot move closer to attacker",
					"zeroSpeed", "Speed becomes 0",
					"noActions", "Cannot take actions, reactions",
					"atkAtkAdv", "Attacks have advantage",
					"atkDefDis", "Attackers have disadvantage",
					"incapacitated", "Can't move or speak",
					"failsStrDex", "Fails Strength and Dex saves",
					"autoCrit", "Attackers within 5ft score critical",
					"abilityDis", "Ability checks have disadvantage",
					"crawlOnly", "Can only crawl",
					"dexDis", "Disadvantage on Dex save")]

[h: conditionsEffects = json.set ("",
				"Unconscious", json.append ("", "incapacitated", "failsStrDex", "atkDefAdv", "autoCrit"),
				"Stunned", json.append ("", "incapacitated", "failsStrDex", "atkDefAdv"),
				"Restrained", json.append ("", "zeroSpeed", "atkDefAdv", "atkAtkDis", "dexDis"),
				"Prone", json.append ("", "crawlOnly", "atkAtkDis", "closeAdvFarDis"),
				"Poisoned", json.append ("", "abilityDis", "atkAtkDis"),
				"Petrified", json.append ("", "incapacitated", "atkDefAdv", "failsStrDex", "dmgResist", "poisonImmunity"),
				"Paralyzed", json.append ("", "incapacitated", "failsStrDex", "autoCrit"),
				"Invisible", json.append ("", "invisible", "atkAtkAdv", "atkDefDis"),
				"Incapacitated", json.append ("", "incapacitated"),
				"Grappled", json.append ("", "zeroSpeed"),
				"Frightened", json.append ("", "srcSeeAbilityDis", "cannotClose"),
				"Deafened", json.append ("", "deaf"),
				"Charmed", json.append ("", "charmed", "srcAbilityAdv"),
				"Blinded", json.append ("", "blind", "atkDefAdv", "atkAtkDis"))]

[h: states = getTokenStates()]
[h: effectsArry = "[]"]
[h, foreach (state, states), code: {
	[if (getState (state)), code: {
		[stateEffects = json.get (conditionsEffects, state)]
		[effectsArry = json.union (effectsArry, stateEffects)]\
	}; {""}]
}]
[h: effectDescription = ""]
[h, foreach (effect, effectsArry), code: {
	[description = json.get (effectsMap, effect)]
	[if (description != ""): effectDescription = effectDescription + description + decode ("%0A")]
}]
[r: effectDescription]				
					