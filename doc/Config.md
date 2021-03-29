# Config

Developer tools use a config.ini in the root of the project (alongside the makefile) to control a few aspects of the tools.

```
[assemble]
directory = output
LibTokenGitTagElement = label

[extract]
directory = .
```

## Sections

`[assemble]` applies to the `assemble` tool which pulls filesystem objects into MapTool assets.

`[extract]` applies to the `extract` tool which pulls apart MapTool assets into filesystem objects (suitable for github).

## Assemble Configuration

`directory` is a directory in which to place assets created.  Many devs use `output` which creates an `output/` directory at the top of the project where all the assets will be built.  Note that absolute paths and Windows paths will not work if the assemble is run in the docker images.

`LibTokenGitTagElement` is a top-level element into which the Git Tag will be placed (replacing or overwriting the element) on a token which has a name starting with 'Lib:'.  

## Extract Configuration

`directory` is a directory in which to place assets extracted.  The default is '.'.
