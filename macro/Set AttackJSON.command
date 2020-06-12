
[h: ATTACK_JSON = "attackJSON"]
[h: NAME = "name"]
[h: ATK_BONUS = "atkBonus"]
[h: DMG_BONUS = "dmgBonus"]
[h: DMG_DIE = "dmgDie"]
[h: DMG_DICE = "dmgDice"]
[h: CRIT_BONUS_DICE = "critBonusDice"]
[h: DMG_TYPE = "dmgType"]
[h: DMG_BONUS_EXPR = "dmgBonusExpr"]
[h: NEW_ATTACK = "NewAttack"]

[h: blankJsonArry = "[]"]
[h: blankJsonObj = "{}"]
[h: blankText = ""]
[h: abort( input( " nothing | first | You might want to run Print AttackJSON macro | label",
	" nothing | reset | You can reinitialize the array by inputting | label",
	" newAttackJson | [] | New AtackJson | text | width=64"))]
[h: isBlank = json.equals(blankJsonArry, newAttackJson) + json.equals(blankJsonObj, newAttackJson) + json.equals(blankText, newAttackJson)]

[s, r, if (isBlank > 0): "Aborting execution due to empty input"; ""]
[h: newAttackJson = if (json.equals("reset", newAttackJson) == 1, "[]", newAttackJson)]
[h, if (isBlank == 0): setProperty(ATTACK_JSON, newAttackJson); ""]	
[r, macro( "Print AttackJSON@global"): ""]