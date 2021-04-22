[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: isReactionAvailable = getProperty (PROP_REACTION)]
[h, if (isReactionAvailable == ""), code: {
	[isReactionAvailable = 1]
	[setProperty (PROP_REACTION, isReactionAvailable)]
}]
[h: reactionVerb = if (!isReactionAvailable, "<font color='red'><b>Not</b></font>", "")]
[h: isConcentrating = getProperty (PROP_CONCENTRATING)]
[h, if (isConcentrating == ""): isConcentrating = 0]
[h: concentrationVerb = if (!isConcentrating, "<font color='red'><b>Not</b></font>", "")]
[h: html = '

					<table>
						<tr>
							<td class="single-outline">
								<!-- Personality -->
								<table class="mixed-outline">
									<tr>
										<td align="center" class="standard-value">' + getProperty (PROP_TRAITS) + '</td>
									</tr>
									<tr>
										<td align="center" class="subtext">
											<b>
											<span title="Edit Personality Traits">' +
		macroLink ("PERSONALITY TRAITS", "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
			"", json.append ("", PROP_TRAITS, "Personality Traits"), currentToken())
											+ '</span>
											</b>
										</td>
									</tr>
								</table>
								<!-- Ideals -->
								<table class="mixed-outline">
									<tr>
										<td align="center" class="standard-value">' +
											getProperty (PROP_IDEALS)
										+ '</td>
									</tr>
									<tr>
										<td align="center" class="subtext">
											<b><span title="Edit Ideals">' +
		macroLink ("IDEALS", "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
				"", json.append ("", PROP_IDEALS, "Ideals"), currentToken())
												+ '</span>
											</b>
										</td>
									</tr>
								</table>
								<!-- Bonds -->
								<table class="mixed-outline">
									<tr>
										<td align="center" class="standard-value">' +
										getProperty (PROP_BONDS)
										+ '</td>
									</tr>
									<tr>
										<td align="center" class="subtext">
											<b><span title="Edit Bonds">' +
		macroLink ("BONDS", "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
			"", json.append ("", PROP_BONDS, "Bonds"), currentToken())
											+ '</span></b>
										</td>
									</tr>
								</table>
								<!-- Flaws -->
								<table class="mixed-outline">
									<tr>
										<td align="center" class="standard-value">' +
										getProperty (PROP_FLAWS)
										+ '</td>
									</tr>
									<tr>
										<td align="center" class="subtext">
											<b><span title="Edit Flaws">' +
		macroLink ("FLAWS", "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
			"", json.append ("", PROP_FLAWS, "Flaws"), currentToken())
											+ '</span></b>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<table class="mixed-outline">
									<tr><td>']
[h: html = html + dnd5e_CharSheet_getResourceHTML()]
[h: html = html + '							</td></tr><tr>
										<td class="standard-value">
											<span title="Edit temporary effects">' +
		macroLink ("Buffs: ", "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
			"", json.append ("", PROP_BUFFS, "Buffs"), currentToken())
			+ getProperty (PROP_BUFFS) + " <br/>"
											+ '</span>											
											<!-- CONDITIONS -->
											<span title="Edit Conditions">' +
		macroLink ("Conditions: ", "dnd5e_CharSheet_launchConditions@" + LIB_TOKEN,
			"", "", currentToken())
			+ dnd5e_Property_getConditionsStat () + " <br/>"
											+ '</span>
											<!-- REACTION -->
											<!-- Could probably do without this -->
											<span title="Toggle Reaction">' +
		macroLink ("Reaction Is "+reactionVerb+" Available: ", 
			"dnd5e_CharSheet_toggleProperty@" + LIB_TOKEN,
			"", PROP_REACTION, currentToken())
			+ dnd5e_CharSheet_formatBoolean (PROP_REACTION) + "<br/>"
											+ '</span>
											<span title="Set Concentration Spell">' +
		macroLink ("Is " + concentrationVerb + " Concentrating: ",
			"dnd5e_CharSheet_toggleProperty@" + LIB_TOKEN,
			"", PROP_CONCENTRATING, currentToken())
			+ dnd5e_CharSheet_formatBoolean (PROP_CONCENTRATING) + "<br/>"
											+ '</span>
										</td>
									</tr>
									<tr>
										<td align="center" class="subtext">
											<b><span title="Change Resources">' +
		macroLink ("RESOURCES &amp; STATES", "dnd5e_CharSheet_changeResources@" + LIB_TOKEN,
			"", "", currentToken()) + '
											</span></b>
										</td>
									</tr>
								</table>']
[h: html = html + dnd5e_CharSheet_getCounterHTML()]
<!-- stubbing out features for now. I need to trim some fat -->
[h: stubbed = html + '								<table class="mixed-outline">
									<tr>
										<td class="subtext">
											<!-- FEATS? -->
											
											<p>
												<a
												href="macro://Args Dialog@Lib:Character//Impersonated?prop%3DFeats%3Bindex%3D3%3Bname%3Dfavored+enemy%3Bdescription%3D%3BtokenName%3Dtrey.kirk"
												>Favored Enemy</a> Class </p>
											<p>
												<a
												href="macro://Args Dialog@Lib:Character//Impersonated?prop%3DFeats%3Bindex%3D4%3Bname%3Dnatural+explorer%3Bdescription%3D%3BtokenName%3Dtrey.kirk"
												>Natural Explorer</a> Class </p>
											<p>
												
												<a
												href="macro://Args Dialog@Lib:Character//Impersonated?prop%3DFeats%3Bindex%3D4%3Bname%3Dnatural+explorer%3Bdescription%3D%3BtokenName%3Dtrey.kirk"
												>Feature!!!</a> Where it came from? </p>
										</td>
									</tr>
									<tr>
										<td align="center" class="subtext">
											<b><a
												href="macro://Add@Lib:Character//Impersonated?prop%3DFeats%3BtokenName%3Dtrey.kirk"
												><span title="Add Features">FEATURES &amp;
												TRAITS</span></a></b>
										</td>
									</tr>
								</table>']

[h: html = html + '							</td>
						</tr>
					</table>
']
[h: log.trace (CATEGORY + "## html = " + html)]
[r: html]