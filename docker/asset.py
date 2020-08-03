#!/usr/bin/env python3
"""Assemble any of our artifacts

Output Format | Inputs
------------- | ------
rptok         | TokenDir
              | .
------------- | ------
mtmacro       | [.../]Name[.xml|.command]
------------- | ------
mtmacset      | [.../]Name1[.xml|.command]
              | [.../]Name2[.xml|.command]
              | [...]
              | SetName
------------- | ------
mtprops       | PropertiesDir
              | .
------------- | ------
"""

import os
import zipfile
import logging as log
from lxml import objectify
from lxml.etree import tostring, Element

from MTAssetLibrary import DataElement, tokentag, proptag, macrotag
from MTAssetLibrary import MacroNameQuote as quote, properties_xml
from MTAssetLibrary import MTMacro


def xml_get_attr(xml, path, default=None):
    """Extract an attribute from xml, but give a default if
    it is not found"""
    try:
        return xml.xpath('./' + path).pop().text
    except Exception as e:  # noqa: F841
        return default


def xml_file_search(pattern):
    return_file = pattern
    log.debug('os.getcwd = '+os.getcwd())
    if pattern.endswith('.xml'):
        return_file = pattern
    elif pattern.endswith('.project'):
        return_file = pattern
    elif pattern.endswith('.command'):
        return_file = pattern[:-8] + '.xml'
    elif os.path.exists(pattern + '.xml'):
        return_file = pattern + '.xml'
    elif os.path.exists(os.path.join(pattern, 'content.xml')):
        return_file = os.path.join(pattern, 'content.xml')

    if not os.path.exists(return_file):
        log.debug('os.getcwd() = ' + os.getcwd())
        raise FileNotFoundError('xml_file_search could not find file ' +
                                str(return_file))

    return return_file


def add_directory_to_zipfile(zf, directory_name):
    savedir = os.getcwd()
    os.chdir(directory_name)
    for f in ('thumbnail', 'thumbnail_large', 'properties.xml'):
        if os.path.exists(f):
            zf.write(f)
            log.debug('write {} ({} bytes) to {}'.format(
                f, os.path.getsize(f), zf.filename))

    for root, dirs, files in os.walk('assets'):
        for f in files:
            f = os.path.join(root, f)
            zf.write(f)
            log.debug('wrote {} ({} bytes) to {}'.format(
                    f, os.path.getsize(f), zf.filename))
    os.chdir(savedir)


class MTAsset():
    """Asset Factory, determines what kind of asset from the input and
    returns the specific subclass"""
    # Inputs for init can be any of
    # directory/
    #           content.xml
    #               root.tag == tokentag
    #               root.tag == proptag
    # directory/
    #           MacroName
    #           MacroName.xml
    #           MacroName.command
    # File.project
    # [...]
    #
    # Name.rptok
    # Name.mtmacro
    # Name.mtmacset
    # Name.mtprops
    def __init__(self, *args, **kwargs):
        """Create an object from filesystem artifacts and determine
        which kind of MapTool asset we intend from those files.  Allows
        transformation between extracted files and maptool asset file"""

        self.types = {
                'macro': {
                    'ext': 'mtmacro',
                    'tag': macrotag,
                    },
                'macroset': {
                    'ext': 'mtmacset',
                    'tag': 'list',
                    },
                'properties': {
                    'ext': 'mtprops',
                    'tag': proptag,
                    },
                'project': {
                    'ext': 'project',
                    'tag': 'project',
                    },
                'token': {
                    'ext': 'rptok',
                    'tag': tokentag,
                    }}

        # make a lookup by tag
        self.tags = {x['tag']: k for k, x in self.types.items()}

        self.type = None  # will be key from types
        self.macrolist = []  # for macroset only

        # some other arguments
        self.path = kwargs.get('path', '.') or '.'
        self.verbose = kwargs.get('verbose', False)

        if not args:
            raise TypeError('MTAsset() missing required argument')

        if len(args) == 1:
            a = args[0]
            self.xml_file = xml_file_search(a)

            self.xml = objectify.parse(self.xml_file)
            self.tag = self.xml.getroot().tag
            self.type = self.tags.get(self.tag)

            if self.type == 'token':
                self.name = self.xml.getroot().name.text
            elif self.type == 'macro':
                self.name = self.xml.getroot().label.text
            elif os.path.split(self.xml_file)[1] == 'content.xml':
                self.name = os.path.basename(os.path.split(self.xml_file)[0])
            else:
                x = self.xml_file  # shortening lines
                self.name = os.path.splitext(os.path.basename(x))[0]
        else:
            self.tag = 'list'
            self.type = 'macroset'
            self.name = kwargs.get('name', 'Unknown')

            for a in args:
                log.debug('MTAsset:__init__ macroset os.getcwd() = '  + os.getcwd())
                k = xml_file_search(a)

                xml = objectify.parse(k)
                root = xml.getroot()
                self.macrolist.append({
                    'arg': a,
                    'file': k,
                    'tag': root.tag,
                    'name': xml_get_attr(xml, 'name'),
                    'label': xml_get_attr(xml, 'label'),
                    'xml': xml
                    })

    @property
    def ext(self):
        return self.types[self.type]['ext']

    @property
    def is_macro(self):
        return self.type == 'macro'

    @property
    def is_macroset(self):
        return self.type == 'macroset'

    @property
    def is_project(self):
        return self.type == 'project'

    @property
    def is_properties(self):
        return self.type == 'properties'

    @property
    def is_token(self):
        return self.type == 'token'

    @property
    def command_file(self):
        if self.is_macro:
            return self.xml_file[:-4] + '.command'
        else:
            return None

    @property
    def output_filename(self):
        return os.path.join(self.path, quote(self.name) + '.' + self.ext)

    def assemble(self):
        os.makedirs(self.path, exist_ok=True)
        if self.is_macro:
            return self.assemble_macro()
        elif self.is_macroset:
            return self.assemble_macroset()
        elif self.is_project:
            return self.assemble_project()
        elif self.is_properties:
            return self.assemble_properties()
        elif self.is_token:
            return self.assemble_token()

    def assemble_macro(self):
        if not self.is_macro:
            raise TypeError('MTAsset is not a macro, why did you call '
                            'assemble_macro')
        command = open(self.command_file, 'r').read()
        self.xml.getroot().command = DataElement(command)
        zf = zipfile.ZipFile(self.output_filename, 'w')
        zf.writestr('properties.xml', properties_xml)
        contentstring = tostring(self.xml, pretty_print=True).decode()
        zf.writestr('content.xml', contentstring)
        zf.close()

    def assemble_macroset(self):
        if not self.is_macroset:
            raise TypeError('MTAsset is not a macroset, why did you call '
                            'assemble_macroset')
        listxml = Element('list')
        for macro in self.macrolist:
            listxml.append(MTMacro(macro['file'], '').xml.getroot())
        zf = zipfile.ZipFile(self.output_filename, 'w')
        zf.writestr('properties.xml', properties_xml)
        contentstring = tostring(listxml, pretty_print=True).decode()
        zf.writestr('content.xml', contentstring)
        zf.close()

    def assemble_project(self):
        if not self.is_project:
            raise TypeError('MTAsset is not a project, why did you call '
                            'assemble_project')
        root = self.xml.getroot()
        for elem in root.iterchildren():
            if elem.tag == 'token' or elem.tag == 'properties' or elem.tag == 'macro':
                asset = MTAsset(elem.attrib['name'], path=self.path)
                asset.assemble()
            elif elem.tag == 'macroset':
                macrolist = [x.attrib['name'] for x in elem.iterchildren() if x.tag == 'macro']
                asset = MTAsset(*macrolist, name=elem.attrib['name'], path=self.path)
                asset.assemble()
            elif elem.tag == 'project':
                pass
            else:
                log.error('Found unknown tag {} in project file, skipping'.format(elem.tag))

    def assemble_properties(self):
        if not self.is_properties:
            raise TypeError('MTAsset is not a properties, why did you '
                            'call assemble_properties')
        zf = zipfile.ZipFile(self.output_filename, 'w')
        add_directory_to_zipfile(zf, self.name)
        contentstring = tostring(self.xml, pretty_print=True).decode()
        zf.writestr('content.xml', contentstring)
        zf.close()

    def assemble_token(self):
        if not self.is_token:
            raise TypeError('MTAsset is not a token, why did you call '
                            'assemble_token')
        zf = zipfile.ZipFile(self.output_filename, 'w')
        add_directory_to_zipfile(zf, os.path.dirname(self.xml_file))
        root = self.xml.getroot()

        if self.xml.find('macroPropertiesMap') is not None:
            # This is a token, reassemble the macro placeholders
            for i, entry in enumerate(root.macroPropertiesMap.entry):
                # using __dict__ seems like cheating but I'm not
                # confident in all the other ways objectify/lxml gives
                # me to test if the 'macro' is present.
                if 'macro' in entry.__dict__:
                    fn = self.xml_file
                    mn = entry.macro.attrib['name']

                    macrobase = os.path.join(os.path.dirname(fn), mn)
                    command_file = macrobase + '.command'
                    xml_file = macrobase + '.xml'

                    # read the files and reconstruct the macro object
                    macro = objectify.parse(xml_file)
                    command = open(command_file, 'r').read()
                    macro.getroot().command = DataElement(command)

                    # re-create the entry object
                    entry_template = '<entry><int>{}</int>{}</entry>'
                    new_entry = objectify.fromstring(
                        entry_template.format(
                                entry.int.text,
                                tostring(macro).decode()))

                    # replace it in the content.xml
                    root.macroPropertiesMap.entry[i] = new_entry

            contentstring = tostring(self.xml, pretty_print=True).decode()
            zf.writestr('content.xml', contentstring)
            zf.close()

# vim: expandtab tabstop=4
