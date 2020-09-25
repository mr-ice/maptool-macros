[h: spell = arg (0)]
[h: maxSpellLevel = arg (1)]
[h: html = ""]
[h: spellLevel = json.get (spell, "level")]
[h: castAtHigherLevel = json.get (spell, "castAtHigherLevels")]
[h: log.warn ("spellLevel: " + spellLevel)]
[h: log.warn ("castAtHigherLevel: " + castAtHigherLevel)]
[h: log.warn ("maxSpellLevel: " + maxSpellLevel)]

[h, if (spellLevel > 0 && castAtHigherLevel == "true" && spellLevel < maxSpellLevel), code: {
	[optionHtml = ""]
	[for (level, spellLevel, maxSpellLevel + 1), code: {
		[optionHtml = optionHtml + '<option value="' + level + '">' + level + '</option>']
	}]
	[log.warn ("optionlHtml: " + optionHtml)]
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
[h: log.warn ("html: " + html)]
[h: macro.return = html]