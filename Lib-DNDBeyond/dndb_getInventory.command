[h: log.debug ("Entering getInventory")]

[h: toon = arg(0)]
[h: filterType = arg(1)]
[h, if (json.length (macro.args) > 2): itemName = arg(2); itemName = "_all"]

[h: log.debug (json.get (toon, "name"))]
[h: log.debug (filterType)]

[h: inventoryArry = json.path.read (toon, "data.inventory[*].[?(@.definition.filterType == '" + filterType + "')]")]
[h: selectedItem = json.path.read (inventoryArry, ".[?(@.name == '" + itemName + "')]")]
[h, if (json.length (selectedItem) > 0): 
		selectedItem = json.get (selectedItem, 0);
		selectedItem = "{}"]
[h: log.debug ("selectedItem: " + json.indent (selectedItem))]
[h, if (itemName == "_all"): macro.return = inventoryArry; macro.return = selectedItem]