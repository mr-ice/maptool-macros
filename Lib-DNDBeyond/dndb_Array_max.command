[h: arry = arg (0)]
[h: log.debug ("dndb_Array_max: arry = " + arry)]
[h, if (json.type (arry) != "ARRAY"), code: {
	[h: log.debug ("Not an array")]
	[h: return (0, arry)]
}]
[if (json.length (arry) == 0), code: {
	[h: log.debug ("Nothing in the array")]
	[h: return (0, "[]")]
}]
[h: sorted = json.sort (arry, "descending")]
[h: maxValue = json.get (sorted, 0)]
[h: macro.return = maxValue]
[h: return (0, maxValue)]