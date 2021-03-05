import sys
sys.path.append('docker')

import os
import pytest
import zipfile
from MTAssetLibrary import maptool_macro_tags as tagset, GetAsset


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
        macro_name = 'MVToken'
        m = GetAsset(macro_name)
        assert m is not None
        m.assemble()
        n = GetAsset(macro_name + '.rptok')
        assert n is not None
        assert n.fromdir is not None
        assert n.xmlfile is not None
        assert n.zipfile is not None
        n.assemble(dryrun=True)
        assert os.path.exists(os.path.join('.', macro_name))
        should_have = os.path.join('.', macro_name, 'properties.xml')
        assert os.path.exists(should_have), f"{should_have} does not exist"
        macro_xml = os.path.join('.', macro_name, '1d20.xml')
        assert not os.path.exists(macro_xml), f"{macro_xml} does not exist, but should"
        macro_cmd = os.path.join('.', macro_name, '1d20.command')
        assert not os.path.exists(macro_cmd), f"{macro_cmd} does not exist, but should"

    def test_asset_token_assemble_dryrun(self, tmpdir):
        macro_name = 'MVToken+1'
        m = GetAsset('MVToken')
        assert m is not None
        m.assemble(dryrun=True)
        assert not os.path.exists(macro_name + '.rptok')

    def test_asset_token_assemble_macroPropertiesMap(self, tmpdir):
        macro_name = 'MVToken'
        m = GetAsset(macro_name)
        assert m is not None
        m.assemble()
        n = GetAsset(macro_name + '.rptok')
        assert n is not None
        assert n.xml.find('macroPropertiesMap/entry/macro') is None
        assert n.xml.find('macroPropertiesMap/entry/' + tagset.macro.tag) is not None