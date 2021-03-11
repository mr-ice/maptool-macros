ifdef OS
    ZIP = jar -cvfM
	DOTSLASH := .\\
else
    ZIP = zip -qr
	DOTSLASH := ./
endif

project: DNDBeyond.project $(shell echo Lib-DNDBeyond/*)
	$(DOTSLASH)dockerrun assemble DNDBeyond.project

all:
	$(DOTSLASH)dockerrun assemble Ashes+PF2.project
	$(DOTSLASH)dockerrun assemble DNDBeyond.project
	$(DOTSLASH)dockerrun assemble DNDBeyond+Open5e.project
	$(DOTSLASH)dockerrun assemble Open5e.project
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
	docker image list | awk '/^(maker|tester|behave)[ \t]/{print $$1}' | xargs docker image rm
	rm -f {maker,tester,behave}.image
	rm -rf output

maker.image: docker/Dockerfile $(shell echo docker/*)
	docker build docker -t maker
	touch $@

tester.image: maker.image docker/Dockerfile.tester
	docker build docker -f docker/Dockerfile.tester -t tester
	touch $@

behave.image: maker.image docker/Dockerfile.behave
	docker build docker -f docker/Dockerfile.behave -t behave
	touch $@

build: maker.image

test: tester.image
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT tester $(ARGS)

behave: behave.image clean
	#docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT behave $(ARGS)
	behave --no-capture --no-capture-stderr --no-logcapture
	git status --ignored

.PHONY: build clean test log behave ptw unzip flake8 tester

log:
	rm -f output/Lib%3ALog4MT.rptok
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT --entrypoint "assemble" maker "Lib-Log4MT/content.xml"
	shasum --algorithm=256 output/Lib%3ALog4MT.rptok
	mv output/Lib%3ALog4MT.rptok output/Lib%3ALog4MT.rptok-from-content.xml
	docker run --rm -it --mount type=bind,source="$$(pwd)",target=/MT --entrypoint "assemble" maker "Lib-Log4MT"
	shasum --algorithm=256 output/Lib%3ALog4MT.rptok

ptw:
	ptw --  --exitfirst --failed-first --last-failed

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
