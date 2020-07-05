[h: adv = json.get (arg (0), "hasAdvantage")]
[h, if (adv == ""): adv = 0; ""]
[h: macro.return = adv]