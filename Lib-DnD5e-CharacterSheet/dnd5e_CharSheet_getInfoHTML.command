[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: html = '
	<table width="240">
			<!-- Top row - token name, character details -->
			<tr>
				<!-- Token name box -->
				<td>
					<table>
						<tr>
							<td class="subtext" align="left">
							' + macroLink ("Reload",
								"dnd5e_CharSheet_refreshPanel@" + LIB_TOKEN, 
								"", 
								"", 
								currentToken()) + '
								
							</td>
							<td class="subtext" align="right">
								<b>DUNGEONS &amp; DRAGONS</b>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="double-outline title">' + token.name + '</td>
						</tr>
						<tr class="subtext">
							<td>
								<span title="Edit Name">' +
								macroLink ("CHARACTER NAME", 
									"dnd5e_CharSheet_changeTokenName@" + LIB_TOKEN, 
									"", "", currentToken()) +'
								</span>
							</td>
						</tr>
					</table>
				</td>
				<!-- character details box -->
				<td>
					<table class="double-outline" style="border-collapse: collapse">
						<tr>
							<td height="15">
								<i> ' + dnd5e_CharSheet_formatProperty ("classes") + '</i>
							</td>
							<td>' + dnd5e_CharSheet_formatProperty (PROP_SUBCLASS) + '</td>
							<td>' + getPlayerName() + '</td>
						</tr>
						<tr class="subtext" style="border-top: 1px solid grey">
							<td><a href="' + 
								macroLinkText ("dnd5e_CharSheet_changeClasses@" + LIB_TOKEN, 
									"", "", currentToken())
									+ '"><span title="Set Classes">CLASS &amp; LEVEL</span></a>
							</td>
							<td>
								<a href="' + 
								macroLinkText ("dnd5e_CharSheet_changeProperty@" + LIB_TOKEN, 
									"", 
									json.append ("", PROP_SUBCLASS, "Sub Class"),
									currentToken()) 
									+ '"><span title="Edit Subclass">SUBCLASS</span></a>
							</td>
							<td>PLAYER NAME</td>
						</tr>
						<tr>
							<td>' + dnd5e_CharSheet_formatProperty ("Race") + '</td>
							<td>' + dnd5e_CharSheet_formatProperty (PROP_ALIGNMENT) + '</td>
							<td>' + dnd5e_CharSheet_formatNumber(
										dnd5e_CharSheet_formatProperty (PROP_EXPERIENCE_POINTS)
									) + '</td>
						</tr>
						<tr class="subtext" style="border-top: 1px solid gray;">
							<td>
								<a href="' +
								macroLinkText ("dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
									"", "Race", currentToken())
									+ '"><span title="Edit Race">RACE</span></a>
							</td>
							<td>
								<a href="' +
								macroLinkText ("dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
									"", json.append ("", PROP_ALIGNMENT, "Alignment"), 
									currentToken())
									+ '"><span title="Edit Alignment">ALIGNMENT</span></a>
							</td>
							<td>
								<a href="' +
								macroLinkText ("dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
									"", 
									json.append ("", PROP_EXPERIENCE_POINTS, "Experience Points"),
									currentToken())
									+ '"><span title="Edit Experience Points">EXPERIENCE POINTS</span>
								</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
']
[h: macro.return = html]