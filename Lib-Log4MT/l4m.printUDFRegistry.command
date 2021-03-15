[h: proxyLib = arg (0)]
[h: wrapperCfgs = l4m.getWrapperConfig (proxyLib)]
[h: formattedWrapperCfgs = l4m.convertConfigToStrProp (wrapperCfgs)]
[dialog (proxyLib, "width=470; height=780;"): {
		<pre>[r: replace (json.indent (formattedWrapperCfgs), "<", "&lt;")]</pre>
}]