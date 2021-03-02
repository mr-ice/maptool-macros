import sys
sys.path.append('docker')

import os
import logging as log
import pytest
import zipfile
from lxml.etree import XMLSyntaxError, tostring
from MTAssetLibrary import maptool_macro_tags as tagset, GetAsset

class Test_MTAsset_Generic:
    """
    Generic Asset tests, specific tests are in individual
    files/classes
    """
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        mvp = 'test/data/MinViable'
        mvzips = ['MVMacro1.zip', 'MVMacro2.zip', 'MVProps.zip',
                  'MVToken.zip', 'MVProject.zip', 'MVProject2.zip',
                  'MVProject3.zip']
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

    def test_asset_with_no_args(self):
        with pytest.raises(TypeError):
            m = GetAsset()

    def test_asset_with_missing_file(self):
        with pytest.raises(FileNotFoundError):
            m = GetAsset('Junk')

    def test_asset_with_non_xml_file(self, tmpdir):
        fn = os.path.join(tmpdir, 'Junk.xml')
        with open(fn, 'w') as f:
            f.write('')
        with pytest.raises(XMLSyntaxError):
            m = GetAsset(fn)

    def test_asset_with_non_maptool_xml(self, tmpdir):
        fn = os.path.join(tmpdir, 'Junk.xml')
        with open(fn, 'w') as f:
            f.write('<wonko/>')
        m = GetAsset(fn)
        assert m is None
