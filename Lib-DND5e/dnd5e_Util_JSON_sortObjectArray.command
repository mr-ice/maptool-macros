[h: unsortedArray = arg(0)]
[h: sortField = arg(1)]
[h: dnd5e_Constants (getMacroName())]
<!-- Make some assertions, first of all -->
[h, if (json.type (unsortedArray) != "ARRAY"): return (0, unsortedArray)]
[h: assert (sortField != "", "sortField cannot be empty")]
<!-- this is an array of objects; How do you sort an array of object? -->
<!-- get an array of the sort field values; sort that array -->
[h: keyValues = json.path.read (unsortedArray, "[*]." + sortField)]
<!-- Well deal with duplicates, just not here -->
[h: uniqueKeyValues = json.unique (keyValues)]
[h: sortedKeyValues = json.sort (uniqueKeyValues)]
[h: log.debug (CATEGORY + "keyValues = " + keyValues + "; sortedKeyValues = " + sortedKeyValues)]
<!-- rebuild the sorted array by path.reading the sort fields -->
[h: sortedArray = "[]"]
[h, foreach (value, sortedKeyValues), code: {
	[paths = json.path.read (unsortedArray, ".[?(@." + sortField + " == '" + value + "')]", "AS_PATH_LIST")]
	[log.debug (CATEGORY + "vaule = " + value + "; paths = " + paths)]
	[foreach (path, paths), code: {
		<!-- The root node $ symbol is unneccessary, yet path.read gives it to us... -->
		[log.trace (CATEGORY + "path = " + path)]
		[objValue = json.path.read (unsortedArray, path)]
		[log.trace (CATEGORY + "objValue = " + objValue)]
		[sortedArray = json.append (sortedArray, objValue)]
	}]
}]
[h: macro.return = sortedArray]