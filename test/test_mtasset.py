from docker import MTAssetLibrary
import sys
sys.path.append('docker')

import os
import pytest
import zipfile
import logging as log
from docker.asset import MTAsset
from lxml.etree import XMLSyntaxError

from MTAssetLibrary import DataElement, maptool_macro_tags as tagset

class Test_MTAsset():
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        mvp = 'test/data/MinViable'
        mvzips = ['MVMacro1.zip', 'MVMacro2.zip', 'MVProps.zip',
                  'MVToken.zip', 'MVProject.zip']
        for zf in [os.path.join(mvp, z) for z in mvzips]:
            with zipfile.ZipFile(zf, 'r') as zip_ref:
                zip_ref.extractall(tmpdir)
        test_start_dir = os.getcwd()
        os.chdir(tmpdir)
        try:
            yield
        finally:
            os.chdir(test_start_dir)

    # def test_asset_with_no_args(self):
    #     with pytest.raises(TypeError):
    #         m = MTAsset()

    # def test_asset_with_missing_file(self):
    #     with pytest.raises(FileNotFoundError):
    #         m = MTAsset('Junk')

    # def test_asset_with_non_xml_file(self, tmpdir):
    #     fn = os.path.join(tmpdir, 'Junk.xml')
    #     with open(fn, 'w') as f:
    #         f.write('')
    #     with pytest.raises(XMLSyntaxError):
    #         m = MTAsset(fn)

    # def test_asset_with_non_maptool_xml(self, tmpdir):
    #     fn = os.path.join(tmpdir, 'Junk.xml')
    #     with open(fn, 'w') as f:
    #         f.write('<wonko/>')
    #     m = MTAsset(fn)
    #     assert m.is_macro is False
    #     assert m.is_project is False
    #     assert m.is_macroset is False
    #     assert m.is_token is False
    #     assert m.is_properties is False

    # def test_asset_with_macro_command(self, tmpdir):
    #     fn = os.path.join(tmpdir, 'Junk.command')
    #     with open(fn, 'w') as f:
    #         f.write('')
    #     fn = os.path.join(tmpdir, 'Junk.xml')
    #     with open(fn, 'w') as f:
    #         f.write('<' + tagset.macro.tag + '>')
    #         f.write('  <label>Test</label>')
    #         f.write('</' + tagset.macro.tag + '>')
    #     m = MTAsset(fn)
    #     assert m.is_macro is True
    #     assert m.is_project is False
    #     assert m.is_macroset is False
    #     assert m.is_token is False
    #     assert m.is_properties is False
    #     m.assemble()
    #     assert os.path.exists('./Test.mtmacro')
    #     os.remove('./Test.mtmacro')

    #     m = MTAsset(os.path.join(tmpdir, 'Junk.command'))
    #     assert m.is_macro is True
    #     assert m.is_project is False
    #     assert m.is_macroset is False
    #     assert m.is_token is False
    #     assert m.is_properties is False
    #     m.assemble()
    #     assert os.path.exists('./Test.mtmacro')
    #     os.remove('./Test.mtmacro')

#    def test_asset_with_project(self, tmpdir):
#        assert os.path.exists('MVProps')
#        assert os.path.isdir('MVProps')
#        assert os.path.isfile('MVProps/content.xml')
#        assert os.path.exists('MVToken')
#        assert os.path.isdir('MVToken')
#        assert os.path.isfile('MVToken/content.xml')
#        assert os.path.isfile('macro/MVMacro1.xml')
#        assert os.path.isfile('macro/MVMacro1.command')
#        assert os.path.isfile('macro/MVMacro2.xml')
#        assert os.path.isfile('macro/MVMacro2.command')
#        assert os.path.isfile('MVProject.project')
#        m = MTAsset('MVProject.project')
#        assert m.is_project is True
#        assert m.is_macro is False
#        assert m.is_macroset is False
#        assert m.is_token is False
#        assert m.is_properties is False
#        m.assemble()
#        assert os.path.isfile('MVProps.mtprops')
#        assert os.path.isfile('Test-MTToken.rptok')
#        assert os.path.isfile('MVToken.rptok')
#        assert os.path.isfile('MVMacroSet.mtmacset')

    # def test_asset_with_properties(self, tmpdir):
    #     dn = os.path.join(tmpdir, 'MTProps')
    #     os.makedirs(dn, exist_ok=True)
    #     fn = os.path.join(dn, 'content.xml')
    #     print(fn)
    #     with open(fn, 'w') as f:
    #         f.write('<' + tagset.properties.tag + '>')
    #         f.write('</' + tagset.properties.tag + '>')
    #     m = MTAsset(fn)
    #     assert m.is_properties is True
    #     assert m.is_project is False
    #     assert m.is_macro is False
    #     assert m.is_macroset is False
    #     assert m.is_token is False
    #     os.makedirs('output', exist_ok=True)
    #     m.assemble()
    #     assert os.path.exists('MTProps.mtprops')

    # def test_asset_with_token(self, tmpdir):
    #     dn = os.path.join(tmpdir, 'MTToken')
    #     os.makedirs(dn, exist_ok=True)
    #     fn = os.path.join(dn, 'content.xml')
    #     with open(fn, 'w') as f:
    #         f.write('<' + tagset.token.tag + '>')
    #         f.write('<name>Test-MTToken</name>')
    #         f.write('</' + tagset.token.tag + '>')
    #     m = MTAsset(dn)
    #     assert m.is_properties is False
    #     assert m.is_project is False
    #     assert m.is_macro is False
    #     assert m.is_macroset is False
    #     assert m.is_token is True
    #     m.assemble()
    #     assert os.path.exists('Test-MTToken.rptok')
    #     os.remove('Test-MTToken.rptok')

    #     m = MTAsset(fn)
    #     assert m.is_properties is False
    #     assert m.is_project is False
    #     assert m.is_macro is False
    #     assert m.is_macroset is False
    #     assert m.is_token is True
    #     m.assemble()
    #     assert os.path.exists('Test-MTToken.rptok')

    # def test_asset_with_macroset(self, tmpdir):
    #     macro1 = 'macro/MVMacro1'
    #     macro2 = 'macro/MVMacro2'
    #     basename = 'Test-MTSet'

    #     assert os.path.exists(macro1 + '.xml')
    #     assert os.path.exists(macro1 + '.command')
    #     assert os.path.exists(macro2 + '.xml')
    #     assert os.path.exists(macro2 + '.command')
    #     #os.makedirs('macro', exist_ok=True)
    #     #with open(macro1 + '.xml', 'w') as f:
    #     #    f.write('<' + tagset.macro.tag + '>')
    #     #    f.write('<label>' + os.path.basename(macro1) + '</label>')
    #     #    f.write('</' + tagset.macro.tag + '>')
    #     #with open(macro1 + '.command', 'w') as f:
    #     #    f.write(macro1)
    #     #with open(macro2 + '.xml', 'w') as f:
    #     #    f.write('<' + tagset.macro.tag + '>')
    #     #    f.write('<label>' + os.path.basename(macro2) + '</label>')
    #     #    f.write('</' + tagset.macro.tag + '>')
    #     #with open(macro2 + '.command', 'w') as f:
    #     #    f.write(macro2)

    #     log.info('test_asset_with_macroset os.getcwd = ' + os.getcwd())
    #     m = MTAsset(macro1, macro2, name=basename)
    #     m.assemble()
    #     assert os.path.exists(basename + '.mtmacset')
