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
import sys
import zipfile
import logging as log
from lxml import objectify
from lxml.etree import tostring
from textwrap import wrap

from MTAssetLibrary import DataElement, tokentag, proptag


class MTAsset():
    def __init__(self, *args, **kwargs):
        # directory/
        #           content.xml
        #               root.tag == tokentag
        #               root.tag == proptag
        # directory/
        #           MacroName
        #           MacroName.xml
        #           MacroName.command
        # [...]
        #
        # Name.rptok
        # Name.mtmacro
        # Name.mtmacset
        # Name.mtprops
        self.directory = next(iter(args), None)  # returns args[0] or None
        self.path = kwargs.get('path', '.') or '.'
        self.verbose = kwargs.get('verbose', False)
        self.rptok = os.path.basename(self.directory + '.rptok')
        self.content_file = os.path.join(self.directory, 'content.xml')
        self.output = os.path.join(self.path, self.rptok)

    def assemble(self):
        """Assemble a maptool asset

        inputs:
            target [...]

        params:
            verbose - turn on verbose output (where not using logger)
            path - optional path for the asset to be created

        outputs:
            asset
        """

        if not os.path.isdir(self.directory):
            log.error("\n".join(wrap(
                    "{} could not be found, be careful that it is in "
                    "the current working directory when running "
                    "with docker".format(self.directory))))
            sys.exit()

        if not os.path.isfile(self.content_file):
            log.error("\n".join(wrap(
                    "{}/content.xml does not exist, are you sure this "
                    "is an extracted rptok?"
                    .format(self.directory))))
            sys.exit()

        if os.path.exists(self.path) and not os.path.isdir(self.path):
            log.error("\n".join(wrap(
                    "{} exists and is not a directory, "
                    "aborting".format(self.path))))
            sys.exit()

        if not os.path.exists(self.path):
            os.makedirs(self.path, exist_ok=True)

        xml = objectify.parse(self.content_file)
        content = tostring(xml, pretty_print=True).decode()
        log.debug('content.xml read from file is {} bytes'
                  .format(len(content)))

        # excludefiles will not be picked up from the filesystem later
        excludefiles = ['content.xml']

        # go through content.xml, finding macros labels to pick up the .xml
        # and .command files.  Then open, reassemble, and replace those.
        root = xml.getroot()

        # Tokens will have macro placeholders, but we could be
        # assembling something else.
        if xml.find('macroPropertiesMap') is not None:
            # This is a token, reassemble the macro placeholders
            for i, entry in enumerate(root.macroPropertiesMap.entry):
                # using __dict__ seems like cheating but I'm not
                # confident in all the other ways objectify/lxml gives
                # me to test if the 'macro' is present.
                if 'macro' in entry.__dict__:
                    label = entry.macro.attrib['name']
                    macrobase = os.path.join(self.directory, label)
                    command_file = macrobase + '.command'
                    xml_file = macrobase + '.xml'

                    # identify files so they aren't later added to the zipfile
                    excludefiles.append(label + '.command')
                    excludefiles.append(label + '.xml')

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

        # re-create the rptok as a zipfile
        zf = zipfile.ZipFile(self.output,
                             mode='w',
                             compression=zipfile.ZIP_DEFLATED)

        # add all the elements of the directory that aren't part of the
        # macro extraction.
        savedir = os.getcwd()
        os.chdir(self.directory)
        for root, dirs, files in os.walk('.'):
            for f in files:
                if f not in excludefiles:
                    if root != '.':
                        zf.write(os.path.join(root, f))
                    else:
                        zf.write(f)
                    log.debug('wrote {} ({} bytes) to {}'.format(
                        f,
                        os.path.getsize(os.path.join(root, f)),
                        zf.filename
                        ))
        os.chdir(savedir)

        # now write the final content.xml from the updated xml object we
        # created above.
        contentstring = tostring(xml, pretty_print=True).decode()
        zf.writestr('content.xml', contentstring)
        log.debug('wrote content.xml to zipfile ({} bytes)'.format(
            len(contentstring)))
        if self.verbose:
            # FIXME pull this as a string and send it through logger
            zf.printdir()
