[h: monsterToon = arg(0)]
[h: tokenId = arg(1)]
[h: switchToken (tokenId)]
[h: o5e_Token_Monster_applyProperties (monsterToon)]
[h: o5e_Token_Monster_applySpecialAbilities (monsterToon)]
[h: o5e_Token_Monster_applyActions (monsterToon)]
[h: o5e_Token_Monster_createMacros ()]
<!-- Apply health -->
[h: params = json.set("{}", "id", currentToken(), "current", HP, 
	"temporary", TempHP, "maximum", MaxHP,
	"dsPass", 0, "dsFail", 0, "exhaustion6", 0)]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]
[h: setNPC ()]