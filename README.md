# maptool-macros
place for maptool macros

These have all been unzipped to save the xml directly, but perhaps we will
build an assembler to take the text -> xml -> zip so we can see directly the
macro 

## Tools

* make build - implementation of dockerbuild with both commands we need
* ./automagic <dir> - build a maptool object from a directory
* ./dockermagic <dir> - run automagic via docker
* ./xc <dir> - eXtract Commands into individual .command files in directory
* ./dockerxc <dir> - run xc on a dir via docker

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
* RollInitiative - https://lmwcs.com/rptools/wiki/Roll_Initiative soon to be HaVoClAdded

