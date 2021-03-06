[h: dnd5e_Constants(getMacroName())]
[h: constitutionValue = getProperty ("ConstitutionBonus")]
[h: bonusHPValue = getProperty ("bonus.maxHP.value")]
[h: bonusHPLevel = getProperty ("bonus.maxHP.level")]
[h: hitDiceString = getProperty ("hitdice")]
<!-- If there are no hit dice, there is no hit point bonus -->
[h, if (hitDiceString == ""), code: {
	[log.debug (CATEGORY + "No hit dice string")]
	[return (0, 0)]
}]
[h: hitDiceObj = dnd5e_Util_parseMultiRollString (hitDiceString)]
[h: log.debug (CATEGORY + "## hitDiceObj = " + hitDiceObj)]
[h: totalHitDice = 0]
[h, foreach (hitDieObj, hitDiceObj), code: {
	[diceRolled = json.get (hitDieObj, "diceRolled")]
	[totalHitDice = totalHitDice + diceRolled]
}]
[h: log.debug (CATEGORY + "## totalHitDice = " + totalHitDice)]

[h: hpBonus = (constitutionValue + bonusHPLevel) * totalHitDice + bonusHPValue]
[h: macro.return = hpBonus]