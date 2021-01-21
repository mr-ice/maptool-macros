[h: basicToon = arg(0)]
[h: toonVersion = json.get (basicToon, "basicToonVersion")]
[h, if (toonVersion == ""): toonVersion = "0.0"; ""]
[h: minBasicToonVersion = getLibProperty ("dndb.basicToonVersion", "Lib:DnDBeyond")]
[h: toonValid = dnd5e_Util_checkVersion (toonVersion, minBasicToonVersion)]
[h, if (!toonValid), code: {
	[broadcast ("<b><font color='red'>Token " + getName() + " must be fully initialized.</font></b><br> BasicToon version " + toonVersion + " is incompatible with library version " + minBasicToonVersion)]
	[abort (0)]
}]