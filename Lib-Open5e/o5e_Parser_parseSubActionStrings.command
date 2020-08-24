[h: actionString = arg (0)]
[h: REG_MARK_DOWN = "(\\*\\*[^*]*\\*\\*)"]
[h: findId = strfind (actionString, REG_MARK_DOWN)]
[h: matchCount = getFindCount (findId)]
[h, if (matchCount == 0), code: {
	[log.debug (getMacroName() + ": no match - returning original")]
	[return (0, actionString)]
}]

[h: subActions = "[]"]
[h, for (match, 1, matchCount + 1), code: {
	[actionName = getGroup (findId, match, 1)]
	[actionName = replace (actionName, "\\*", "")]
	<!-- For each match there is only one group. Use the groups end as our substring start.
	     Use the next match group start / end as the limit -->
	[subStart = getGroupEnd (findId, match, 1)]
	[if (match < matchCount): subEnd = getGroupStart (findId, match + 1, 1); subEnd = length (actionString)]
	[subActionString = substring (actionString, subStart, subEnd)]
	[actionObj = json.set ("", "name", actionName, "desc", subActionString)]
	[subActions = json.append (subActions, actionObj)]
}]
[h: macro.return = json.set ("", "actions", subActions)]