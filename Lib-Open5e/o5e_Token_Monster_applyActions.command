[h: monsterJson = arg (0)]
[h, if (encode (monsterJson) == ""): return (0); ""]
[h: actions = json.get (monsterJson, "actions")]

[h: actionObjs = "{}"]
[h, foreach (action, actions), code: {
	[actionString = json.get (action, "desc")]
	[actionName = json.get (action, "name")]
	<!-- Anicent Silver Dragon Bug - More than one breath weapon -->
	[subActions = o5e_Parser_parseSubActionStrings (actionString)]

	[if (json.type (subActions) == "OBJECT"), code: {
		[subActionObjs = o5e_Token_Monster_applyActions (subActions)]
		[actionObjs = json.merge (actionObjs, subActionObjs)]
	}; {
		[actionObj = o5e_Parser_parseActionString (actionString)]
		[actionObjs = json.set (actionObjs, actionName, actionObj)]
	}]
}]
[h: log.debug (getMacroName() + ": actionObjs = " + json.indent (actionObjs))]
[h: setProperty ("_o5e_MonsterActions", actionObjs)]
<!-- This is a recursive function, so not only does it apply the propery it also returns data -->
[h: macro.return = actionObjs]