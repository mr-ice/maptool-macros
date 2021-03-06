[h: itemObject = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: log.debug (CATEGORY + "## itemObject = " + itemObject)]

[h, if (json.type (itemObject) != "OBJECT"): itemObject = "{}"]
[h: log.debug (CATEGORY + "## itemObject = " + itemObject)]

[h: inputStr = ""]
[h: nameStr = "eqName | " + json.get (itemObject, "name") + " | Equipment Name | TEXT | width=12"]
[h: quantStr = "eqQuantity | " + json.get (itemObject, "quantity")  + " | Quantity | TEXT | width=4"]
[h: valueStr = "eqValue | " + json.get (itemObject, "value") + " | Purchase Price | TEXT | width=4"]
[h: weightStr = "eqWeight | " + json.get (itemObject, "weight") + " | Weight | TEXT | width=4"]
[h: containerStr = "eqContainer | " + json.get (itemObject, "contianer") + " | Container | TEXT | width=8"]
[h: descriptionStr = "eqDescription | " + json.get (itemObject, "description") + " | Description | TEXT | width=32"]
[h: typeStr = "eqType | " + json.get (itemObject, "type") + " | Type | TEXT | width=8"]
[h: carriedStr = "eqCarried | " + json.get (itemObject, "carried") + " | Carried | CHECK"]
[h: attunedStr = "eqAttuned | " + json.get (itemObject, "attuned") + " | Attuned | CHECK"]
[h: deleteStr = "eqDelete | | Delete Item? | CHECK"]

[h: inputStr = listAppend (inputStr, nameStr, "##")]
[h: inputStr = listAppend (inputStr, quantStr, "##")]
[h: inputStr = listAppend (inputStr, valueStr, "##")]
[h: inputStr = listAppend (inputStr, weightStr, "##")]
[h: inputStr = listAppend (inputStr, descriptionStr, "##")]
[h: inputStr = listAppend (inputStr, carriedStr, "##")]
[h: inputStr = listAppend (inputStr, "junk |____________________________________________________________||label|span=true", "##")]
[h: inputStr = listAppend (inputStr, deleteStr, "##")]

[h: log.trace (CATEGORY + "## inputStr = " + inputStr)]
[h: macro.return = inputStr]