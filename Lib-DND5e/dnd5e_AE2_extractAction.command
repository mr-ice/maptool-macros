[h: workingCopy = arg(0)]
[h: activeAction = arg(1)]
[h: json.toVars(dnd5e_AE2_getConstants())]
[h: exps = json.get(workingCopy, activeAction)]
[h: firstExp = json.get(exps, 0)]
[h: newActionType = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionType")]
[h: oldActionType = newActionType]
[h, if (newActionType == DNDB_ATTACK_TYPE || newActionType == DNDB_SPELL_TYPE): oldActionType = oldActionType + "-" + dnd5e_RollExpression_getName(firstExp)]
[h, if (newActionType == DNDB_SPELL_TYPE): oldActionType = oldActionType + "-" + json.get(firstExp, "spellLevel")]
[h: return(0, json.set("{}", "exps", exps, "newActionType", newActionType, "oldActionType", oldActionType))]
