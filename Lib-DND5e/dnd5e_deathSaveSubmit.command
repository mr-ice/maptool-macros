[h: log.info("dnd5e_deathSaveSubmit:" + json.indent(macro.args, 2))]
[h: id = json.get(macro.args, "id")]
[h: dsPass = json.contains(macro.args, "pass-1") 
			+ json.contains(macro.args, "pass-2") 
			+ json.contains(macro.args, "pass-3")]
[h: dsFail = json.contains(macro.args, "fail-1") 
			+ json.contains(macro.args, "fail-2") 
			+ json.contains(macro.args, "fail-3")]
[h: bonus = json.get(macro.args, "bonus")]
[h, if (!isNumber(bonus)): bonus = 0; '']
[h: roll = json.get(macro.args, "advantage")]
[h, switch(json.get(macro.args, "myForm_btn")), code:
	case "Roll": {
		[h, if (bonus != 0): roll = roll + if(bonus > 0, " + ", " - ") + replace(bonus, "-", "");""]
		[h: log.info("roll = " + roll + "=" + eval(roll))]
		[h: result = eval(roll)]
		[h, if (result >= 10), code: {
			[h: dsPass = dsPass + 1]
			[h: textValue = strformat("PASSED(%{result})")]
		}; {
			[h: dsFail = dsFail + 1]
			[h: textValue = strformat("FAILED(%{result})")]
		}]
	};
	case "Set": {
		[h: textValue = strformat("SET %{dsPass} Pass/%{dsFail} Fail")]
	};
	default: {
		[h: abort(0)]
	}
]
<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "current", 0, "temporary", getProperty("TempHP", id), 
	"maximum", getProperty("MaxHP", id), "dsPass", dsPass, "dsFail", dsFail, 
	"exhaustion6", getState("Exhaustion 6", id), "text-type", "deathSave", "text-value", textValue)]
[h: dnd5e_applyHealth(params)]
[h: abort(0)] <!-- No output -->