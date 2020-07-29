[h: searchTerm = arg (0)]
[h: encoded = encode (searchTerm)]
[h: log.debug (getMacroName() + ": encoded = " + encoded)]
[h: macro.return = o5e_Open5e_get ("monsters?search=" + encoded)]
