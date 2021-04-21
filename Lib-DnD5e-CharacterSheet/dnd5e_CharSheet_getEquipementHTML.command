[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: html = '
        <table style="border-style: solid double solid double; border-width:2px 3px 2px 3px;">
            <tr>
                <td>
                    <!-- CURRENCY -->']
                    
[h: coinObj = getProperty (PROP_CURRENCY)]
[h, if (json.type (coinObj) != "OBJECT"): coinObj = "{}"]
[h: gpObj = json.get (coinObj, "GP")]
[h: totalCoinWeight = 0]
[h, if (json.type (gpObj) != "OBJECT"), code: { 
	[goldCoins = 0]
}; {
	[goldCoins = json.get (gpObj, "quantity")]
	[if (!isNumber (goldCoins)): goldCoins = 0]
	[coinWeight = json.get (gpObj, "weight")]
	[if (!isNumber (coinWeight)): coinWeight = 0.02]
	[totalCoinWeight = totalCoinWeight + (coinWeight * goldCoins)]
}]

[h: epObj = json.get (coinObj, "EP")]
[h, if (json.type (epObj) != "OBJECT"), code: { 
	[electrumCoins = 0]
}; {
	[electrumCoins = json.get (epObj, "quantity")]
	[if (!isNumber (electrumCoins)): electrumCoins = 0]
	[coinWeight = json.get (epObj, "weight")]
	[if (!isNumber (coinWeight)): coinWeight = 0.02]
	[totalCoinWeight = totalCoinWeight + (coinWeight * electrumCoins)]
}]

[h: spObj = json.get (coinObj, "SP")]
[h, if (json.type (spObj) != "OBJECT"), code: { 
	[silverCoins = 0]
}; {
	[silverCoins = json.get (spObj, "quantity")]
	[if (!isNumber (goldCoins)): silverCoins = 0]
	[coinWeight = json.get (spObj, "weight")]
	[if (!isNumber (coinWeight)): coinWeight = 0.02]
	[totalCoinWeight = totalCoinWeight + (coinWeight * silverCoins)]
}]

[h: cpObj = json.get (coinObj, "CP")]
[h, if (json.type (cpObj) != "OBJECT"), code: { 
	[copperCoins = 0]
}; {
	[copperCoins = json.get (cpObj, "quantity")]
	[if (!isNumber (copperCoins)): copperCoins = 0]
	[coinWeight = json.get (cpObj, "weight")]
	[if (!isNumber (coinWeight)): coinWeight = 0.02]
	[totalCoinWeight = totalCoinWeight + (coinWeight * copperCoins)]
}]

[h: ppObj = json.get (coinObj, "PP")]
[h, if (json.type (ppObj) != "OBJECT"), code: { 
	[platinumCoins = 0]
}; {
	[platinumCoins = json.get (gpObj, "quantity")]
	[if (!isNumber (platinumCoins)): platinumCoins = 0]
	[coinWeight = json.get (gpObj, "weight")]
	[if (!isNumber (coinWeight)): coinWeight = 0.02]
	[totalCoinWeight = totalCoinWeight + (coinWeight * platinumCoins)]
}]

[h: html = html + '
                    <table>
                        <tr>
                            <td class="currency-value mixed-outline">' + platinumCoins + '</td>
                            <td class="currency-value mixed-outline">' + electrumCoins + '</td>
                            <td class="currency-value mixed-outline">' + goldCoins + '</td>
                            <td class="currency-value mixed-outline">' + silverCoins + '</td>
                            <td class="currency-value mixed-outline">' + copperCoins + '</td>
                            <td class="currency-value " rowspan="2" valign="middle">
                                <span title="Edit Currency">' +
		macroLink ("Coins", "dnd5e_CharSheet_changeCoins@" + LIB_TOKEN, 
				"", "", currentToken())
                                + '</span>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" class="single-outline subtext">' +
		macroLink ("PP", "dnd5e_CharSheet_changeCoins@" + LIB_TOKEN,
				"", "PP", currentToken())
                            + '</td>
                            <td align="center" class="single-outline subtext">' +
		macroLink ("EP", "dnd5e_CharSheet_changeCoins@" + LIB_TOKEN,
				"", "EP", currentToken())
                            + '</td>
                            <td align="center" class="single-outline subtext">' +
		macroLink ("GP", "dnd5e_CharSheet_changeCoins@" + LIB_TOKEN,
				"", "GP", currentToken())
                            + '</td>
                            <td align="center" class="single-outline subtext">' +
		macroLink ("SP", "dnd5e_CharSheet_changeCoins@" + LIB_TOKEN,
				"", "SP", currentToken())
                            + '</td>
                            <td align="center" class="single-outline subtext">' +
		macroLink ("CP", "dnd5e_CharSheet_changeCoins@" + LIB_TOKEN,
				"", "CP", currentToken())
                            + '</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <!-- EQUIPMENT -->
                    <table>
                        <tr>
                            <td width="18" class="standard-label">
                                    <b>CD.</b>
                            </td>
                            <td class="standard-label">
                                    <b>NAME</b>
                            </td>
                            <td width="25" class="standard-label">
                                    <b>#</b>
                            </td>
                            <td width="25" align="right" class="standard-label">
                                    <b>lb.</b>
                            </td>
                        </tr>']

[h: equipmentObject = getProperty (PROP_EQUIPMENT)]
[h: totalWeightCarried = totalCoinWeight]
[h, foreach (equipmentKey, equipmentObject), code: {
	[item = json.get (equipmentObject, equipmentKey)]
	[itemName = json.get (item, "name")]
	[itemCarried = json.get (item, "carried")]
	[if (!isNumber(itemCarried)): itemCarried = 0]
	[carriedSpan = if (itemCarried, "Stop carrying " + itemName, "Carry " + itemName)]
	[itemWeight = json.get (item, "weight")]
	[itemQuantity = json.get (item, "quantity")]
	[totalWeightCarried = totalWeightCarried + (itemWeight * itemQuantity * itemCarried)]
	[html = html + '
                        <tr>
                            <td class="standard-value"><span title="' + carriedSpan + '">' +
		macroLink (dnd5e_CharSheet_formatBoolean (itemCarried, 1), "dnd5e_CharSheet_toggleCarried@" + 
			LIB_TOKEN, "", equipmentKey, currentToken())
                            + '</span></td>
                            <td class="standard-value"><span title="Edit ' + itemName + '">' +
		macroLink (itemName, "dnd5e_CharSheet_changeEquipment@" + LIB_TOKEN,
			"", equipmentKey, currentToken())
                            + '</span></td>
                            <td class="standard-value">x '+ itemQuantity +'</td>
                            <td align="right" class="standard-value">'+ itemWeight +' lb.</td>
                        </tr>
	']
}]
[h: strScore = getProperty ("Strength")]

[h: encumberedMsg = "Unencumbered"]
[h: encumberedStatus = "Unencumbered"]
[h: encumberedLimit = strScore * 5]
[h, if (totalWeightCarried > (strScore * 5)), code: {
	[encumberedStatus = "<b>Encumbered</b>"]
	[encumberedMsg = "Speed drops by 10 feet."]
	[encumberedLimit = strScore * 10]
}]
[h, if (totalWeightCarried > (strScore * 10)), code: {
	[encumberedStatus = "<b>Heavily Encumbered</b>"]
	[encumberedMsg = "Speed drops by 20 feet, disadvantage on ability checks, attack rolls, and saving throws that use Strength, Dexterity, or Constitution."]
	[encumberedLimit = strScore * 15]
}]

                        <!-- New Item -->
[h: html = html + '
                        <tr>
                            <td class="standard-value"><span title="Add New Item">' +
		macroLink ("+", "dnd5e_CharSheet_changeEquipment@" + LIB_TOKEN, 
			"", "", currentToken())
                            + '</span></td>
                            <td class="standard-value">&nbsp;</td>
                            <td class="standard-value">&nbsp</td>
                            <td align="right" class="standard-value">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" class="equipment-encumbrance"><b>Total weight</b>: '+totalWeightCarried+'/'+encumberedLimit+' (<span
                        title="'+encumberedMsg+'"
                        >'+encumberedStatus+'</span>) </td>
            </tr>
            <tr>
                <td align="center" class="subtext">
                    <b><span title="Add Equipment">' +
		macroLink ("EQUIPMENT", "dnd5e_CharSheet_changeEquipment@" + LIB_TOKEN,
			"", "", currentToken())
                    	+ '</span>
                    </b>
                </td>
            </tr>
        </table>']
[h: macro.return = html]