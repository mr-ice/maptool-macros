# Projects
Projects collect sets of maptool assets and can be assembled together.

(!) There is no extract action on projects
  
## Project xml

Project files end in .project and are xml.

They have the following top level structure, each element can be repeated, and is
described below.

```
<project>
   <macro/>
   <macroset/>
   <token/>
   <project/>
   <text/>
</project>
```

The top level project wrapper ignores all attributes at this time.

## macro
```
<macro name="Alpha"/>
```
```
<macro name="Bravo"></macro>
```

A macro is identified by it's extracted filesystem name.  This must be present in the `name` attribute.  The name can be the name of a macro's xml or command file, or it can be the basename and .xml will be appended automatically.  Usually the name needs to include a directory part.

## macroset
```
<macroset name="Charlie">
    <macro name="Garrett"/>
	<macro name="Bosley"/>
	<macro name="Munroe"/>
	<macro name="Duncan"/>
</macroset>
```

A macroset is given a name for the created .mtmacset file (there are no filesystem objects for extracted macro sets), and contains a list of macros to put inside.

A macroset should not be empty, an empty .mtmacset will not be created.

## token
```
<token name="Delta"/>
```
A token element must be empty and must contain a name attribute.

A token name should refer to a token directory containing a content.xml, or a path to the content.xml.

## project
```
<project name="Echo"/>
```

A project is identified by it's file relative to the current file.  .project is appended if that produces a match.

A project identified this way is merged with the top level project when assembling.  macroset objects of the same name will be merged.

## text
```
<text [name="Foxtrot"]>This is text
This is also text
This is more.
when will this end?
</text>
```

The text name is used as an output file name, the default is README.txt.   No parsing or transforming is done on the bit between the tags, it is written to the file verbatim.
