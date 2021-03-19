<!-- encode / decode to normalize it -->
[h: encWrapperConfig = encode (arg(0))]
[h: encWrapperConfig = replace (encWrapperConfig, "%0A", "")]
[h: wrapperConfig = decode (encWrapperConfig)]
[h: macro.return = wrapperConfig]