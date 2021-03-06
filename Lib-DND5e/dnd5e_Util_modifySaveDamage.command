[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: totalDamage = arg(0)]
[h: startingTotalDamage = totalDamage]
[h: saveResult = lower(arg(1))]
[h, switch(saveResult), code:
	case "half": {
		[h: totalDamage = floor(totalDamage / 2)]
		[h: saveEffect = "Save for Half"]
	};
	case "none": {
		[h: totalDamage = 0]
		[h: saveEffect = "Save for None"]
	};
	case "failed": {
		[h: saveEffect = "Save Failed"]
	};
	default: {
		[h, if (isNumber(saveResult)), code: {
			[h: totalDamage = floor(totalDamage * saveResult)]
			[h: saveEffect = "Save for " + round(saveResult * 100) + "%"]
		}; {
			[h: saveEffect = "Save for unknown effect: " + saveResult]
		}]
	}
]
[h: macro.return = json.set("{}", "damage", totalDamage, "saveText", saveEffect)]