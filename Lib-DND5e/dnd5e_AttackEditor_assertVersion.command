[h, if (argCount() > 0): doAssert = arg(0); doAssert = 1]
[h: dnd5e_AE2_getConstants()]

[h: tokenVersion = getProperty (AE_VERSION_PROPERTY)]
[h: versioned = dnd5e_Util_checkVersion (tokenVersion, AE_CURRENT_VERSION)]
[h, if (!versioned), code: {
	[msg = 	"<b><font color='red'>Token " + getName() + " Attack Editor attacks must be updated.</font></b><br> Token version " +
		tokenVersion + " must be updated with Attack Editor version " + AE_CURRENT_VERSION)]
	[if (doAssert): assert (0, msg); broadcast (msg, "self")]
}]
[h: macro.return = versioned]