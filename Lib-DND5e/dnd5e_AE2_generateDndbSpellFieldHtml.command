[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h: stepClass = arg(3)]
[h: spells = json.path.read(dndb_getBasicToon(), ".spells[?(@.modifiers[0].friendlyTypeName=='Damage')]")]
[h: spellNames = "[]"]
[h, foreach(spell, spells, ""): spellNames = json.append(spellNames, json.set("{}", "name", json.get(spell, "name"), "level", json.get(spell, "level")))]
[h: spellNames = json.sort(spellNames, "ascending", "level", "name")]
[h: spellsShown = "[]"]
[h, foreach(spell, spellNames, ""), code: {
	[h: level = dnd5e_Util_ordinalPostfix(json.get(spell, "level"), "Cantrip", "(%{value})")]
	[h: spellsShown = json.append(spellsShown, json.set("{}", "name", json.get(spell, "name"), "level", level))]	
}]
[h: log.debug("dnd5e_AE2_generateDndbSpellFieldHtml: fieldId=" + fieldId + " value=" + value + " stepClass=" + stepClass + " spells=" + json.indent(spellsShown))]
<div class="col-4 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id">Spell:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker [r:stepClass]" data-show-subtext="true" title="Choose spell&hellip;">
    [r, foreach(spell, spellsShown, "</option>"): "<option" 
    	+ if(replace(value, " ", "") == replace(json.get(spell, "name"), " ", ""), " selected", "") 
    	+ " data-subtext='" + json.get(spell, "level") + "'>" + json.get(spell, "name")]
  </select>
</div>