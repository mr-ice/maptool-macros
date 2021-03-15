[h: category = arg (0)]
[h, if (l4m.isTraceEnabled (category, ".lineparser")):
	log.setLevel ("net.rptools.maptool.client.MapToolLineParser", "DEBUG");
	l4m.disableLineParser()]