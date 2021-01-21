[h: requiredMinVersion = arg (0)]
[h, if (argCount() > 1): requiredMaxVersion = arg (1); requiredMaxVersion = -1]
[h, if (argCount() > 2): libTokenName = arg (2); libTokenName = getMacroLocation()]

[h: libTokenVersion = getLibProperty ("libversion", libTokenName)]
[h, macro ("dnd5e_Util_checkVersion@this"): json.append ("", libTokenVersion, requiredMinVersion, requiredMaxVersion)]
[h: isValid = macro.return]
[h, if (!isValid), code: {
	[msg = "<font color='red'><b>Missing required token library:</b></font> " + libTokenName + " " + requiredMinVersion]
	[if (requiredMaxVersion != -1): msg = msg + " - " + requiredMaxVersion; ""]
	[msg = msg + "<br>Current version: " + libTokenVersion]
	[broadcast (msg)]
	[abort (0)]
}; {}]