
<!-- Present the user with the cast spell dialogue -->

[h: inputObj = arg (0)]
[h: dndb_Constants (getMacroName())]
[h: encodedSpellName = json.get (inputObj, "spellName")]
[h: maxSpellSlot = json.get (inputObj, "maxSpellSlot")]
[h, if (maxSpellSlot == ""): maxSpellSlot = 0; ""]

[h: spells = dndb_getCastableSpells()]

[h: selectedSpell = json.get (spells, encodedSpellName)]
[h: spellName = json.get (selectedSpell, "name")]
[h: spellLevel = json.get (selectedSpell, "level")]
[h: spellDescription = json.get (selectedSpell, "description")]

<!-- Get Save DC, if any -->
[h: saveDescription = ""]
[h: saveDCAbilityId = json.get (selectedSpell, "saveDCAbilityId")]
[h, if (isNumber (saveDCAbilityId)), code: {
	[h: saveDC = json.get (selectedSpell, "saveDC")]
	[h, switch (saveDCAbilityId):
		case 0: saveAbility = "Strength";
		case 1: saveAbility = "Dexterity";
		case 2: saveAbility = "Constitution";
		case 3: saveAbility	= "Intelligence";
		case 4: saveAbility = "Wisdom";
		case 5: saveAbility = "Charisma"]
	[h: saveDescription = saveAbility + " save DC " + saveDC]
}]

<!-- Build HTML -->
[h: attackHtml = dndb_CastSpell_getAttackHtml (selectedSpell)]
[h, if (encode (attackHtml) == ""): hasAttackHtml = 0; hasAttackHtml = 1]
[h: modHtml = dndb_CastSpell_getModHtml (selectedSpell)]
[h, if (encode (modHtml) == ""): hasModHtml = 0; hasModHtml = 1]
[h: spellSlotHtml = dndb_CastSpell_getSpellSlotHtml (selectedSpell, maxSpellSlot)]
[h, if (encode (spellSlotHtml) == ""): hasSpellSlotHtml = 0; hasSpellSlotHtml = 1]
[h, if (spellSlotHtml || modHtml || attackHtml): showHtml = 1; showHtml = 0]
[h: contentHtml = spellSlotHtml + attackHtml + modHtml]
[h: log.debug (CATEGORY + "##" + contentHtml)]
[h: title = "Cast Spell: " + spellName]
[h: processorLink = macroLinkText ("dndb_CastSpell_processor@Lib:DnDBeyond", "all", "", currentToken())]
<!-- override showHtml to true to always force it for now. -->
[h: showHtml = 1]
[if (showHtml), code: {
	[dialog5 (title,
	"title=" + title + "; input=1; width=500; height=500; closebutton=0"): {
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="dnd5e_Editor_CSS@Lib:DnD5e"></link>
	</head>
	<body>
		<form action="[r: processorLink]" method="json">
		<input name="spellName" value="[r:encodedSpellName]" hidden="true" />
		<input name="noShowSpellDescription" value="1" hidden="true"/>
		<div class="grid-container">
           <div class="grid-header">[r: spellName]</div>
           [r: contentHtml]
           <div class="grid-footer">[r: json.get (selectedSpell, "description")]<br>
              <br>
              <b>[r: saveDescription]</b>
           </div>
           <div class="grid-header">
              <input name="actionButton" class="button" value="Cast Spell" type="submit" />
              <input name="actionButton" class="button" value="Cancel" type="submit" />
           </div>
        </div>

        </form>
     </body>
</html>
}]}; {
		[h: macroObj = json.set ("", "actionButton", "Cast Spell", 
	                      "spellName", encodedSpellName)]
		[r, macro ("dndb_CastSpell_processor@this"): macroObj]
}]
