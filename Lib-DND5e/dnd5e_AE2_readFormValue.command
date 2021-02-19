<!-- Get the field value from the form, if not set then done -->
[h: l_fieldId = dnd5e_RollExpression_getTypedDescriptor(exp, "rowId") + "-" + field]
[h: return(json.contains(form, l_fieldId), exp)]

<!-- Get the new value and save it -->
[h: l_value = json.get(form, l_fieldId)]
<!-- Switch does not support fields as cases -->
[h, switch(field):
	case "bonus": exp = dnd5e_RollExpression_setBonus(exp, l_value);
	case "rollString": exp = dnd5e_RollExpression_parseRoll(l_value, exp);
    case "damageType": exp = dnd5e_RollExpression_setDamageTypes(exp, l_value);
    case "DC": exp = dnd5e_RollExpression_setSaveDC(exp, l_value);
    case "saveAbility": exp = dnd5e_RollExpression_setSaveAbility(exp, l_value);
    case "saveAgainst": exp = json.set(exp, "saveAgainst", l_value);
    case "saveEffect": exp = dnd5e_RollExpression_setSaveEffect(exp, l_value);
    case "saveResult": exp = json.set(exp, "saveResult", l_value);
    case "conditions": exp = json.set(exp, "conditions", l_value);
    case "name": exp = dnd5e_RollExpression_setName(exp, l_value);
    case "onCritical": exp = dnd5e_RollExpression_setOnCritAdd(exp, l_value);
    case "dndbAttack": exp = dnd5e_RollExpression_setName(exp, l_value);
    case "dndbSpell": exp = dnd5e_RollExpression_setName(exp, l_value);
    case "dndbSpellLevel": exp = json.set(exp, "spellLevel", l_value);
    case "targetCheck": exp = dnd5e_RollExpression_setTargetCheck(exp, l_value);
    case "drainAbility": exp = dnd5e_RollExpression_setDrainAbility(exp, l_value);
    case "drainAbility": exp = dnd5e_RollExpression_setDrainAbility(exp, l_value);
    case "proficency": exp = dnd5e_RollExpression_setProficiency(exp, if(l_value == "on", 1, 0));
    case "abilityMod": exp = dnd5e_RollExpression_setSpellcastingAbility(exp, l_value);
    default: exp = dnd5e_RollExpression_addTypedDescriptor(exp, field, l_value);
]
[h: macro.return = exp]