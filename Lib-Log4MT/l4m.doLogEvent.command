[h: level = arg (0)]
[h: category = arg (1)]
[h: msg = arg (2)]
[h: suffix = arg (3)]
[h: l4m.Constants()]

[h: secondDelim = indexOf (msg, CATEGORY_DELIM)]
[h: delimLength = length (CATEGORY_DELIM)]
[h, if (secondDelim >= 0), code: {
	[secondCat = substring (msg, 0, secondDelim)]
	<!-- if the secondCat contains a pipe, skip parsing a categoy by the secondary delim. Assume
	     its an input string instead -->
	[hasPipes = indexOf (secondCat, "|")]
	[if (hasPipes == -1), code: {
		[if (category != ""): category = category + "." + secondCat; category = secondCat]
		[msg = substring (msg, secondDelim + delimLength, length (msg))]
	}]
}]

[h, if (l4m.isLogLevelEnabled (level, category, suffix)), code: {
	<!-- We need to pass a json object in order to cause log.info to use the old function -->
	[message = category + " (" + upper(level) + ") "  + ": " + msg]
	[log.info (NATIVE_CATEGORY, message)]
}; {}]