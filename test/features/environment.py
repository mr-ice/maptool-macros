import os
import sys
import glob
import zipfile
import logging as log
import tempfile
from shutil import rmtree, copy
from behave import fixture as behave_fixture
from behave.fixture import use_fixture_by_tag


FixtureRegistry = {}  # easier to update existing dict
fixture_prefix = 'fixture.'


def before_all(context):
    '''Before anything, do some setup'''
    # -- SET LOG LEVEL: behave --logging-level=ERROR ...
    # on behave command-line or in "behave.ini".
    context.config.setup_logging()
    log.info('Finished setup_logging in before_all')

    # set up a temp directory
    context.projectdir = os.getcwd()
    context.testdir = os.path.join(context.projectdir, 'test', 'data')
    context.tmpdir = tempfile.mkdtemp(
        prefix='behave-',
        suffix=f'-{os.getpid()}')
    os.chdir(context.tmpdir)
    context.assemble = os.path.join(context.projectdir, 'docker', 'assemble')
    context.extract = os.path.join(context.projectdir, 'docker', 'extract')
    context.cleanup = []  # list to remove after _every_ step
    # in that temp directory we should set up the test sources
    # from test/data, and some things to point to them

    # -- ALTERNATIVE: Setup logging with a configuration file.
    # context.config.setup_logging(configfile="behave_logging.ini")


def no_after_all(context):
    '''After everything, do some teardown'''
    log.info(f'in environment.after_all with {context.testdir=}')
    log.info(f'in environment.after_all with {context.projectdir=}')
    os.chdir(context.projectdir)
    rmtree(context.tmpdir, ignore_errors=True)
    log.info(f'in {sys._getframe(  ).f_code.co_name}, removed {context.tmpdir=}')


def fixture(func, *args, **kwargs):
    '''
    This fixture decorator registers the fixture with a library for
    use_fixture_by_tag in before_tag to find it.  I don't know why
    this isn't either the default or built in.
    '''
    FixtureRegistry.update({fixture_prefix + func.__name__: func})
    return behave_fixture(func, *args, **kwargs)

# This is not working yet, it was an attempt to wrap a fixture function to
# log in/out.  Does contain the bit I learned about the name of the current
# function executing.
# def enter_exit(func, *args, **kwargs):
#     log.info(f'Entering environment.{sys._getframe(  ).f_code.co_name}')
#     func(*args, **kwargs)
#     log.info(f'Leaving environment.{sys._getframe(  ).f_code.co_name}')


def before_scenario(context, scenario):
    log.debug(f'Entering environment.{sys._getframe(  ).f_code.co_name} for {scenario=}')
    _prevdir = os.getcwd()
    os.makedirs('src', exist_ok=True)
    os.chdir('src')
    for filename in glob.glob(os.path.join(context.testdir, 'DNDB-Test', '*')):
        if filename.endswith('.zip'):
            zipfile.ZipFile(filename).extractall()
        else:
            copy(filename, '.')
    for filename in glob.glob(os.path.join(context.testdir, 'MinViable', '*')):
        if filename.endswith('.zip'):
            zipfile.ZipFile(filename).extractall()
        else:
            copy(filename, '.')
    # put a little bit of our inventory into
    context.source = {}
    context.source['macro'] = [
        {
            'path': 'src/macro/MVMacro1.xml',
            'filename': 'Minimum+Viable+Macro+1',
        },
        {
            'path': 'src/macro/MVMacro2.xml',
            'filename': 'Minimum+Viable+Macro+2',
        }
    ]
    context.source['token'] = {
        'src': [
            'src/MVToken',
            'src/BaseToken30957877',
        ],
        'rptok': [
            'src/BaseToken30960137.rptok',
            'src/BaseToken30957978.rptok',
            'src/BaseToken30959709.rptok',
            'src/BaseToken30957877.rptok',
            'src/TestComparisonToken.rptok',
        ]
    }
    context.source['props'] = [
        'src/MVProps',
        'src/MVProps2',
    ]
    os.chdir(_prevdir)
    log.debug(f'Leaving environment.{sys._getframe(  ).f_code.co_name} for {scenario=}')


def after_scenario(context, scenario):
    log.debug(f'Entering environment.{sys._getframe(  ).f_code.co_name} for {scenario=}')
    os.chdir(context.tmpdir)
    rmtree('src')
    log.debug(f'Removed src directory from {context.tmpdir}')
    log.debug(f'inspecting {context.cleanup=} for things to remove')
    for pathname in context.cleanup:
        try:
            log.debug(f'removing {pathname}')
            if os.path.isdir(pathname):
                rmtree(pathname, ignore_errors=True)
            else:
                os.remove(pathname)
        except FileNotFoundError:
            pass
    log.debug('Emptying context.cleanup for next run')
    context.cleanup = []
    log.debug(f'Leaving environment.{sys._getframe(  ).f_code.co_name} for {scenario=}')


def before_tag(context, tag):
    '''
    call the fixture by the name of the tag
    '''
    log.debug(f'Entering environment.{sys._getframe(  ).f_code.co_name} for {tag=}')
    if tag.startswith(fixture_prefix):
        return use_fixture_by_tag(tag, context, FixtureRegistry)
    log.debug(f'Leaving environment.{sys._getframe(  ).f_code.co_name} for {tag=}')


@fixture
def test_fixture(context):
    log.debug('setup test_fixture')
    log.debug('creating context.tokenpath')
    context.tokenpath = 'BraveLittleHamster'
    print(f'I created {context.tokenpath=}')
    yield
    log.debug('cleanup test_fixture')
    log.debug('leaving test_fixture')
