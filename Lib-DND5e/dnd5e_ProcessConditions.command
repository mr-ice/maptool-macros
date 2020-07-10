[h, if(json.get(macro.args, "myForm_btn") == "Close"): abort(0); abort(1)]
[h: allStates = "Blinded,Charmed,Frightened,Deafened,Incapacitated,Poisoned,Invisible,Paralyzed,Grappled,Prone,Restrained,Stunned,Petrified,Unconscious"]
[h: plus = json.append("", "Incapacitated")]
[h: plusPlus = json.append("", "Incapacitated", "Prone")]
[h: multiStates = json.set("{}", "Paralyzed", plus, "Stunned", plus, "Petrified", plus, "Unconscious", plusPlus)]
[h, foreach(state, allStates), code: {
	[h: setState(state, json.contains(macro.args, state))]
	[h, if (json.contains(macro.args, state) && json.contains(multiStates, state)), code: {
		[h, foreach(extraState, json.get(multiStates, state)): setState(extraState, 1)]
	}; {}]
}]
