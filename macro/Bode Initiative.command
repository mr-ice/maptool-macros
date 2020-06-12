[h: initBonus = getProperty("Initiative")]

[h: roll1 = 1d20 + initBonus]
[h: roll2 = 1d20 + initBonus]

Initiative: [r:roll1]<br>
<i>Advantage</i>: [r:roll2]

[h: realInit = max(roll1, roll2)]
[h: setInitiative(realInit)]