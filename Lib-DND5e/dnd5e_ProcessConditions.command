[h, if(json.get(macro.args, "myForm_btn") == "Close"): abort(0); abort(1)]
[h: allStates = "Blinded,Charmed,Frightened,Deafened,Incapacitated,Poisoned,Invisible,Paralyzed,Grappled,Prone,Restrained,Stunned,Petrified,Unconscious"]
[h, foreach(state, allStates): setState(state, json.contains(macro.args, state))]
