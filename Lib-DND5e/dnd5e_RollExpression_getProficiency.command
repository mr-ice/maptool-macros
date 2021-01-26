[h: rollExpression = arg(0)]
[h: proficient = json.get (rollExpression, "proficient")]
[h, if (proficient == ""): proficient = 0; ""]
[h: macro.return = proficient]