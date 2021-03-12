[h: metersRaw = l4m.getMeters()]
[h: metersCompiled = "{}"]
<!-- first pass - Collect all meters for their respective macros -->
[h, foreach (meterKey, json.fields (metersRaw)), code: {
	[meterRaw = json.get (metersRaw, meterKey)]
	[if (encode (meterRaw) != ""), code: {
		[meterData = json.get (meterRaw, "meters")]
		[macroName = json.get (meterRaw, "macroName")]
		[meterCompiled = json.get (metersCompiled, macroName)]
		<!-- cheating -->
		[meterCompiled = json.set (meterCompiled, "init", "true")]
		[meters = json.get (meterCompiled, "meters")]
		[if (json.isEmpty (meters)): meters = meterData; 
								meters = json.merge (meters, meterData)]
		[meterCompiled = json.set (meterCompiled, "meters", meters)]
		[metersCompiled = json.set (metersCompiled, macroName, meterCompiled)]
	}; {}]
}]
[h: csv = "macro name, count, min, max, average, total"]
[h, foreach (macroName, json.fields (metersCompiled)), code: {
	[meterCompiled = json.get (metersCompiled, macroName)]
	[meters = json.get (meterCompiled, "meters")]
	[if (json.type (meters) != "ARRAY"): meters = "[0]"; ""]
	[total = math.arraySum (meters)]
	[meterCount = json.length (meters)]
	[meterMin = math.arrayMin (meters)]
	[meterMax = math.arrayMax (meters)]
	[meterAvg = math.arrayMean (meters)]
	[meterCompiled = json.set (meterCompiled,
			"total", total,
			"count", meterCount,
			"min", meterMin,
			"max", meterMax,
			"avg", meterAvg)]
	[metersCompiled = json.set (metersCompiled, macroName, meterCompiled)]
	[csv = csv + decode ("%0A") + macroName + "," +
			meterCount + "," +
			meterMin + "," +
			meterMax + "," +
			meterAvg + "," +
			total]
}]
[h: log.debug (getMacroName() + ": returned = " + json.indent (metersCompiled))]
[h: report = decode ("%0A") + csv]
[dialog("Performance Meters", "title=Performance Meters; input=1; width=580; height=550; closebutton=0"): {
	<html><body>

			<pre>[r: report]</pre>

		</body>
	</html>
}]

[h: log.warn (report)]
[h: macro.return = csv]
