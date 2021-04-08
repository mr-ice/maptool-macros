[h: dnd5e_PartyPanel_Constants (getMacroName())]

[h: pcTokens = dnd5e_PartyPanel_getPCTokens()]
[h: log.debug (CATEGORY + "## pcTokens = " + pcTokens)]
[h: assert (json.length (pcTokens) > 0, "No PC tokens on this map!", 0)]
[h: html = "<html><head><link rel='stylesheet' type='text/css' href='dnd5e_PartyPanel_css@Lib:DnD5e-PartyPanel'/></head>"]
[h: html = html + "<body><div class='table-wrapper'><table>"]
[h: html = html + "<thead>" + dnd5e_PartyPanel_getTokenHtml() + "</thead>"]
[h: html = html + "<tbody>"]
[h, foreach (pcToken, pcTokens), code: {
	[html = html + dnd5e_PartyPanel_getTokenHtml (pcToken)]
}]
[h: html = html + "</tbody></table></div>"]
[h: html = html + "<div><form action='" + macroLinkText ("dnd5e_PartyPanel_refreshPanel@this") + "'>" +
	"<input class='button' value='Refresh Panel' type='submit'/></form><div>"]
[h: html = html + "</body></html>"]
[h: log.trace (CATEGORY + "##html = " + html)]
[frame5 (PANEL_NAME, "height=600; width=600"): {
	[r: html]	
}]