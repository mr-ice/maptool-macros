# mtmacro is a single macro export
# mtmacset is a macro set export
# rptok is a token export

ifdef OS
    ZIP = jar -cvfM
else
    ZIP = zip -r
endif

%/.mtprops %/.mtmacro %/.mtmacset %/.rptok: %
	echo "strange slashes in $@, aborting"

%.mtprops %.mtmacro %.mtmacset %.rptok: %/content.xml %/properties.xml
	mkdir .temp-$$$$; \
	cp  $^ .temp-$$$$; \
	test -d $*/assets && cp -r $^ $*/assets .temp-$$$$; \
	test -e $*/thumbnail && cp $*/thumbnail .temp-$$$$; \
	test -e $*/thumbnail_large && cp $*/thumbnail_large .temp-$$$$; \
	( cd .temp-$$$$ && \
	$(ZIP) ../$@ . ); \
	rm -rf .temp-$$$$

clean:
	rm -rf *.mtprops *.mtmacro *.mtmacset *.rptok .temp-*

realclean:
	docker image list | grep maker | cut -f1 -d\ | xargs docker image rm

build:
	docker build docker -t maker

.PHONY: build clean
