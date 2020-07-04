# mtmacro is a single macro export
# mtmacset is a macro set export
# rptok is a token export

ifdef OS
    ZIP = jar -cvfM
	DOTSLASH := .\\
else
    ZIP = zip -qr
	DOTSLASH := ./
endif

project: DNDBeyond.project $(shell echo Lib-DNDBeyond/*)
	$(DOTSLASH)dockerrun project-assemble DNDBeyond.project

project-local: DNDBeyond.project $(shell echo LIB-DNDBeyond/*)
	$(DOTSLASH)docker/project-assemble DNDBeyond.project

%.mtmacro:
	@echo "E: makefile no longer builds macros.  You should use dockerrun macro-assemble instead"

%.rptok:
	@echo "E: makefile no longer builds tokens.  You should use dockerrun token-assemble instead"

%.mtmacset:
	@echo "E: makefile no loner builds macro sets.  You should use macro-assemble, see README.md"

%/.mtprops %/.mtmacro %/.mtmacset %/.rptok: %
	echo "strange slashes in $@, aborting"

%.mtprops: %/content.xml %/properties.xml
	mkdir /tmp/.temp-$$$$; \
	cp  $^ /tmp/.temp-$$$$; \
	test -d $*/assets && cp -r $*/assets /tmp/.temp-$$$$; \
	test -e $*/thumbnail && cp $*/thumbnail /tmp/.temp-$$$$; \
	test -e $*/thumbnail_large && cp $*/thumbnail_large /tmp/.temp-$$$$; \
	OUTDIR=$$PWD && \
	( cd /tmp/.temp-$$$$ && \
	$(ZIP) $$OUTDIR/$@ . );


clean:
	rm -rf *.mtprops *.mtmacro *.mtmacset *.rptok .temp-*

realclean:
	docker image list | grep maker | cut -f1 -d\ | xargs docker image rm

maker.image: docker/Dockerfile $(shell echo docker/*)
	docker build docker -t maker
	touch $@

tester.image: maker.image docker/tester/Dockerfile
	docker build docker/tester -t tester
	touch $@

build: maker.image tester.image

test: tester.image
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT tester "$(ARGS)"


.PHONY: build clean test
