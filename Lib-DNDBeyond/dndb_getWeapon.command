<!-- get toon and maybe a weapon name -->
[h: toon = arg(0)]
[h, if (json.length (macro.args) > 1):
				weapons = dndb_getInventory (toon, "Weapon", arg(1)); 
				weapons = dndb_getInventory (toon, "Weapon")]

[h: weapons = dndb_convertWeapons (toon, weapons)]

[h: macro.return = weapons]