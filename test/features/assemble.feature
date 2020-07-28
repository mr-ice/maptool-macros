@fixture.base_token
@fixture.base_macro
Feature: Assemble

    As a builder, I want to be able to build Maptool Assets
    from their exploded parts.

    Background:
        Given I am using the assembler
          And I have a test token dir
          And I have the assemble command

    Scenario: Assemble a Token
        When I assemble that Token
        Then I will have a Token file
         And the Token file will be a zipfile
         And the Token file will contain a content.xml
         And the Asset content.xml will be a net.rptools.maptool.model.Token

    Scenario: Assemble a Token to a specified output directory
        When I assemble that Token specifying output
        Then I will have a Token file in the output

    Scenario: Error messages from commandline tool
        When I call assemble without an argument
        Then I get an error message about required input

    Scenario: I should be able to assemble a Token with the commandline tool
        When I call assemble on the Token Dir
        Then I will have created a Token file

    Scenario: I should be able to assemble a Token verbosely
        When I call assemble on the Token Dir verbosely
        Then I should get more verbose output
         And It builds the Token

    Scenario: I should be able to assemble a Macro by Name
        When I call assemble with a Macro name
        Then I should get a mtmacro asset
         And that asset should contain a content.xml
         And the Asset content.xml will be a net.rptools.maptool.model.MacroButtonProperties

    Scenario: I should be able to assemble a Macro by XML File
        When I call assemble with a Macro XML FileName
        Then I should get a mtmacro asset
         And that asset should contain a content.xml
         And the Asset content.xml will be a net.rptools.maptool.model.MacroButtonProperties

    Scenario: I should be able to assemble a Macro by Command File
        When I call assemble with a Macro Command File Name
        Then I should get a mtmacro asset
         And that asset should contain a content.xml
         And the Asset content.xml will be a net.rptools.maptool.model.MacroButtonProperties
