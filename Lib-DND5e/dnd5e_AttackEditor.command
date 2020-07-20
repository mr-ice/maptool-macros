[h: log.debug ("arrrgs = " + json.indent (macro.args))]
[h, if (json.length (macro.args) > 1): attackObj = arg (1); attackObj = "{}"]
[h, if (json.isEmpty (attackObj)), code: {
	[newAttack = dnd5e_RollExpression_Attack()]
	[newDamage = dnd5e_RollExpression_Damage()]
	[attackObj = json.set ("", "New Attack", json.append ("", newAttack, newDamage))]
}]

<!-- This editor knows nothing of the attackJSON property. It relies on a caller to manage the results -->
[h: callbackLink = arg (0)]
[h: processorLink = macroLinkText ("dnd5e_AttackEditor_processor@this", "all", "", currentToken())]
[h: attackFields = json.fromList (json.fields (attackObj))]
[h: log.debug ("attackFields: " + attackFields)]
[h, if (json.length (macro.args) > 2): firstSelected = arg (2); firstSelected = ""]
[h, if (firstSelected == ""): firstSelected = json.get (attackFields, 0); ""]
[h: log.debug ("firstSelected: " + firstSelected)]

[dialog5 ("Attack Editor", "title=Attack Editor; input=0; width=580; height=550; closebutton=0"): {
<html>
    <head>
      <link rel="stylesheet" type="text/css" href="dnd5e_Editor_CSS@Lib:DnD5e"></link>
    </head>
    <script>
[r:"
function openAttack(evt, attackName) {
  var i, tabcontent, tablinks;

  tabcontent = document.getElementsByClassName('tabcontent');
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = 'none';
  }

  tablinks = document.getElementsByClassName('tablinks');
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(' active', '');
  }


  document.getElementById(attackName).style.display = 'block';
  evt.currentTarget.className += ' active';
  document.getElementById('activeAttack').value = attackName;
}

"]
    </script>
    <body>

<!-- Build from attackJSON keys, excluding _lastSelected -->
    
<div class="tab">
	[r, foreach (field, attackFields, ""), code: {
		[h, if (field == firstSelected): active = "active"; active = ""]
        <button class="tablinks [r: active]" onclick="openAttack(event, '[r: field]')">[r: field]</button>
	}]
</div>


<!-- use a macro chain to build the attack div. We calll buildAttack and pass the attack array. it delegates
	to getAttackHtml, getDamageHtml, getExtraDamageHtml -->
<form action="[r:processorLink]" method="json">
	<input name="attackFields" value="[r:json.toList (attackFields)]" hidden="true" />
	<input name="callbackMacroLink" value="[r: callbackLink]" hidden="true"/>
	<input id="activeAttack" name="activeAttack" value="[r: firstSelected]" hidden="true"/>
[r, foreach (field, attackFields, ""), code: {
<!-- Tab content -->
<div id="[r: field]" class="tabcontent" [r, if (field == firstSelected): 'style=display:block'; '']>

	[h: attackExpressions = json.get (attackObj, field)]
	[r: dnd5e_Editor_buildAttackHTML (attackExpressions, field)]

<div class="roll-container">
  <input name="addAttack" class="button" value="Add Attack" type="submit"/>
  <input name="duplicateAttack" class="button" value="Duplicate Attack" type="submit"/>
</div>

[r: dnd5e_AttackEditor_getMacroHtml ()]

</div>
}]
<div>
  <label>Normal<input type="radio" name="advDisadvantage" value="Normal" checked="true"></label>
  <label>Advantage<input type="radio" name="advDisadvantage" value="Advantage"></label>
  <label>Disadvantage<input type="radio" name="advDisadvantage" value="Disadvantage"></label>
</div>
<input name="actionButton" class="button" value="Save & Attack" type="submit" />
<input name="actionButton" class="button" value="Save Only" type="submit" />
<input name="actionButton" class="button" value="Cancel" type="submit" />

      </form>
    </body>
</html>
}]