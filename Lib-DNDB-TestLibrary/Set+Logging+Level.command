[h: loggers = json.sort(log.getLoggers(),"a","name")]
[h: loggerList = ""]
[h, FOREACH(logger, loggers), CODE: {
    [h: loggerList = listAppend(loggerList,json.get(logger,"name"))]
}]
[h:status=input(
    "junkVar|Select a Logger and Level||LABEL|SPAN=TRUE",
    "lname|"+loggerList+"|Logger|LIST|VALUE=STRING",
    "level|DEBUG,INFO,WARN,ERROR,FATAL|Level|LIST|VALUE=STRING")]
[h:abort(status)]
[r: "Setting <i><b>" + lname + "</b></i> to <b>" + level + "</b>."]
[h: log.setLevel(lname,level)]