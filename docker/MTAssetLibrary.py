import os
from urllib.parse import quote_plus
from lxml import objectify
from lxml.etree import tostring

def DataElement(content):
    return objectify.DataElement(content, nsmap='', _pytype='')

def MacroNameQuote(name):
    return quote_plus(name, safe='')

def XML2File(to_dir, to_file, xml, verbose):
    content = tostring(xml, pretty_print=True).decode()
    with open(os.path.join(to_dir,to_file), 'w') as f:
        f.write(content)
        if verbose:
            print('wrote {} bytes to modified {}'.
                  format(len(content),to_file))
