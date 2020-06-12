<!-- get toon and maybe a armor name -->
[h: toon = arg(0)]
[h, if (json.length (macro.args) > 1): 
				results = dndb_getInventory (toon, "Armor", arg(1)); 
				results = dndb_getInventory (toon, "Armor")]
[h: macro.return = results]