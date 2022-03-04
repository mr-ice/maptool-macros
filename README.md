# maptool-macros
place for maptool macros

These MapTool artifacts have all been unpacked and their macros extracted into
xml and command (text) files.  They can be reassembled with the tools herein.

## Meta-Tools and Tools

You'll need a working git, docker, and bash.   Note the examples here
assume you are in the top directory of the checkout (where the scripts live).

Command | Result
------------ | -------------
<code>./dockerbuild</code> | make our docker images using a bash script
<code>dockerbuild.cmd</code> | make our docker images using a windows command script
<code>make build</code> | make our docker images using make
<code>./dockerrun extract &lt;thing&gt;</code> | extract an object and macros to .xml and .command files
<code>./dockerrun assemble &lt;thing&gt;</code> | pointed at a directory or file it parses what it can to re-assemble it into a Maptool Asset


----
[click here](https://myco.com/mylink)

## Sample Macro List (note, this list is not maintained)
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

