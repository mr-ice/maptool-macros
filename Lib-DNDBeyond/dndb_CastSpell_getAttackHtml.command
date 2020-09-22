[h: spell = arg (0)]
[h: html = ""]
[h, if (json.get (spell, "requiresAttackRoll") == "true"), code: {
	[advLabel = dnd5e_Macro_getModLabel ("advantage")]
	[disadvLabel = dnd5e_Macro_getModLabel ("disadvantage")]
	[bothLabel = dnd5e_Macro_getModLabel ("both")]
	[html = '
   <div class="grid-footer">Advantage / Disadvantage</div>
   <div class="grid-item1">
      <label>' + advLabel + '<input id="castSpell-advantage" name="castSpell-advantage" class="big-checkbox" type="checkbox" /></label>
   </div>
   <div class="grid-item2">
      <label>' + disadvLabel + '<input id="castSpell-disadvatage" name="castSpell-disadvatage" class="big-checkbox" type="checkbox" /></label>
   </div>
   <div class="grid-item3">
      <label>' + bothLabel + '<input id="castSpell-both" name="castSpell-both" class="big-checkbox" type="checkbox" /></label>
   </div>
'
   ]
}]
[h: macro.return = html]