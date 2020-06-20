from docker.MacroName import MacroNameQuote as quote

class TestMacroName():
    def test_macro_name_quote_no_changes(self):
        assert quote('nochangesnecessary') == 'nochangesnecessary'

    def test_macro_name_quote_spaces(self):
        assert quote('has spaces in name') == 'has+spaces+in+name'

    def test_macro_name_quote_slashes(self):
        assert quote('has/slashes/in/name') == 'has%2Fslashes%2Fin%2Fname'

    def test_macro_name_quote_plus(self):
        assert quote('has+literal+plus') == 'has%2Bliteral%2Bplus'
