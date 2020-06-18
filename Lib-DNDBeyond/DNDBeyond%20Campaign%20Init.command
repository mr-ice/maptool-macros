
[h: setProperty ("libversion", "0.15")]

<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dndb_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]

<pre>[r: json.indent (getInfo ("client"), 3)]</pre>