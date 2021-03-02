[h: DATA_MACRO = arg(0)]
[h, macro (DATA_MACRO + "@Lib:DnDBeyond"): ""]
[h: inputObj = macro.return]
[h, if (inputObj == ""): inputObj = encode ("{}"); ""]

[h: macro.return = decode (inputObj)]