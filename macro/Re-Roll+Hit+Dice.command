[h, if (MaxHP == HP): keepMaxed = 1; keepMaxed = 0]
[h: assert (HitDice != "", "<font color='red'>" + getName() + "</font>: Token does not have <b>HitDice</b>; Nothing to do")]
[h: MaxHP = evalMacro ("[r: " + HitDice + "+ " + BonusHP +"]")]
[h, if (keepMaxed || HP > MaxHP):	HP = MaxHP]
[r: getLabel() + ": " + HP + " / " + MaxHP]