[h: spell = arg (0)]
[h: maxSpellLevel = arg (1)]
[h: dndb_Constants (getMacroName())]
[h: html = ""]
[h: spellLevel = json.get (spell, "level")]
[h: castAtHigherLevel = json.get (spell, "castAtHigherLevels")]
[h: log.debug (CATEGORY + "##spellLevel: " + spellLevel)]
[h: log.debug (CATEGORY + "##castAtHigherLevel: " + castAtHigherLevel)]
[h: log.debug (CATEGORY + "##maxSpellLevel: " + maxSpellLevel)]

[h, if (spellLevel > 0 && castAtHigherLevel == "true" && spellLevel < maxSpellLevel), code: {
	[optionHtml = ""]
	[for (level, spellLevel, maxSpellLevel + 1), code: {
		[optionHtml = optionHtml + '<option value="' + level + '">' + level + '</option>']
	}]
	[log.debug (CATEGORY + "##optionlHtml: " + optionHtml)]
	[html = '
   <div class="grid-item12">
      <label>Spell Slot</label>
   </div>
   <div class="grid-item3">
      <select name="spell-slot" id="spell-slot">
' + optionHtml + '
      </select>
   </div>
']
}]
[h: log.debug (CATEGORY + "##html: " + html)]
[h: macro.return = html]