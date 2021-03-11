import sys
sys.path.insert(0, 'docker')

import os
import zipfile
import glob
import logging as log
from lxml.etree import Element, tostring
from MTAssetLibrary import maptool_macro_tags as tagset, random_string
from subprocess import Popen, PIPE
from lxml import objectify
from behave import given, when, then

# the noqa: F811 turns off complaining that the function is redefined.
# In behave, common usage is to use step_impl as the function in each
# step.  They don't have to be, but they also don't have to have unique
# or any other predefined name pattern.


def run_assemble(context, *args):
    p = Popen([context.assemble, *args],
              stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout, context.stderr = p.communicate()


@given('I have a test token dir')
def step_impl(context):  # noqa: F811
    assert 'source' in context, f'{context} does not have source'
    assert 'token' in context.source, f'{context.source} does not have token'
    assert 'src' in context.source['token'], f'{context.source["token"]} does not have src'
    context.tokenpath = context.source['token']['src'][0]  # usually 'src/MVtoken'
    context.tokenfilename = os.path.basename(context.tokenpath) + '.' + tagset.token.ext
    context.cleanup.append(context.tokenfilename)
    assert os.path.exists(context.tokenpath)
    assert os.path.isdir(context.tokenpath)
    assert os.path.exists(os.path.join(context.tokenpath, 'content.xml'))
    log.info(f'inspecting if {context.tokenfilename=} exists {os.path.exists(context.tokenfilename)=}')
    assert not os.path.exists(context.tokenfilename)
    log.info(f'inspecting {context.cleanup=} for things to remove in @given("I have a test token dir")')


@given(u'I have two base macros')
def step_impl(context):  # noqa: F811
    assert 'source' in context, f'{context} does not have source'
    assert 'macro' in context.source, f'{context.source} does not have token'
    context.macropath = context.source['macro'][0]['path']  # usually 'src/macro/MVMacro1.xml'
    context.macrofilename = context.source['macro'][0]['filename'] + '.' + tagset.macro.ext
    context.cleanup.append(context.macrofilename)
    assert os.path.exists(context.macropath)
    assert os.path.isfile(context.macropath)
    assert os.path.exists(context.source['macro'][1]['path'])
    assert os.path.isfile(context.source['macro'][1]['path'])


@given(u'I have a base properties dir')
def step_impl(context):  # noqa: F811
    assert 'source' in context, f'{context} does not have source'
    assert 'props' in context.source, f'{context.source} does not have props'
    context.proppath = context.source['props'][0]  # usually 'src/MVProps'
    context.propfilename = os.path.basename(context.proppath) + '.' + tagset.properties.ext
    assert os.path.exists(context.proppath)
    assert os.path.isdir(context.proppath)
    assert os.path.exists(os.path.join(context.proppath, 'content.xml'))


@given(u'I have a base project file')
def step_impl(context):  # noqa: F811
    assert 'source' in context, f'{context} does not have source'
    assert 'project' in context.source, f'{context.source} does not have project'
    context.projpath = context.source['project'][0]  # usually 'src/MVProject.project'

    assert os.path.exists(context.projpath)
    assert os.path.isfile(context.projpath)


@given('I have the assemble command')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.assemble)
    assert os.access(context.assemble, os.X_OK)


@when('I call the assemble command with that test token dir')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.tokenpath)
    assert b'Error' not in context.stderr, context.stderr


@given(u'I have two or more macros')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.source['macro'][0]['path'])
    assert os.path.exists(context.source['macro'][1]['path'])


@when(u'I call the assemble command with two or more macros as input, a name, and an output directory')
def step_impl(context):  # noqa: F811
    context.macrosetRandomName = random_string()
    context.temp_directory = random_string()
    context.cleanup.append(context.macrosetRandomName)
    context.cleanup.append(context.temp_directory)
    run_assemble(context, context.source['macro'][0]['path'],
                 context.source['macro'][1]['path'],
                 '--name', context.macrosetRandomName,
                 '--output', context.temp_directory)
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get an output directory')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.temp_directory)
    assert os.path.isdir(context.temp_directory)


@then(u'a named macroset')
def step_impl(context):  # noqa: F811
    ptf = os.path.join(context.temp_directory, context.macrosetRandomName)
    context.macrosetfile = ptf + '.mtmacset'
    assert os.path.exists(context.macrosetfile), f'Expected macroset {context.macrosetfile} does not exist.  {os.listdir(context.temp_directory)=}'
    assert os.path.isfile(context.macrosetfile), f'Expected macroset {context.macrosetfile} is not a file'


@then(u'I will have a Token file')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.tokenfilename), f'{os.listdir(".")=}'


@then(u'the Token file will be a zipfile')
def step_impl(context):  # noqa: F811
    assert zipfile.is_zipfile(context.tokenfilename)
    context.zf = zipfile.ZipFile(context.tokenfilename)


@then(u'the Token file will contain a content.xml')
def step_impl(context):  # noqa: F811
    assert 'content.xml' in [x.filename for x in context.zf.filelist]
    context.contentfile = context.zf.open('content.xml')


@then(u'the Asset content.xml will be a "{tag}"')
def step_impl(context, tag):  # noqa: F811
    context.xml = objectify.parse(context.contentfile)
    assert context.xml.getroot().tag == tag


@when(u'I assemble that Token specifying output')
def step_impl(context):  # noqa: F811
    context.temp_directory = random_string()
    run_assemble(context, context.tokenpath, '--output', context.temp_directory)
    assert b'Error' not in context.stderr, context.stderr
    context.tokenfilename = os.path.basename(context.tokenpath) + '.' + tagset.token.ext


@then(u'I will have a Token file in the output')
def step_impl(context):  # noqa: F811
    assert os.path.exists(os.path.join(context.temp_directory, context.tokenfilename))


@when(u'I call assemble without an argument')
def step_impl(context):  # noqa: F811
    run_assemble(context)
    assert b'Error' not in context.stderr, context.stderr


@then(u'I get an error message about required input')
def step_impl(context):  # noqa: F811
    assert b'arguments are required' in context.stderr


@when(u'I call assemble on the Token Dir verbosely')
def step_impl(context):  # noqa: F811
    context.tokenfilename = os.path.basename(context.tokenpath) + '.' + tagset.token.ext
    if os.path.exists(context.tokenfilename):
        os.remove(context.tokenfilename)
    assert not os.path.exists(context.tokenfilename)
    run_assemble(context, context.tokenpath, '--verbose')
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get more verbose output')
def step_impl(context):  # noqa: F811
    assert b"INFO: Verbose output." in context.stderr


@then(u'It builds the Token')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.tokenfilename)


@when(u'I call assemble with a Macro name')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.macropath)
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get a mtmacro asset')
def step_impl(context):  # noqa: F811
    macrofile = context.macrofilename
    assert os.path.exists(macrofile), f'{glob.glob("*.mtmacro")=}'
    context.zf = zipfile.ZipFile(macrofile)


@then(u'that Macro should contain a content.xml')
def step_impl(context):  # noqa: F811
    assert 'content.xml' in [x.filename for x in context.zf.filelist]
    context.contentfile = context.zf.open('content.xml')


@when(u'I call assemble with a Macro XML FileName')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.macropath)
    assert b'Error' not in context.stderr, context.stderr


@when(u'I call assemble with a Macro Command File Name')
def step_impl(context):  # noqa: F811
    context.macrocommand = os.path.splitext(context.macropath)[0] + '.command'
    run_assemble(context, context.macrocommand)
    assert b'Error' not in context.stderr, context.stderr


@when(u'I call assemble with a Properties directory name')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.proppath)
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get a mtprops asset')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.propfilename), f'{context.propfilename} does not exist'


@then(u'the Properties file will be a zipfile')
def step_impl(context):  # noqa: F811
    assert zipfile.is_zipfile(context.propfilename)
    context.zf = zipfile.ZipFile(context.propfilename)


@then(u'that mtprops should contain a content.xml')
def step_impl(context):  # noqa: F811
    assert 'content.xml' in [x.filename for x in context.zf.filelist]
    context.contentfile = context.zf.open('content.xml')


@given(u'I have a Project with MacroSet Token Props')
def step_impl(context):  # noqa: F811
    context.projpath = random_string() + '.project'
    root = Element('project')
    context.macrosetname = random_string()
    macroset = Element('macroset', name=context.macrosetname)
    context.macrosetfilename = context.macrosetname + '.' + tagset.macroset.ext
    macroset.append(Element('macro', name=context.source['macro'][0]['path']))
    macroset.append(Element('macro', name=context.source['macro'][1]['path']))
    root.append(macroset)
    root.append(Element('token', name=context.source['token']['src'][0]))
    root.append(Element('properties', name=context.source['props'][0]))
    context.cleanup.append(context.projpath)
    context.cleanup.append(context.macrosetfilename)
    with open(context.projpath, 'w') as fh:
        fh.write(tostring(root, pretty_print=True).decode())


@when(u'I call assemble with a Project file name')
def step_impl(context):  # noqa: F811
    '''We will create a project file using our context.source
    assets and etree.Element
    '''
    run_assemble(context, context.projpath)
    context.projcontents = open(context.projpath).read()
    assert b'Error' not in context.stderr, f'{context.stderr=} {context.stdout=}'


@when(u'that Project contains a macroset')
def step_impl(context):  # noqa: F811
    assert 'macroset' in context.projcontents


@when(u'that Project contains a token')
def step_impl(context):  # noqa: F811
    assert '<token' in context.projcontents


@when(u'that Project contains a Properties')
def step_impl(context):  # noqa: F811
    assert '<properties' in context.projcontents


@then(u'I should get a macroset file')
def step_impl(context):  # noqa: F811
    context.macrosetfile = context.macrosetfilename
    assert os.path.exists(context.macrosetfile), f'{context.macrosetfile} does not exist after building {context.projpath} with {context.stderr=} and {context.stdout=}'


@then(u'that macroset should contain a content.xml')
def step_impl(context):  # noqa: F811
    zf = zipfile.ZipFile(context.macrosetfile)
    assert 'content.xml' in [x.filename for x in zf.filelist]
    context.contentfile = zf.open('content.xml')


@then(u'the Asset content.xml will be a list')
def step_impl(context):  # noqa: F811
    context.xml = objectify.parse(context.contentfile)
    assert context.xml.getroot().tag == tagset.macroset.tag


@then(u'I should get a token file')
def step_impl(context):  # noqa: F811
    filename = 'MVToken.' + tagset.token.ext
    assert os.path.exists(filename), f'{filename} does not exist'


@then(u'that token should contain a content.xml')
def step_impl(context):  # noqa: F811
    context.tokenfilename = os.path.basename(context.tokenpath) + '.' + tagset.token.ext

    if 'temp_directory' in context:
        context.tokenfilename = os.path.join(context.temp_directory, context.tokenfilename)

    zf = zipfile.ZipFile(context.tokenfilename)
    assert 'content.xml' in [x.filename for x in zf.filelist]
    context.contentfile = zf.open('content.xml')


@then(u'I should get a properties file')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.propfilename)


@then(u'that properties file should be a zipfile')
def step_impl(context):  # noqa: F811
    assert zipfile.is_zipfile(context.propfilename)
    context.zf = zipfile.ZipFile(context.propfilename)


@then(u'that properties file should contain a content.xml')
def step_impl(context):  # noqa: F811
    assert 'content.xml' in [x.filename for x in context.zf.filelist]
    context.contentfile = context.zf.open('content.xml')


@when(u'I call assemble with a Project file name and output directory')
def step_impl(context):  # noqa: F811
    context.temp_directory = random_string()
    assert os.path.exists(context.projpath), f'{context.projpath} does not exist in {os.getcwd()=}'
    run_assemble(context, context.projpath, '--output', context.temp_directory)
    context.projcontents = open(context.projpath).read()
    assert b'Error' not in context.stderr, f'Error found in {context.stderr} when running {context.assemble} {context.projpath} --output {context.temp_directory}'


@then(u'I should get a macroset file in the output directory')
def step_impl(context):  # noqa: F811
    context.macrosetfile = os.path.join(context.temp_directory, context.macrosetname + '.' + tagset.macroset.ext)
    assert os.path.exists(context.macrosetfile), f'{context.macrosetfile} not found in {context.temp_directory} {os.listdir()=} {os.listdir(context.temp_directory)=}'


@then(u'I should get a token file in the output directory')
def step_impl(context):  # noqa: F811
    tokenfile = os.path.join(context.temp_directory, 'MVToken.' + tagset.token.ext)
    assert os.path.exists(tokenfile), f'{tokenfile} not found in {context.temp_directory} {os.listdir()=} {os.listdir(context.temp_directory)=}'


@then(u'I should get a properties file in the output directory')
def step_impl(context):  # noqa: F811
    propfile = os.path.join(context.temp_directory, 'MVProps.' + tagset.properties.ext)
    assert os.path.exists(propfile), f'{propfile} not found in {context.temp_directory} {os.listdir()=} {os.listdir(context.temp_directory)=}'
    context.zf = zipfile.ZipFile(propfile)


@given(u'I start with an extracted Token')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.tokenpath)


@when(u'I assemble that Token')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.tokenpath)
    context.projcontents = open(context.projpath).read()
    assert b'Error' not in context.stderr, context.stderr


@when(u'that token is in a clean checkout')
def step_impl(context):  # noqa: F811
    raise NotImplementedError(u'STEP: When that token is in a clean checkout')


@when(u'that checkout is not based on a Tag')
def step_impl(context):  # noqa: F811
    raise NotImplementedError(u'STEP: When that checkout is not based on a Tag')


@then(u'the assembled token will have a gmName of [hash]')
def step_impl(context):  # noqa: F811
    raise NotImplementedError(u'STEP: Then the assembled token will have a gmName of [hash]')


@then(u'the token\'s macros will have an html comment of "https://github.com/mr-ice/maptool-macros/ [hash]" replacing a previous comment in that format')
def step_impl(context):  # noqa: F811
    raise NotImplementedError(u'STEP: Then the token\'s macros will have an html comment of "https://github.com/mr-ice/maptool-macros/ [hash]" replacing a previous comment in that format')


@given(u'A project with a text element')
def step_impl(context):  # noqa: F811
    context.projpath = random_string() + '.project'
    context.projecttextfile = 'README.txt'
    context.cleanup.append(context.projpath)
    context.cleanup.append(context.projecttextfile)

    root = Element('project')
    text = Element('text')
    context.random_text = text.text = random_string()
    root.append(text)

    with open(context.projpath, 'w') as fh:
        fh.write(tostring(root, pretty_print=True).decode())
    assert os.path.exists(context.projpath)


@when(u'I call the assemble command with the project/text structure')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.projpath)
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get a text file')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.projecttextfile)


@then(u'the text file should contain my content')
def step_impl(context):  # noqa: F811
    assert context.random_text in open(context.projecttextfile).read()


@given(u'A project with a project element')
def step_impl(context):  # noqa: F811
    saveproj = random_string()
    context.projpath = saveproj + '.project'
    context.projecttextfile = random_string() + '.txt'
    context.cleanup.append(context.projpath)
    context.cleanup.append(context.projecttextfile)

    root = Element('project')
    text = Element('text', name=context.projecttextfile)
    context.random_text = random_string()
    text.text = context.random_text + '\n'
    root.append(text)

    with open(context.projpath, 'w') as fh:
        fh.write(tostring(root, pretty_print=True).decode())

    assert os.path.exists(context.projpath)

    context.projpath = random_string() + '.project'
    context.cleanup.append(context.projpath)

    root = Element('project')
    text = Element('project', name=saveproj)
    root.append(text)
    log.info(f'{context.random_text=} up here where it started')
    with open(context.projpath, 'w') as fh:
        fh.write(tostring(root, pretty_print=True).decode())
    assert os.path.exists(context.projpath)


@when(u'I call the assemble command with the project/project structure')
def step_impl(context):  # noqa: F811
    run_assemble(context, context.projpath)
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get a text file from the embedded project')
def step_impl(context):  # noqa: F811
    assert os.path.exists(context.projecttextfile), f'{context.projecttextfile} does not exist'


@then(u'that text file should contain the embedded content')
def step_impl(context):   # noqa: F811
    log.info(f'{os.getcwd()=}')
    log.info(f'{context.projpath=}')
    log.info(f'{context.projecttextfile=}')
    log.info(f'{context.random_text=}')
    assert os.path.exists(context.projecttextfile), f'{context.projecttextfile} missing when looking for missing context'
    # time.sleep(300)
    assert context.random_text in open(context.projecttextfile).read(), f'{context.projecttextfile=} missing {context.random_text=}, {open(context.projecttextfile).read()=}'
