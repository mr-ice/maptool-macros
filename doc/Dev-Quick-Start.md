# Getting started for developers
(!) if you came here thinking this would be quick, think again!

## Prerequisites

1. github account
1. git installed locally (or via your favorite ide)
1. docker (e.g. docker workstation)
1. discord
1. gnu `make` (optional)

## Initial checkout

1. go to https://github.com/mr-ice/maptool-macros in your browser and click the "Fork" button
1. you'll be taken to your fork, probably https://github.com/(your id)/maptool-macros
1. In your git client do `git clone https://github.com/mr-ice/maptool-macros` (or from your fork url, above)
1. `make build` or `dockerbuild`

## Optional config

1. `make config.ini`
   * If you don't have make, you can copy/paste this:
   ```
   [assemble]
	directory = output

	[extract]
	directory = .
   ```
1. tweak `config.ini` if you care to

## Building

1. `dockerrun assemble <thing>` (e.g. `dockerrun assemble DNDBeyond.project`)

## Extracting

1. `dockerrun extract <thing>` (e.g. `dockerrun extract Lib-DNDBeyond.rptok`)

# Other considerations

* Make sure to check out issues at https://github.com/mr-ice/maptool-macros/issues

* Use a feature branch when possible

* Use your own fork when possible

* Discuss changes on the discord channel https://discord.gg/uSZS4Bv4

* Create PRs and use issue names in your commit messages