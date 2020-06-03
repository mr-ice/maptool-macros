# mtmacro is a single macro export
# mtmacset is a macro set export
# rptok is a token export

%.mtmacro %.mtmacset %.rptok: %
	zip -j -r $@ $<
