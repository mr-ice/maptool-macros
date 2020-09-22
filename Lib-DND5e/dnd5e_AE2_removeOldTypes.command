<!-- Copy header info to external fields -->
[h: oldActionType = arg(0)]
[h: oldExps = arg(1)]
[h: log.debug("dnd5e_AE2_removeOldTypes: oldActionType=" + oldActionType + " oldExps=" + json.indent(oldExps))]
[h: actionType = arg(2)]
[h: newExps = arg(3)]
[h: log.debug("dnd5e_AE2_removeOldTypes: actionType=" + actionType + " newExps=" + json.indent(newExps))]

<!-- Copy header info to new expression -->
[h, if (json.isEmpty(oldExps)), code: {
	[h: actionName = "New Action"]
	[h: actionDesc = ""]
};{
	[h: exp = json.get(oldExps, 0)]
	[h: actionName = dnd5e_RollExpression_getTypedDescriptor(exp, "actionName")] 
	[h: actionDesc = dnd5e_RollExpression_getTypedDescriptor(exp, "actionDesc")] 
}]
[h: exp = json.get(newExps, 0)]
[h, if (dnd5e_RollExpression_getTypedDescriptor(exp, "actionName") == ""): exp = dnd5e_RollExpression_addTypedDescriptor(exp, "actionName", actionName)] 
[h, if (dnd5e_RollExpression_getTypedDescriptor(exp, "actionName") == ""): exp = dnd5e_RollExpression_addTypedDescriptor(exp, "actionDesc", actionDesc)]
[h: newExps = json.merge(json.append("[]", exp), json.remove(newExps, 0))]
[h: return(if(oldActionType != "" && !json.isEmpty(oldExps), 1, 0), newExps)]

<!-- The old expressions left after removing the old ones are added to this expression -->
[h, foreach(exp, oldExps), code: {
	[h, if(oldActionType == "Free Form"), code: {
		[h: newExps = json.append(newExps, dnd5e_RollExpression_removeTypedDescriptor(exp, "actionType"))]
	}; {
		[h, if(dnd5e_RollExpression_getTypedDescriptor(exp, "actionType") == oldActionType): ""; newExps = json.append(newExps, exp)]
	}]
}]
[h: return(0, newExps)];