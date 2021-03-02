[h: objects = arg (0)]
[h: objClass = arg (1)]

[h: DATA_MACRO = "Data_Macro_Patched_Objects_Registry"]
[h: registry = dndb_Util_getRegistry (DATA_MACRO)]
[h: classPatches = json.get (registry, objClass)]
[h, if (encode (classPatches) == ""): classPatches = "[]"]
[h, foreach (patch, classPatches), code: {
	[json.toVars (patch)] <!-- defines 'field', 'value', & 'patch' -->
	[searchString = ".[?(@." + field + " == '" + value + "')]"]
	[log.debug (getMacroName() + ": searchString = " + searchString)]
	[matchedPaths = json.path.read (objects, 
			searchString, "ALWAYS_RETURN_LIST, AS_PATH_LIST, SUPPRESS_EXCEPTIONS")]
	[log.debug (getMacroName() + ": matchedPaths = " + matchedPaths)]
	[foreach (path, matchedPaths), code: {
		[originalObj = json.path.read (objects, path)]
		[log.debug (getMacroName() + ": path = " + path + "; originalObj = " + originalObj)]
		[patchedObj = json.merge (originalObj, patch)]
		[log.debug (getMacroName() + ": patch = " + patchedObj)]
		[fields = json.fields (patchedObj, "json")]
		<!-- json.path.put, because its stupid -->
		[foreach (field, fields): objects = json.path.put (
				objects, path, field, json.get (patchedObj, field))]
	}]
}]
[h: macro.return = objects]