<!-- get toon and maybe an item name -->
[h: toon = arg(0)]
[h, if (json.length (macro.args) > 1): 
				results = dndb_getInventory (toon, "Other Gear", arg(1)); 
				results = dndb_getInventory (toon, "Other Gear")]
[h: macro.return = results]