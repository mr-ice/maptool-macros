<!-- Constants -->
[h: ATTACK_JSON = "attackJSON"]
[h: NAME = "name"]
[h: ATK_BONUS = "atkBonus"]
[h: DMG_BONUS = "dmgBonus"]
[h: DMG_DIE = "dmgDie"]
[h: DMG_DICE = "dmgDice"]
[h: CRIT_BONUS_DICE = "critBonusDice"]
[h: DMG_TYPE = "dmgType"]
[h: DMG_BONUS_EXPR = "dmgBonusExpr"]
[h: NEW_ATTACK = "New Attack"]
[h: LAST_ATTACK_SELECTION = "lastAttackSelection"]

<!-- Read attack JSON and prompt for selection -->
[h, if (!isPropertyEmpty (ATTACK_JSON)), code: {
	<!-- Property is populated. Fetch JSON data -->
    [h: attackJson = getProperty(ATTACK_JSON)]
}; {
	<!-- Property is empty, use blank object -->
	[h: attackJson = ""]
}]

[h: arrLen = json.length(attackJson)]
[h, if (arrLen < 1), code: {
	<!-- no attacks found, so create one in the config macro -->
	[h, macro("Attack Config@global"): ""]
	[h: attackJson = getProperty(ATTACK_JSON)]
}; {
    <!-- no-op -->
}]

<!-- Build an attack list to pick from -->
[h: attackList = ""]
[h, foreach (attack, attackJson): attackList = json.append(attackList, json.get(attack, NAME))]

<!-- Locate the index of the last selection to make it the default selection -->
[h: lastSelection = getProperty(LAST_ATTACK_SELECTION)]
[h: selectedIndex = json.indexOf(attackList, lastSelection)]
[h: selectedIndex = if (selectedIndex < 0, 0, selectedIndex)]

<!-- User Input -->
[h: abort( input(
    "selectedAttack | " + json.toList(attackList) + " | Select Attack | list | value=string select=" + selectedIndex,
    "advantageDisadvantage|None,Advantage,Disadvantage|Advantage/Disadvantage|list|value=string"
))]

<!-- Save the selection for next execution as the default selection -->
[h: setProperty(LAST_ATTACK_SELECTION, selectedAttack)]

<!-- Attack selected! Fetch the JSON for the selected attack. -->
[r, foreach (attack, attackJson), code: {
	[h: attackName = json.get(attack, NAME)]
	[h, if (attackName == selectedAttack), code: {
		[cfgAttack = attack]
	};{ 0 }]
}]

<!-- transfer json properties to input vars -->
[h: attackBonus = json.get(cfgAttack, ATK_BONUS)]
[h: dmgBonus = json.get(cfgAttack, DMG_BONUS)]
[h: dmgDie = json.get(cfgAttack, DMG_DIE)]
[h: dmgNumDice = json.get(cfgAttack, DMG_DICE)]
[h: attackName = json.get(cfgAttack, NAME)]
[h: critBonus = json.get(cfgAttack, CRIT_BONUS_DICE)]
[h: dmgType = json.get(cfgAttack, DMG_TYPE)]
[h: dmgBonusExpr = json.get(cfgAttack, DMG_BONUS_EXPR)]

<!-- Roll attack dice (always roll two, determine if advantage or disadvantage applies after -->
<!-- Unlike dmg rolls that use a full text expression, attack is done in discrete steps to determine criticals -->
[h: attack = 1d20]
[h: attack2 = 1d20]

<!-- Calculate the correct attack roll -->
[h: realAttack = attack]
[h,if (advantageDisadvantage == "Advantage"): realAttack = max(attack, attack2)]
[h,if (advantageDisadvantage == "Disadvantage"): realAttack = min(attack, attack2)]

<!-- Apply critical -->
[h,if (realAttack == 20): dmgNumDice = (dmgNumDice * 2) + critBonus]

<!-- Roll damage -->
[h: dmgExpression = dmgNumDice + "d" + dmgDie + " + " + dmgBonus]
[h: noDmgExpression = json.equals(dmgBonusExpr, "") + json.equals(dmgBonusExpr, 0)]
[h: dmgExpression = if (noDmgExpression > 0, dmgExpression, dmgExpression + " + " + dmgBonusExpr)]
[h: dmg = eval(dmgExpression)]

<!-- Build the message -->
[h: atkString = "<b>"]
[h: atk2String = "<b>"]
[h,if(attack == 20): atkString = atkString + "<font color='red'><i>CRITICAL</i></font> "]
[h,if(attack2 == 20): atk2String = atk2String + "<font color='red'><i>CRITICAL</i></font> "]
[h: attack = attack + attackBonus]
[h: attack2 = attack2 + attackBonus]
[h: realAttack = realAttack + attackBonus]
[h,if(advantageDisadvantage != "None"): realAtkString = "<b>" + realAttack + "</b>"]
[h: atkString = atkString + attack + "</b>"]
[h: atk2String = atk2String + attack2 + "</b>"]

[h: nameStr = getName() + ": " + attackName + "<br>(" + dmgType + ")<br><br>"]
[h: atkStr = "Attack (1d20 + " + attackBonus + "): " + atkString + "<br>"]
[h,if(advantageDisadvantage != "None"): atkStr = atkStr + advantageDisadvantage + ": " + atk2String + "<br><br>Actual Attack: " + realAtkString + "<br>"]
[h: dmgStr = "Damage (" + dmgExpression + "): " + dmg]

[r: nameStr]
[r: atkStr]
[r: dmgStr]