[h: monster = arg(0)]

[h: o5e_ExtDB_Constants (getMacroName())]
[h: monsterName = json.get (monster, "name")]
[h: finishedInput = 1]
[h: exampleInputLabels = 
	"junk | <html>Example actions (use <i>italicized</i> text)</html> || label | span=true" + 
	"##junk | <html><br/></html> || label | span=true" +
	"##junk | <html><b>Melee Attack:</b></html> || label | span=true" +	"##junk |<html><i>Melee Weapon Attack: +9 to hit, reach 10 ft., one target. Hit: 12 (2d6 + 5) bludgeoning damage. If the target is a creature, it must succeed on a DC 14 Constitution saving throw or become diseased.</i></html>|| label | span=true" + 
		"##junk | <html><b>Ranged Attack:</b></html> || label | span=true" +	"##junk |<html><i>Ranged Weapon Attack: +6 to hit, range 80/320 ft., one target. Hit: 7 (1d8 + 3) piercing damage, and the target must make a DC 15 Constitution saving throw, taking 24 (7d6) poison damage on a failed save, or half as much damage on a successful one.</i></html>|| label | span=true" + 
		"##junk | <html><b>Melee or Ranged Attack:</b></html> || label | span=true" +	"##junk |<html><i>Melee or Ranged Weapon Attack: +3 to hit, reach 5 ft. or range 20/60 ft., one target. Hit: 4 (1d6 + 1) piercing damage.</i></html>|| label | span=true" + 
		"##junk | <html><b>Breath Weapon:</b></html> || label | span=true" +	"##junk |<html><i>The dragon exhales fire in a 90-foot cone. Each creature in that area must make a DC 24 Dexterity saving throw, taking 91 (26d6) fire damage on a failed save, or half as much damage on a successful one.</i></html>|| label | span=true" + 
		"##junk | <html><b>Generic Ability:</b></html> || label | span=true" +	"##junk |<html><i>The golem reconfigures its construction, moving shields and armor to encase its body. It regains 10 hp, and its AC increases by 2 until the end of its next turn.</i></html>|| label | span=true" +
		"##junk | <html><br/></html> || label | span=true"]

	
[h, while (finishedInput), code: {
	[actions = json.get (monster, "actions")]
	[if (encode (actions) == ""): actions = "[]"]
	[log.debug (CATEGORY + "actions = " + actions)]
	[newAction = " -- New Action --"]
	[actionNames = json.path.read (actions, "[*].name", "ALWAYS_RETURN_LIST")]
	[log.debug (CATEGORY + "actionNames = " + actionNames)]
	[inputList = json.merge (json.append ("[]", newAction), actionNames)]
	[deleteAction = 0]
	[inputStr = "junk | Cancel when done || label | span=true ## selectedAction | " + inputList + 
		"| Select Action to Edit | LIST | delimiter=json value=string"]
	[inputStr = inputStr + "## deleteAction | 0 | Delete Action? | CHECK"]
	[selectedAction = ""]
	[resetChoice = 0]
	[finishedInput = input (inputStr)]
	[if (finishedInput && selectedAction == newAction && !deleteAction): 
		resetChoice = !input ("selectedAction | Action | Action Name")]
	[if (finishedInput && !resetChoice && !deleteAction), code: {
		[pathFilter = "[*].[?(@.name == '" + selectedAction + "')]"]
		[actionTextPath = json.path.read (actions, pathFilter, "AS_PATH_LIST,SUPPRESS_EXCEPTIONS")]
		[log.debug (CATEGORY + "actionTextPath = " + actionTextPath)]
		[descriptionArry = json.path.read (actions, pathfilter + "['desc']")]
		[if (json.type (descriptionArry == "ARRAY") && json.length (descriptionArry) > 0):
			description = json.get (descriptionArry, 0); description = "New Description"]
		[log.debug (CATEGORY + "description = " + description)]
		[descriptionInput = exampleInputLabels + "##description | " + description + 
				" | " + selectedAction + " | TEXT | width=120"]
		[input (descriptionInput)]
		[action = json.set ("", "name", selectedAction, "desc", description)]
		[if (actionTextPath == "[]"):
			actions = json.append (actions, action);
			actions = json.path.set (actions, pathFilter, action)]
		[monster = json.set (monster, "actions", actions)]
	}]
	[if (finishedInput && !resetChoice && deleteAction), code: {
		[pathFilter = "[*].[?(@.name == '" + selectedAction + "')]"]
		[actionTextPath = json.path.read (actions, pathFilter, "AS_PATH_LIST,SUPPRESS_EXCEPTIONS")]
		[log.debug (CATEGORY + "actionTextPath = " + actionTextPath)]
		[actions = json.path.delete (actions, pathFilter)]
		[log.debug (CATEGORY + "after delete: actions = " + actions)]
		[monster = json.set (monster, "actions", actions)]
	}]
}]
[h: macro.return = monster]