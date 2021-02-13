[h: rollExpression = arg (0)]
[h: maxPriority = json.get (rollExpression, "maxPriority")]
[h, if (encode (maxPriority) == ""): maxPriority = -1; ""]
[h: macro.return = maxPriority]