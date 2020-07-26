
<!-- Get a title from the first expression-->
[h: title = json.get(arg(0), 0)]
<div>
  <span style='font: bold 14px;'>[r:dnd5e_RollExpression_getName(title)]</span>
  <div style='left-margin: 15px;'>

<!-- View each expression -->
[h: damageTotal = 0]
[h: lastDamage = 0]
[foreach(exp, arg(0), ""), code: {
	[h: log.debug("Working On" + json.indent(exp))]

	<!-- Generate the tool tip -->
	[h: total = dnd5e_RollExpression_getTotal(exp)]
	[h: tt = dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipRoll") + " = " 
			+ dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipDetail") + " = " + total]

	<!-- Handle top level expressions only by type -->
	[switch(dnd5e_RollExpression_getExpressionType(exp)), code:
	case "Attack": {

		<!-- Get all of the condition output -->
		[h: conditions = dnd5e_RollExpression_getTypedDescriptor(exp, "condition")] 
		[h: log.debug("conditions: " + json.indent(dnd5e_RollExpression_getTypedDescriptor(exp, "condition")))]		
		[r, if(!json.isEmpty(conditions)): json.toList(conditions, "<br>") + "<br>"]

		<!-- Attack roll ouput with tool tip, advantage, critical,  auto miss & lucky -->
		<span title='[r:tt]'><span style='font: bold 12px;' title='[r:tt]'>[r:total]</span> to hit
		[r: dnd5e_RollExpression_getTypedDescriptor(exp, "advantageable")]
		[h: critable = json.path.read(arg(0), ".typedDescriptors.critable", "ALWAYS_RETURN_LIST")]
		[r, if (!json.isEmpty(critable)): " <span style='color: red; font: bold italic 12px;' title='" 
			+ tt + "'>Critical</span>"; ""]
		[r, if (dnd5e_RollExpression_getRoll(exp) == 1): " <span style='color: red; font: bold italic 12px;' title='" 
			+ tt + "'>Automatic Miss</span>"; ""]
		[r: dnd5e_RollExpression_getTypedDescriptor(exp, "lucky")]
		</span><br>
	};
	case "Damage": {

		<!-- Regular damage with tool tip and damage types -->
		[h: damageTotal = damageTotal + total]
		[h: lastDamage = total]
		<span title='[r:tt]'><span style='font: bold 12px;' title='[r:tt]'>&nbsp;&nbsp;[r:total]</span>
		[r: json.toList(dnd5e_RollExpression_getDamageTypes(exp))] Damage
		</span><br>
	};
	case "Save Damage": {

		<!-- Damage on Save with tool tip, damage types & save information -->
		[h: damageTotal = damageTotal + total]
		[h: lastDamage = total]
		<span title='[r:tt]'><span style='font: bold 12px;' title='[r:tt]'>&nbsp;&nbsp;[r:total]</span>
		[r: json.toList(dnd5e_RollExpression_getDamageTypes(exp))] Damage
		[h: save = dnd5e_RollExpression_getTypedDescriptor(exp, "saveable")]
		<span title='[r:tt]' style='font: italic;'><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			[r:dnd5e_RollExpression_getTypedDescriptor(exp, "saveable")]
		</span><br>
	};
	default: {
	}]
	[h: log.debug("-----------------------------------------------------------------------")]
}]
[r, if(damageTotal != lastDamage): "<span style='font: bold 12px;'>" + damageTotal + "</span> Total damage"; ""]
  </div>
</div>