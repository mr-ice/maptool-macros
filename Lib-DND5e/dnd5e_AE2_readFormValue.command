[h: exp = arg(0)]
[h: form = arg(1)]
[h: fieldName = arg(2)]

<!-- Get the field value from the form, if not set then done -->
[h: fieldId = dnd5e_RollExpression_getTypedDescriptor(exp, "rowId") + "-" + fieldName]
[h: return(json.contains(form, fieldId), exp)]

<!-- Get the new value and save it -->
[h: value = json.get(form, fieldId)]
[h, switch(fieldName):
	case "bonus": exp = dnd5e_RollExpression_setBonus(exp, value);
	case "rollString": exp = dnd5e_RollExpression_parseRoll(value, exp);
    case "damageType": exp = dnd5e_RollExpression_setDamageTypes(exp, value);
    case "DC": exp = dnd5e_RollExpression_setSaveDC(exp, value);
    case "saveAbility": exp = dnd5e_RollExpression_setSaveAbility(exp, value);
    case "saveAgainst": exp = json.set(exp, "saveAgainst", value);
    case "saveEffect": exp = dnd5e_RollExpression_setSaveEffect(exp, value);
    case "saveResult": exp = json.set(exp, "saveResult", value);
    case "conditions": exp = json.set(exp, "conditions", value);
    case "name": exp = dnd5e_RollExpression_setName(exp, value);
    case "onCritical": exp = dnd5e_RollExpression_setOnCritAdd(exp, value);
    case "dndbAttack": exp = dnd5e_RollExpression_setName(exp, value);
    case "dndbSpell": exp = dnd5e_RollExpression_setName(exp, value);
    case "dndbSpellLevel": exp = json.set(exp, "spellLevel", value);
    case "targetCheck": exp = dnd5e_RollExpression_setTargetCheck(exp, value);
    case "drainAbility": exp = dnd5e_RollExpression_setDrainAbility(exp, value);
    default: exp = dnd5e_RollExpression_addTypedDescriptor(exp, fieldName, value);
]
[h: log.debug("dnd5e_AE2_readFormValue: fieldId=" + fieldId + " fieldName=" + fieldName + " value=" + value + " exp=" + json.indent(exp))]
[h: macro.return = exp]