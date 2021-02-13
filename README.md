# maptool-macros
place for maptool macros

These MapTool artifacts have all been unpacked and their macros extracted into
xml and command (text) files.  They can be reassembled with the tools herein.

## Meta-Tools and Tools

You'll need a working git, docker, and bash.   Note the examples here
assume you are in the top directory of the checkout.


./dockerbuild
:    make our docker images using bash

<dl>
  <dt><code>./dockerbuild</code></dt>
  <dd>make our docker images using bash</dd>
  <dt><code>make build</code></dt>
  <dd>make our docker images using make</dd>
  <dt><code>./dockermagic &lt;base thing&gt;</code></dt>
  <dd>build a macro from its xml file, or a properties or token from its
  directory</dd>
  <dt><code>./dockerrun automagic &lt;base thing&gt;</code></dt>
  <dd>same as <code>./dockermagic</code></dd>
  <dt><code>./dockerrun macro-extract &lt;thing&gt;</code></dt>
  <dd>extract macros from mtmacro and mtmacset objects</dd>
  <dt><code>./dockerrun macro-assemble &lt;macro/1&gt;</code></dt>
  <dd>assemble a mtmacro from macro/1.xml and macro/1.command</dd>
  <dt><code>./dockerrun macro-assemble macro/1 macro/2 macro/3 --set myset</code></dt>
  <dd>assemble myset.mtmacset from macro/1.xml macro/1.command [etc...]</dd>
  <dt><code>./dockerrun token-extract &lt;thing&gt;</code></dt>
  <dd>extract a token and its macros from a .rptok file</dd>
  <dt><code>./dockerrun token-assemble &lt;dir&gt;</code></dt>
  <dd>put a token back together</dd>
  <dt><code>./dockerrun project-assemble &lt;thing&gt;</code></dt>
  <dd>put together tokens, properties, and macrosets described in a
    .project xml file</dd>
</dl>

---
**NOTE**
Note that automagic does not build mtmacsets.  We get rid of the
container (set) so to re-create them we need the list of macros passed
to macro-assemble.  This can be done via project file.
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

