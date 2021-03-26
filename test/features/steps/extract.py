import sys
sys.path.insert(0, 'docker')

import os
from glob import glob
from behave import given, when, then
from lxml import objectify
from MTAssetLibrary import tagset, random_string, run_extract, run_assemble
from MTAssetLibrary import GetAsset, git_comment_str, github_url


@given(u'I have a sample token')
def step_impl(context):  # noqa: F811
    assert 'token' in context.source
    assert 'rptok' in context.source['token']
    assert len(context.source['token']['rptok']) > 1
    context.tokenfile = context.source['token']['rptok'][1]
    assert os.path.exists(context.tokenfile)


@given(u'I have a sample macro')
def step_impl(context):  # noqa: F811
    assert 'macro' in context.source
    assert len(context.source['macro']) > 1
    assert 'path' in context.source['macro'][0]
    context.macrosrc = context.source['macro'][0]['path']
    assert os.path.exists(context.macrosrc)
    run_assemble(context, context.macrosrc)
    context.macrofile = context.source['macro'][0]['filename'] + '.' + tagset.macro.ext
    assert os.path.exists(context.macrofile)


@given(u'I have a sample macroset')
def step_impl(context):   # noqa: F811
    assert 'macro' in context.source
    assert len(context.source['macro']) > 1
    context.macrosetname = random_string()
    run_assemble(
        context,
        '--name',
        context.macrosetname,
        context.source['macro'][0]['path'],
        context.source['macro'][1]['path']
    )
    context.macrosetfilename = context.macrosetname + '.' + tagset.macroset.ext
    assert os.path.exists(context.macrosetfilename)


@given(u'I have a sample properties')
def step_impl(context):   # noqa: F811
    assert 'props' in context.source
    assert len(context.source['props']) > 1
    context.propsname = os.path.basename(context.source['props'][0])
    run_assemble(
        context,
        os.path.join('src', context.propsname)
    )
    assert b'Error' not in context.stderr, f'{context.stderr=}'
    context.propsfilename = context.propsname + '.' + tagset.properties.ext
    assert os.path.exists(context.propsfilename), f'{context.propsfilename=} does not exist in\ntmpdir = \'{os.getcwd()}\' \n{glob("*")=}\n{glob("src/*")=}\n{context.stdout=}\n{context.stderr=}'


@when(u'I extract a token')
def step_impl(context):   # noqa: F811
    run_extract(context, context.tokenfile)
    context.tokenname = os.path.basename(os.path.splitext(context.tokenfile)[0])
    assert b'Error' not in context.stderr, context.stderr


@then(u'I should get a token directory')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.tokenname), f'{context.tokenname=} does not exist in\ntmpdir = \'{os.getcwd()}\' {glob(".")=}'
    assert os.path.isdir(context.tokenname)


@then(u'I should get a token/content.xml')
def step_impl(context):   # noqa: F811
    context.tokencontent = os.path.join(context.tokenname, 'content.xml')
    assert os.path.exists(context.tokencontent), f'{context.tokencontent=} does not exist in\ntmpdir = \'{os.getcwd()}\' {glob(".")=}'
    assert os.path.isfile(context.tokencontent)


@then(u'I should get a token/properties.xml')
def step_impl(context):   # noqa: F811
    context.tokenprop = os.path.join(context.tokenname, 'properties.xml')
    assert os.path.exists(context.tokenprop), f'{context.tokenprop=} does not exist in\ntmpdir = \'{os.getcwd()}\' {glob(".")=}'
    assert os.path.isfile(context.tokenprop)


@then(u'I should get a token/thumbnail')
def step_impl(context):   # noqa: F811
    assert os.path.exists(os.path.join(context.tokenname, 'thumbnail')), f'thumbnail not in\ntmpdir = \'{os.getcwd()}/{context.tokenname}\''


@then(u'I should get a token/thumbnail_large')
def step_impl(context):   # noqa: F811
    assert os.path.exists(os.path.join(context.tokenname, 'thumbnail_large')), f'thumbnail_large not in\ntmpdir = \'{os.getcwd()}/{context.tokenname}\''


@then(u'I should get a token/assets directory')
def step_impl(context):   # noqa: F811
    assert os.path.exists(os.path.join(context.tokenname, 'assets')), f'assets not in\ntmpdir = \'{os.getcwd()}/{context.tokenname}\''
    assert os.path.isdir(os.path.join(context.tokenname, 'assets')), f'assets not a directory in\ntmpdir = \'{os.getcwd()}/{context.tokenname}\''


@then(u'I should get a macro xml file in the token directory')
def step_impl(context):   # noqa: F811
    assert os.path.exists(os.path.join(context.tokenname, 'Heal.xml')), f'Heal.xml not in {context.tokenname} in \ntmpdir = \'{os.getcwd()}\''


@then(u'I should get a macro command file in the token directory')
def step_impl(context):   # noqa: F811
    context.macrofilename = os.path.join(context.tokenname, 'Heal.command')
    assert os.path.exists(os.path.join(context.macrofilename)), f'{context.macrofilename} not in \ntmpdir = \'{os.getcwd()}/{context.tokenname}\''


@given(u'I have a token with name that starts with \'Lib:\'')
def step_impl(context):   # noqa: F811
    assert 'token' in context.source
    assert 'src' in context.source['token']
    assert len(context.source['token']['src']) > 1
    context.tokenpath = context.source['token']['src'][1]
    context.tokenname = 'Lib:' + random_string()
    m = GetAsset(context.tokenpath)
    assert m is not None
    m.root.name = context.tokenname
    filename = context.tokenname.replace(':', '-')
    m.assemble(filename)
    context.tokenfile = filename + '.' + tagset.token.ext
    assert os.path.exists(context.tokenfile), f'{context.tokenfile} does not exist in \'{os.getcwd()}\''


@given(u'that token has a gmName')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.tokenfile)
    m = GetAsset(context.tokenfile)
    assert m.root.name == context.tokenname
    assert m.root.gmName is not None


@then(u'that token/content.xml should not have a gmName')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.tokenname)
    assert os.path.isdir(context.tokenname)
    contentxml = os.path.join(context.tokenname, 'content.xml')
    assert os.path.exists(contentxml)
    assert 'gmName' not in open(contentxml).read(), f"{contentxml} has gmName\ntmpdir ='{os.getcwd()}'"


@when(u'I extract a macro')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.macrofile)
    run_extract(context, context.macrofile)
    assert b'Error' not in context.stderr


@then(u'I should get a macro directory')
def step_impl(context):   # noqa: F811
    assert os.path.exists('macro')
    assert os.path.isdir('macro')


@then(u'I should get a macro xml file')
def step_impl(context):   # noqa: F811
    assert os.path.exists('macro/' + context.source['macro'][0]['filename'] + '.xml')


@then(u'I should get a macro command file')
def step_impl(context):   # noqa: F811
    context.macrofilename = os.path.join('macro', context.source['macro'][0]['filename'] + '.command')
    assert os.path.exists(context.macrofilename)


@when(u'I extract a macroset')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.macrosetfilename)
    run_extract(context, context.macrosetfilename)
    assert b'Error' not in context.stderr, f"{context.stderr}\ntmpdir = '{os.getcwd()}'"


@then(u'I should get macro xml files')
def step_impl(context):   # noqa: F811
    m1file = os.path.join('macro', context.source['macro'][0]['filename'])
    m2file = os.path.join('macro', context.source['macro'][1]['filename'])
    assert os.path.exists(m1file + '.xml')
    assert os.path.exists(m2file + '.xml')


@then(u'I should get macro command files')
def step_impl(context):   # noqa: F811
    m1file = os.path.join('macro', context.source['macro'][0]['filename'])
    m2file = os.path.join('macro', context.source['macro'][1]['filename'])
    assert os.path.exists(m1file + '.command')
    assert os.path.exists(m2file + '.command')


@when(u'I extract a properties')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.propsfilename)
    run_extract(context, context.propsfilename)
    assert b'Error' not in context.stderr, f"{context.stderr} in \ntmpdir = '{os.getcwd()}'"


@then(u'I should get a properties directory')
def step_impl(context):   # noqa: F811
    assert os.path.exists(context.propsname)
    assert os.path.isdir(context.propsname)


@then(u'I should get a properties/content.xml')
def step_impl(context):   # noqa: F811
    fn = os.path.join(context.propsname, 'content.xml')
    assert os.path.exists(fn), f"{fn} not found in {context.propsname}\ntmpdir = '{os.getcwd()}'"


@then(u'I should get a properties/properties.xml')
def step_impl(context):   # noqa: F811
    fn = os.path.join(context.propsname, 'properties.xml')
    assert os.path.exists(fn), f"{fn} not found in {context.propsname}\ntmpdir = '{os.getcwd()}'"


@given(u'I have a macro asset with github comment')
def step_impl(context):   # noqa: F811
    m = GetAsset(context.macrosrc)
    m.root.command = objectify.StringElement(git_comment_str + '\n' + m.root.command.text)
    context.macroname = random_string()
    m.assemble(context.macroname)
    context.macrofile = context.macroname + '.' + tagset.macro.ext
    assert os.path.exists(context.macrofile)


@then(u'that macro command file should not have a github comment')
def step_impl(context):   # noqa: F811
    fn = context.macrofilename
    assert os.path.exists(fn), f"{fn} not in tmpdir = '{os.getcwd()}'"
    assert github_url not in open(fn).read(), f"{fn} contains {github_url} but should not, tmpdir = '{os.getcwd()}'"


@given(u'I have a token with github comment on a macro')
def step_impl(context):   # noqa: F811
    context.tokensrc = context.source['token']['src'][1]
    context.tokenfile = context.source['token']['rptok'][1]
    content_xml = os.path.join(context.tokensrc, 'content.xml')
    cxml = objectify.parse(content_xml)
    for m in cxml.findall('macroPropertiesMap/entry/' + tagset.macro.tag):
        m.command = objectify.StringElement(git_comment_str + '\n' + m.command.text)
    cxml.write(content_xml, pretty_print=True)
    run_assemble(context, context.tokensrc)
    assert b'Error' not in context.stderr, f"{context.stderr} in\tmpdir = '{os.getcwd()}'"
    # assert False, f"{context.tokenfile} not in tmpdir = '{os.getcwd()}'"


@given(u'I have a token to extract')
def step_impl(context):   # noqa: F811
    # all about propertyMapCI
    assert os.path.exists(context.tokenfile)


@when(u'I extract that token')
def step_impl(context):   # noqa: F811
    run_extract(context, context.tokenfile)
    assert b'Error' not in context.stderr, f"{context.stderr} in '{os.getcwd()}'"


@then(u'I should have a propertyMap xml in the token directory')
def step_impl(context):   # noqa: F811
    context.tokendir = os.path.basename(os.path.splitext(context.tokenfile)[0])
    assert os.path.exists(context.tokendir)
    assert os.path.isdir(context.tokendir)
    propmapfile = os.path.join(context.tokendir, 'propertyMapCI.xml')
    assert os.path.exists(propmapfile), f"{propmapfile} does not exist in '{os.getcwd()}'"


@then(u'the propertyMap on the token content.xml should be empty')
def step_impl(context):   # noqa: F811
    filename = os.path.join(context.tokendir, 'content.xml')
    assert os.path.exists(filename)
    assert os.path.isfile(filename)
    assert 'propertyMapCI' not in open(filename).read()
