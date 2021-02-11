[h: log.debug ("Proc args = " + json.indent (macro.args))]

[h: inputArgs = macro.args]
[h: actionButton = json.get (inputArgs, "actionButton")]
[h: saveAttackAsMacro = json.get (inputArgs, "saveAttack")]
[h: duplicateAttack = json.get (inputArgs, "duplicateAttack")]
[h, if (duplicateAttack == ""): doDuplicate = 0; doDuplicate = 1]
[h, if (saveAttackAsMacro == "on"): saveAttackAsMacro = 1; saveAttackAsMacro = 0]
[h, if (actionButton == "Cancel"), code: {
	[closeDialog ("Attack Editor")]
	[abort (0)]
}; {""}]

<!-- Macro button color - Trying to keep the macro color choices transient until save is a real PITA since
     the payload back to the editor is the attack object JSON. So instead, just take whatever they have
     selected and save it as the preference. -->
[h: dnd5e_Preferences_setPreference ("attackEditor_macroFontColor", json.get (inputArgs, "attackEditorMacroFontColor"))]
[h: dnd5e_Preferences_setPreference ("attackEditor_macroButtonColor", json.get (inputArgs,"attackEditorMacroButtonColor"))]
[h: advantage = json.get (inputArgs, "advantage")]
[h: disadvantage = json.get (inputArgs, "disadvantage")]
[h: advDisadv = "Normal"]
[h, if (advantage == "Advantage"), code: {
	[if (disadvantage == "Disadvantage"): advDisadv = "Both"; advDisadv = "Advantage"]
}; {""}]
[h, if (disadvantage == "Disadvantage" && advantage != "Advantage"): advDisadv = "Disadvantage"; ""]
<!-- Well capture the currently selected attack based off of the action selected. For now, none -->
[h: selectedAttack = json.get (inputArgs, "activeAttack")]

<!-- Build the roll expressions -->
[h: attackObj = "{}"]
[h: duplicatedAttack = "{}"]

<!-- Build the attack -->
<!-- And build the attackObj -->
[h: attackFields = json.fromList (json.get (inputArgs, "attackFields"))]
[h, foreach (attackField, attackFields), code: {
	[h: rollExpressions = "[]"]
	<!-- Build the Attack -->
	[attackName = json.get (inputArgs, "attackName-" + attackField)]
	<!-- if there is no attack name, force it. We rely on it being non-null -->
	[if (attackName == ""): attackName = attackField; ""]
	<!-- if attackField == selectedAttack, set selectedAttack to the attack name. This catches instances
	     where the name is changed in the same session the user chooses to atttck -->
	[if (attackField == selectedAttack): selectedAttack = attackName; ""]
	[attackBonus = json.get (inputArgs, "attackBonus-" + attackField)]
	[damageRollString = json.get (inputArgs, "damageRoll-" + attackField)]
	[damageType = json.get (inputArgs, "damageType-" + attackField)]
	[damageCritical = json.get (inputArgs, "damageCritical-" + attackField)]
	[attackExpression = dnd5e_RollExpression_Attack (attackName)]
	[attackExpression = dnd5e_RollExpression_setBonus (attackExpression, attackBonus)]
	<!-- adorn with weapon or spellcasting, if applicable -->
	[attackType = json.get (inputArgs, "attackType-" + attackField)]
	[weaponType = json.get (inputArgs, "weaponType-" + attackField)]
	[abilityVal = json.get (inputArgs, "ability-" + attackField)]
	[proficiencyVal = json.get (inputArgs, "proficiency-" + attackField)]
	[if (attackType == "weapon"), code: {
		[attackExpression = dnd5e_RollExpression_setWeaponType (attackExpression, weaponType)]
		[attackExpression = dnd5e_RollExpression_setProficiency (attackExpression, proficiencyVal)]
	}; {}]

	[if (attackType  == "ability"), code: {
		[attackExpression = dnd5e_RollExpression_setSpellcastingAbility (attackExpression, abilityVal)]
		[attackExpression = dnd5e_RollExpression_setProficiency (attackExpression, proficiency)]
	}; {}]
	
	[rollExpressions = json.append (rollExpressions, attackExpression)]

	<!-- Weapon damage -->
	[damageExpression = dnd5e_RollExpression_Damage ("", damageRollString)]
	[if (attackType == "weapon"), code: {
		[damageExpression = dnd5e_RollExpression_setWeaponType (damageExpression, weaponType)]
	}; {}]
	
	[damageExpression = dnd5e_RollExpression_setDamageTypes (damageExpression, damageType)]
	[damageExpression = dnd5e_RollExpression_setOnCritAdd (damageExpression, damageCritical)]
	[rollExpressions = json.append (rollExpressions, damageExpression)]

	[extraDamageTotal = json.get (inputArgs, "extraDamage-" + attackField)]
	[if (!isNumber (extraDamageTotal)): extraDamageTotal = 0; ""]
	[for (index, 0, extraDamageTotal), code: {
		[extraDamageRoll = json.get (inputArgs, "extraDamageRoll-" + attackField + "-" + index)]
		[extraDamageType = json.get (inputArgs, "extraDamageType-" + attackField + "-" + index)]
		[extraDamageSaveDC = json.get (inputArgs, "extraDamageSaveDC-" + attackField + "-" + index)]
		[extraDamageSaveAbility = json.get (inputArgs, "extraDamageSaveAbility-" + attackField + "-" + index)]
		[extraDamageSaveEffect = json.get (inputArgs, "extraDamageSaveEffect-" + attackField + "-" + index)]
		<!-- defaults as regular damage (which has critable) -->
		[extraDamage = dnd5e_RollExpression_Damage ("", extraDamageRoll)]
		[diceRolled = dnd5e_RollExpression_getDiceRolled (extraDamage)]
		[if (isNumber (extraDamageSaveDC) && diceRolled > 0): extraDamage = dnd5e_RollExpression_SaveDamage ("", extraDamageRoll); ""]
		[if (isNumber (extraDamageSaveDC) && diceRolled == 0): extraDamage = dnd5e_RollExpression_SaveEffect (); ""]
		[extraDamage = dnd5e_RollExpression_setDamageTypes (extraDamage, extraDamageType)]
		[extraDamage = dnd5e_RollExpression_setSaveDC (extraDamage, extraDamageSaveDC)]
		[extraDamage = dnd5e_RollExpression_setSaveAbility (extraDamage, extraDamageSaveAbility)]
		[extraDamage = dnd5e_RollExpression_setSaveEffect (extraDamage, extraDamageSaveEffect)]

		[doDelete = json.get (inputArgs, "deleteExtraDamage-" + attackField + "-" + index)]
		<!-- if doDelete is blank, add the expression. If it is not, its the selected attack -->
		[if (doDelete == ""): rollExpressions = json.append (rollExpressions, extraDamage); selectedAttack = attackName]
	}]
	[doAddExtraDamage = json.get (inputArgs, "addExtraDamage-" + attackField)]
	<!-- if doAddExtraDamage is the action, its also the selected attack -->
	[h, if (doAddExtraDamage == "Add Damage"), code: {
		[rollExpressions = json.append (rollExpressions, dnd5e_RollExpression_Damage ())]
		[selectedAttack = attackName]
	}; {""}]
	<!-- notice we are adding the attack by its name, not the original field value -->
	[h: doDeleteAttack = json.get (inputArgs, "deleteAttack-" + attackField)]
	[h, if (doDeleteAttack == ""): attackObj = json.set (attackObj, attackName, rollExpressions); ""]
	[h, if (doDuplicate && attackName == selectedAttack): duplicatedAttack = rollExpressions; ""]
}]

[h, if (doDuplicate), code: {
	<!-- give the attack a unique name and tack it on, also make it selected -->
	[selectedAttack = "Duplicated " + selectedAttack]
	[attackObj = json.set (attackObj, selectedAttack, duplicatedAttack)]
}]



[h: doAddAttack = json.get (inputArgs, "addAttack")]
<!-- if theres nothing in the attackObj, add a new attack -->
[h, if (doAddAttack != "" || json.isEmpty (attackObj)), code: {
	<!-- new attack selected. create a new one and make it the selected -->
	[newAttack = "New Attack"]
	[selectedAttack = newAttack]
	[rollExpressions = json.append ("", dnd5e_RollExpression_Attack (newAttack),
										dnd5e_RollExpression_Damage ())]
	[attackObj = json.set (attackObj, newAttack, rollExpressions)]
}]

[h: callbackLink = json.get (inputArgs, "callbackMacroLink")]

[h, if (actionButton == ""), code: {
	<!-- Did not click actionButton, callback the editor -->
 	[h: dnd5e_AttackEditor (callbackLink, attackObj, selectedAttack)]
}; {
	<!-- Done -->
	<!-- Tack on the attackObj json to the macroLink -->
	[h: closeDialog ("Attack Editor")]
	<!-- ampersand gets clobbered on transmission, avoid -->
	[h, if (actionButton == "Save & Attack"): actionButton = "SaveAttack"; ""]
	[h: retObj = json.set ("", "action", actionButton, 
							   "advantageDisadvantage", advDisadv,
							   "saveAttackAsMacro", saveAttackAsMacro,
							   "selectedAttack", selectedAttack,
							   "attackObj", attackObj)]
	[h: queryParamIndex = indexOf (callbackLink, "?")]
	[h, if (queryParamIndex == -1): queryParamIndex = length (callbackLink); ""]
	[h: callbackLinkWithQuery = substring (callbackLink, 0, queryParamIndex) + "?" + retObj]
	[h: log.debug ("callbackLinkWithQuery: " + callbackLinkWithQuery)]
	[h: execLink (callbackLinkWithQuery)]
}]
