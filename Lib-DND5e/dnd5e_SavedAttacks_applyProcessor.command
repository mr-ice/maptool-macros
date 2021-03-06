<!-- Get the hidden values from the form -->
[h: form = arg(0)]
[h: sIds = decode(json.get(form, "hidden-sIds"))]
[h: activeIndex = json.get(form, "hidden-activeIndex")]
[h: workingCopy = decode(json.get(form, "hidden-working-copy"))]
[h: active = json.get(workingCopy, activeIndex)]
[h: selected = decode(json.get(form, "hidden-selected"))]
[h: log.debug(getMacroName() + ": form=" + json.indent(form))]

<!-- Read the form -->
[h, for(i, 0, json.length(sIds)): selected = json.set(selected, i, dnd5e_SavedAttacks_readTargetRow(form, json.get(sIds, i), active, i, json.get(selected, i)))]

<!-- Change the active action? -->
[h, if (json.contains(form, "changeActive")), code: {
	[h: newActiveIndex = json.get(form, "changeActive")]
    [h, if (newActiveIndex != activeIndex), code: {
    	[h: selected = "[]"]
   		[h, for(i, 0, json.length(sIds)): selected = json.append(selected, "{}")]
    }]
    [h: activeIndex = newActiveIndex]
}]

<!-- Apply the attack? -->
[h, if (json.contains(form, "control") && json.get(form, "control") == "run"), code: {
	[h: closeDialog("Saved Attacks")]
	[h: adjust = json.length(dnd5e_SavedAttacks_fetch()) - 1]
	[h: args = json.append("[]", abs(activeIndex - adjust), selected)]
	[h: link = macroLinkText("dnd5e_SavedAttacks_apply@Lib:DnD5e", "all", args)]
	[h: log.debug(getMacroName() + ": link=" + json.indent(link))]
	[h: execLink(link)]
	[h: abort(0)]
}]

<!-- Exit the dialog? -->
[h, if (json.contains(form, "control") && json.get(form, "control") == "exit"), code: {
	[h: closeDialog("Saved Attacks")]
	[h: return(0, "")]	
}]

<!-- Clear the attacks and exit? -->
[h, if (json.contains(form, "control") && json.get(form, "control") == "clear"), code: {
	[h: setLibProperty("savedAttackRolledExpressions", "[]", "Lib:DnD5e")]	
	[h: closeDialog("Saved Attacks")]
	[h: return(0, "")]	
}]

<!-- Next loop -->
[h: dnd5e_SavedAttacks_applyUI(activeIndex, workingCopy, sIds, selected)]