# Lib:DNDBeyond
A suite of library token macros designed to extract various character
information from DNDBeyond.

----
## Build
Lib:DNDBeyond has the following dependencies (Including the build command):
1. DnD5e (./dockermagic DnD5e)
2. Lib-DND5e (./dockermagic Lib-DND5e)
3. DNDBeyond-macset (./dockerrun macro-assemble "macro/Initialize DNDBeyond Character" "macro/Quick Update" "macro/Reset Properties" --list DNDBeyond)


## Installation
[Refer to the wiki for details](https://github.com/mr-ice/maptool-macros/wiki/D&D-Beyond-Framework)
Lib:DNDBeyond is simply a token with a unique role. It's a [Libray Token](https://lmwcs.com/rptools/wiki/Library_Token) which designates it as a repository for macros.
1. Drag the .rptok file from the operating system to any map. A good practice is to designate a player-hidden map
2. Either restart the campaign or execute the token macro DNDBeyond Campaign Init. This macro is auto-executed for all future load ups of the campaign.

## Trusted Macros
These macros are required to be [Trusted Macros](https://lmwcs.com/rptools/wiki/Trusted_Macro) due to their use of REST calls and logging. To maintain their status as a Trusted Macro, they may not be set to be User Editable. Doing so will disallow users from leveraging the defined function and ultimately breaking other macros.

## Usage
[See the wiki for details](https://github.com/mr-ice/maptool-macros/wiki/D&D-Beyond-Framework)
