[h: lineParserLog = "net.rptools.maptool.client.MapToolLineParser"]
[h: currentLevel = json.get (json.path.read (log.getLoggers(), "[*].[?(@.name == '" + lineParserLog  + "')]['level']"), 0)]
[h: log.debug ("Current: " + lineParserLog + ": " + currentLevel)]
[h, if (currentLevel == "DEBUG"): newLevel = "WARN"; newLevel = "DEBUG"]
[h: log.debug ("New: " + lineParserLog + ": " +  newLevel)]
[r: log.setLevel (lineParserLog, newLevel)]