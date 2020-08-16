import os
import zipfile
import datetime
import logging as log
from urllib.parse import quote_plus
from lxml import objectify, etree
from lxml.etree import tostring
from zipfile import ZipFile, ZIP_DEFLATED

fixed_version = '1.6.1'

macrotag = 'net.rptools.maptool.model.MacroButtonProperties'
tokentag = 'net.rptools.maptool.model.Token'
proptag = 'net.rptools.maptool.model.CampaignProperties'

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
    return quote_plus(name, safe=':')


def XML2File(to_dir, to_file, xml):
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
