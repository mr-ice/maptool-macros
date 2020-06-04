# Lib:DNDBeyond
A suite of library token macros designed to extract various character
information from DNDBeyond.

----
## Installation
Lib:DNDBeyond is simply a token with a unique role. It's a [Libray Token](https://lmwcs.com/rptools/wiki/Library_Token) which designates it as a repository for macros.
1. Drag the .rptok file from the operating system to any map. A good practice is to designate a player-hidden map
2. Either restart the campaign or execute the token macro DNDBeyond Campaign Init. This macro is auto-executed for all future load ups of the campaign.

## Trusted Macros
These macros are required to be [Trusted Macros](https://lmwcs.com/rptools/wiki/Trusted_Macro) due to their use of REST calls and logging. To maintain their status as a Trusted Macro, they may not be set to be User Editable. Doing so will disallow users from leveraging the defined function and ultimately breaking other macros.

## Usage
For now, the bulk of the macros are low-level functions intended to be consumed by some other macro yet-to-be developed. Macros with the naming prefix "dndb" are intended to be functions and will not operate correctly if executed as a stand-alone macro. However, an example pattern from one such macro would be the following, which fetches all skills from the DNDBeyond character:

    [h: bode = "9471826"]
    [h: toon = dndb_getCharJSON (bode)]
    [h: skills = dndb_getSkill (toon)]
    <pre>[r: json.indent (skills)]</pre>
