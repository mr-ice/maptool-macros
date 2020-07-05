[h: dadv = json.get (arg (0), "hasDisadvantage")]
[h, if (dadv == ""): dadv = 0; ""]
[h: macro.return = dadv]