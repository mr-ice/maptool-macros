import os
import zipfile
import datetime
import logging as log
from urllib.parse import quote_plus
from lxml import objectify, etree
from lxml.etree import tostring
from zipfile import ZipFile, ZIP_DEFLATED

fixed_version = '1.6.1'

class Tag:
    """This is a mapping of a filesystem extension to the type of xml tag that 
    file may contain.
    """
    def __init__(self, name, ext, tag):
        self.name = name
        self.ext = ext
        self.tag = tag

class TagSet:
    """This contains different filesystem extensions to the tag found in them"""
    def __init__(self):
        self.macro = Tag('macro', 'mtmacro', 'net.rptools.maptool.model.MacroButtonProperties')
        self.macroset = Tag('macroset', 'mtmacset', 'list')
        self.project = Tag('project', 'project', 'project')
        self.token = Tag('token', 'rptok', 'net.rptools.maptool.model.Token')
        self.properties = Tag('property', 'mtprops', 'net.rptools.maptool.model.CampaignProperties')
        self.campaign = Tag('campaign', 'cmpgn', 'net.rptools.maptool.util.PersistenceUtil_-PersistedCampaign')

    def keys(self):
        """expose the dict keys method"""
        return self.__dict__.keys()

    def items(self):
        """expose the dict items method"""
        return self.__dict__.items()

    def values(self):
        """expose the dict values method"""
        return self.__dict__.values()

    def get(self, name, default=None):
        """expose the dict get method"""
        return self.__dict__.get(name, default)

maptool_macro_tags = TagSet()

# define a properties.xml body for the final .mtmacro assembly
properties_xml = """<map>
  <entry>
    <string>version</string>
    <string>{}</string>
  </entry>
</map>""".format(fixed_version)


def DataElement(content):
    return objectify.DataElement(content, nsmap='', _pytype='')


def MacroNameQuote(name):
    """Quote characters in file names that aren't safe for filesystems, there
    is an overlap here with characters that aren't safe for URLs, so
    we're using an URL quoter"""
    return quote_plus(name, safe='')


def XML2File(to_dir, to_file, xml):
    """using lxml.etree.tostring, write xml to to_dir/to_file"""
    content = tostring(xml, pretty_print=True).decode()
    with open(os.path.join(to_dir, to_file), 'w') as f:
        f.write(content)
        log.info('wrote {} bytes to modified {}'.
                 format(len(content), to_file))


class MTMacro():
    def __init__(self, target, ext):
        self.target = target
        self.extension = ext
        self.xml = None
        self.origxml = None
        self.command = None

        base, ext = os.path.splitext(target)
        self.xmlfile = base + '.xml'
        self.commandfile = base + '.command'

        log.info('loading %s for the macro xml file' % self.xmlfile)
        self.origxml = objectify.parse(self.xmlfile)
        self.xml = objectify.parse(self.xmlfile)
        log.info('loading %s for the macro command file' % self.commandfile)
        self.command = open(self.commandfile).read()
        # reassemble the command into the xml
        self.xml.getroot().command = DataElement(self.command)
        self.label = self.xml.getroot().label
        log.info('got label \"%s\" from the xml' % self.label.text)
        self.label = MacroNameQuote(self.label.text)
        if self.label != self.xml.getroot().label:
            log.info('transformed label to filesystem friendly %s'
                     % self.label)

        self.outputfile = self.label + self.extension

    @property
    def root(self):
        if self.xml:
            return self.xml.getroot()
        else:
            return None

    def save(self):
        if self.xml and self.outputfile:
            log.info('using %s as the output filename' % self.outputfile)

            # then assemble the zipfile
            zf = ZipFile(self.outputfile, mode='w', compression=ZIP_DEFLATED)
            try:
                zf.writestr('content.xml',
                            etree.tostring(self.xml, pretty_print=True))
                zf.writestr('properties.xml', properties_xml)
            finally:
                zf.close()
            print_info(self.outputfile)


def print_info(archive_name):
    log.info("Archive: " + archive_name)
    zf = zipfile.ZipFile(archive_name)
    sum = 0
    count = 0
    log.info("  Length     Date     Time       Name")
    log.info("---------  ---------- --------   ----")
    for info in zf.infolist():
        log.info("{:>9}  {:>19}   {}".format(
            info.file_size,
            datetime.datetime(*info.date_time).__str__(),
            info.filename))
        sum += info.file_size
        count += 1

    log.info("---------                        ----")
    log.info("{:>9}                        {} files".format(sum, count))
