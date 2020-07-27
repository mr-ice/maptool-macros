[h: tokenName = getName()]
[h, if (startsWith (tokenName, "Lib:")), code: {
	[broadcast ("<font color='red'>Library token! Aborting.</font>")]
	[abort(0)]
}; {""}]

[h: names = getMacros()]
[h, foreach (name, names), code: {
	[indexes = getMacroIndexes (name)]
	[foreach (index, indexes), code: {
		[removeMacro (index)]
	}]
}]
