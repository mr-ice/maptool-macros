Feature: Assemble

    As a builder, I want to be able to build Maptool Assets
    from their exploded parts.

    Background:
       Given I have a test token dir
         And I have two base macros
         And I have a base properties dir
         And I have the assemble command

    Scenario: Assemble a Token
        When I call the assemble command with that test token dir
        Then I will have a Token file
         And the Token file will be a zipfile
         And the Token file will contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.Token"

    Scenario: Assemble a Token to a specified output directory
        When I assemble that Token specifying output
        Then I will have a Token file in the output

    Scenario: Error messages from commandline tool
        When I call assemble without an argument
        Then I get an error message about required input

    Scenario: I should be able to assemble a Token verbosely
        When I call assemble on the Token Dir verbosely
        Then I should get more verbose output
         And It builds the Token

    Scenario: I should be able to assemble a Macro by Name
        When I call assemble with a Macro name
        Then I should get a mtmacro asset
         And that Macro should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.MacroButtonProperties"

    Scenario: I should be able to assemble a Macro by XML File
        When I call assemble with a Macro XML FileName
        Then I should get a mtmacro asset
         And that Macro should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.MacroButtonProperties"

    Scenario: I should be able to assemble a Macro by Command File
        When I call assemble with a Macro Command File Name
        Then I should get a mtmacro asset
         And that Macro should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.MacroButtonProperties"

    Scenario: I should be able to assemble a Properties by name
        When I call assemble with a Properties directory name
        Then I should get a mtprops asset
         And the Properties file will be a zipfile
         And that mtprops should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.CampaignProperties"

    Scenario: I should be able to assemble a Project
        Given I have a Project with MacroSet Token Props
        When I call assemble with a Project file name
         And that Project contains a macroset
         And that Project contains a token
         And that Project contains a Properties
        Then I should get a macroset file
         And that macroset should contain a content.xml
         And the Asset content.xml will be a list
         And I should get a token file
         And that token should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.Token"
         And I should get a properties file
         And that properties file should be a zipfile
         And that properties file should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.CampaignProperties"

    Scenario: Assembling a project with an output directory should result in all assets created in the output directory
        Given I have a Project with MacroSet Token Props
         When I call assemble with a Project file name and output directory
         And that Project contains a macroset
         And that Project contains a token
         And that Project contains a Properties
        Then I should get a macroset file in the output directory
         And that macroset should contain a content.xml
         And the Asset content.xml will be a list
         And I should get a token file in the output directory
         And that token should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.Token"
         And I should get a properties file in the output directory
         And that properties file should contain a content.xml
         And the Asset content.xml will be a "net.rptools.maptool.model.CampaignProperties"

    Scenario: I should be able to assemble a macro set from the commandline
       Given I have two or more macros
        When I call the assemble command with two or more macros as input, a name, and an output directory
        Then I should get an output directory
         And a named macroset
         And that macroset should contain a content.xml
         And the Asset content.xml will be a list

    Scenario: Embed instructions for GMs in project files # Issue #176
       Given A project with a text element
         And I have the assemble command
        When I call the assemble command with the project/text structure
        Then I should get a text file
         And the text file should contain my content

    Scenario: make project files reference another project file enhancement # Issue #177
       Given A project with a project element
         And I have the assemble command
        When I call the assemble command with the project/project structure
        Then I should get a text file from the embedded project
         And that text file should contain the embedded content

    @wip
    Scenario: make project files merge macrosets # Issue #67
       Given I have three nested project files with common macroset
        When I assemble the master project
        Then I get the macroset from the collection
         And that macroset contains macros from the "first" project
         And that macroset contains macros from the "second" project
         And that macroset contains macros from the "third" project

