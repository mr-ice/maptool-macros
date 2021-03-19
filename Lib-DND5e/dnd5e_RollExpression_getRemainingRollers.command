[h: rollExpression = arg (0)]
[h: rolledRollers = json.get (rollExpression, "rolledRollers")]
[h, if (!json.type (rolledRollers == "ARRAY")): rolledRollers = "[]"]
[h: rollers = dnd5e_RollExpression_getDiceRollers (rollExpression)]
<!-- heres a question: will a roller ever be used twice? The reroll pattern is not to add the roller to the existing roller
     list and continue rolling. A re-roll is always a clone of the original re, rolling in a recursion call. Theres no
     other scenario I can think of where a roller is called more than once for any given RollExpression.

     Therefore, it should be safe to remove whatever is in rolledRollers from rollers. Whatever is left 
     are the remaining rollers -->
[h: log.debug (getMacroName() + "##rolledRollers = " + rolledRollers + "; rollers = " + rollers)]
[h: remainingRollers = json.removeAll (rollers, rolledRollers)]
[h: macro.return = remainingRollers]