[h: registry = arg(0)]
[h: log.debug(getMacroName() + " registry=" + json.indent(registry))]
[h: registryName = arg(1)]
[h: fields = json.sort(json.fields(registry, "json"))]
[h: log.debug(getMacroName() + " fields=" + json.indent(fields))]
[h: sortedRegistry = "{}"]
[h, foreach(field, fields, ""): sortedRegistry = json.set(sortedRegistry, field, json.get(registry, field))]
[h: log.debug(getMacroName() + " sortedRegistry=" + json.indent(sortedRegistry))]
[dialog (registryName): {
		<pre>[r: replace (json.indent (sortedRegistry), "<", "&lt;")]</pre>
}]