[h: log.debug ("dndbt_Test_AttackEditorProcessor_testRollBuild: args = " + macro.args)]
[h, if (json.length (macro.args) > 0), code: {
	[builtExpression = json.get (arg (0), "attackObj")]
	[report = "[]"]
	[macro ("data_AttackEditor_processorExpression_1@Lib:DNDB-TestLibrary"): ""]
	[knownExpression = macro.return]
	[reportObj = "{}"]
	[if (encode (builtExpression) != encode (knownExpression)), code: {
		[report = json.append (report, "Differences found in expressions")]
		[report = json.append (report, json.set ("", "Expected", knownExpression, "Constructed", builtExpression))]
		[reportObj = json.set (reportObj, getMacroName(), report)]
		<!-- Since this code block is asychronous from the test harness, alert the user somethings amiss -->
		[broadcast ("<font color='red'><b>" + getMacroName() + " has a test failure; See log</b></font>")]
	}; {
		[reportObj = json.set (reportObj, getMacroName(), "Passed")]
	}]
	[log.info (getMacroName() + ": " + reportObj)]
	[macro.return = reportObj]
}; {
	<!-- fresh execution. Get the test data and send it to the processor -->
	[macro ("data_AttackEditor_processorParams_1@Lib:DNDB-TestLibrary"): "dndbt_Test_AttackEditorProcessor_testRollBuild_1@Lib:DNDB-TestLibrary"]
	[dataPackage = macro.return]
	[h, macro ("dnd5e_AttackEditor_processor@Lib:DnD5e"): dataPackage]
}]
