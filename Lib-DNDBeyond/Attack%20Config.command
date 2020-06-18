
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
	[h: selectedAttack = NEW_ATTACK]
}; {
    [h: attackList = NEW_ATTACK]  
    [h, foreach (attack, attackJson): attackList = json.append(attackList, json.get(attack, NAME))]
    [h: abort( input( "selectedAttack | " + json.toList(attackList) + " | Select Attack | list | value=string"))]
}]

<!-- Attack selected! Fetch the JSON for the selected attack. If "new" was selected, nothing will be found -->
[h: cfgAttack = json.fromStrProp(NAME + "=" + NEW_ATTACK)]
[h, foreach (attack, attackJson), code: {
	[h: attackName = json.get(attack, NAME)]
	[h, if (attackName == selectedAttack), code: {
		[cfgAttack = attack]
	}; {0}]
}]

<!-- transfer json properties to input vars -->
[h: inputAtkBonus = json.get(cfgAttack, ATK_BONUS)]
[h: inputDmgBonus = json.get(cfgAttack, DMG_BONUS)]
[h: inputDmgDie = json.get(cfgAttack, DMG_DIE)]
[h: inputDmgDice = json.get(cfgAttack, DMG_DICE)]
[h: inputName = json.get(cfgAttack, NAME)]
[h: inputCritBonus = json.get(cfgAttack, CRIT_BONUS_DICE)]
[h: inputDmgType = json.get(cfgAttack, DMG_TYPE)]
[h: inputDmgBonusExpr = json.get(cfgAttack, DMG_BONUS_EXPR)]

<!-- Prompt the input -->
[h: abort( input( "inputName | " + inputName + " | Attack Name | text",
    "inputAtkBonus | " + inputAtkBonus + " | Attack Bonus | text",
    "inputDmgBonus | " + inputDmgBonus + " | Damage Bonus | text",
    "inputDmgDie | " + inputDmgDie + " | Damage Die | text",
    "inputDmgDice | " + inputDmgDice + " | Number of Damage Dice | text",
    "inputDmgType | " + inputDmgType + " | Damage Type | text",
    "inputCritBonus | " + inputCritBonus + " | Extra Critical Dice | text",
    "inputDmgBonusExpr | " + inputDmgBonusExpr + " | Bonus Damage Expression | text",
    "inputDeleteAttack | | Delete Attack | check"))]

<!-- Convert the input into a new JSON object -->
[h: cfgAttack = json.set(cfgAttack, 
    NAME, inputName,
    ATK_BONUS, inputAtkBonus,
    DMG_BONUS, inputDmgBonus,
    DMG_DIE, inputDmgDie,
    DMG_DICE, inputDmgDice,
    CRIT_BONUS_DICE, inputCritBonus,
    DMG_TYPE, inputDmgType,
    DMG_BONUS_EXPR, inputDmgBonusExpr)]

[h, if (NEW_ATTACK == selectedAttack), code: {
    <!-- If you added a new attack, just tack it into attackJson -->
    [h: newAttackJson = json.append(attackJson, cfgAttack)]
}; {
    <!-- But if you modifed and existing attack, iterate through the attackJson and replace it -->
    [h: newAttackJson = ""]
    [h, foreach (attack, attackJson), code: {
        [h: attackName = json.get(attack, NAME)]
        [h: attack = if (attackName == selectedAttack, cfgAttack, attack)]
        [h: newAttackJson = if (inputDeleteAttack == 1 && selectedAttack == json.get(attack, NAME), newAttackJson, json.append(newAttackJson, attack))]
    }]
}]

[h: setProperty(ATTACK_JSON, newAttackJson)]
