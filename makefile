ifdef OS
    ZIP = jar -cvfM
	DOTSLASH := .\\
else
    ZIP = zip -qr
	DOTSLASH := ./
endif

PROJECTS := $(wildcard *.project)

project: DNDBeyond.project $(shell echo Lib-DNDBeyond/*)
	$(DOTSLASH)dockerrun assemble DNDBeyond.project

%.project:
	$(DOTSLASH)dockerrun assemble $<

all: Lib-Log4MT
	$(DOTSLASH)dockerrun assemble Ashes+PF2.project
	$(DOTSLASH)dockerrun assemble DNDBeyond.project
	$(DOTSLASH)dockerrun assemble DNDBeyond+Open5e.project
	$(DOTSLASH)dockerrun assemble Open5e.project

Lib-Log4MT:
	$(DOTSLASH)dockerrun assemble Lib-Log4MT

project-local: DNDBeyond.project $(shell echo LIB-DNDBeyond/*)
	$(DOTSLASH)docker/project-assemble DNDBeyond.project

%.mtmacro %.rptok %.mtmacset %.mtprops:
	@echo "E: makefile no longer builds assets directly, use dockerrun assemble"

%/.mtprops %/.mtmacro %/.mtmacset %/.rptok: %
	echo "strange slashes in $@, aborting"

clean:
	rm -rf *.mtprops *.mtmacro *.mtmacset *.rptok .temp-* output/*

realclean: clean
	docker image rm maker -f 2> /dev/null
	docker image rm tester -f 2> /dev/null
	docker image rm behave -f 2> /dev/null
	rm -f {maker,tester,behave}.image

maker.image: docker/Dockerfile $(shell echo docker/*)
	docker build docker -t maker
	touch $@

tester.image: maker.image docker/Dockerfile.tester
	docker build docker -f docker/Dockerfile.tester -t tester
	touch $@

build: maker.image

test: tester.image
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT tester $(ARGS)

behave: tester.image
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT --entrypoint=behave tester --no-capture --no-capture-stderr --no-logcapture
	#git status --ignored


label:
	rm -rf output/Lib*Log4MT*
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT --entrypoint "assemble" maker "Lib-Log4MT/content.xml"
	unzip -p output/Lib-Log4MT.rptok content.xml | tail

ptw:
	ptw -- --exitfirst --failed-first --last-failed

unzip:
	for z in test/data/MinViable/*.zip; do unzip -o $$z; done
	rm -rf qaa
	mkdir qaa
	./docker/assemble MVProject.project --output qaa
	ls -altr

config.ini: makefile
	echo '[assemble]\ndirectory = output\n\n[extract]\ndirectory = .' > $@

maptool-macros.code-workspace: makefile
	echo '{\n    "folders": [\n        {\n            "path": "."\n        }\n    ]\n}' > $@

.vscode/extensions.json: makefile
	mkdir -p .vscode
	echo '{\n    "recommendations": [\n        "slevesque.vscode-zipexplorer"\n    ]\n}' > $@

vscode: .vscode/extensions.json maptool-macros.code-workspace

flake8:
	flake8 --ignore E501,E402,F405

.PHONY: build clean test log behave ptw unzip flake8 tester Lib-Log4MT $(PROJECTS)
