#!/usr/bin/env python3
"""
This presents a Maptool Asset Class to assemble or extract
any of our assets.

The asset type is determined by the container.  Either a maptool
asset file which is a zipfile containing a content.xml and other
files, or an xml file with the outer tag matching one of our asset
types.

This class will provide a mechanism to extract macros from some
objects to individual files.  A file for the xml wrapper and a
file for the macro text itself.

Macro and MacroSet objects extract to a generic macro/ directory,
Token macros extract to the Token directory. Campaign Macros
extract to the Campaign directory.
"""

import sys
sys.path.append('docker')
import os
from io import BytesIO
from zipfile import ZipFile, is_zipfile, ZIP_DEFLATED
from lxml import objectify
import lxml
import lxml.etree as etree
import logging as log
from io import StringIO
from .utils import *  # noqa: F403


def GetAsset(*whence, name=None, path=None):
    """Asset Generator

    Load the thing we were given to find out what kind of asset
    it is, then return that asset.
    """
    zf = None
    if len(whence) == 0:
        raise TypeError('GetAsset() missing required argument')
    if len(whence) == 1:
        whence = whence[0]
        if not os.path.exists(whence):
            if os.path.exists(whence + '.xml'):
                whence = whence + '.xml'
            else:
                log.error(f"Cannot create an asset, {whence} not found.")

        # find the xml file
        # if we were given a zipfile, load the zipfile and content.xml
        # to find out what we are. If we were loaded from another type
        # of file we find and load the xml.
        if is_zipfile(whence):
            zf = ZipFile(whence)
            content_xml = zf.open('content.xml')
        elif os.path.isdir(whence):
            content_xml = open(os.path.join(whence, 'content.xml'))
        elif whence.endswith('.command'):
            # if we were given a .command we switch whence to
            # the corresponding .xml and open _that_
            whence = os.path.splitext(whence)[0] + '.xml'
            content_xml = open(whence)
        elif os.path.exists(whence + '.project'):
            content_xml = open(whence + '.project')
        else:
            content_xml = open(whence)

        xml = objectify.parse(content_xml)

        if xml.getroot().tag == tagset.macro.tag:
            return MTMacroObj(whence, zf, content_xml.name, xml, name, path)
        if xml.getroot().tag == tagset.macroset.tag:
            return MTMacroSet(whence, zf, content_xml.name, xml, name, path)
        if xml.getroot().tag == tagset.token.tag:
            return MTToken(whence, zf, content_xml.name, xml, name, path)
        if xml.getroot().tag == tagset.properties.tag:
            return MTProperties(whence, zf, content_xml.name, xml, name, path)
        if xml.getroot().tag == tagset.campaign.tag:
            return MTCampaign(whence, zf, content_xml.name, xml, name, path)
        if xml.getroot().tag == tagset.project.tag:
            return MTProject(whence, zf, content_xml.name, xml, name, path)
    else:
        """The only allowed asset from a list is a MacroSet
        """
        w = whence[0]
        if not os.path.exists(w):
            if os.path.exists(w + '.xml'):
                w = w + '.xml'

        content_xml = open(w)
        xml = objectify.parse(content_xml)
        asset = MTMacroObj(w, zf, content_xml.name, xml, name, path)
        for w in whence[1:]:
            asset.append(GetAsset(w))
        return asset


class MTAsset:
    """
    A MapTool Asset class
    """
    def __init__(self, whence, zf=None, xmlfile=None, xml=None, name=None, path=None):
        self.whence = whence  # file or directory this object loads
        self.zipfile = zf  # zipfile object if whence is a zipfile
        self.xmlfile = xmlfile  # path to xml file opened in GetAsset
        self.xml = xml  # xml object
        self.given_name = name  # output file prefix for saves
        self.output_dir = path or '.'  # output directory prefix for saves

    @property
    def fromdir(self):
        if os.path.isdir(self.whence):
            return self.whence
        else:
            return dirname(self.xmlfile)

    @property
    def _loaded_from(self):
        if is_zipfile(self.whence):
            return 'assetTypeFile'
        if os.path.isdir(self.whence):
            if os.path.isfile(os.path.join(self.whence, 'content.xml')):
                return 'directoryWithContentFile'
        if os.path.isfile(self.whence):
            return self.whence + 'File'
        return None

    @property
    def tag(self):  # return tag from xml
        """
        Return the current object's outer tag (xml name of the object)
        """
        return self.root.tag

    @property
    def is_token(self):  # tag matches token tag
        """
        Return True if the tag matches a token tag
        """
        return self.tag == tagset.token.tag

    @property
    def is_properties(self):  # tag matches properties tag
        """
        Return True if the tag matches a properties tag
        """
        return self.tag == tagset.properties.tag \
            or self.tag == 'campaignProperties'

    @property
    def is_macroset(self):  # tag matches macro set tag
        """
        Return True if the tag matches a macro set tag
        """
        return self.tag == tagset.macroset.tag

    @property
    def is_project(self):  # tag matches project tag
        """
        Return True if the tag matches a project tag
        """
        return self.tag == tagset.project.tag

    @property
    def is_macro(self):  # tag matches macro tag
        """
        Return True if the tag matches a macro tag
        """
        return self.tag == tagset.macro.tag

    @property
    def is_campaign(self):  # tag matches campaign tag
        """
        Return True if the tag matches a campaign tag
        """
        return self.tag == tagset.campaign.tag

    @property
    def isasset_type(self):  # return tag object with ext, name, tag
        """
        Returns the Tag Type of the current object, the Tag
        contains a .ext, .name, and .tag attribute.
        """
        if self.is_token:
            return tagset.token
        if self.is_macroset:
            return tagset.macroset
        if self.is_properties:
            return tagset.properties
        if self.is_project:
            return tagset.project
        if self.is_macro:
            return tagset.macro
        if self.is_campaign:
            return tagset.campaign
        return None

    @property
    def root(self):  # root element from xml
        """
        Return the root element in the xml for this object
        """
        return self.xml.getroot()

    @property
    def _from_dir(self):  # return true if whence is a directory
        return os.path.isdir(self.whence)

    @property
    def dirname(self):  # return directory of the xmlfile (naively)
        return dirname(self.xmlfile)

    @property
    def name(self):
        """
        Figure out the name of this object based on the file
        or attributes.  Each type of object may or may not have
        a name in a different place.

        If the object does not normally have a name, we can
        try to discover them from the filesystem name.

        This is the base object, which has a default name strategy.
        """
        if self.whence.endswith('content.xml'):

            return basename(dirname(self.whence))
        elif os.path.isdir(self.whence):
            return basename(self.whence)
        elif self.whence.endswith(tagset.properties.ext) or \
                self.whence.endswith(tagset.macroset.ext) or \
                self.whence.endswith(tagset.campaign.ext) or \
                self.whence.endswith(tagset.project.ext) or \
                self.whence.endswith(tagset.token.ext):
            return basename(os.path.splitext(self.whence)[0])
        else:
            return 'Generic' + self.isasset_type.name.capitalize()

    def best_name(self, save_name=None):  # return best name from given, set, embedded
        if save_name:
            return save_name
        if self.given_name:
            return self.given_name
        if self.name:
            return str(self.name)
        return 'Generic' + self.isasset_type.name.capitalize()

    def best_name_escaped(self, save_name=None):  # return best_name html escaped
        return MacroNameQuote(self.best_name(save_name))

    def assemble(self, save_name=None, output_dir=None, ext=None, dryrun=False, verbose=False):
        """
        MTAsset.assemble() method

        Returns None

        This will cause the asset to write itself to a file based on the
        maptool asset type.

            <output_dir>/<name>.<ext>

        Keyword Arguments:
        save_name (default None) - temporary change of name to the object (and resulting filename)
        dryrun (default False) - don't actually save anything
        verbose (default False) - print out debugging information normally logged
        """
        # NOTE:  This is the assemble in the base object, it
        # won't be called if overloaded in a specific object
        # so tokens and properties and campaigns can use
        # more appopriate save mechanisms.
        output_dir = output_dir or self.output_dir or '.'
        # print(f'{type(output_dir)=}')
        # print(f'{type(self.best_name(save_name))=}')

        save_file = os.path.join(output_dir,
                                 self.best_name(save_name))
        save_file += '.' + (ext or self.isasset_type.ext)
        if not os.path.exists(output_dir) and not dryrun:
            log.debug(f'making directories {output_dir}')
            os.makedirs(output_dir)
        log.debug(f'.save: opening {save_file} for output')
        if not dryrun:
            self._assemble_to(save_file)

    def _assemble_to(self, save_file):
        return self._assemble_objects(
            save_file,
            self.is_token or self.is_properties,
            not self.is_token and not self.is_properties)

    def _assemble_objects(self, save_file, directory=False, properties=False):
        """MTProperties._assemble_objects()
        Do the act of creating the zipfile, assuming
        we have figured out things elsewhere.
        """
        zf = ZipFile(save_file, mode='w', compression=ZIP_DEFLATED)
        if directory:
            # if we loaded from an xmlfile the directory is the
            # parent of that xmlfile, if we loaded from a directory
            # it is that directory, and otherwise it is probably
            add_directory_to_zipfile(zf, self.dirname or self.best_name_escaped())
        zf.writestr('content.xml',
                    etree.tostring(self.xml, pretty_print=True))
        if properties:
            zf.writestr('properties.xml', properties_xml)
        return zf

    def save_to(self, save_name=None, output_dir=None):
        default_dir = '.'
        if self.is_macro:
            default_dir = 'macro'
        output_dir = output_dir or self.output_dir or default_dir
        # output_dir = MacroNameQuote(output_dir)
        save_name = self.best_name_escaped(save_name)
        return os.path.join(output_dir, save_name)

    def extract(self, save_name=None, output_dir=None, dryrun=None, verbose=None):
        """
        MTAsset.extract() method

        Returns None


        This will cause the asset to write itself to a directory and/or files based on the type:
            <save_name|Objec

        Keyword Arguments
        save_name (default object_name) - temporary change of name to the object (and resulting directory)
        dryrun (default None) - don't actually save anything
        verbose (default None) - print out debugging information normally logged
        """
        # Properties, Campaigns uses this
        output_path = self.save_to(save_name, output_dir)
        if not dryrun:
            make_directory_path(output_path)

        # what if we didn't assemble yet? we have to write
        # a file in memory.
        if self.zipfile is None:
            self.zipfile = self._assemble_to(BytesIO())
        # extract all the files from the zipfile into the directory
        log.info(f"extracting {self.best_name} to {output_path}")
        if not dryrun:
            self.zipfile.extractall(output_path)


class MTCampaign(MTAsset):
    pass


class MTProperties(MTAsset):

    def append(self, new, collection, xpath):
        """
        Properties are several lists of things
        <tokenTypeMap><entry>/ent[...]
        <remoteRepositoryList/>
        <lightSourcesMap><entry>[...]
        <lookupTableMap/>
        <sightTypeMap><entry>[...]
        <tokenStates><entry>[...]
        <tokenBars><entry>[...]
        <characterSheets><entry>[...]
        """
        # we have to assume collection/xpath to find elements
        # and we will append them to collection
        if collection not in xpath:
            xpath = os.path.join(collection, xpath)

        if type(new) == str:
            new = GetAsset(new)
        if type(new) == MTProperties:
            found = new.root.find(xpath)
            if found is not None:
                self.root.find(collection).append(found)
            else:
                log.warning(f'{xpath} not found in {self.name}')


class MTToken(MTAsset):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.gitTagElement = 'gmName'
        self.gitTagElementWhenNameMatches = 'Lib:'

        if self.fromdir != '':
            # When picking up files from the filesystem, make sure to pick
            # up some of the elements we split out on extract.
            macrofiles = []
            for fn in os.listdir(self.fromdir):
                if fn == 'propertyMapCI.xml':
                    propmapfile = os.path.join(self.fromdir, fn)
                    propmap = objectify.parse(propmapfile).getroot()
                    if (pmap := self.root.find('propertyMapCI')) is not None:
                        self.root.remove(pmap)
                    self.root.append(propmap)
                elif fn in ('content.xml', 'properties.xml'):
                    pass  # handled differently
                elif fn.endswith('.xml'):
                    macrofiles.append(fn)

            if macrofiles:
                E = objectify.ElementMaker(annotate=False)
                if (mpm := self.xml.find('macroPropertiesMap')) is not None:
                    mpm.getparent().remove(mpm)
                count = 1
                macroPropertiesMap = E.macroPropertiesMap()
                for macro in macrofiles:
                    macro = GetAsset(os.path.join(self.fromdir, macro))
                    macro.root.index = DataElement(count)
                    new_entry = E.entry(E.int(count), macro.root)
                    macroPropertiesMap.append(new_entry)
                    count = count + 1
                self.root.macroPropertiesMap = macroPropertiesMap


    def assemble(self, save_name=None, output_dir=None, ext=None, dryrun=None, gitTagElement=None):
        """MTToken.assemble()

        Keyword Arguments:
        save_name
        output_dir
        ext
        dryrun
        verbose
        """
        log.info('MTToken.assemble called')
        if not output_dir:
            output_dir = self.output_dir or '.'
        if not os.path.exists(output_dir) and not dryrun:
            log.debug(f'making directories {output_dir}')
            os.makedirs(output_dir)
        save_file = os.path.join(output_dir,
                                 self.best_name_escaped(save_name))
        save_file += '.' + (ext or self.isasset_type.ext)
        log.debug(f'{save_file=}')
        if not dryrun:
            zf = ZipFile(save_file, mode='w', compression=ZIP_DEFLATED)
            add_directory_to_zipfile(zf, self.dirname)
        if gitTagElement is None:
            gitTagElement = self.gitTagElement
        if self.root.name.text.startswith(self.gitTagElementWhenNameMatches):
            self.root[gitTagElement] = DataElement(git_tag_str)
        if not dryrun:
            try:
                zf.writestr('content.xml',
                            etree.tostring(self.xml, pretty_print=True))
            finally:
                zf.close()

    def extract(self, save_name=None, output_dir=None, dryrun=None):
        """MTToken.extract()

        Keyword Arguments:
        save_name (None) - use this name instead of the name when loaded
        output_dir (None) - put the extracted Token in this path prefix
        dryrun (None) - don't actually do anything
        """
        # make the directory
        # extract the files from the zipfile into the directory
        #   exclude or plan to overwrite the content.xml
        # go through the content.xml, extracting the macros and leaving
        #   a placeholder
        # write the modified content.xml

        # make the directory if needed
        output_path = self.save_to(save_name, output_dir)
        if not dryrun:
            make_directory_path(output_path)

        # extract all the files from the zipfile into the directory
        log.info(f"extracting {self.best_name} to {output_path}")
        if not dryrun:
            self.zipfile.extractall(output_path)

        # extract macros to individual .xml and .command files, removing
        # the macroPropertiesMap from the token
        for i, entry in enumerate(self.root.macroPropertiesMap.entry):
            macro = entry[tagset.macro.tag]
            macro.remove(macro['index'])
            label = MacroNameQuote(macro.label.text)
            macrobase = os.path.join(output_path, label)
            if not dryrun:
                write_macro_files(macro, macrobase)

        self.root.remove(self.root.macroPropertiesMap)

        # extract the propertyMapCI to its own file, removing it from
        # the content.xml
        if not dryrun:
            if (propmap := self.root.find('propertyMapCI')) is not None:
                propmap.getparent().remove(propmap)
                with open(os.path.join(output_path, 'propertyMapCI.xml'), 'w') as fh:
                    fh.write(tostring(propmap, pretty_print=True).decode())

                
        # remove the gitTagElement on extract
        if self.root.name.text.startswith(self.gitTagElementWhenNameMatches):
            for ename in ('gmName', 'label', self.gitTagElement):
                if (elem := self.root.find(ename)) is not None:
                    self.root.remove(elem)


        if not dryrun:
            if 'Lib:' in self.root.name.text and 'gmName' in [x.tag for x in self.root.iterchildren()]:
                del(self.root.gmName)
            XML2File(output_path, 'content.xml', self.xml)


class MTMacroSet(MTAsset):
    @property
    def name(self):
        return basename(os.path.splitext(self.whence)[0])

    def append(self, thing):
        """
        append a MTMacroObj by root
        append a lxml.etree._ElementTree by getroot()
        append a str by MTMacroObj(str).root
        else try to append a thing (should be lxml.etree._Element)
        """
        if type(thing) == MTMacroObj:
            self.root.append(thing.root)
        elif type(thing) == lxml.etree._ElementTree:
            self.root.append(thing.getroot())
        elif type(thing) == str:
            self.root.append(GetAsset(thing).root)
        elif type(thing) == lxml.etree._Element:
            self.root.append(thing)
        else:
            log.error("Couldn't append, invalid type")

    def extract(self, *args, **kwargs):
        '''MTMacroSet.extract()

        extract the macros into the macro directory
        '''
        for macro in self.root.iterchildren():
            macro_base = 'macro/' + MacroNameQuote(macro.label.text)
            write_macro_files(macro, macro_base)


class MTMacroObj(MTAsset):
    def __init__(self, *args, **kwargs):
        # whence, zf=None, xmlfile=None, xml=None, name=None, path=None):
        super().__init__(*args, **kwargs)
        # self.whence = whence # file or directory this object loads
        # self.zipfile = zf # zipfile object if whence is a zipfile
        # self.xmlfile = xmlfile # path to xml file opened in GetAsset
        # self.xml = xml # xml object
        # self.given_name = name # output file prefix for saves
        # self.output_dir = path # output directory prefix for saves

        # Special for MacroObjects loaded from xml files on disk
        # is to reassemble the extracted command file
        if not self._loaded_from == 'assetTypeFile':
            log.info('loading %s for the macro xml file' % self.whence)
            log.info('loading %s for the macro command file' % self.command_file)
            # command = git_comment_str + '\n' + open(self.command_file).read()
            command = open(self.command_file).read()
            # reassemble the command into the xml
            self.root.command = DataElement(command)

    @property
    def command_file(self):
        return os.path.splitext(self.whence)[0] + '.command'

    @property
    def name(self):
        """
        Macros have a label, return that for name
        """
        return self.root.label.text

    def assemble(self, save_name=None, output_dir=None, ext=None, dryrun=None, verbose=None):
        """MTMacroObj.assemble()

        write the macro object to <output_dir>/<save_name>.<ext>

        Keyword Arguments:
        save_name - the base name of the output file, defaults to the label
        output_dir - a directory for the output file, defaults to '.'
        ext - a new extension, defaults to mtmacro for MTMacroObj
        dryrun - if True, don't create anything, just log what you would do
        verbose - turn up logging to 'debug' for this run only
        """
        if not output_dir:
            output_dir = self.output_dir or '.'
        # print(f'{type(output_dir)=}')
        # print(f'{type(self.best_name(save_name))=}')
        if not os.path.exists(output_dir) and not dryrun:
            log.debug(f'making directories {output_dir}')
            os.makedirs(output_dir)
        save_file = os.path.join(output_dir,
                                 self.best_name_escaped(save_name))
        save_file += '.' + (ext or self.isasset_type.ext)

        log.debug(f'.save: opening {save_file} for output')
        if not dryrun:
            zf = ZipFile(save_file, mode='w', compression=ZIP_DEFLATED)
            try:
                zf.writestr('content.xml',
                            etree.tostring(self.xml, pretty_print=True))
                zf.writestr('properties.xml', properties_xml)
            finally:
                zf.close()
            print_info(save_file)

    def append(self, new):
        """
        Appending to a macro should convert us to a macroset
        object, at least the object should identify as such
        and assemble should create a .mtmacset object (currently
        the latter is true, it doesn't actually cast us to the
        MTMacroSet object)
        """
        if self.is_macro:
            # this replaces the current object's xml with a new one, wrapping
            # our macro in a list for extending.
            newxml = objectify.parse(StringIO('<' + tagset.macroset.tag + '/>'))
            newxml.getroot().append(self.root)
            self.xml = newxml
        if type(new) == MTMacroObj:
            self.root.append(new.root)

    def extract(self, save_name=None, output_dir=None, dryrun=None):
        """
        MTMacroObj.extract() method

        Returns None

        This will cause the macro to write itself to a macro directory as MacroName.xml and MacroName.command

        Keyword Arguments
        save_name (default object_name) - temporary change of name to the object (and resulting files)
        dryrun (default None) - don't actually save anything
        """
        # Properties, Campaigns uses this
        output_path = output_dir or 'macro'
        if not dryrun:
            make_directory_path(output_path)

        # what if we didn't assemble yet? we have to write
        # a file in memory.
        if self.zipfile is None:
            self.zipfile = self._assemble_to(BytesIO())
        # don't extractall for macros
        basefn = os.path.join(output_path, self.best_name_escaped(save_name))
        if not dryrun:
            write_macro_files(self.root, basefn)


class MTProject(MTAsset):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # glue in flatten_project, note we have to convert from
        # ElementTree to Element and back
        self.xml = flatten_project(self.xml.getroot()).getroottree()

    def extract(self, *args, **kwargs):
        log.warning("Projects are only for assembly")
        return False

    def assemble(self, output_dir=None, dryrun=False, verbose=False):
        """MTProject.assemble() method

        Returns None

        This reads the project xml file and builds
        each of the assets described therein.

        Keyword arguments:
        dryrun (default False) - don't write anything
        verbose (default False) - turn up debugging information
        """
        output_dir = output_dir or self.output_dir
        if not os.path.exists(output_dir) and not dryrun:
            log.debug(f'making directories {output_dir}')
            os.makedirs(output_dir)
        for elem in self.root.iterchildren():
            if elem.tag == 'macroset':
                asset = None
                for macro in elem.iterchildren():
                    if macro.tag != 'macro':
                        continue
                    if asset is None:
                        asset = GetAsset(macro.get('name'))
                    else:
                        asset.append(GetAsset(macro.get('name')))
                if asset is not None:
                    asset.assemble(save_name=elem.get('name'), output_dir=output_dir)
            elif elem.tag == 'text':
                name = elem.get('name', 'README.txt')
                with open(os.path.join(output_dir, name), 'w') as asset:
                    asset.write(elem.text.strip())
            else:
                asset_name = elem.get('name')
                if elem.tag == 'project' and not elem.get('name', '').endswith('.project'):
                    asset_name = elem.get('name') + '.project'
                asset = GetAsset(asset_name)
                if elem.tag == 'token':
                    asset.gitTagElement = elem.get('gitTagElement', 'gmName')
                asset.assemble(output_dir=output_dir)


# junk.project xml file
# Dir/content.xml with net.rptools.maptool.model.CampaignProperties creates a .mtprops
# Dir/content.xml with net.rptools.maptool.model.Token creates a .rptok
# Dir/content.xml with net.rptools.maptool.util.PersistenceUtil_-PersistedCampaign creates a .cmpgn
# Dir/content.xml with list creates a .mtmacset
# *.xml with net.rptools.maptool.model.MacroButtonProperties creates a .mtmacro
