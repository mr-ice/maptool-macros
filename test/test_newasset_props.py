import sys
sys.path.append('docker')

import os
import logging as log
import pytest
import zipfile
from lxml.etree import XMLSyntaxError, tostring
from MTAssetLibrary import maptool_macro_tags as tagset
from MTAssetLibrary import random_string, GetAsset

class Test_MTAsset_Properties:
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        mvp = 'test/data/MinViable'
        mvzips = ['MVMacro1.zip', 'MVMacro2.zip', 'MVProps.zip',
                  'MVToken.zip', 'MVProject.zip', 'MVProject2.zip',
                  'MVProject3.zip', 'MVProps2.zip']
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

    def test_asset_with_distant_properties(self, tmpdir):
        os.chdir('/tmp')
        dn = os.path.join(tmpdir, 'MTProps')
        os.makedirs(dn, exist_ok=True)
        fn = os.path.join(dn, 'content.xml')
        log.info(f'creating empty properties at {fn}')
        with open(fn, 'w') as f:
            f.write('<' + tagset.properties.tag + '>')
            f.write('</' + tagset.properties.tag + '>')
        log.info(f'opening asset at {fn}')
        m = GetAsset(fn)
        assert m.is_properties is True
        assert m.is_project is False
        assert m.is_macro is False
        assert m.is_macroset is False
        assert m.is_token is False
        os.makedirs('output', exist_ok=True)
        m.assemble()
        assert os.path.exists('MTProps.mtprops')
        os.remove('MTProps.mtprops')


    def test_asset_with_properties_dir(self, tmpdir):
        m = GetAsset('MVProps')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.tag == tagset.properties.tag

    def test_asset_with_properties_contentxml(self, tmpdir):
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.tag == tagset.properties.tag

    
    def test_properties_asset_from_dir_equals_xml(self, tmpdir):
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.tag == tagset.properties.tag
        n = GetAsset('MVProps')
        assert n is not None
        assert n.fromdir is not None
        assert n.xmlfile is not None
        assert n.tag == tagset.properties.tag
        assert tostring(m.root) == tostring(n.root)

    def test_properties_asset_assemble(self, tmpdir):
        newname = random_string()
        newfilename = newname + '.' + tagset.properties.ext
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        m.assemble(save_name=newname)
        assert os.path.exists(newfilename), f'{newfilename} was not found'

    def test_properties_append_MTProperties(self, tmpdir):
        newname = random_string()
        newfilename = newname + '.' + tagset.properties.ext
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        m.append(GetAsset('MVProps2'), 'tokenTypeMap', 'entry[string="Second"]')
        m.assemble(save_name=newname)
        assert os.path.exists(newfilename)
        n = GetAsset(newfilename)
        assert n.xml.find('tokenTypeMap/entry[string="Second"]') is not None

    def test_properties_append_string(self, tmpdir):
        newname = random_string()
        newfilename = newname + '.' + tagset.properties.ext
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        m.append('MVProps2', 'tokenTypeMap', 'entry[string="Second"]')
        m.assemble(save_name=newname)
        assert os.path.exists(newfilename)
        n = GetAsset(newfilename)
        assert n.xml.find('tokenTypeMap/entry[string="Second"]') is not None

    def test_properties_append_invalid_string(self, tmpdir):
        newname = random_string()
        fakename = random_string()
        newfilename = newname + '.' + tagset.properties.ext
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        with pytest.raises(FileNotFoundError):
            m.append(fakename, 'tokenTypeMap', 'entry[string="Second"]')
    
    def test_properties_asset_extract(self, tmpdir):
        newname = random_string()
        newfilename = newname + '.' + tagset.properties.ext
        m = GetAsset('MVProps/content.xml')
        assert m is not None
        m.extract(save_name=newname)
        for filename in 'content.xml', 'properties.xml':
            file_exists = os.path.join(newname, filename)
            assert os.path.exists(file_exists), f'{file_exists} does not exist'

        
