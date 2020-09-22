import os
import random
import string
import lxml
import logging as log
from behave import given, when, then
from docker.asset import MTAsset
import zipfile
from subprocess import Popen, PIPE
from MTAssetLibrary import MacroNameQuote as quote

# the noqa: F811 turns off complaining that the function is redefined.
# In behave, common usage is to use step_impl as the function in each
# step.  They don't have to be, but they also don't have to have unique
# or any other predefined name pattern.

@given('I am using the assembler')  # noqa: F811
def step_impl(context):
    context.asset = MTAsset(context.tokenpath)


@given('I have a test token dir')  # noqa: F811
def step_impl(context):
    assert context.tokenpath is not None
    assert os.path.exists(context.tokenpath)
    assert os.path.isdir(context.tokenpath)
    assert os.path.exists(os.path.join(context.tokenpath, 'content.xml'))
    assert os.path.isfile(os.path.join(context.tokenpath, 'content.xml'))


@given('I have the assemble command')  # noqa: F811
def step_impl(context):
    assert os.path.exists('docker/assemble')
    assert os.access('docker/assemble', os.X_OK)


@when('I assemble that Token')  # noqa: F811
def step_impl(context):
    ## TODO we really want to call the assemble command instead of the
    ## object method.
    context.asset.assemble()


@then('I will have a Token file')  # noqa: F811
def step_impl(context):
    assert os.path.exists(context.asset.output_filename), \
        'RPTok file at {} was not created'.format(context.asset.output_filename)


@then('the Token file will be a zipfile')  # noqa: F811
def step_impl(context):
    assert zipfile.is_zipfile(context.asset.output_filename)


@then('the Token file will contain a content.xml')  # noqa: F811
def step_impl(context):
    context.zipfile = zipfile.ZipFile(context.asset.output_filename)
    context.content_exception = None
    try:
        context.content = context.zipfile.open('content.xml')
    except Exception as e:
        context.content_exception = e
        assert False


@then('the Asset content.xml will be a {tag}')  # noqa: F811
def step_impl(context, tag):
    log.debug('context.content = ' + str(context.content.read()))
    context.content.seek(0,0)
    context.xml = lxml.objectify.parse(context.content)
    assert context.xml.getroot().tag == tag

@when('I assemble that Token specifying output')  # noqa: F811
def step_impl(context):
    context.outputdir = '/tmp/' + ''.join(random.choice(
        string.ascii_letters + string.digits) for i in range(6))
    os.makedirs(context.outputdir)
    context.asset = MTAsset(context.tokenpath, path=context.outputdir)
    context.asset.assemble()


@then('I will have a Token file in the output')  # noqa: F811
def step_impl(context):
    context.rptokout = os.path.join(context.outputdir,
            context.asset.output_filename)
    assert os.path.exists(context.rptokout), \
        'No Token file was created at {}'.format(context.rptokout)


@when('I call assemble without an argument')  # noqa: F811
def step_impl(context):
    p = Popen('./docker/token-assemble', stderr=PIPE,
              stdout=PIPE, close_fds=True)
    context.stdout, context.stderr = p.communicate()


@then('I get an error message about required input')  # noqa: F811
def step_impl(context):
    assert b'arguments are required' in context.stderr


@when('I call assemble on the Token Dir')  # noqa: F811
def step_impl(context):
    p = Popen(['./docker/token-assemble', context.tokenpath],
              stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout, context.stderr = p.communicate()


@then('I will have created a Token file')  # noqa: F811
def step_impl(context):
    assert os.path.exists(context.tokenfilename + '.rptok')


@when('I call assemble on the Token Dir verbosely')  # noqa: F811
def step_impl(context):
    p = Popen(['./docker/token-assemble', context.tokenpath],
              stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout_standard, context.stderr_standard = p.communicate()
    p = Popen(['./docker/token-assemble', '--verbose', context.tokenpath],
              stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout_verbose, context.stderr_verbose = p.communicate()


@then('I should get more verbose output')  # noqa: F811
def step_impl(context):
    assert len(context.stdout_verbose) >= len(context.stdout_standard)
    assert len(context.stderr_verbose) > len(context.stderr_standard)


@then('It builds the token')  # noqa: F811
def step_impl(context):
    assert os.path.exists(context.tokenfilename + '.rptok'), \
        'RPTok file at {} was not created'.format(context.tokenfilename)


@when(u'I call assemble with a Macro name')  # noqa: F811
def step_impl(context):
    log.info('Creating MTAsset with %s' % context.macro1['path'])
    context.asset = MTAsset(context.macro1['path'])
    log.info('Calling assemble on MTAsset(%s)' % context.macro1['path'])
    context.asset.assemble()


@when(u'I call assemble with a Macro XML FileName')  # noqa: F811
def step_impl(context):
    context.asset = MTAsset(context.macro1['xml'])
    context.asset.assemble()


@when(u'I call assemble with a Macro Command File Name')  # noqa: F811
def step_impl(context):
    context.asset = MTAsset(context.macro2['path'] + '.command')
    context.asset.assemble()


@then(u'I should get a mtmacro asset')  # noqa: F811
def step_impl(context):
    ql = quote(context.macro1['label'])
    context.macrofilename = ql + '.mtmacro'
    assert os.path.exists(context.macrofilename), \
	'Macro file expected %s.mtmacro does not exist' % ql


@then(u'that Macro should contain a content.xml')  # noqa: F811
def step_impl(context):
    zf = zipfile.ZipFile(context.macrofilename)
    log.debug('zf.filename = ' + zf.filename)
    # This raises KeyError if content.xml is not there
    context.content = zf.open('content.xml')


@when(u'I call assemble with a Properties directory name')  # noqa: F811
def step_impl(context):
    context.asset = MTAsset(context.propname)
    context.asset.assemble()


@then(u'I should get a mtprops asset')  # noqa: F811
def step_impl(context):
    assert os.path.exists('MVProps.mtprops')


@then(u'that mtprops should contain a content.xml')  # noqa: F811
def step_impl(context):
    zf = zipfile.ZipFile('MVProps.mtprops')
    log.debug('zf.filename = ' + zf.filename)
    # This raises KeyError if content.xml is not there
    context.content = zf.open('content.xml')


@when(u'I call assemble with a Project file name')  # noqa: F811
def step_impl(context):
    log.debug('os.getcwd() = ' + os.getcwd())
    context.asset = MTAsset('MVProject.project')
    context.asset.assemble()
    context.project_contents = open(context.projpath, 'r').read()


@when(u'that Project contains a macroset')  # noqa: F811
def step_impl(context):
    #determine that context.projpath contains a macroset
    assert 'macroset' in context.project_contents


@when(u'that Project contains a token')  # noqa: F811
def step_impl(context):
    assert 'token' in context.project_contents


@when(u'that Project contains a Properties')  # noqa: F811
def step_impl(context):
    assert 'properties' in context.project_contents


@then(u'I should get a macroset file')  # noqa: F811
def step_impl(context):
    assert os.path.exists('MVMacroSet.mtmacset')


@then(u'that macroset should contain a content.xml')  # noqa: F811
def step_impl(context):
    zf = zipfile.ZipFile('MVMacroSet.mtmacset')
    context.content = zf.open('content.xml')


@then(u'I should get a token file')  # noqa: F811
def step_impl(context):
    log.info('context.tokenfilename = ' + context.tokenfilename)
    assert os.path.exists(context.tokenfilename + '.rptok')


@then(u'that token should contain a content.xml')  # noqa: F811
def step_impl(context):
    zf = zipfile.ZipFile(context.tokenfilename + '.rptok')
    context.content = zf.open('content.xml')


@then(u'I should get a properties file')  # noqa: F811
def step_impl(context):
    assert os.path.exists(context.propname + '.mtprops')


@then(u'that properties file should contain a content.xml')  # noqa: F811
def step_impl(context):
    zf = zipfile.ZipFile(context.propname + '.mtprops')
    context.content = zf.open('content.xml')


@when(u'I call assemble with a Project file name and output directory')  # noqa: F811
def step_impl(context):
    log.debug('os.getcwd() = ' + os.getcwd())
    context.outputdir = 'test-output-dir'
    context.asset = MTAsset('MVProject.project', path=context.outputdir)
    context.asset.assemble()
    context.project_contents = open(context.projpath, 'r').read()


@then(u'I should get a macroset file in the output directory')  # noqa: F811
def step_impl(context):
    assert os.path.exists(os.path.join(context.outputdir, 'MVMacroSet.mtmacset'))


@then(u'I should get a token file in the output directory')  # noqa: F811
def step_impl(context):
    assert os.path.exists(os.path.join(context.outputdir, context.tokenfilename + '.rptok'))


@then(u'I should get a properties file in the output directory')  # noqa: F811
def step_impl(context):
    assert os.path.exists(os.path.join(context.outputdir, context.propname + '.mtprops'))


@given(u'I am using the assemble command')  # noqa: F811
def step_impl(context):
    assert os.path.exists('docker/assemble')


@when(u'I call the assemble command with two or more macros as input and an output directory')  # noqa: F811
def step_impl(context):
    p = Popen(['./docker/assemble', context.macro1['path'], context.macro2['path'], '--name',
        context.macrosetRandomName, '--output', context.temp_directory],
        stderr=PIPE, stdout=PIPE, close_fds=True)
    context.stdout, context.stderr = p.communicate()


@then(u'I should get an output directory')  # noqa: F811
def step_impl(context):
    assert os.path.exists(context.temp_directory)
    assert os.path.isdir(context.temp_directory)


@then(u'a named macroset')  # noqa: F811
def step_impl(context):
    ptf = os.path.join(context.temp_directory, context.macrosetRandomName)
    ptf = ptf + '.mtmacset'
    assert os.path.exists(ptf), 'Expected macroset %s does not exist' % ptf
    assert os.path.isfile(ptf), 'Expected macroset %s is not a file' % ptf
