[h: useables = getProperty("ggdd_useables")]
<!-- always return a JSON object 0-->
[h, if (json.isEmpty(useables)):
	useables = "{}"]
[h: macro.return = useables]