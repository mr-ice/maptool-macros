
[h: Bode = "9471826"]
[h: Bob = "291999"]
[h: Blurrier = "29699178"]
[h: Barby = "14954596"]
[h: Ziarali = "28120733"]
[h: Bhelduhr = "7995967"]
[h: Yaichi = "27752286"]
[h: Rex = "20170550"]
[h: Nibbles = "2673527"]
<!-- dndbt_getKetdelle -->
[h: Ketdelle = "8035705"]
[h: Craw = "30352009"]
[h: Kaz = "27986972"]
[h: Haglin = "4049906"]
[h: Clerical = "30598169"]
[h: Live2 = "30957978"]
[h: Jerry = "30957877"]
[h: Tatlo = "12149365"]
[h: Pzzt = "1714674"]
[h: Geewizz = "30729915"]
[h: Horgotin = "dndbt_Horgotin"]
[h: Ralthos = "42968882"]
[h: Bafoon = "44707662"]

[h: toon = dndb_getCharJSON (Ralthos)]

[h: message = json.get (toon, "message")]
[h: name = json.path.read (toon, "data.name")]
[h: message = message + ": " + name]
[r: message]
[h: log.debug (message)]
[h: log.warn ("MARK")]
<pre>[r: log.info (dndb_getSpells (toon))]</pre>

[h: log.warn ("FINISH")]