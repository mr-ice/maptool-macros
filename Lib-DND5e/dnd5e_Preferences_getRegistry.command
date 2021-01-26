<!-- I kept going back and forth trying to decide if the registry was better as a token property of
	the library token or as a data macro command. I landed on data macro as it allows for me to
	better persist changes to the registry in version control (git). It does make setting and
	retrieval more of a PITA, but thats what this macro is for. And thanks to the encapsulation,
	whenever we decide to change it up, only have to change it here -->
[h: DATA_MACRO = "Data_Preference_Registry"]

[h: macro.return = dnd5e_Util_getRegistry (DATA_MACRO)]
