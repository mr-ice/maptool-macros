[h: o5et_Constants(getMacroName())]
<!-- oh, does this look very much like the weapon test? Good, shuttup -->
<!-- we do these one at a time and explicitly specify test values -->

<!-- only need to do one critter atm. Its got two interesting attacks -->
<!-- pact-litch -->
[h: testRecord = json.set ("", 
	"pact-lich", json.set ("", "abilities", "[11,16,16,16,14,20]",
				"testActions", "['Maddening Touch', 'Enhanced Eldritch Blast']",
				"monsterAction.Enhanced Eldritch Blast", "{'spellcastingAbility':'Charisma','attackType':'Ranged'," +
					"'attackBonus':0}",
				"Enhanced Eldritch Blast.originalDmgBonus", 5,
				"Enhanced Eldritch Blast.originalAtkBonus", 10,
				"monsterAction.Maddening Touch", "{'spellcastingAbility':'Charisma','attackType':'Melee'," +
					"'attackBonus':0}",
				"Maddening Touch.originalDmgBonus",0,
				"Maddening Touch.originalAtkBonus",10)
	)
]

[h: log.debug (CATEGORY + "##testRecord = " + testRecord)]

[h: report = "{}"]
[h, foreach (slug, json.fields (testRecord, "json")), code: {
	[tokenId = o5et_Util_setupSlug (slug)]
	[switchToken (tokenId)]
	[testData = json.get (testRecord, slug)]
	[expectedAbilities = json.get (testData, "abilities")]
	[actualAbilities = json.append ("", getProperty ("Strength"), getProperty ("Dexterity"), getProperty ("Constitution"),
				getProperty ("Intelligence"), getProperty ("Wisdom"), getProperty ("Charisma"))]
	[report = json.merge (report, o5et_Util_assertEqual (expectedAbilities, actualAbilities, "Token Abilities - " + slug))]
	[testActions = json.get (testData, "testActions")]
	[monsterActions = getProperty ("_o5e_monsteractions")]
	[log.debug (CATEGORY + "## monsterActions = " + monsterActions)]
	[foreach (testAction, testActions), code: {
		[monsterAction = json.get (monsterActions, testAction)]
		[log.debug (CATEGORY + "## testAction = " + testAction +"; monsterAction = " + monsterAction)]
		[expectedProfile = json.get (testData, "monsterAction." + testAction)]
		[actualProfile = "{}"]
		[foreach (profileField, json.fields (expectedProfile, "json")): 
			actualProfile = json.set (actualProfile, profileField, json.get (monsterAction, profileField))]
		[report = json.merge (report, o5et_Util_assertEqual (actualProfile, expectedProfile, slug + " - " + testAction + " - profile"))]
		<!-- Get the RE and confirm the bonus -->
		[baseRollExpression = o5e_RollExpression_forAttackAction (testAction, monsterAction)]
		<!-- Easier to just roll the RE -->
		[attackRE = json.get (baseRollExpression, 0)]
		[damageRE = json.get (baseRollExpression, 1)]
		[rolled = dnd5e_DiceRoller_roll (baseRollExpression)]
		[rolledAttackRE = json.get (rolled, 0)]
		[rolledDamageRE = json.get (rolled, 1)]
		[originalAtkBonus = json.get (testData, testAction + ".originalAtkBonus")]
		[originalDmgBonus = json.get (testData, testAction + ".originalDmgBonus")]
		[actualAtkBonus = dnd5e_RollExpression_getBonus (rolledAttackRE)]
		[actualDmgBonus = dnd5e_RollExpression_getBonus (rolledDamageRE)]
		[report = json.merge (report, o5et_Util_assertEqual(actualAtkBonus, originalAtkBonus, slug + " - " + testAction + " - attackBonus"))]
		[report = json.merge (report, o5et_Util_assertEqual(actualDmgBonus, originalDmgBonus, slug + " - " + testAction + " - damageBonus"))]
		
		[testAbility = json.get (monsterAction, "spellcastingAbility")]
		[increaseValue = 10]
		[basePropertyValue = getProperty (testAbility)]
		[setProperty (testAbility, basePropertyValue + increaseValue)]
		<!-- Roll the original again -->
		[rolled = dnd5e_DiceRoller_roll (baseRollExpression)]
		[increasedAttackRE = json.get (rolled, 0)]
		[increasedDamageRE = json.get (rolled, 1)]
		[newAtkBonus = dnd5e_RollExpression_getBonus (increasedAttackRE)]
		[newDmgBonus = dnd5e_RollExpression_getBonus (increasedDamageRE)]
		<!-- Revert the property, in case theres another action to test -->
		[setProperty (testAbility, basePropertyValue)]
		[report = json.merge (report, o5et_Util_assertEqual (newAtkBonus, actualAtkBonus + (increaseValue / 2), slug +
			" - " + testAction + " - attack ability change"))]
		<!-- spell attacks should not have an increased damage -->
		[report = json.merge (report, o5et_Util_assertEqual (newDmgBonus, actualDmgBonus, slug +
			" - " + testAction + " - damage ability change"))]
	}]
	[removeToken (tokenId)]
}]

[h: macro.return = report]