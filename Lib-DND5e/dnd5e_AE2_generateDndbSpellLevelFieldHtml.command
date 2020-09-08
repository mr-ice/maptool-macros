[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h: stepClass = arg(3)]

<!-- Find the spell -->
[h: toon = dndb_getBasicToon()]
[h: spellName = arg(4)]
[h: spell = json.path.read(toon, ".spells[?(@.name=='" + spellName + "')]")]
[h, if (json.type(spell) == "ARRAY"): spell = json.get(spell, 0); ""]
[h: log.debug("dnd5e_AE2_generateDndbSpellLevelFieldHtml: fieldId=" + fieldId + " value=" + value + " stepClass=" + stepClass 
				+ " spellName=" + spellName + " spell=" + json.indent(spell))]

<!-- Cast at higher levels? If not then done -->
[h: spellLevel = json.get(spell, "level")]
[h: scaleType = json.path.read(spell, ".modifiers[0].atHigherLevels.scaleType")]
[h, if (json.type(scaleType) == "ARRAY"): scaleType = json.get(scaleType, 0)]
[h: spellCastHigher = json.get(spell, "castAtHigherLevels")]
[h: log.debug("dnd5e_AE2_generateDndbSpellLevelFieldHtml: spellLevel=" + spellLevel + " scaleType=" + scaleType + " spellCastHigher=" + spellCastHigher)]
[h: return(if(spellCastHigher == "true" && scaleType == "spellscale", 1, 0), "")]

<!-- Find the valid spell levels -->
[h: allLevels = json.path.read(toon, ".spellSlots[?(@.available>0)].level")]
[h, while(json.get(allLevels, 0) < spellLevel): allLevels = json.remove(allLevels, 0)]
[h: levelBump = json.path.read(spell, ".modifiers[0].atHigherLevels.higherLevelDefinitions[0].level")]
[h, if (json.isEmpty(levelBump)): levelBump = 1; levelBump = json.get(levelBump, 0)]
[h, if (!isNumber(levelBump)): levelBump = 1]
[h: log.debug("dnd5e_AE2_generateDndbSpellLevelFieldHtml: levelBump=" + levelBump + " allLevels=" + allLevels)]
[h: levels = "[]"]
[h, for(index, 0, json.length(allLevels)), code: {
	[h, if (math.mod(index, levelBump) == 0): levels = json.append(levels, json.get(allLevels, index))]
}]
[h: return(if(json.length(levels) > 1, 1, 0), "")]
<div class="col-4 form-group action-detail[r:stepClass]" data-toggle="tooltip" title="Choose the level of the spell slot used to cast the spell">
  <label for="[r:fieldId]-id">Cast at Level:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker [r:stepClass]" title="Choose level&hellip;" required onchange="changeType(this.value)">
    [r, foreach(level, levels, "</option>"): "<option" + if(value == level, " selected", "") + ">" + level]
  </select>
</div> 