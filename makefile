# mtmacro is a single macro export
# mtmacset is a macro set export
# rptok is a token export

ifdef OS
    ZIP = jar -cvfM
else
    ZIP = zip -j -r
endif

%/.mtmacro %/.mtmacset %/.rptok: %
	echo "strange slashes in $@, aborting"

%.mtmacro %.mtmacset %.rptok: %
	cd $< && \
	$(ZIP) ../$@ .

clean:
	rm -f *.mtmacro *.mtmacset *.rptok
