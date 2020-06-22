[h: basicToon = getProperty ("dndb_BasicToon")]
[h: log.error ("Previous: " + basicToon)]
[h: abort (input ("choice | edit,set,print | Action | List | value=string"))]
[h, if (choice == "copy"), code: {
	[h: input ("basicToon | " + basicToon + " | Copy BasicToon | Text | span=true")]
	[h: abort (0)]
}]
[h, if (choice == "set"), code: {
	[h: abort (input ("basicToon | " + basicToon + " | Set BasicToon | Text "))]
	[h: setProperty ("dndb_BasicToon", basicToon)]
	[h: log.error ("New: " + basicToon)]
	[h: abort (0)]
}]
[h: keys = json.fields (basicToon)]

[h, if (choice == "get"), code: {
	[h: abort (input ("field | " + keys + " | Field | List | value=string"))]
	[h: value = json.get (basicToon, field)]
	[h: log.error (field + ": " + json.indent (value))]
	[h: abort (0)]
}]

[h, if (choice == "print"), code: {
	[h: abort (input ("field | all," + keys + " | Field | List | value=string"))]
	[h, if (field == "all"): toPrint = basicToon; toPrint = json.get (basicToon, field)]
	[dialog ("Basic Toon: " + field): {
		<pre>[r: replace (json.indent(toPrint), "<", "&lt;")]</pre>
	}]
	[h: abort (0)]
}]

[h: abort (input ("field | " + keys + " | Field | List | value=string",
				"value | | Value | Text"))]
[h: basicToon = json.set (basicToon, field, value)]
[h: setProperty ("dndb_BasicToon", basicToon)]
[h: log.error ("Edited: " + basicToon)]