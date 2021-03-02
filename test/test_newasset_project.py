import sys
sys.path.append('docker')

import os
import logging as log
import pytest
import zipfile
from lxml.etree import XMLSyntaxError, tostring
from MTAssetLibrary import maptool_macro_tags as tagset, GetAsset

class Test_MTAsset_Project:
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        mvp = 'test/data/MinViable'
        mvzips = ['MVMacro1.zip', 'MVMacro2.zip', 'MVProps.zip',
                  'MVToken.zip', 'MVProject.zip', 'MVProject2.zip',
                  'MVProject3.zip', 'MVProject4.zip']
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

    def test_asset_project(self, tmpdir):
        m = GetAsset('MVProject.project')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.xml.find('macroset') is not None
        assert m.xml.find('token') is not None

    def test_asset_project2(self, tmpdir):
        m = GetAsset('MVProject2.project')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.xml.find('macro') is not None
        assert m.xml.find('text') is not None

    def test_asset_project3(self, tmpdir):
        m = GetAsset('MVProject3.project')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.xml.find('macroset') is not None
        assert m.xml.find('project') is not None

    def test_asset_project1_assemble(self, tmpdir):
        m = GetAsset('MVProject.project')
        assert m is not None
        m.assemble()
        assert os.path.exists('MVToken+1.' + tagset.token.ext)
        assert os.path.exists('MVProps.' + tagset.properties.ext)
        assert os.path.exists('MVMacroSet.' + tagset.macroset.ext)

    def test_asset_project2_assemble(self, tmpdir):
        m = GetAsset('MVProject2.project')
        assert m is not None
        m.assemble()
        assert os.path.exists('README.txt')
        assert os.path.exists('Minimum+Viable+Macro+1.' + tagset.macro.ext)

    def test_asset_project3_assemble(self, tmpdir):
        m = GetAsset('MVProject3.project')
        assert m is not None
        m.assemble()
        # These files come from Project2
        assert os.path.exists('MVProps.' + tagset.properties.ext)
        assert os.path.exists('MVMacroSet.' + tagset.macroset.ext)
        assert os.path.exists('README.txt')
        assert os.path.exists('Minimum+Viable+Macro+1.' + tagset.macro.ext)

    def test_asset_project4_assemble(self, tmpdir):
        # project 4 has a text with a name
        m = GetAsset('MVProject4.project')
        assert m is not None
        m.assemble()
        assert os.path.exists('instructions.txt')
        assert os.path.exists('Minimum+Viable+Macro+1.' + tagset.macro.ext)

    
