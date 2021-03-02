import sys
sys.path.insert(0, 'docker')
import os

import shutil
from behave import fixture, use_fixture
from behave.fixture import use_fixture_by_tag
from zipfile import ZipFile
from shutil import rmtree
import logging as log
import random
import string
from MTAssetLibrary import maptool_macro_tags as tagset

@fixture
def base_rptok(context):
    """This defines a few variables to use in our BDD tests"""
    context.tokenpath = 'BaseToken30957877'
    context.tokenname = 'Base Token 30957877'
    context.tokenfilename = 'Base+Token+30957877.rptok'
    context.tokensrc = 'test/data/DNDB-Test/BaseToken30957877.zip'
    yield context.tokenpath
    try:
        # if we 'assembled' a token, remove it
        os.remove(context.tokenpath + '.rptok')
        os.remove(context.tokenfilename)
    except Exception as e:
        # avoid flake warning for not using e
        if e is not None:
            pass
        pass


@fixture
def base_token(context):
    """This extracts a base token for use by our BDD tests"""
    log.debug("In environment.base_token")
    use_fixture(base_rptok, context)
    log.debug("os.getcwd() = " + os.getcwd())
    log.debug("context.tokenpath = " + context.tokenpath)
    zf = ZipFile(context.tokensrc)
    zf.extractall()
    yield context.tokenpath
    try:
        rmtree(context.tokenpath)
    except Exception as e:
        pass

@fixture
def minviable_token(context):
    """This extracts the minviable token"""
    log.debug("In environment.minviable_token")
    log.debug(f'{os.getcwd()=}')
    context.mvtokensrc = 'test/data/MinViable/MVToken.zip'
    context.mvtokendir = 'MVToken'
    log.debug(f'{context.mvtokensrc=}')
    zf = ZipFile(context.mvtokensrc)
    zf.extractall()
    yield context.mvtokensrc
    try:
        rmtree(context.mvtokendir)
    except Exception as e:
        pass

@fixture
def base_macro1(context):
    """This extracts a minimum viable macro for testing"""
    log.debug("In environment.base_macro")
    context.macro1path = 'macro/MVMacro1'
    context.macro1name = 'MVMacro1'
    context.macro1label = 'Minimum Viable Macro 1'
    context.macro1 = {
        'path': 'macro/MVMacro1',
        'xml': 'macro/MVMacro1.xml',
        'command': 'macro/MVMacro1.command',
        'name': 'MVMacro1',
        'label': 'Minimum Viable Macro 1',
        'qlabel': 'Minimum+Viable+Macro+1',
        'macrofilename': 'Minimum+Viable+Macro+1.mtmacro',
        'src': 'test/data/MinViable/MVMacro1.zip'
        }
    context.macro1src = 'test/data/MinViable/MVMacro1.zip'
    zf = ZipFile(context.macro1['src'])
    zf.extractall()
    yield context.macro1['path']
    if os.path.exists(context.macro1['xml']):
        os.remove(context.macro1['xml'])
    if os.path.exists(context.macro1['command']):
        os.remove(context.macro1['command'])


@fixture
def base_macro2(context):
    """This extracts a minimum viable macro for testing"""
    log.debug("In environment.base_macro")
    context.macro2path = 'macro/MVMacro2'
    context.macro2name = 'MVMacro2'
    context.macro2label = 'Minimum Viable Macro 2'
    context.macro2 = {
        'path': 'macro/MVMacro2',
        'xml': 'macro/MVMacro2.xml',
        'command': 'macro/MVMacro2.command',
        'name': 'MVMacro2',
        'label': 'Minimum Viable Macro 2',
        'qlabel': 'Minimum+Viable+Macro+2',
        'macrofilename': 'Minimum+Viable+Macro+2.mtmacro',
        'src': 'test/data/MinViable/MVMacro2.zip'
        }

    context.macro2src = 'test/data/MinViable/MVMacro2.zip'
    zf = ZipFile(context.macro2['src'])
    zf.extractall()
    yield context.macro2path
    if os.path.exists(context.macro2['xml']):
        os.remove(context.macro2['xml'])
    if os.path.exists(context.macro2['command']):
        os.remove(context.macro2['command'])


@fixture
def base_properties(context):
    """This unpacks the MVProperties"""
    log.debug("In environment.base_properties")
    context.proppath = 'MVProps'
    context.propname = 'MVProps'
    context.propfilename = context.proppath + '.' + tagset.properties.ext
    context.propsrc = 'test/data/MinViable/MVProps.zip'
    zf = ZipFile(context.propsrc)
    zf.extractall()
    yield context.proppath
    if os.path.exists(context.proppath):
        shutil.rmtree(context.proppath)


@fixture
def base_project(context):
    """This creates a project file for testing"""
    use_fixture(base_token, context)
    use_fixture(base_macro1, context)
    use_fixture(base_macro2, context)
    context.projpath = 'MVProject.project'
    context.projname = 'MVProject'
    context.projsrc = 'test/data/MinViable/MVProject.zip'
    zf = ZipFile(context.projsrc)
    zf.extractall()
    yield context.projsrc
    if os.path.exists(context.projpath):
        os.remove(context.projpath)


@fixture
def temp_directory(context):
    """This creates a temporary directory for test output"""
    context.temp_directory = ''.join(random.choice(
        string.ascii_letters + string.digits) for i in range(6))
    context.macrosetRandomName = ''.join(random.choice(
        string.ascii_letters + string.digits) for i in range(6))
    os.makedirs(context.temp_directory)
    yield context.temp_directory
    rmtree(context.temp_directory)

@fixture
def config_env(context):
    """
    Set an environment variable to not use a local
    config.ini
    """
    context.orig_mtasset_config = os.environ.get('MTASSET_CONFIG')
    os.environ['MTASSET_CONFIG'] = '/dev/null'
    yield
    if context.orig_mtasset_config:
        os.environ['MTASSET_CONFIG'] = context.orig_mtasset_config
    else:
        del(os.environ['MTASSET_CONFIG'])


# Why is this so stupid in behave?  fixture should automatically
# register these so we don't have to.   I tried with fixture(name=)
FixtureRegistry = {
    "fixture.base_token": base_token,
    "fixture.base_rptok": base_rptok,
    "fixture.minviable_token": minviable_token,
    "fixture.base_macro1": base_macro1,
    "fixture.base_macro2": base_macro2,
    "fixture.base_properties": base_properties,
    "fixture.base_project": base_project,
    "fixture.temp_directory": temp_directory,
    "fixture.config_env": config_env,
}


def before_tag(context, tag):
    log.debug("In environment.before_tag")
    if tag.startswith('fixture.'):
        return use_fixture_by_tag(tag, context, FixtureRegistry)
