[h: id = currentToken()]
[h: dsPass = getProperty("DSPass")]
[h, if (!isNumber(dsPass)): dsPass = 0]
[h: dsFail = getProperty("DSFail")]
[h, if (!isNumber(dsFail)): dsFail = 0]
[h: current = getProperty("HP")]
[h, if (!isNumber(current)): current = 0]
[h: isStable = getState("Stable"))]
[h: isDead = getState("Dead")]
[h: log.info("dnd5e_deathSaves: id=" + id + " name=" + getName(id) + " dsPass=" + dsPass + " dsFail=" + dsFail)]
[h: processorLink = macroLinkText("dnd5e_deathSaveSubmit@Lib:DnD5e", "all", "", id)]
[dialog5("Death Saves", "title=Make a Death Save; input=1; width=250; height=380"): {
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="dnd5e_deathSavesCSS@Lib:DnD5e" />
    <style>
      [r: "input[type='checkbox']:checked.pass {  background-image: url("][r: getStateImage("Stable", 30)][r:");}"]
      [r: "input[type='checkbox']:checked.fail {  background-image: url("][r: getStateImage("Dying", 30)][r:");}"]
    </style>
  </head>
  <body>
    <form action="[r:processorLink]" method="json">
      <input type="hidden" name="id" value=[r: id]>
      <div style="width: 100%; text-align: center">
        <div class="title">[r:getName(id)] Death Save</div>
        [r, if (!isPC(id)): '<div class="radio">&diams; Only PCs save</div>'; ""]
        [r, if (current > 0): '<div class="radio">&diams; Has ' + current + ' HP</div>'; ""]
        [r, if (isStable || dsPass >= 3): '<div class="radio">&diams; Already Stable</div>'; ""]
        [r, if (isDead || dsFail >= 3): '<div class="radio">&diams; Already Dead</div>'; ""]
        <div class="radio">
          <label for="bonus">Modifier:</label>
          <input style="margin-left: 5px" type="text" id="bonus" name="bonus" size=2 value=0>
        </div>
        <div class="radio">
          <input type="radio" id="none" name="advantage" value="1d20" checked>
          <label for="none">None</label>
        </div>
        <div class="radio">
          <input type="radio" id="advantage" name="advantage" value="2d20k1">
          <label for="advantage">Advantage</label>
        </div>
        <div class="radio">
          <input type="radio" id="disadvantage" name="advantage" value="2d20kl1">
          <label for="disadvantage">Disadvantage</label>
        </div>
        <div>
          Passed Saves<br/>
          <input type="checkbox" name="pass-1" value="1" class="pass" [r, if(dsPass >= 1): "checked"]>
          <input type="checkbox" name="pass-2" value="1" class="pass" [r, if(dsPass >= 2): "checked"]>
          <input type="checkbox" name="pass-3" value="1" class="pass" [r, if(dsPass >= 3): "checked"]>
        </div>
        <div>
          Failed Saves<br/>
          <input type="checkbox" name="fail-1" value="1" class="fail" [r, if(dsFail >= 1): "checked"]>
          <input type="checkbox" name="fail-2" value="1" class="fail" [r, if(dsFail >= 2): "checked"]>
          <input type="checkbox" name="fail-3" value="1" class="fail" [r, if(dsFail >= 3): "checked"]>
        </div>
        <div>
	      <input type="submit" name="myForm_btn" value="Roll">
	      <input type="submit" name="myForm_btn" value="Set">
          <input type="submit" name="myForm_btn" value="Close">
        </div>
      </div>
    </form>
  </body>
</html>
}]