[h: reportResults = "{}"]
[h: testTokenName = "conditionTest"]
[h: testToken = dnd5et_Util_createTestToken (testTokenName)]
[h: setAllStates (0, testToken)]
[h: setProperty ("Strength", 12, testToken)]
[h: setProperty ("Dexterity", 14, testToken)]
[h: setProperty ("Proficiency", 3, testToken)]
[h: re = dnd5e_RollExpression_WeaponAttack ("test weapon", 1)]
[h: dmg = dnd5e_RollExpression_WeaponDamage ("damage", "1d8")]
[h: rolls = json.append ("", re, dmg)]
[h, token (testTokenName): rolled = dnd5e_DiceRoller_roll (rolls)]
[h: attackRoll = json.get (rolled, 0)]
[h: rolls = json.get (attackRoll, "rolls")]
[h: reportResults = dnd5et_Util_assertEqual (json.length (rolls), 1, "Conditions - base")]

<!-- child rolls -->
[h: setState ("Blessed", 1, testToken)]
[h: staticRe = dnd5e_RollExpression_setStaticRoll (re, "10")]
[h: rolls = json.append ("", staticRe)]
[h, token (testTokenName): rolled = json.get (dnd5e_DiceRoller_roll (rolls), 0)]
[h: total = dnd5e_RollExpression_getTotal (rolled)]
[h: testName = "Blessed Condition Test"]
<!-- base roll is 10 + 3 (prof) + 1 (str). This total must be 15-18 total -->
[h: reportResults = json.set (reportResults, testName, "Passed: " + total)]
[h, if (total < 15): reportResults = json.set (reportResults, testName, "Failed: Actual total: " + total + " is not greater than 14")]
[h, if (total > 18): reportResults = json.set (reportResults, testName, "Failed: Actual total: " + total + " is not less than 19")]

<!-- Disadvantage from Blinded -->
[h: setAllStates (0, testToken)]
[h: setState ("Blinded", 1, testToken)]
[h: rolls = json.append ("", re)]
[h, token (testTokenName): rolled = json.get (dnd5e_DiceRoller_roll (rolls), 0)]
[h: rolls = json.get (rolled, "rolls")]
[h: roll = json.get (rolled, "roll")]
[h: testName = "Blinded Condition Test"]
[h: reportResults = json.set (reportResults, testName, "Passed: (" + rolls + ") " + roll)]
[h, if (json.length (rolls) != 2): 
	reportResults = json.set (reportResults, testName, "Failed: Did not throw two rolls: " + rolls)]
[h: hasDisadvantage = dnd5e_RollExpression_hasDisadvantage (rolled)]
[h, if (!hasDisadvantage): reportResults = json.set (reportResults, testName, "Failed: Does not have disadvantage")]

<!-- Advantage from Invisibile -->
[h: setAllStates (0, testToken)]
[h: setState ("Invisible", 1, testToken)]
[h: rolls = json.append ("", re)]
[h, token (testTokenName): rolled = json.get (dnd5e_DiceRoller_roll (rolls), 0)]
[h: rolls = json.get (rolled, "rolls")]
[h: roll = json.get (rolled, "roll")]
[h: testName = "Invisible Condition Test"]
[h: reportResults = json.set (reportResults, testName, "Passed: (" + rolls + ") " + roll)]
[h, if (json.length (rolls) != 2): 
	reportResults = json.set (reportResults, testName, "Failed: Did not throw two rolls: " + rolls)]
[h: hasAdvantage = dnd5e_RollExpression_hasAdvantage (rolled)]
[h, if (!hasAdvantage): reportResults = json.set (reportResults, testName, "Failed: Does not have advantage")]

[h: removeToken (testToken)]

[h:macro.return = reportResults]