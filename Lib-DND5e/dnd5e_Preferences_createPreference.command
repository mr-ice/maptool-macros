[h: registry = arg (0)]

<!-- create -->
[h: createInputString = dnd5e_Util_getMetaInputString ()]
[h: abort( input(createInputString))]
[h, if (inputOpts != "0"): prefOpts = inputOpts; prefOpts = ""]
[h: regObj = json.set ("", "key", inputVar,
						"value", inputValue,
						"prompt", inputPrompt,
						"type", inputType,
						"opts", prefOpts)]
[h: registry = json.set (registry, inputVar, regObj)]
[h: macro.return = registry]