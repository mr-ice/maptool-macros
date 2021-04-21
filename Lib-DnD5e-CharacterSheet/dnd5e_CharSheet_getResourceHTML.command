[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: html = '<table>']
[h: resourceObj = getProperty (PROP_RESOURCES)]
[h, if (json.type (resourceObj) != "OBJECT"): resourceObject = "{}"]
[h, if (json.length (resourceObj) == 0):
	resourceObj = json.set (resourceObj, "stub", "")]
[h: html = html + '
	<tr>
		<td width="40%" align="center" class="subtext"><b>NAME</b></td>
		<td width="30%" align="center" class="subtext"><b>USED / TOTAL</b></td>
		<td width="30%" align="center" class="subtext"><b>RESET</b></td>
	</tr>']
[h, foreach (resourceField, resourceObj), code: {
	[strProp = json.get (resourceObj, resourceField)]
	[name = getStrProp (strProp, "name", "&nbsp;", "##")]
	[current = getStrProp (strProp, "current", "", "##")]
	[limit = getStrProp (strProp, "limit", "", "##")]
	[if (isNumber (current)):
		currentLimitStr = macroLink (current, "dnd5e_CharSheet_incrementCounter@" + LIB_TOKEN,
			"", json.append ("", resourceField, 1, PROP_RESOURCES, 1), currentToken())
			+ " / " + limit;
		currentLimitStr = "  "]
	[reset = getStrProp (strProp, "reset", "&nbsp;", "##")]
	[html = html + '
	<tr>
		<td width="33%" valign="middle" class="offwhite standard-value">' +
			macroLink (name, "dnd5e_CharSheet_changeResources@" + LIB_TOKEN, 
				"", json.append ("", resourceField), currentToken())
		+ '</td>
		<td width="33%" valign="middle" align="center" class="offwhite standard-value">' 
			+ currentLimitStr +'</td>
		<td width="33%" valign="middle" class="offwhite standard-value">' + 
			macroLink (reset, "dnd5e_CharSheet_resetResources@" + LIB_TOKEN,
				"", json.append ("", resourceField, PROP_RESOURCES, reset), currentToken())
				+ '</td>
	</tr>']
}]
[h: html = html + '</table>']
[h: log.trace (CATEGORY + "## html = " + html)]
[h: macro.return = html]