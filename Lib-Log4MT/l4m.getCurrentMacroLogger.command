[h: currentLevel = json.get (json.path.read (log.getLoggers(), "[*].[?(@.name == 'macro-logger')]['level']"), 0)]
[h: macro.return = currentLevel]