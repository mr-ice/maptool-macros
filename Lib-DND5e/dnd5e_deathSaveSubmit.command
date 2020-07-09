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
[r, switch(json.get(macro.args, "myForm_btn")), code:
	case "Roll": {
		[h, if (bonus != 0): roll = roll + if(bonus > 0, " + ", " - ") + replace(bonus, "-", "");""]
		[h: log.info("roll = " + roll + "=" + eval(roll))]
		[h: result = eval(roll)]
		[r: "Death Save: (" + roll + ") = " + result + "<br/>"]
		[r, if (result >= 10), code: {
			[h: dsPass = dsPass + 1]
			[r: "Death Save Passed!" + if(dsPass >= 3, " You are now stable.", "")]
		}; {
			[h: dsFail = dsFail + 1]
			[r: "Death Save Failed!" + if(dsFail >= 3, " You are dead.", "")]
		}]
	};
	case "Set": {
		[r: "Setting death saves to " + dsPass + if(dsPass == 1, " pass", " passes") + " and "
			+ dsFail + if(dsFail == 1, " failure", " failures") + "."]
		[r, if (dsFail >= 3): "You are dead."; ""]
		[r, if (dsFail < 3 && dsPass >= 3): "You are stable."; ""]			
	};
	default: {
	}
]
<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "current", 0, "temporary", getProperty("TempHP", id), 
	"maximum", getProperty("TempHP", id), "dsPass", dsPass, "dsFail", dsFail, 
	"exhaustion6", getState("Exhaustion 6", id))]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]