"""
This test the 2021 version of the Maptool Assets
for macros (.mtmacro) and macro sets (.mtmacset)
to see whether we put them together and take them
apart correctly with the new Asset objects.
"""
import sys
sys.path.append('docker')

import os
import pytest
import zipfile
from lxml import objectify
from glob import glob
from MTAssetLibrary import tagset
from MTAssetLibrary import random_string, GetAsset, MTMacroSet
from MTAssetLibrary import github_url


class Test_MTAsset_Macro:
    """
    Test MTAsset/GetAsset with Macros and MacroSets
    """
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        mvp = 'test/data/MinViable'
        for zf in glob(mvp + '/*.zip'):
            with zipfile.ZipFile(zf, 'r') as zip_ref:
                zip_ref.extractall(tmpdir)
        test_start_dir = os.getcwd()
        os.chdir(tmpdir)
        # Create a sample MVMacroSet.mtmacset for
        # the tests to use
        m = GetAsset('macro/MVMacro1.xml')
        n = GetAsset('macro/MVMacro2.xml')
        assert m is not None
        assert m.is_macro
        assert n is not None
        assert n.is_macro
        m.append(n)
        m.assemble(save_name='MVMacroSet')
        try:
            yield
        finally:
            os.chdir(test_start_dir)

    def test_asset_with_macro_command(self, tmpdir):
        fn = os.path.join(tmpdir, 'Junk.command')
        with open(fn, 'w') as f:
            f.write('')
        fn = os.path.join(tmpdir, 'Junk.xml')
        with open(fn, 'w') as f:
            f.write('<' + tagset.macro.tag + '>')
            f.write('  <label>Test</label>')
            f.write('</' + tagset.macro.tag + '>')
        m = GetAsset(fn)
        assert m.is_macro is True
        assert m.is_project is False
        assert m.is_macroset is False
        assert m.is_token is False
        assert m.is_properties is False
        m.assemble()
        assert os.path.exists('./Test.mtmacro')
        os.remove('./Test.mtmacro')
        m = GetAsset(os.path.join(tmpdir, 'Junk.command'))
        assert m.is_macro is True
        assert m.is_project is False
        assert m.is_macroset is False
        assert m.is_token is False
        assert m.is_properties is False
        m.assemble()
        assert os.path.exists('./Test.mtmacro')
        os.remove('./Test.mtmacro')

    def test_macro_with_command_file(self, tmpdir):
        target = 'macro/MVMacro1.command'
        assert os.path.exists(target)
        m = GetAsset(target)
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.tag == tagset.macro.tag

    def test_macro_with_missing_command_file(self, tmpdir):
        target = 'macro/' + random_string() + 'command'
        assert not os.path.exists(target)
        with pytest.raises(FileNotFoundError):
            m = GetAsset(target)
            assert m is not None

    def test_macro_with_missing_xml_file(self, tmpdir):
        target = 'macro/' + random_string() + '.xml'
        assert not os.path.exists(target)
        with pytest.raises(FileNotFoundError):
            m = GetAsset(target)
            assert m is not None

    def test_macro_with_macro1(self, tmpdir):
        m = GetAsset('macro/MVMacro1.xml')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.tag == tagset.macro.tag

    def test_macro_with_macro2(self, tmpdir):
        m = GetAsset('macro/MVMacro2.xml')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.tag == tagset.macro.tag

    def test_macro_assemble_macro1(self, tmpdir):
        # saveperc = 'Minimum%20Viable%20Macro%201'
        # savepath = 'Minimum%2BViable%2BMacro%2B1'
        saveplus = 'Minimum+Viable+Macro+1'
        m = GetAsset('macro/MVMacro1.xml')
        assert m is not None
        m.assemble()
        assert m.best_name_escaped() == saveplus
        assert os.path.exists(saveplus + '.mtmacro'), f'{saveplus + ".mtmacro"} does not exist as expected'

    def test_macro_assemble_macro2(self, tmpdir):
        saveplus = 'Minimum+Viable+Macro+2'
        m = GetAsset('macro/MVMacro2.xml')
        assert m is not None
        m.assemble()
        assert m.best_name_escaped() == saveplus
        assert os.path.exists(saveplus + '.mtmacro'), f'{saveplus+".mtmacro"} does not exist as expected'

    def test_macro_append_macro_object(self, tmpdir):
        newname = random_string()
        newfilename = newname + '.' + tagset.macroset.ext
        m = GetAsset('macro/MVMacro1.xml')
        n = GetAsset('macro/MVMacro2.xml')
        assert m is not None
        assert m.is_macro
        assert n is not None
        assert n.is_macro
        m.append(n)
        # This is a weird one, it doesn't actually change
        # the type of object, just the contents, but since
        # they share the same base object, it works.
        assert m.tag == tagset.macroset.tag
        assert m.is_macroset
        m.assemble(save_name=newname)
        assert os.path.exists(newfilename)
        o = GetAsset(newfilename)
        assert o is not None
        assert o.is_macroset
        assert o.tag == tagset.macroset.tag
        assert type(o) == MTMacroSet
        for tag in [x.tag for x in o.root.iterchildren()]:
            assert tag == tagset.macro.tag

    def test_macro_macroset_append_object(self, tmpdir):
        m = GetAsset('macro/MVMacro1.xml')
        assert m is not None
        o = GetAsset('MVMacroSet.mtmacset')
        assert o is not None
        o.append(m)
        assert o is not None
        # see if o now has two copies of m
        assert len(o.root.findall('./' + tagset.macro.tag)) == 3

    def test_macro_macro_assemble_save_as(self, tmpdir):
        newname = random_string()
        m = GetAsset('macro/MVMacro1.xml')
        assert m is not None
        assert m.xmlfile == 'macro/MVMacro1.xml'
        m.assemble(save_name=newname)
        assert os.path.exists(newname + '.mtmacro')

    def test_macro_macroset_assemble_save_as(self, tmpdir):
        newname = random_string()
        newfilename = newname + '.' + tagset.macroset.ext
        assert os.path.exists('MVMacroSet.mtmacset')
        m = GetAsset('MVMacroSet.mtmacset')
        assert m is not None
        assert m.best_name(newname) == newname
        # assert False, f'{m.xmlfile} is m.xmlfile'
        # assert False, f'{m.dirname} is m.dirname'
        m.assemble(save_name=newname)
        assert os.path.exists(newfilename), f'{newfilename} does not exist'

    # def test_macro_git_sha_comment(self, tmpdir):
    #     macroname = 'macro/MVMacro1'
    #     m = GetAsset(macroname)
    #     assert m is not None
    #     assert github_url in m.root.command.text

    # def test_macroset_git_sha_comment(self, tmpdir):
    #     macrosetname = random_string()
    #     m = GetAsset('macro/MVMacro1')
    #     m.append(GetAsset('macro/MVMacro2'))
    #     m.assemble(macrosetname)
    #     m = GetAsset(macrosetname + '.' + tagset.macroset.ext)
    #     assert m is not None
    #     for macro in m.root.iterchildren():
    #         assert github_url in macro.command.text

    def test_macro_extract_git_sha_remove(self, tmpdir):
        macroname = random_string()
        m = GetAsset('macro/MVMacro1')
        assert m is not None
        m.root.label = objectify.StringElement(macroname)
        m.assemble(save_name=macroname)
        m = GetAsset(macroname + '.' + tagset.macro.ext)
        assert m is not None
        assert m.is_macro
        m.extract()
        assert os.path.exists(f'macro/{macroname}.xml'), f'expected macro/{macroname}.xml in {glob("**/*")=}'
        assert os.path.exists(f'macro/{macroname}.command'), f'{glob("**/*")=}'
