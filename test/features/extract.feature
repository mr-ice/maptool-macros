Feature: extract

    As a developer, I want to be able to extract
    MapTool assets to parts, to facilitate tracking
    changes to macros using git.

    Background:
       Given I have a sample token
         And I have a sample macro
         And I have a sample macroset
         And I have a sample properties

    Scenario: Extract a Token
        When I extract a token
        Then I should get a token directory
        And I should get a token/content.xml
        And I should get a token/properties.xml
        And I should get a token/thumbnail
        And I should get a token/thumbnail_large
        And I should get a token/assets directory
        And I should get a macro xml file in the token directory
        And I should get a macro command file in the token directory

    Scenario: Extract a Lib:Token stripping gmName
       Given I have a token with name that starts with 'Lib:'
         And that token has a gmName
        When I extract a token
        Then I should get a token directory
         And I should get a token/content.xml
         And that token/content.xml should not have a gmName

    Scenario: Extract a macro
        When I extract a macro
        Then I should get a macro directory
         And I should get a macro xml file
         And I should get a macro command file

    Scenario: Extract a macroset
        When I extract a macroset
        Then I should get a macro directory
        And I should get macro xml files
        And I should get macro command files

    Scenario: Extract a propertiess
        When I extract a properties
        Then I should get a properties directory
         And I should get a properties/content.xml
         And I should get a properties/properties.xml
        
    Scenario: Extract a macro with github comment
       Given I have a macro asset with github comment
        When I extract a macro
        Then I should get a macro directory
         And I should get a macro xml file
         And I should get a macro command file
         And that macro command file should not have a github comment

    @wip
    Scenario: Extract a macro from token with github comment
       Given I have a token with github comment on a macro
        When I extract a token
        Then I should get a token directory
         And I should get a token/content.xml
         And I should get a macro xml file in the token directory
         And I should get a macro command file in the token directory
         And that macro command file should not have a github comment
