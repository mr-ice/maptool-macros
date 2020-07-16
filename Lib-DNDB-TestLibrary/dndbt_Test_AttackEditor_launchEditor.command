[h, macro ("Attack Editor@Lib:DnD5e"): ""]
[h: results = "{}"]
[h, if (isDialogVisible ("Attack Editor")), code: {
	<!-- I see you -->
	[closeDialog ("Attack Editor")]
	[results = json.set (results, "dndbt_Test_AttackEditor_launchEditor", "Passed")]
}; {
	[results = json.set (results, "dndbt_Test_AttackEditor_launchEditor", "Failed: Attack Editor was not launched")]
}]
[h: log.info ("dndbt_Test_AttackEditor_launchEditor: " + results)]
[h: macro.return = results]