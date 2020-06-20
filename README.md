# maptool-macros
place for maptool macros

These MapTool artifacts have all been unpacked and their macros extracted into
xml and command (text) files.  They can be reassembled with the tools herein.

## Meta-Tools and Tools

You'll need a working git, docker, and bash.

* ./dockerbuild - make our images
* ./dockermagic <dir> - build a macro, token, or mtprops
* ./dockerrun automagic <dir> -- same as ./dockermagic
* ./dockerrun macro-extract <thing> - extract macros from mtmacro and
  mtmacset objects
* ./dockerrun macro-assemble macro/1 -- assemble a mtmacro from
  macro/1.xml and macro/1.command
* ./dockerrun macro-assemble macro/1 macro/2 macro/3 --set myset --
  assemble myset.mtmacset from macro/1.xml macro/1.command [etc...]
* ./dockerrun token-extract <thing> - extract a token and its macros 
* ./dockerrun token-assemble <dir> - put a token back together

---
**NOTE**
Note that automagic does not build mtmacsets.  We get rid of the
container (set) so to re-create them we need the list of macros passed
to macro-assemble
---

## Macros
* RollSave - Simple roll an attribute save
* Set Elevation - Simple set/clear elevation on selected token
* AttackMacros - Trey's Macro Set
  * Make Attack
  * Attack Config
  * Print AttackJSON
  * Set AttackJSON
  * Bode
    * Dynamic Example
    * Test
    * Bode Initiative
    * Multi Attacks
  * Generic
    * 1d4
    * 1d6
    * 1d8
    * 1d10
    * 1d12
    * 1d20
    * Die Roller
    * Iteration Testing
    * d20 Advantage/Disadvantage
* AttackConfig - Trey's JSON Attack Config
* MakeAttack - Trey's JSON Attack Button
* PrintAttackJSON - Trey's JSON print
* SetAttackJSON - Trey's JSON Attack Import
* RollInitiative - https://lmwcs.com/rptools/wiki/Roll_Initiative
* RollInititative - single  every thing selected gets an initiative roll

