[h: registry = dnd5e_CharSheet_UDF_getRegistry()]
[h: REG_NAME = "UDF Registry"]
[h: dnd5e_Util_printRegistry (registry, REG_NAME)]
[h: crudInput = 
	" action | Create / Modify Key, Delete Key | " + 
	" Action | List "]
[h: abort (input (crudInput))]
[h, switch (action):
	case 0: registry = dnd5e_Macro_UDF_modifyKey (registry);
	case 1: registry = dnd5e_Macro_UDF_deleteKey (registry);
	case 2: "";
]
[h: dnd5e_CharSheet_UDF_setRegistry (registry)]
[h: dnd5e_Util_printRegistry (registry, REG_NAME)]