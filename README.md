# maptool-macros
place for maptool macros

These MapTool artifacts have all been unpacked and their macros extracted into
xml and command (text) files.  They can be reassembled with the tools herein.

## Meta-Tools and Tools

You'll need a working git, docker, and bash.   Note the examples here
assume you are in the top directory of the checkout (where the scripts live).

</dl>
<dt><code>./dockerbuild</code></dt>
<dd>make our docker images using a bash script</dd><br>
<dt><code>dockerbuild.cmd</code></dt>
<dd>make our docker images using a windows command script</dd><br>
<dt><code>make build</code></dt>
<dd>make our docker images using make</dd><br>
<dt><code>./dockerrun macro-extract &lt;thing&gt;</code></dt>
<dd>extract macros from a mtmacro or mtmacset object into
     a macro/ directory</dd><br>
<dt><code>./dockerrun token-extract &lt;thing&gt;</code></dt>
<dd>unpack a token object and extract the macros (these
     will be in the token directory)</dd><br>
<dt><code>./dockerrun assemble &lt;thing&gt;</code></dt>
<dd>If &lt;thing&gt; is a macro/* file, it will assemble a mtmacro object</dd><br>
<dd>If &lt;thing&gt; is multiple macro/* files, it will assemble a mtmacset object</dd><br>
<dd>If &lt;thing&gt; is a directory, it will assemble the thing in the content.xml file therein</dd><br>
<dd>If &lt;thing&gt; is a content.xml, it will assemble that thing (usually this has
     to be in a directory with the objects referenced in the content.xml)</dd><br>
<dd>If &lt;thing&gt; is a .project file, it will assemble all the objects listed in
  the project file.</dd><br>
</dl>
---

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

