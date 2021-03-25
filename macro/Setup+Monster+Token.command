[h: selected = getSelected("json")]
[h: CATEGORY = "Lib:Open5e.setup"]
[h: log.debug (CATEGORY + "## selected = " + selected)]
[h: assert (json.length (selected), "<b><font color='red'>No Token selected!</font></b><Br>Please select 1 or more tokens")]
[h: firstSelected = json.get (selected, 0)]
[h, token (firstSelected): slug = getProperty("Character ID")]
[h, token (firstSelected), if (encode (slug) == ""): slug = getName(); ""]
[h: monsterToon = o5e_Open5e_searchMonsterInput (slug)]
[r: "<br>name: " + json.get (monsterToon, "name")]
[h, foreach (selectedToken, selected), code: {
	[h: switchToken (selectedToken)]
	[h: o5e_Token_Monster_applyProperties (monsterToon)]
	[h: o5e_Token_Monster_applyActions (monsterToon)]
	[h: o5e_Token_Monster_createMacros ()]
	<!-- Apply health -->
	[h: params = json.set("{}", "id", currentToken(), "current", HP, 
	"temporary", TempHP, "maximum", MaxHP,
	"dsPass", 0, "dsFail", 0, "exhaustion6", 0)]
	[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]
	[h: setNPC ()]
}]