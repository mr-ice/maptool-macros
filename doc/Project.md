# Projects
Projects collect sets of maptool assets and can be assembled together.

(!) There is no extract action on projects
  
## Project xml

Project files end in .project and are xml.

```
<project>
   <macro/>
   <macroset/>
   <token/>
   <project/>
   <text/>
</project>
```

## macro
```
<macro name="Alpha"/>
```
```
<macro name="Bravo"></macro>
```

A macro is identified by it's extracted filesystem name.  The name can be the name of a macro's xml or command file, or it can be the basename and .xml will be appended automatically.

## macroset
```
<macroset name="Charlie">
    <macro name="Garrett"/>
	<macro name="Bosley"/>
	<macro name="Munroe"/>
	<macro name="Duncan"/>
</macroset>
```

A macroset is given a name to create (there are no filesystem objects for macro sets), and contains a list of macros to put inside.

## token
```
<token name="Delta"/>
```

A token is identified by it's extracted filesystem directory name, or a path to it's extracted content.xml

## project
```
<project name="Echo"/>
```

A project is identified by it's file relative to the current file.  .project is appended if that produces a match.

## text
```
<text [name="Foxtrot"]>This is text
This is also text
This is more.
when will this end?
</text>
```

The text name is a file name to create in the output directory, the default is README.txt.   No parsing or transforming is done on the bit between the tags, it is written to the file verbatim.
