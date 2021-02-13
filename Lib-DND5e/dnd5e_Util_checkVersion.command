[h: version = arg(0)]
[h, if (version == ""): version = "0.0"; ""]
[h: minimumRequiredVersion = arg(1)]
[h, if (argCount() > 2): 
			maximumRequiredVersion = arg(2);
			maximumRequiredVersion = -1]
[h: log.debug (getMacroName() + ": version = " + version + "; minimumRequiredVersion = " + minimumRequiredVersion + "; maximumRequiredVersion = " + maximumRequiredVersion)]
[h: periodIndex = indexOf (version, ".")]
[h: majorVersion = number (substring (version, 0, periodIndex))]
[h: minorVersion = number (substring (version, periodIndex + 1))]

[h: periodIndex = indexOf (minimumRequiredVersion, ".")]
[h: minMajorVersion = number (substring (minimumRequiredVersion, 0, periodIndex))]
[h: minMinorVersion = number (substring (minimumRequiredVersion, periodIndex + 1))]
[h, if (majorVersion > minMajorVersion): valid = 1; valid = 0]
[h, if (majorVersion == minMajorVersion && minorVersion >= minMinorVersion): valid = 1; ""]
[h: log.debug (getMacroName() + ": valid after minimum check = " + valid)]
[h, if (maximumRequiredVersion >=0), code: {
	[periodIndex = indexOf (maximumRequiredVersion, ".")]
	[maxMajorVersion = number (substring (maximumRequiredVersion, 0, periodIndex))]
	[maxMinorVersion = number (substring (maximumRequiredVersion, periodIndex + 1))]
	[if (majorVersion > maxMajorVersion): valid = 0; ""]
	[if (majorVersion == maxMajorVersion && minorVersion > maxMinorVersion): valid = 0; ""]
	[log.debug (getMacroName() + ": valid after maximum check = " + valid)]
}]
	
[h: macro.return = valid]