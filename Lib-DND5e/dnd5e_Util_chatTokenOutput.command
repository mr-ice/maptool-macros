<!-- Constants for chat output -->
[h: OUT_TABLE  = 
	'<table style="border-spacing:1pt;border-width:0px;border-style:solid;padding:0px;">
	  <tr>
	    %{tokenImage}
	    %{tokenText}
	    %{columnsHtml}
	  </tr>
	</table>'
]
[h: IMG_SRC = '<img src="%{image}" alt="%{text}" width="30" height="30"/>']
[h: IMAGE_COLUMN = strformat('<td width="34" style="padding:0px;border-width:1pt;border-style:solid;text-align:center;">%{IMG_SRC}</td>')]
[h: BG_STYLE = 'background-color:%s;']
[h: TEXT_COLUMN = '<td style="%{bgColor}border-width:1pt;border-style:solid;padding:0px 5px 0px 3px;" NOWRAP>%{text}</td>']
[h: TOKEN_NAME = '<b>%s</b> %s']

<!-- Constants for objects -->
[h: ID = "id"]
[h: kTEXT = "text"]
[h: BG_COLOR = "bgColor"]
[h: kIMAGE = "image"]
[h: TO = "to"]
[h: TO_GM = "gm"]
[h: TO_OWNER = "owner"]
[h: TO_OTHER = "other"]
[h: TO_GROUP_LIST = json.append("[]", TO_GM, TO_OWNER, TO_OTHER)]

<!-- Token Image processing -->
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: outToken = arg(0)]
[h: id = json.get(outToken, ID)]
[h: image = getTokenImage("", id)]
[h: text = dnd5e_Util_encodeHtml(getName(id))]
[h: tokenImage = strformat(IMAGE_COLUMN)]
[h: log.debug(getMacroName() + ": tokenImage=" + tokenImage + " TEXT=" + kTEXT)]

<!-- Token Text processing -->
[h: text = strformat(TOKEN_NAME, text, json.get(outToken, kTEXT))]
[h, if (json.contains(outToken, BG_COLOR)): bgColor = strformat(BG_STYLE, json.get(outToken, BG_COLOR)); bgColor = ""]
[h: tokenText = strformat(TEXT_COLUMN)]
[h: log.debug(getMacroName() + ": tokenText=" + tokenText)]

<!-- Additional output -->
[h: otherTargets = "[]"]
[h: outColumns = json.set("{}", "all", "[]")]
[h, if (argCount() > 1): additionalColumns = arg(1); additionalolumns = "[]"]
[h, foreach(column, additionalColumns, ""), code: {

	<!-- Generate the chat ouput -->
	[h: log.debug(getMacroName() + ": column=" + json.indent(column))]
	[h, if (json.contains(column, kTEXT)): text = json.get(column, kTEXT); text = "UNKNOWN"]
	[h: log.debug(getMacroName() + ": text=" + text + " json.contains(column, TEXT)=" + json.contains(column, kTEXT))]
	[h, if (json.contains(column, kIMAGE)), code: {
		[h: image = json.get(column, kIMAGE)]
		[h: outColumn = strformat(IMAGE_COLUMN)]
	};{
		[h, if (json.contains(column, BG_COLOR)): bgColor = strformat(BG_STYLE, json.get(outToken, BG_COLOR)); bgColor = ""]
		[h: outColumn = strformat(TEXT_COLUMN)]
	}]
	[h: log.debug(getMacroName() + ": outColumn=" + outColumn)]

	<!-- add to ouput groups -->
	[h, if (json.contains(column, TO)): to = json.get(column, TO); to = json.fields(outColumns)]
	[h, foreach(target, to, ""), code: {
		[h, if (!json.contains(outColumns, target)): outColumns = json.set(outColumns, target, json.get(outColumns, "all"))]
		[h: columns = json.get(outColumns, target)]
		[h: columns = json.append(columns, outColumn)]
		[h: log.debug(getMacroName() + ": target=" + target + " columns=" + json.indent(columns))]		
		[h: outColumns = json.set(outColumns, target, columns)]
		[h, if (target != "all" && !json.contains(TO_GROUP_LIST, target)): otherTargets = json.append(otherTargets, target)]
	}]
}]

<!-- Group the players by GM/Owner/Other -->
[h: owners = getOwners("json", id)]	
[h: players = getAllPlayerNames("json")]
[h: gmPlayers = "[]"]
[h: ownerPlayers = "[]"]
[h: otherPlayers = "[]"]
[h, foreach(player, players), code: {
	[h, if (isGM(player)): gmPlayers = json.append(gmPlayers, player)]
	[h, if (!isGM(player) && json.contains(owners, player)): ownerPlayers = json.append(ownerPlayers, player)]
	[h, if (!isGM(player) && !json.contains(owners, player)): otherPlayers = json.append(otherPlayers, player)]
}]
[h: playerGroups = json.set("{}", TO_GM, json.removeAll(gmPlayers, otherTargets), TO_OWNER, json.removeAll(ownerPlayers, otherTargets), 
									TO_OTHER, json.removeAll(otherPlayers, otherTargets))]
[h: log.debug(getMacroName() + ": playerGroups=" + json.indent(playerGroups))]		

<!-- broadcast -->
[h, if(argCount() > 2): targets = arg(2); targets = json.merge(otherTargets, TO_GROUP_LIST)]
[h: log.debug(getMacroName() + ": targets=" + json.indent(targets))]		
[h: all = json.get(outColumns, "all")]
[h, foreach(target, targets, ""), code: {
	[h: broadcastTarget = json.append("[]", target)]
	[h, if (json.contains(TO_GROUP_LIST, target)): broadcastTarget = json.get(playerGroups, target)]
	[h: log.debug(getMacroName() + ": broadcastTarget=" + json.indent(broadcastTarget))]
	[h: columns = json.get(outColumns, target)]
	[h, if (json.contains(outColumns, target)): columns = json.get(outColumns, target); columns = all]
	[h: log.debug(getMacroName() + ": columns=" + json.indent(columns))]
	[h: columnsHtml = json.toList(columns, " ")]
	[h, if (!json.isEmpty(broadcastTarget)): broadcast(strformat(OUT_TABLE), broadcastTarget, "json")]
}]