[h: equipmentKey = arg (0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: equipmentObject = getProperty (PROP_EQUIPMENT)]
[h, if (json.type (equipmentObject) != "OBJECT"): equipmentObject = "{}"]
[h, if (equipmentKey != ""):
	item = json.get (equipmentObject, equipmentKey);
	item = "{}"]
[h: inputStr = dnd5e_CharSheet_Util_getEquipmentInput (item)]
[h: abort (input (inputStr))]
[h, if (equipmentKey == ""): equipmentKey = eqName]
[h: item = json.set (item, "name", eqName, 
		"quantity", eqQuantity,
		"value", eqValue,
		"weight", eqWeight,
		"description", eqDescription,
		"carried", eqCarried)]
[h: log.debug (CATEGORY + "## new item: " + item)]
[h, if (eqDelete):
	equipmentObject = json.remove (equipmentObject, equipmentKey);
	equipmentObject = json.set (equipmentObject, equipmentKey, item)]
[h: setProperty (PROP_EQUIPMENT, equipmentObject)]
[h: dnd5e_CharSheet_refreshPanel ()]