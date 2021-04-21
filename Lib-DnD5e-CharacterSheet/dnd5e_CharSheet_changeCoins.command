[h: coinType = arg (0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: coinObj = getProperty (PROP_CURRENCY)]
<!-- merge over the template to ensure empy values arent -->
[h, if (json.type (coinObj) != "OBJECT"):
	coinObj = dnd5e_CharSheet_Util_getCoinTemplate ();
	coinObj = json.merge (dnd5e_CharSheet_Util_getCoinTemplate (), coinObj)]
[h: log.debug (CATEGORY + "## coinObj = " + coinObj)]
[h, if (coinType == ""):
	coinTypes = json.append ("", "PP", "EP", "GP", "SP", "CP");
	coinTypes = json.append ("", coinType)]
[h: log.debug (CATEGORY + "## coinTypes: " + coinTypes)]
[h: inputStr = "junk | Coin totals | | label | span=true"]
[h, foreach (coinType, coinTypes), code: {
	[typeObj = json.get (coinObj, coinType)]
	[log.debug (CATEGORY + "## typeObj = " + typeObj)]
	[subStr = coinType + "|" + json.get (typeObj, "quantity") + " | " + json.get (typeObj, "name") + " coins|TEXT|width=4"]
	[inputStr = listAppend (inputStr, subStr, "##")]
}]

[h: abort (input (inputStr))]

[h, foreach (coinType, coinTypes), code: {
	[quantity = eval (coinType)]
	[typeObj = json.get (coinObj, coinType)]
	[typeObj = json.set (typeObj, "quantity", quantity)]
	[coinObj = json.set (coinObj, coinType, typeObj)]
}]
[h: setProperty (PROP_CURRENCY, coinObj)]
[h: dnd5e_CharSheet_refreshPanel ()]