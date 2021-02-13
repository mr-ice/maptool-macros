ifdef OS
    ZIP = jar -cvfM
	DOTSLASH := .\\
else
    ZIP = zip -qr
	DOTSLASH := ./
endif

project: DNDBeyond.project $(shell echo Lib-DNDBeyond/*)
	$(DOTSLASH)dockerrun assemble DNDBeyond.project

all: DNDBeyond+Open5e.project $(shell echo Lib-DNDBeyond/*) $(shell echo Lib-Open5e/*)
	$(DOTSLASH)dockerrun assemble DNDBeyond+Open5e.project

project-local: DNDBeyond.project $(shell echo LIB-DNDBeyond/*)
	$(DOTSLASH)docker/project-assemble DNDBeyond.project

%.mtmacro %.rptok %.mtmacset %.mtprops:
	@echo "E: makefile no longer builds assets directly, use dockerrun assemble"

%/.mtprops %/.mtmacro %/.mtmacset %/.rptok: %
	echo "strange slashes in $@, aborting"

clean:
	rm -rf *.mtprops *.mtmacro *.mtmacset *.rptok .temp-* output/*

realclean:
	docker image list | awk '/^(maker|tester|behave)[ \t]/{print $$1}' | xargs docker image rm
	rm -f {maker,tester,behave}.image
	rm -rf output

maker.image: docker/Dockerfile $(shell echo docker/*)
	docker build docker -t maker
	touch $@

tester.image: maker.image docker/tester/Dockerfile
	docker build docker/tester -t tester
	touch $@

behave.image: maker.image docker/behave/Dockerfile
	docker build docker/behave -t behave
	touch $@

build: tester.image behave.image

test: tester.image
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT tester $(ARGS)

behave: behave.image
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT behave $(ARGS)

.PHONY: build clean test
