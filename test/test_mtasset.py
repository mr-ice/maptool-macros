import sys
sys.path.append('docker')

import os
import pytest
import zipfile
from docker.asset import MTAsset
from lxml.etree import XMLSyntaxError

from MTAssetLibrary import DataElement, tokentag, proptag, macrotag

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

    def test_asset_with_no_args(self):
        with pytest.raises(TypeError):
            m = MTAsset()

    def test_asset_with_missing_file(self):
        with pytest.raises(FileNotFoundError):
            m = MTAsset('Junk')

    def test_asset_with_non_xml_file(self, tmpdir):
        fn = os.path.join(tmpdir, 'Junk.xml')
        with open(fn, 'w') as f:
            f.write('')
        with pytest.raises(XMLSyntaxError):
            m = MTAsset(fn)

    def test_asset_with_non_maptool_xml(self, tmpdir):
        fn = os.path.join(tmpdir, 'Junk.xml')
        with open(fn, 'w') as f:
            f.write('<wonko/>')
        m = MTAsset(fn)
        assert m.is_macro is False
        assert m.is_project is False
        assert m.is_macroset is False
        assert m.is_token is False
        assert m.is_properties is False

    def test_asset_with_macro_command(self, tmpdir):
        fn = os.path.join(tmpdir, 'Junk.command')
        with open(fn, 'w') as f:
            f.write('')
        fn = os.path.join(tmpdir, 'Junk.xml')
        with open(fn, 'w') as f:
            f.write('<' + macrotag + '>')
            f.write('  <label>Test</label>')
            f.write('</' + macrotag + '>')
        m = MTAsset(fn)
        assert m.is_macro is True
        assert m.is_project is False
        assert m.is_macroset is False
        assert m.is_token is False
        assert m.is_properties is False
        m.assemble()
        assert os.path.exists('./Test.mtmacro')
        os.remove('./Test.mtmacro')

        m = MTAsset(os.path.join(tmpdir, 'Junk.command'))
        assert m.is_macro is True
        assert m.is_project is False
        assert m.is_macroset is False
        assert m.is_token is False
        assert m.is_properties is False
        m.assemble()
        assert os.path.exists('./Test.mtmacro')
        os.remove('./Test.mtmacro')

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

    def test_asset_with_properties(self, tmpdir):
        dn = os.path.join(tmpdir, 'MTProps')
        os.makedirs(dn, exist_ok=True)
        fn = os.path.join(dn, 'content.xml')
        print(fn)
        with open(fn, 'w') as f:
            f.write('<' + proptag + '>')
            f.write('</' + proptag + '>')
        m = MTAsset(fn)
        assert m.is_properties is True
        assert m.is_project is False
        assert m.is_macro is False
        assert m.is_macroset is False
        assert m.is_token is False
        m.assemble()
        assert os.path.exists('./MTProps.mtprops')

    def test_asset_with_token(self, tmpdir):
        dn = os.path.join(tmpdir, 'MTToken')
        os.makedirs(dn, exist_ok=True)
        fn = os.path.join(dn, 'content.xml')
        with open(fn, 'w') as f:
            f.write('<' + tokentag + '>')
            f.write('<name>Test-MTToken</name>')
            f.write('</' + tokentag + '>')
        m = MTAsset(dn)
        assert m.is_properties is False
        assert m.is_project is False
        assert m.is_macro is False
        assert m.is_macroset is False
        assert m.is_token is True
        m.assemble()
        assert os.path.exists('Test-MTToken.rptok')
        os.remove('Test-MTToken.rptok')

        m = MTAsset(fn)
        assert m.is_properties is False
        assert m.is_project is False
        assert m.is_macro is False
        assert m.is_macroset is False
        assert m.is_token is True
        m.assemble()
        assert os.path.exists('Test-MTToken.rptok')
