[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: html = '
<table>
						<tr>
							<td class="offwhite single-outline">
								<!-- Grey box -->
								<table>
									<tr>
										<td width="33%">
											<!-- Armor Class -->
											<table class="mixed-outline back-white">
												<tr>
												<td class="armor-class-value ac-init-move">
												<!-- tool tip: dex bonus to AC / cdata is total AC -->
												' + dnd5e_CharSheet_getArmorClassSpan() + '
												</td>
												</tr>
												<tr>
												<td class="subtext" align="center">
												<b><span title="Edit Armor Class"
												>' +
				macroLink ("ARMOR CLASS", "dnd5e_CharSheet_changeArmorClass@" + LIB_TOKEN,
					"", "", currentToken())
												+ '</span>
												</b>
												</td>
												</tr>
											</table>
										</td>
										<td width="33%">
											<!-- INITIATIVE -->
											<table class="mixed-outline back-white">
												<tr>
												<td class="armor-class-value ac-init-move">' +
				dnd5e_CharSheet_getInitiativeSpan (macroLink (dnd5e_CharSheet_formatBonus (getProperty ("Initiative")),
														"dnd5e_CharSheet_rollInitiative@" + LIB_TOKEN,
														"all", "", currentToken()))
												+ '</td>
												</tr>
												<tr>
												<td class="subtext" align="center">
												<b><span title="Edit Initiative">' +
				macroLink ("INITIATIVE", "dnd5e_CharSheet_changeInitiative@" + LIB_TOKEN,
					"", "", currentToken())
												+ '</span></b>
												</td>
												</tr>
											</table>
										</td>
										<td width="34%">
											<!-- SPEED -->
											<table class="mixed-outline back-white">
												<tr>
												<td class="armor-class-value ac-init-move"><span title="' +
										getProperty ("stat.movement")
										+ '">'+
										getProperty ("walk")
												+ ' ft.</span></td>
												</tr>
												<tr>
												<td class="subtext" align="center">
												<b><span title="Edit Movement Speed">' +
				macroLink ("SPEED", "dnd5e_CharSheet_changeSpeed@" + LIB_TOKEN,
					"", "", currentToken())
												 + '</span></b>
												</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<!-- Hit points -->
										<td colspan="3">
<table class="back-white mixed-outline">
    <tr>
        <td class="detail-label">Hit Point Maximum</td>
        <td class="hitpoint-maximum">
            <span title="Edit Maximum Hit Points">' + macroLink (getProperty ("MaxHP"),
                "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN, "", json.append ("", "MaxHP", 
                "Maximum Hit Points"), currentToken()) + '</span>
        </td>
        <!-- 3rd column -->
        <td>&nbsp;</td>
    </tr>
    <tr>
    	<td class="hitpoint-subtract">
    		<span title="Apply Damage">
    			<a class="hitpoint-subtract" href="'+
    				macroLinkText ("dnd5e_CharSheet_applyHealth@" + LIB_TOKEN,
	    			"all",
    				"0",
    				currentToken())
    				+'">&ndash;
    			</a>
    		</span>
    	</td>
    	<td class="hitpoint-current"><span title="Edit Hit Points">'+
    		macroLink (getProperty ("HP"), "dnd5e_CharSheet_changeHitPoints@" + LIB_TOKEN,
    			"all",
    			"",
    			currentToken())
    	+'</span></td>
    	<td class="hitpoint-add">
    		<span title="Apply Health">
    			<a class="hitpoint-add" href="'+
    				macroLinkText ("dnd5e_CharSheet_applyHealth@" + LIB_TOKEN,
	    			"all",
    				"1",
    				currentToken())
    				+'">+
    			</a>
    		</span>
    	</td>
    </tr>
    

    <tr>
        <td colspan="3" align="center" class="subtext">
            <b>'+
            macroLink ("CURRENT HIT POINTS", "dnd5e_CharSheet_changeHitPoints@" + LIB_TOKEN,
            	"all", "", currentToken()) +'</b>
        </td>
    </tr>
</table>
										</td>
									</tr>
									<tr>
										<!-- TEMP HP -->
										<td colspan="3">
											<table class="single-outline back-white">
												<tr>
												<td class="temp-hp-value">
													<span title="Edit Temporary Hit Points">' +
			macroLink (getProperty ("TempHP"), "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
				"all", json.append ("", "TempHP", "Temporary Hit Points"), currentToken())
												+ '</span></td>
												</tr>
												<tr>
												<td align="center" class="subtext">
												<b>'+
			macroLink ("TEMPORARY HIT POINTS", "dnd5e_CharSheet_changeHitPoints@" + LIB_TOKEN,
				"all", "", currentToken())
												+'</b>
												</td>
												</tr>
											</table>
										</td>
									</tr>

									<tr>
										<td colspan="3">
											<table>
    <tr>
        <td width="50%">
            <table class="back-white mixed-outline" height="50px">
                <tr>

                    <td class="save-bonus">' + getProperty ("HitDice") + '</td>
                </tr>
                <tr>
                    <td align="center" class="subtext">
                        <b>
                            <span title="Edit Hit Dice">'+ macroLink ("HIT DICE",
                                "dnd5e_CharSheet_changeProperty@" + LIB_TOKEN, "", json.append ("",
                                "HitDice", "Hit Dice"), currentToken()) + '</span>
                        </b>
                    </td>
                </tr>
            </table>
        </td>

        <!-- DEATH SAVES -->
        <td>
            <table class="back-white mixed-outline" height="50px">
                <tr>
                    <td class="death-save-label">SUCCESSES</td>
                    <td width="55" align="center" class="save-proficient">
                    	<!-- this macro link parameters and cdata are derived on the current
                    			state of the death saves -->
						<table>
						    <tr>
						        <td>'+
		macroLink (dnd5e_CharSheet_formatDeathSave (1, 1), 
			"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN, 
			"", "['1', '1']", currentToken())
						        +'</td>
						        <td>'+
		macroLink (dnd5e_CharSheet_formatDeathSave (1, 2),
			"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN, 
			"", "['1', '2']", currentToken())
						        +'</td>
						        <td>'+
		macroLink (dnd5e_CharSheet_formatDeathSave (1, 3), 
			"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN, 
			"", "['1', '3']", currentToken())
						        +'</td>
						    </tr>
						</table>
                    </td>
                </tr>
                <tr>
                    <td class="death-save-label">FAILURES</td>
                    <td align="center" class="save-proficient">
                       <table>
						    <tr>
						        <td>'+
		macroLink (dnd5e_CharSheet_formatDeathSave (0, 1),
			"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN, 
			"", "['0', '1']", currentToken())
						        +'</td>
						        <td>'+
		macroLink (dnd5e_CharSheet_formatDeathSave (0, 2),
			"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN, 
			"", "['0', '2']", currentToken())
						        +'</td>
						        <td>'+
		macroLink (dnd5e_CharSheet_formatDeathSave (0, 3),
			"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN, 
			"", "['0', '3']", currentToken())
						        +'</td>
						    </tr>
						</table>
                    </td>
                </tr>
                <tr>
                    <!-- This link should bring up the Death Save macro -->
                    <td colspan="2" align="center" class="subtext">
                        <b><span title="Roll Death Saving Throw">' +
			macroLink ("DEATH SAVES", 
				"dnd5e_CharSheet_toggleDeathSaves@" + LIB_TOKEN,
				"all", "", currentToken())
                        + '</span></b>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
											<!-- End black table -->
										</td>
									</tr>
								</table><!-- end green table -->
							</td>
						</tr>
<!-- Weapons / Attacks -->
						<tr>
							<!-- next row of the blue table -->
							<td>
								<table class="mixed-outline">
									<tr>
										<td class="attack-unit">
											<!-- Attacks And spells -->
											<table>
												<!-- Header -->
												<tr>
												<td class="attack-label" align="left"><b>NAME</b></td>
												<td class="attack-label" align="center" width="55"><b>ATK BONUS</b></td>
												<td class="attack-label" align="right"><b>DAMAGE</b></td>
												</tr>
												<!-- the deeds -->
				' + dnd5e_CharSheet_getAttacksHTML () + '
											</table>
										</td>
									</tr>
									
									<tr>
										<td>
											<!-- Didn&apos;t use a spell caster for the template sheet, so this is a bit nebulous -->
											<!-- SPELLS -->
											<!-- SPELLCASTING CLASS -->
											<!-- ABILITY -->
											<!-- DC -->
											<table
												style="padding:0px; margin:0px border:3px solid green">
												<tr>
												<td class="spellcasting-dc"><b>DC:</b>
												<span title="Wisdom">' +
		macroLink ("TBD", "dnd5e_CharSheet_doesNothing@" + LIB_TOKEN,
				"", "", currentToken())
												+ '</span>
												</td>
												
												<td class="weapons-label">
												<span title="Launch Editor">' +
		macroLink ("ATTACKS", "dnd5e_CharSheet_launchEditor@" + LIB_TOKEN, 
			"all", "", currentToken())
												+ '</span>
												</td>

												<td class="spellcasting-atk"><b>ATK:</b>
												<span title="Wisdom">' +
		macroLink ("TBD", "dnd5e_CharSheet_doesNothing@" + LIB_TOKEN,
				"", "", currentToken())
												+ '</span>
												</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											<!-- wtf is this? -->
											<table width="100%"
												class="mixed-outline"
											><tr><td class="detail-label">Spell casting table goes here</tr></td></table>
										</td>
									</tr>
									<tr>
										<td align="center"
											class="subtext">
											<b><span title="Cast Spell">' +
		macroLink ("SPELLCASTING (WIP)", "dnd5e_CharSheet_spellCastingPanel@" + LIB_TOKEN,
				"all", "", currentToken())
											
											+ '</span>
												</b>
										</td>
									</tr>
								</table>
							</td>
						</tr>
<tr>
    <!-- Equipment box -->
    <td>
']
[h: html = html + dnd5e_CharSheet_getEquipementHTML()]
[h: html = html + '
    </td>
</tr>

</table>
']
[r: html]