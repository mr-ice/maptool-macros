[dialog5("Set Conditions", "title=Set Conditions; input=1; width=1020; height=838"): {
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="dnd5e_ConditionsCSS@[r: getMacroLocation()]"></link>
    </head>
    <body>
      [h: processorLink = macroLinkText("dnd5e_ProcessConditions@Lib:DnD5e", "all", "", currentToken())]
      <form action="[r:processorLink]" method="json">
        <table>
          <tr>
            <td>
              <label><input type="checkbox" name="Blinded" [r:if(getState("Blinded"),"checked","")]/>Blinded<img src='[r:getStateImage("Blinded", 30)]'/></label>
              <ul>
                <li>You can&apos;t see and automatically fail any ability check that requires sight.</li>
                <li>You have disadvanted on attacks, Attackers have advantage.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Charmed" [r:if(getState("Charmed"),"checked","")]/>Charmed<img src='[r:getStateImage("Charmed", 30)]'/></label>
              <ul>
                <li>Your can&apos;t attack the charmer or target the charmer with harmful abilities or magical effects.</li>
                <li>The charmer has advantage on any ability check to interact socially with the creature.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Frightened"/ [r:if(getState("Frightened"),"checked","")]>Frightened<img src='[r:getStateImage("Frightened", 30)]'/></label>
              <ul>
                <li>You have disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.</li>
                <li>You can&apos;t willingly move closer to the source of its fear.</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <label><input type="checkbox" name="Deafened" [r:if(getState("Deafened"),"checked","")]/>Deafened<img src='[r:getStateImage("Deafened", 30)]'/></label>
              <ul>
                <li>You can&apos;t hear and automatically fail any ability check that requires hearing.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Incapacitated" [r:if(getState("Incapacitated"),"checked","")]/>Incapacitated<img src='[r:getStateImage("Incapacitated", 30)]'/></label>
              <ul>
                <li>You can&apos;t take actions or reactions.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Poisoned" [r:if(getState("Poisoned"),"checked","")]/>Poisoned<img src='[r:getStateImage("Poisoned", 30)]'/></label>
              <ul>
                <li>You have disadvantage on attack rolls and ability checks.</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <label><input type="checkbox" name="Invisible" [r:if(getState("Invisible"),"checked","")]/>Invisible<img src='[r:getStateImage("Invisible", 30)]'/></label>
              <ul>
                <li>You can&apost be seen w/o the aid of magic or a special sense. You can hide as if you were heavily obscured. Your location can be detected by any noise or tracks.</li>
                <li>You have advantage on attacks, Attackers have disadvantage.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Paralyzed" [r:if(getState("Paralyzed"),"checked","")]/>Paralyzed<img src='[r:getStateImage("Paralyzed", 30)]'/> plus <img src='[r:getStateImage("Incapacitated", 30)]'/></label>
              <ul>
                <li>Your are incapacitated and can&apos;t move or speak.</li>
                <li>You automatically fail Strength and Dexterity saving throws. Attackers have advantage.</li>
                <li>When you are hit it is a critical hit if the attacker is within 5 feet of you.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Grappled" [r:if(getState("Grappled"),"checked","")]/>Grappled<img src='[r:getStateImage("Grappled", 30)]'/></label>
              <ul>
                <li>Your speed becomes 0, and you can&apos;t benefit from any bonus to your speed.</li>
                <li>The condition ends if the grappler is incapacitated.</li>
                <li>The condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <label><input type="checkbox" name="Prone" [r:if(getState("Prone"),"checked","")]/>Prone<img src='[r:getStateImage("Prone", 30)]'/></label>
              <ul>
                <li>Your only movement option is to crawl, unless you stand up and thereby end the condition.</li>
                <li>You have disadvantage on attack rolls.</li>
                <li>Attackers have advantage if they are is within 5 feet of you. Otherwise, the attack roll has disadvantage.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Restrained" [r:if(getState("Restrained"),"checked","")]/>Restrained<img src='[r:getStateImage("Restrained", 30)]'/></label>
              <ul>
                <li>Your speed becomes 0, and you can&apos;t benefit from any bonus to your speed.</li>
                <li>You have disadvantge on attacks, Attackers have advantage.</li>
                <li>You have disadvantage on Dexterity saving throws.</li>
              </ul>
            </td>
            <td>
              <label><input type="checkbox" name="Stunned"/ [r:if(getState("Stunned"),"checked","")]>Stunned<img src='[r:getStateImage("Stunned", 30)]'/> plus <img src='[r:getStateImage("Incapacitated", 30)]'/></label>
              <ul>
                <li>Youe are incapacitated, can&apos;t move, and can speak only falteringly.</li>
                <li>You automatically fail Strength and Dexterity saving throws.</li>
                <li>Attackers have advantage.</li>
              </ul>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <label><input type="checkbox" name="Petrified" [r:if(getState("Petrified"),"checked","")]/>Petrified<img src='[r:getStateImage("Petrified", 30)]'/> plus <img src='[r:getStateImage("Incapacitated", 30)]'/></label>
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
              <label><input type="checkbox" name="Unconscious" [r:if(getState("Unconscious"),"checked","")]/>Unconscious<img src='[r:getStateImage("Unconscious", 30)]'/> plus <img src='[r:getStateImage("Incapacitated", 30)]'/><img src='[r:getStateImage("Prone", 30)]'/></label>
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