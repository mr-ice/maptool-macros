pytest (unit style)
    // Used to test the code objects, methods, functions
    When encoding a name used as a filename (file or directory),
        the resulting name should be filesystem safe on Linux, MacOS, and Windows
        https://stackoverflow.com/questions/1976007/what-characters-are-forbidden-in-windows-and-linux-directory-names
        https://stackoverflow.com/questions/1856785/characters-allowed-in-a-url
    When creating asset from TokenDir, create a MTToken object with macros assembled
    When creating asset from PropsDir, create a MTProperties object
    When creating asset from MacroSet description, create a MTMacroSet object
    When creating asset from Macro description, create a MTMacroObj object    


behave (E2E)
    // Used to run the user endpoint and test the output
    assemble TokenDir will assemble a TokenDir.rptok
    assemble TokenDir/content.xml will assemble a TokenDir.rptok
    assemble TokenDir or TokenDir/content.xml with name will assemble a name.rptok
    assemble PropsDir will assemble a PropsDir.mtprops
    assemble PropsDir/content.xml will assemble a PropsDir.mtprops
    assemble PropsDir or PropsDir/content.xml with name will assemble a name.mtprops
    assemble macro/MacroName will assemble a MacroName.mtmacro
    assemble macro/MacroName.xml will assemble a MacroName.mtmacro
    assemble macro/MacroName.command will assemble a MacroName.mtmacro
    assemble any macro above with name will assemble a name.mtmacro
    assemble macroset from macro/MacroName1 macro/MacroName2 will create name.mtmacset with two macros
    assemble MyProject.project will assemble assets designated in project xml file
    assemble MyProject.project with macro name="macro/foo" will assemble foo.mtmacro
    assemble MyProject.project with token name="TokenDir" will assemble TokenDir.rptok
    assemble MyProject.project with props name="PropsDir" will assemble PropsDir.mtprops
    assemble anything with --output will put results in directory named
    assemble anything with config.ini '[assemble]\ndirectory = outputdir' will put results in outputdir
