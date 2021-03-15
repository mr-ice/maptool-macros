[h: logger = arg(0)]
[h: currentLevel = json.get (json.path.read (log.getLoggers(), "[*].[?(@.name == '" + logger  + "')]['level']"), 0)]
[h: macro.return = currentLevel]