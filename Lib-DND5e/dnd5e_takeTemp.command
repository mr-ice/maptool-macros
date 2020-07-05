<!-- Read the temp hp --> 
[h: abort(input("value|0|Enter Damage:|TEXT|WIDTH=4"))]
[h: params = json.set("{}", "id", currentToken(), "temporary", getProperty("TempHP"), "updateTemp", value)]
[h, macro("dnd5e_updateTemp@Lib:DnD5e"): params]