#!/usr/bin/env python3
"""This simple script takes a content.xml as the argument and extracts
all the macros it finds into individual files per macro.  It doesn't
change content.xml"""

import sys
from lxml import objectify
from urllib.parse import quote

main = objectify.parse(sys.argv[1])
macro = 'net.rptools.maptool.model.MacroButtonProperties'
token = 'net.rptools.maptool.model.Token'

def macroList(elem):
    if elem.tag == 'list':
        # usually a list of macros
        return {x.label:x.command for x in elem.findall('./'+macro)}
    elif elem.tag == macro:
        # it's already a macro
        return {elem.label:elem.command}
    elif elem.tag == token:
        # a token has a macroPropertiesMap with macros:
        mpm = elem.macroPropertiesMap
        return {x.label:x.command for x in mpm.findall('./entry/'+macro)}

for label, command in macroList(main.getroot()).items():
    label = str(label)
    if '/' in label:
        label = quote(str(label),safe=' ')
    with open(label + '.command', 'w') as f:
        f.write(str(command))
