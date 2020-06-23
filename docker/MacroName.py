from urllib.parse import quote_plus


def MacroNameQuote(name):
    return quote_plus(name, safe='')
