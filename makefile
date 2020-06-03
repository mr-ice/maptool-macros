
%.mtmacro %.mtmacset %.rptok: %
	zip -j -r $@ $<
