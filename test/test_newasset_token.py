from docker.MTAssetLibrary.utils import random_string
import sys
sys.path.append('docker')

import os
import pytest
import zipfile
from lxml import objectify
from MTAssetLibrary import maptool_macro_tags as tagset, GetAsset
from MTAssetLibrary import github_url, git_tag_str
from MTAssetLibrary import MacroNameQuote


class Test_MTAsset_Token:
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        mvp = 'test/data/MinViable'
        mvzips = ['MVMacro1.zip', 'MVMacro2.zip', 'MVProps.zip',
                  'MVToken.zip']
        for zf in [os.path.join(mvp, z) for z in mvzips]:
            with zipfile.ZipFile(zf, 'r') as zip_ref:
                zip_ref.extractall(tmpdir)
        test_start_dir = os.getcwd()
        os.chdir(tmpdir)
        try:
            yield
        finally:
            os.chdir(test_start_dir)

# macro/MVMacro1.xml
# macro/MVMacro1.command
# macro/MVMacro2.xml
# macro/MVMacro2.command
# MVProps/content.xml
# MVToken/content.xml
# MVProject.project
# MVProject2.project contains <text>
# MVProject3.project contains <project> subelement

    def test_asset_with_token(self, tmpdir):
        dn = os.path.join(tmpdir, 'MTToken')
        os.makedirs(dn, exist_ok=True)
        fn = os.path.join(dn, 'content.xml')
        with open(fn, 'w') as f:
            f.write('<' + tagset.token.tag + '>')
            f.write('<name>Test-MTToken</name>')
            f.write('</' + tagset.token.tag + '>')
        m = GetAsset(dn)
        assert m.is_properties is False
        assert m.is_project is False
        assert m.is_macro is False
        assert m.is_macroset is False
        assert m.is_token is True
        m.assemble()
        assert os.path.exists('MTToken.rptok')
        os.remove('MTToken.rptok')

        m = GetAsset(fn)
        assert m.is_properties is False
        assert m.is_project is False
        assert m.is_macro is False
        assert m.is_macroset is False
        assert m.is_token is True
        m.assemble()
        assert os.path.exists('MTToken.rptok')

    def test_asset_token(self, tmpdir):
        m = GetAsset('MVToken/content.xml')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.dirname is not None
        assert m.tag == tagset.token.tag

    # that's the basic stuff out of the way... now assemble and extract
    def test_asset_token_assemble(self, tmpdir):
        m = GetAsset('MVToken')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        # assert False, f'{m.whence=}'
        # assert False, f'{m.dirname=}'
        m.assemble()
        assert os.path.exists('MVToken.rptok')

    def test_asset_token_best_name(self, tmpdir):
        m = GetAsset('MVToken')
        assert m is not None
        assert m.best_name() == 'MVToken'
        assert m.best_name_escaped() == 'MVToken'

    def test_asset_token_save_to(self, tmpdir):
        target = 'NewMVToken'
        targetAsset = GetAsset('MVToken')
        targetAsset.assemble()
        assert os.path.exists('MVToken.rptok')
        m = GetAsset('MVToken.rptok')
        assert m is not None
        # m.extract(save_name=target)
        assert m.output_dir == '.'
        assert m.save_to(target) == './' + target

    def test_asset_token_extract(self, tmpdir):
        tdir = 'MVToken'
        tfilename = tdir + '.rptok'
        # we don't come with a pre-assembled token, so assemble one
        targetAsset = GetAsset(tdir)
        targetAsset.assemble()
        assert os.path.exists(tfilename), f'{tfilename} does not exist'
        # The original is in 'MVToken', but the name is
        # 'MVToken+1' so we should have a copy there once extracted
        m = GetAsset(tfilename)
        m.extract()
        # assert False, m.save_to(None, target)
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None  # should this be None?
        assert m.zipfile is not None
        for asset in 'properties.xml', 'content.xml', 'thumbnail', 'thumbnail_large', '1d20.command', '1d20.xml':
            assert os.path.exists(os.path.join(tdir, asset))

    def test_asset_token_extract_with_name(self, tmpdir):
        tdir = 'MVToken'
        tfilename = tdir + '.rptok'
        target = 'NewMVToken'
        targetAsset = GetAsset(tdir)
        targetAsset.assemble()
        assert os.path.exists(tfilename), f'{tfilename} does not exist'
        m = GetAsset(tfilename)
        # assert False, m.save_to(None, target)
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None  # should this be None?
        assert m.zipfile is not None
        m.extract(save_name=target)
        for asset in 'properties.xml', 'content.xml', 'thumbnail', 'thumbnail_large', '1d20.command', '1d20.xml':
            assert os.path.exists(os.path.join(target, asset))

    def test_asset_token_extract_macro_dryrun(self, tmpdir):
        '''When extracting with dryrun, a token should not actually
        be created'''
        newname = random_string()
        macro_name = 'MVToken'
        m = GetAsset(macro_name)
        assert m is not None
        m.assemble(newname)
        n = GetAsset(newname + '.rptok')
        assert n is not None
        assert n.fromdir is not None
        assert n.xmlfile is not None
        assert n.zipfile is not None
        n.assemble(dryrun=True)
        assert not os.path.exists(os.path.join('.', newname))
        should_have = os.path.join('.', newname, 'properties.xml')
        assert not os.path.exists(should_have), f"{should_have} exists when using dryrun"
        macro_xml = os.path.join('.', newname, '1d20.xml')
        assert not os.path.exists(macro_xml), f"{macro_xml} exists when using dryrun"
        macro_cmd = os.path.join('.', newname, '1d20.command')
        assert not os.path.exists(macro_cmd), f"{macro_cmd} exists when using dryrun"

    def test_asset_token_assemble_dryrun(self, tmpdir):
        macro_name = 'MVToken+1'
        m = GetAsset('MVToken')
        assert m is not None
        m.assemble(dryrun=True)
        assert not os.path.exists(macro_name + '.rptok')

    def test_asset_token_assemble_macroPropertiesMap(self, tmpdir):
        tokenname = 'MVToken'
        m = GetAsset(tokenname)
        assert m is not None
        m.assemble()
        n = GetAsset(tokenname + '.rptok')
        assert n is not None
        assert n.xml.find('macroPropertiesMap/entry/macro') is None
        assert n.xml.find('macroPropertiesMap/entry/' + tagset.macro.tag) is not None

    def test_token_assemble_sha_macro(self, tmpdir):
        # Macros should get tagged with comment even in
        # non Lib: tokens.
        tokenname = 'MVToken'
        m = GetAsset(tokenname)
        assert m is not None
        m.assemble('TestToken')
        m = GetAsset('TestToken.rptok')
        assert m is not None
        for entry in m.root.macroPropertiesMap.iterchildren():
            for macro in entry.iterchildren():
                if macro.tag == tagset.macro.tag:
                    assert github_url in macro.command.text

    def test_token_assemble_no_gmname_change(self, tmpdir):
        # TODO this will fail if MVToken ever gets a gmName
        tokenname = random_string()
        m = GetAsset('MVToken')
        assert m is not None
        m.assemble(tokenname)
        m = GetAsset(tokenname + '.' + tagset.token.ext)
        assert m is not None
        assert 'gmName' not in [x.tag for x in m.root.iterchildren()]

    def test_token_assemble_sha_gmname(self, tmpdir):
        tokenname = 'Lib:' + random_string()
        tokennameq = tokenname.replace(':', '-')
        m = GetAsset('MVToken')
        assert m is not None
        m.root.name = objectify.StringElement(tokenname)
        m.assemble(tokennameq)
        m = GetAsset(MacroNameQuote(tokennameq + '.' + tagset.token.ext))
        assert m is not None
        assert 'gmName' in [x.tag for x in m.root.iterchildren()]
        assert m.root.gmName == git_tag_str

    def test_token_extract_sha_gmname_remove(self, tmpdir):
        tokenname = 'Lib:' + random_string()
        tokennameq = tokenname.replace(':', '-')
        m = GetAsset('MVToken')
        assert m is not None
        m.assemble(save_name=tokennameq)
        m = GetAsset(tokennameq + '.' + tagset.token.ext)
        assert m is not None
        m.extract()
        assert os.path.exists(tokennameq)
        assert os.path.isdir(tokennameq)
        assert os.path.exists(os.path.join(tokennameq, 'content.xml'))
        xml = objectify.parse(os.path.join(tokennameq, 'content.xml'))
        assert 'gmName' not in [x.tag for x in xml.getroot().iterchildren()]
