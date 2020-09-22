[h: typedDescriptors = dnd5e_RollExpression_getTypedDescriptors(arg(0))]
[h: return(0, if(json.contains(typedDescriptors, arg(1)), decode(json.get(typedDescriptors, arg(1))), ""))]