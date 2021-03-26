"""
This is the MTAssetLibrary

Just some helper functions and objects.
"""
import re
import os
import copy
import zipfile
import datetime
import random
import string
import logging as log
from subprocess import Popen, run, PIPE
from urllib.parse import quote_plus
from lxml import objectify, etree
from lxml.etree import tostring
from zipfile import ZipFile, ZIP_DEFLATED

fixed_version = '1.8.3'
github_url = 'https://github.com/mr-ice/maptool-macros/'
dir_sep_re = r'([\\/]+)'


class Tag:
    """
    This is a mapping of a
        object name
        xml tag
        file extension (ext)
    """
    def __init__(self, name, ext, tag):
        self.name = name
        self.ext = ext
        self.tag = tag


class TagSet:
    """This is a collection of Tag objects for ease of lookup"""
    def __init__(self):
        self.macro = Tag('macro', 'mtmacro', 'net.rptools.maptool.model.MacroButtonProperties')
        self.macroset = Tag('macroset', 'mtmacset', 'list')
        self.text = Tag('text', 'txt', 'text')
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


tagset = TagSet()

# define a properties.xml body for the final .mtmacro assembly
properties_xml = """<map>
  <entry>
    <string>version</string>
    <string>{}</string>
  </entry>
</map>""".format(fixed_version)


def GitCmd(cmd):
    cmd = bytes(cmd).split()
    res = run(cmd, stdout=PIPE, stderr=PIPE)
    if res.stdout and b'fatal' not in res.stderr:
        return res.stdout.strip().decode()


def GitShow():
    """Returns all the things we know about git"""
    return {
        'tag': GitTag(),
        'branch': GitBranch(),
        'sha': GitSha(),
        'dirty': GitDirty(),
        'tagref': GitTagRef()
    }


def GitTag():
    """Returns git describe --tags --dirty --abbrev=8 """
    cmd = b'git describe --tags --dirty --abbrev=8'
    return GitCmd(cmd)


def GitTagRef():
    """Returns GitTag after \d-g"""
    tag = GitTag()
    return re.sub('.*\d-g', '', str(tag))


def GitDirty():
    """Returns '-dirty' or None"""
    ret = GitTag()
    if ret and ret.endswith('-dirty'):
        return '-dirty'
    return ''


def GitBranch():
    """Returns current git branch"""
    cmd = b'git rev-parse --abbrev-ref HEAD'
    return GitCmd(cmd) or 'unknown'


def GitSha():
    """Returns sha of current commit"""
    cmd = b'git log -1 --format=%h --abbrev=8'
    return GitCmd(cmd) or 'unknown'


git_tag_str = GitTagRef()
git_comment_str = f'<!-- {github_url} {git_tag_str} -->'


def DataElement(content):
    return objectify.DataElement(content, nsmap='', _pytype='')


def NewElement(content):
    new = objectify.Element(content, nsmap='', _pytype='')
    objectify.deannotate(new, cleanup_namespaces=True)
    return new


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


def objectify_merge(orig, add):
    '''This merges objectify.ObjectifiedObject trees.  Useful
    in flattening nested project xml representations.

    The outer wrapper is here just to make a reference
    copy before calling the internal merge.

    :returns: a copy of orig merged with add'''

    def recurse_merge(add, new, start):
        '''Wrapped to keep anything from using it
        directly, this uses the start as a reference
        to decide what from the add object to put
        into the new object.

        Modifies the new object in place'''

        for child in add.iterchildren():
            log.debug(f'{tostring(child)=} found in add')
            xpath_child = f'{child.tag}[@name="{child.get("name")}"]'

            child_start = start.find(xpath_child)
            if child_start is not None:
                log.debug(f'{tostring(child_start)=} found in start')

            child_new = new.find(xpath_child)
            if child_new is not None:
                log.debug(f'{tostring(child_new)=} found in new')

            if child_start is None:
                log.debug(f'{xpath_child} not found in start, appending to new')
                new.append(copy.deepcopy(child))
            elif child.countchildren() > 0:
                log.debug(f'{tostring(child)=} has children, recursing')
                recurse_merge(child, child_new, child_start)

    start = copy.deepcopy(orig)
    recurse_merge(add, orig, start)
    return orig


def flatten_project(p):
    '''Projects can refer to projects (see doc/Project.md).
    This function is to flatten the current top level with
    all reference projects into one structure.

    :return: copy of p with all <project> elements removed
    and the contents of <project> transcluded.
    '''
    while projects := p.findall('project'):
        for project in projects:
            p.remove(project)
        for project in projects:
            # GetAsset would parse the name but it isn't available
            # have to do this in a hopefully similar way.
            name = project.get('name')
            if os.path.exists(name + '.project'):
                name = name + '.project'
            new = objectify.parse(name).getroot()
            log.debug('recursing into', project.get('name'))
            p = objectify_merge(p, new)
    return p


def add_directory_to_zipfile(zf, directory_name):
    # the asset zip doesn't have directories, so we'll
    # have to be in the directory to load the files.
    savedir = os.getcwd()
    os.chdir(directory_name)
    for f in ('thumbnail', 'thumbnail_large', 'properties.xml'):
        if os.path.exists(f):
            zf.write(f)
            log.debug('write {} ({} bytes) to {}'.format(
                f, os.path.getsize(f), zf.filename))

    for root, dirs, files in os.walk('assets'):
        f"{dirs}"
        for f in files:
            f = os.path.join(root, f)
            zf.write(f)
            log.debug('wrote {} ({} bytes) to {}'.format(
                      f, os.path.getsize(f), zf.filename))
    os.chdir(savedir)


def random_string(length=6):
    what = ''
    chars = string.ascii_letters + string.digits

    for i in range(0, length):
        what += random.choice(chars)

    return what


def basename(string):
    '''Like os.path.basename, but looks for / and \\'''
    parts = re.split(dir_sep_re, string)
    if parts[-1] in ('\\', '/'):
        return ''
    return parts[-1]


def dirname(string):
    '''Like os.path.dirname, but looks for / and \\'''
    parts = re.split(dir_sep_re, string)
    return ''.join(parts[0:-2])


def make_directory_path(path):
    """
    This simply wraps os.makedirs() with a test and logging output
    """
    if not os.path.exists(path):
        log.info("creating directory %s" % path)
        os.makedirs(path, mode=0o755)


def write_macro_files(macro, tofilebase):
    if '/' in tofilebase:
        dir = os.path.dirname(tofilebase)
        if not os.path.exists(dir):
            os.makedirs(dir)
    command = ''
    if 'command' in [x.tag for x in macro.iterchildren()]:
        command = macro.command.text or ''
        del(macro.command)
    log.info(f'extracting {macro.label} to {tofilebase}.xml')
    pattern = f'(<!-- {github_url} [0-9a-z-]+ -->\n?)'
    if match := re.match(pattern, command):
        command = command.replace(match[0], '')
    with open(tofilebase + '.xml', 'w') as fh:
        fh.write(tostring(macro, pretty_print=True).decode())
    with open(tofilebase + '.command', 'w') as fh:
        fh.write(command)


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


def run_assemble(context, *args):
    p = Popen([context.assemble, *args],
              stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout, context.stderr = p.communicate()


def run_extract(context, *args):
    p = Popen([context.extract, *args],
              stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout, context.stderr = p.communicate()
