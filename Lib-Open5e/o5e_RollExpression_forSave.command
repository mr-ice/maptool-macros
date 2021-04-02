[h: actionObj = arg (0)]
[h: o5e_Constants (getMacroName())]

[h: spellcastingAbility = json.get (actionObj, "spellcastingAbility")]
<!-- If its not listed, its an innate ability (like a breath weapon) - thats constitution based -->
[h, if (spellcastingAbility == ""): spellcastingAbility = "Constitution"]
[h: abilityBonus = getProperty ("abilityBonus." + spellcastingAbility)]
[h: profValue = getProperty ("Proficiency")]
[h: saveDC = json.get (actionObj, "saveDC")]
<!-- No calculating the saveDC, just yet. Issue #260 -->
[h: saveDCx = 8 + profValue + abilityBonus]
[h: log.debug (CATEGORY + "## profValue = " + profValue + "; spellcastingAbility = " + 
		spellcastingAbility + "; abilityBonus = " + abilityBonus)]

[h: saveAbility = json.get (actionObj, "saveAbility")]
[h, if (saveAbility == ""), code: {
	[log.debug (CATEGORY + "## no save ability in save object")]
	[return (0, "")]
}]
[h: saveEffect = json.get (actionObj, "saveEffect")]
[h: re = dnd5e_RollExpression_Save ("Save")]
[h: re = dnd5e_RollExpression_setSaveDC (re, saveDC)]
[h: re = dnd5e_RollExpression_setSaveAbility (re, saveAbility)]
[h: rex = dnd5e_RollExpression_setSaveEffect (re, saveEffect)]
[h: rex = dnd5e_RollExpression_setSaveEffectMultiplier (re, 0)]
[h: re = dnd5e_RollExpression_addType (re, dnd5e_Type_Targeted())]
[h: macro.return = re]