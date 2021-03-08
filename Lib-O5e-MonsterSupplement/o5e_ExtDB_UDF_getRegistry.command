[h: o5e_ExtDB_Constants(getMacroName())]
[h: DATA_MACRO = "Data_Macro_UDF_Registry"]
<!-- This macro executes during onCampaignLoad. No calling UDFs -->
[h: args = json.append ("", DATA_MACRO, LIB_TOKEN_NAME)]
[h, macro ("dnd5e_Util_getRegistry@Lib:DnD5e"): args]
<!-- is this the right way to do it? looks silly -->
[h: macro.return = macro.return]