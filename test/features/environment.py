import os
from behave import fixture, use_fixture
from behave.fixture import use_fixture_by_tag
from zipfile import ZipFile
from shutil import rmtree
import logging as log

log.debug("In environment.py")


@fixture
def base_rptok(context):
    """This simply defines a base rptok to use in our BDD tests"""
    log.debug("In environment.base_rptok")
    context.tokenpath = 'BaseToken30957877'
    context.tokenname = 'Base Token 30957877'
    context.tokensrc = 'test/data/DNDB-Test/BaseToken30957877.rptok'
    yield context.tokenpath
    try:
        os.remove(context.tokenpath + '.rptok')
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
    # FIXME use extract or previously extracted
    zf = ZipFile(context.tokensrc)
    zf.extractall(path=context.tokenpath)
    yield context.tokenpath
    rmtree(context.tokenpath)


# Why is this so stupid in behave?  fixture should automatically
# register these so we don't have to.
FixtureRegistry = {
    "fixture.base_token": base_token,
    "fixture.base_rptok": base_rptok,
}


def before_tag(context, tag):
    log.debug("In environment.before_tag")
    if tag.startswith('fixture.'):
        return use_fixture_by_tag(tag, context, FixtureRegistry)
