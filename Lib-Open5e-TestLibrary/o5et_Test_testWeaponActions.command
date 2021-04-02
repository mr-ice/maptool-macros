[h: o5et_Constants(getMacroName())]
<!-- we do these one at a time and explicitly specify test values -->
[h: testRecord = json.set ("", 
	"elvish-veteran-archer", json.set ("", "abilities", "[11,16,12,11,13,11]",
				"testActions", "['Longbow']",
				"monsterAction.Longbow", "{'weaponType':1,'attackType':'Ranged','attackBonus':1}",
				"Longbow.originalDmgBonus",4,
				"Longbow.originalAtkBonus",6),
	"stone-giant", json.set ("", "abilities", "[23,15,20,10,12,9]",
				"testActions", "['Greatclub','Rock']",
				"monsterAction.Greatclub", "{'weaponType':0,'attackType':'Melee','attackBonus':0}",
				"monsterAction.Rock", "{'weaponType':0,'attackType':'Ranged','attackBonus':0}",
				"Rock.originalAtkBonus", 9,
				"Rock.originalDmgBonus", 6,
				"Greatclub.originalAtkBonus", 9,
				"Greatclub.originalDmgBonus", 6),
	"deathsworn-elf", json.set ("", "abilities", "[14,19,12,11,13,14]",
				"testActions", "['Scimitar']",
				"monsterAction.Scimitar", "{'weaponType':2,'attackType':'Melee','attackBonus':0}",
				"Scimitar.originalDmgBonus", 4,
				"Scimitar.originalAtkBonus", 7)
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
	[foreach (testAction, testActions), code: {
		[monsterAction = json.get (monsterActions, testAction)]
		[actualProfile = json.set ("", "weaponType", json.get (monsterAction, "weaponType"), "attackType", 
					json.get (monsterAction, "attackType"), "attackBonus", json.get (monsterAction, "attackBonus"))]
		[expectedProfile = json.get (testData, "monsterAction." + testAction)]
		[report = json.merge (report, o5et_Util_assertEqual (actualProfile, expectedProfile, slug + " - " + testAction + " - profile"))]
		<!-- Get the RE and confirm the bonus -->
		[baseRollExpression = o5e_RollExpression_forAttackAction (testAction, monsterAction)]
		<!-- Easier to just roll the RE -->
		[weaponRE = json.get (baseRollExpression, 0)]
		[damageRE = json.get (baseRollExpression, 1)]
		[rolled = dnd5e_DiceRoller_roll (baseRollExpression)]
		[rolledWeaponRE = json.get (rolled, 0)]
		[rolledDamageRE = json.get (rolled, 1)]
		[originalAtkBonus = json.get (testData, testAction + ".originalAtkBonus")]
		[originalDmgBonus = json.get (testData, testAction + ".originalDmgBonus")]
		[actualAtkBonus = dnd5e_RollExpression_getBonus (rolledWeaponRE)]
		[actualDmgBonus = dnd5e_RollExpression_getBonus (rolledDamageRE)]
		[report = json.merge (report, o5et_Util_assertEqual(actualAtkBonus, originalAtkBonus, slug + " - " + testAction + " - attackBonus"))]
		[report = json.merge (report, o5et_Util_assertEqual(actualDmgBonus, originalDmgBonus, slug + " - " + testAction + " - damageBonus"))]
		<!-- If the attackType is 1 or 2, increase Dexterity. If its 0, Strength. Test that the bonus increases by half that value -->
		[testAbility = "Dexterity"]
		[if (json.get (monsterAction, "weaponType") == 0): testAbility = "Strength"]
		[increaseValue = 10]
		[basePropertyValue = getProperty (testAbility)]
		[setProperty (testAbility, basePropertyValue + increaseValue)]
		<!-- Roll the original again -->
		[rolled = dnd5e_DiceRoller_roll (baseRollExpression)]
		[increasedWeaponRE = json.get (rolled, 0)]
		[increasedDamageRE = json.get (rolled, 1)]
		[newAtkBonus = dnd5e_RollExpression_getBonus (increasedWeaponRE)]
		[newDmgBonus = dnd5e_RollExpression_getBonus (increasedDamageRE)]
		<!-- Revert the property, in case theres another action to test -->
		[setProperty (testAbility, basePropertyValue)]
		[report = json.merge (report, o5et_Util_assertEqual (newAtkBonus, actualAtkBonus + (increaseValue / 2), slug +
			" - " + testAction + " - attack ability change"))]
		[report = json.merge (report, o5et_Util_assertEqual (newDmgBonus, actualDmgBonus + (increaseValue / 2), slug +
			" - " + testAction + " - damage ability change"))]
		
	}]
	[removeToken (tokenId)]
}]

[h: macro.return = report]