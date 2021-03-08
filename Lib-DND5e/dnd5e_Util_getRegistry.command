[h: DATA_MACRO = arg(0)]
[h, if (argCount() > 1): tokenName = arg(1); tokenName = "Lib:DND5e"]
[h, macro (DATA_MACRO + "@" + tokenName): ""]
[h: inputObj = macro.return]
[h, if (inputObj == ""): inputObj = encode ("{}"); ""]

[h: macro.return = decode (inputObj)]