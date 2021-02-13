[h: DATA_MACRO = "Data_Macro_UDF_Registry"]
<!-- This macro executes during onCampaignLoad. No calling UDFs -->
[h, macro ("dnd5e_Util_getRegistry@this"): DATA_MACRO]
<!-- is this the right way to do it? looks silly -->
[h: macro.return = macro.return]