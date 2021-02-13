[h: DATA_MACRO = arg(0)]
[h, macro (DATA_MACRO + "@Lib:DND5e"): ""]
[h: inputObj = macro.return]
[h, if (inputObj == ""): inputObj = encode ("{}"); ""]

[h: macro.return = decode (inputObj)]