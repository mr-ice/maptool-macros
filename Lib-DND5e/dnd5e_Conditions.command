[dialog5("Set Conditions", "title=Set Conditions; input=1; width=1020; height=838"): {
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="dnd5e_ConditionsCSS@[r: getMacroLocation()]"></link>
      <style>
        [r: "input[type='checkbox']:checked#Blinded {background-image: url("][r: getStateImage("Blinded", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Blinded {background-image: url("][r: getStateImage("Blinded", 30)][r:"); filter: grayscale(1); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Charmed {background-image: url("][r: getStateImage("Charmed", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Charmed {background-image: url("][r: getStateImage("Charmed", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Frightened {background-image: url("][r: getStateImage("Frightened", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Frightened {background-image: url("][r: getStateImage("Frightened", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Deafened {background-image: url("][r: getStateImage("Deafened", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Deafened {background-image: url("][r: getStateImage("Deafened", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Incapacitated {background-image: url("][r: getStateImage("Incapacitated", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Incapacitated {background-image: url("][r: getStateImage("Incapacitated", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Poisoned {background-image: url("][r: getStateImage("Poisoned", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Poisoned {background-image: url("][r: getStateImage("Poisoned", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Invisible {background-image: url("][r: getStateImage("Invisible", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Invisible {background-image: url("][r: getStateImage("Invisible", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Paralyzed {background-image: url("][r: getStateImage("Paralyzed", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Paralyzed {background-image: url("][r: getStateImage("Paralyzed", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Grappled {background-image: url("][r: getStateImage("Grappled", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Grappled {background-image: url("][r: getStateImage("Grappled", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Prone {background-image: url("][r: getStateImage("Prone", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Prone {background-image: url("][r: getStateImage("Prone", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Restrained {background-image: url("][r: getStateImage("Restrained", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Restrained {background-image: url("][r: getStateImage("Restrained", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Stunned {background-image: url("][r: getStateImage("Stunned", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Stunned {background-image: url("][r: getStateImage("Stunned", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Petrified {background-image: url("][r: getStateImage("Petrified", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Petrified {background-image: url("][r: getStateImage("Petrified", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
        [r: "input[type='checkbox']:checked#Unconscious {background-image: url("][r: getStateImage("Unconscious", 30)][r:");}"]
        [r: "input[type='checkbox']:not(:checked)#Unconscious {background-image: url("][r: getStateImage("Unconscious", 30)][r:"); filter: grayscale(100%); opacity: 0.3;}"]
      </style>
    </head>
    <body>
      [h: processorLink = macroLinkText("dnd5e_ProcessConditions@Lib:DnD5e", "all", "", currentToken())]
      <form action="[r:processorLink]" method="json">
        <table>
          <tr>
            <td>
              <label><input type="checkbox" name="Blinded" id="Blinded" [r:if(getState("Blinded"),"checked","")]/>Blinded</label>
              <ul>
                <li>You can&apos;t see and automatically fail any ability check that requires sight.</li>
                <li>You have disadvanted on attacks, Attackers have advantage.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Charmed" id="Charmed" [r:if(getState("Charmed"),"checked","")]/>Charmed</label>
              <ul>
                <li>Your can&apos;t attack the charmer or target the charmer with harmful abilities or magical effects.</li>
                <li>The charmer has advantage on any ability check to interact socially with the creature.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Frightened" id="Frightened" [r:if(getState("Frightened"),"checked","")]>Frightened</label>
              <ul>
                <li>You have disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.</li>
                <li>You can&apos;t willingly move closer to the source of its fear.</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <label><input type="checkbox" name="Deafened" id="Deafened" [r:if(getState("Deafened"),"checked","")]/>Deafened</label>
              <ul>
                <li>You can&apos;t hear and automatically fail any ability check that requires hearing.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Incapacitated" id="Incapacitated" [r:if(getState("Incapacitated"),"checked","")]/>Incapacitated</label>
              <ul>
                <li>You can&apos;t take actions or reactions.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Poisoned" id="Poisoned" [r:if(getState("Poisoned"),"checked","")]/>Poisoned</label>
              <ul>
                <li>You have disadvantage on attack rolls and ability checks.</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <label><input type="checkbox" name="Invisible" id="Invisible" [r:if(getState("Invisible"),"checked","")]/>Invisible</label>
              <ul>
                <li>You can&apost be seen w/o the aid of magic or a special sense. You can hide as if you were heavily obscured. Your location can be detected by any noise or tracks.</li>
                <li>You have advantage on attacks, Attackers have disadvantage.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Paralyzed" id="Paralyzed" [r:if(getState("Paralyzed"),"checked","")]/>Paralyzed plus <img src='[r:getStateImage("Incapacitated", 30)]'/></label>
              <ul>
                <li>Your are incapacitated and can&apos;t move or speak.</li>
                <li>You automatically fail Strength and Dexterity saving throws. Attackers have advantage.</li>
                <li>When you are hit it is a critical hit if the attacker is within 5 feet of you.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Grappled" id="Grappled" [r:if(getState("Grappled"),"checked","")]/>Grappled</label>
              <ul>
                <li>Your speed becomes 0, and you can&apos;t benefit from any bonus to your speed.</li>
                <li>The condition ends if the grappler is incapacitated.</li>
                <li>The condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <label><input type="checkbox" name="Prone" id="Prone" [r:if(getState("Prone"),"checked","")]/>Prone</label>
              <ul>
                <li>Your only movement option is to crawl, unless you stand up and thereby end the condition.</li>
                <li>You have disadvantage on attack rolls.</li>
                <li>Attackers have advantage if they are is within 5 feet of you. Otherwise, the attack roll has disadvantage.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Restrained" id="Restrained" [r:if(getState("Restrained"),"checked","")]/>Restrained</label>
              <ul>
                <li>Your speed becomes 0, and you can&apos;t benefit from any bonus to your speed.</li>
                <li>You have disadvantge on attacks, Attackers have advantage.</li>
                <li>You have disadvantage on Dexterity saving throws.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Stunned" id="Stunned"/ [r:if(getState("Stunned"),"checked","")]>Stunned plus <img src='[r:getStateImage("Incapacitated", 30)]'/></label>
              <ul>
                <li>Youe are incapacitated, can&apos;t move, and can speak only falteringly.</li>
                <li>You automatically fail Strength and Dexterity saving throws.</li>
                <li>Attackers have advantage.</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <label><input type="checkbox" name="Petrified" id="Petrified" [r:if(getState("Petrified"),"checked","")]/>Petrified plus <img src='[r:getStateImage("Incapacitated", 30)]'/></label>
              <ul>
                <li>You are transformed, along with any nonmagical object you are wearing or carrying, into a solid inanimate substance. Your weight increases 10x, and you cease aging.</li>
                <li>You are incapacitated, can&apos;t move or speak, and are unaware of your surroundings.</li>
                <li>Attackers have advantage.</li>
                <li>You automatically fail Strength and Dexterity saving throws.</li>
                <li>You have resistance to all damage.</li>
                <li>You are immune to poison and disease, although a poison or disease already in your system is suspended, not neutralized.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Unconscious" id="Unconscious" [r:if(getState("Unconscious"),"checked","")]/>Unconscious plus <img src='[r:getStateImage("Incapacitated", 30)]'/><img src='[r:getStateImage("Prone", 30)]'/></label>
              <ul>
                <li>You are incapacitated, can&apos;t move or speak, and are unaware of your surroundings</li>
                <li>You drop whatever you&apos;re holding and fall prone.</li>
                <li>You automatically fail Strength and Dexterity saving throws.</li>
                <li>Attackers have advantage.</li>
                <li>When you are hit it is a critical hit if the attacker is within 5 feet of you.</li>
              </ul>
            </td>
          </tr>
      </table>
        <input type="submit" name="myForm_btn" value="OK">
        <input type="submit" name="myForm_btn" value="Close">
      </form>
    </body>
  </html>
}]