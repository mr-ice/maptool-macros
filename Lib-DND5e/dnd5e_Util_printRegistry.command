[h: registry = arg(0)]
[h: registryName = arg(1)]
[dialog (registryName): {
		<pre>[r: replace (json.indent (registry), "<", "&lt;")]</pre>
}]