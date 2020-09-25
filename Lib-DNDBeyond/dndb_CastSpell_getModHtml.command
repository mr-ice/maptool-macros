[h: spell = arg (0)]
[h: html = ""]
<!-- Look at modifiers and if there are any w/ Restrictions, prompt with a choice for
     which restriction to select. For now, assuming only one restriction is valid -->
[h: modifiers = json.get (spell, "modifiers")]
<!-- dont display any selector if theres only one anyways. It will be auto-selected -->
[h, if (json.length (modifiers) == 1): return (0, ""); ""]
[h: restrictedModiferMap = "{}"]
[h: optionHtml = ""]
[h, foreach (modifier, modifiers), code: {
	[restriction = json.get (modifier, "restriction")]
	[if (restriction != ""), code: {
		[encodedRestriction = encode (restriction)]
		[restrictedModiferMap = json.set (restrictedModiferMap, encodedRestriction, modifier)]
		[optionHtml = optionHtml + '<option value="' + encodedRestriction + '">' + restriction + '</option>']
	}; {}]
}]
[h, if (encode (optionHtml) != ""), code: {
	[optionHtml = '<option value="None" selected>None</option>' + optionHtml + 
	              '<option value="Other">Other</option>']
	[html = '
	<div class="grid-item12">
	   <label>Modifier Choice</label>
	</div>
	<div class="grid-item3">
	   <select name="spell-restriction" id="spell-restriction">
' + optionHtml + '
       </select>
    </div>
']
}; {}]
[h: log.debug (getMacroName() + ": html = " + html)]
[h: macro.return = html]