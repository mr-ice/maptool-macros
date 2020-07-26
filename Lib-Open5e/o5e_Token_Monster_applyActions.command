[h: monsterJson = arg (0)]
[h, if (encode (monsterJson) == ""): return (0); ""]
[h: actions = json.get (monsterJson, "actions")]

[h: actionObjs = "{}"]
[h, foreach (action, actions), code: {
	[h: actionString = json.get (action, "desc")]
	[h: actionName = json.get (action, "name")]
	[h: actionObj = o5e_Parser_parseActionString (actionString)]
	<!-- if its an object, consider it an attack. Otherwise its a string that we
	     need to parse as an Effect -->
	<!-- need to reduce attack bonuses to their proficiencies values only -->
	[h: actionObjs = json.set (actionObjs, actionName, actionObj)]
}]
[h: log.debug (getMacroName() + ": actionObjs = " + json.indent (actionObjs))]
[h: setProperty ("_o5e_MonsterActions", actionObjs)]