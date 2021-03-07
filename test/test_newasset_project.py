import sys
sys.path.append('docker')

import os
import pytest
import zipfile
import logging as log
from glob import glob
from lxml.etree import Element, tostring
from MTAssetLibrary import maptool_macro_tags as tagset, GetAsset
from MTAssetLibrary import random_string


class Test_MTAsset_Project:
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        test_start_dir = os.getcwd()
        os.chdir(tmpdir)
        mvp = os.path.join(test_start_dir, 'test/data/MinViable')
        mvzips = ['MVMacro1.zip', 'MVMacro2.zip', 'MVProps.zip',
                  'MVToken.zip']
        for zf in [os.path.join(mvp, z) for z in mvzips]:
            with zipfile.ZipFile(zf, 'r') as zip_ref:
                zip_ref.extractall(tmpdir)
        self.source = [
            {'name': random_string(), 'in': ['macroset', 'token']},
            {'name': random_string(), 'in': ['macro', 'text']},
            {'name': random_string(), 'in': ['macroset', 'project']},
            {'name': random_string(), 'in': ['macro', 'text'], 'textname': random_string()},
        ]
        # create a project file with macroset, properties, and token
        p1 = self.source[0]
        p1['filename'] = p1['name'] + '.' + tagset.project.ext
        root = Element('project')
        p1['macrosetname'] = random_string()
        macroset = Element('macroset', name=p1['macrosetname'])
        p1['macrosetfilename'] = p1['macrosetname'] + '.' + tagset.macroset.ext
        macroset.append(Element('macro', name="macro/MVMacro1"))
        macroset.append(Element('macro', name="macro/MVMacro2"))
        root.append(macroset)
        root.append(Element('properties', name="MVProps"))
        root.append(Element('token', name="MVToken"))
        with open(p1['filename'], 'w') as fh:
            fh.write(tostring(root, pretty_print=True).decode())

        # create a project with macro and text (unnamed)
        p2 = self.source[1]
        p2['filename'] = p2['name'] + '.' + tagset.project.ext
        root = Element('project')
        root.append(Element('macro', name="macro/MVMacro1"))
        text = Element('text')
        p2['textbody'] = random_string()
        text.text = p2['textbody'] + '\n'
        root.append(text)
        with open(p2['filename'], 'w') as fh:
            fh.write(tostring(root, pretty_print=True).decode())

        # create a project with macroset and project (referring to #2 above)
        p3 = self.source[2]
        p3['filename'] = p3['name'] + '.' + tagset.project.ext
        root = Element('project')
        p3['macrosetname'] = random_string()
        macroset = Element('macroset', name=p3['macrosetname'])
        self.macrosetfilename = p3['macrosetname'] + '.' + tagset.macroset.ext
        macroset.append(Element('macro', name="macro/MVMacro1"))
        macroset.append(Element('macro', name="macro/MVMacro2"))
        root.append(macroset)
        root.append(Element('project', name=self.source[1]['filename']))
        with open(p3['filename'], 'w') as fh:
            fh.write(tostring(root, pretty_print=True).decode())

        # create a project with macro and text with name
        p4 = self.source[3]
        p4['filename'] = self.source[3]['name'] + '.' + tagset.project.ext
        root = Element('project')
        p4['macrosetname'] = random_string()
        root.append(Element('macro', name="macro/MVMacro2"))
        p4['randomtext'] = random_string()
        p4['textfile'] = random_string() + '.txt'
        text = Element('text', name=p4['textfile'])
        text.text = p4['randomtext'] + '\n'
        root.append(text)
        with open(p4['filename'], 'w') as fh:
            fh.write(tostring(root, pretty_print=True).decode())

        try:
            yield
        finally:
            os.chdir(test_start_dir)

    def test_asset_project(self, tmpdir):
        m = GetAsset(self.source[0]['filename'])
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.xml.find('macroset') is not None
        assert m.xml.find('token') is not None

    def test_asset_project2(self, tmpdir):
        log.info(f'project[1] named {self.source[1]["name"]=} created in {self.source[1]["filename"]=}')
        m = GetAsset(self.source[1]['filename'])
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.xml.find('macro') is not None
        assert m.xml.find('text') is not None

    def test_asset_project3(self, tmpdir):
        m = GetAsset(self.source[2]['filename'])
        assert m is not None
        assert m.fromdir is not None
        assert m.xmlfile is not None
        assert m.zipfile is None
        assert m.xml.find('macroset') is not None
        assert m.xml.find('project') is not None

    def test_asset_project1_assemble(self, tmpdir):
        print(f'in test_asset_project1_assemble with {self.source}')
        m = GetAsset(self.source[0]['filename'])
        assert m is not None
        m.assemble()
        assert os.path.exists('MVToken.' + tagset.token.ext)
        assert os.path.exists('MVProps.' + tagset.properties.ext)
        assert os.path.exists(self.source[0]['macrosetname'] + '.' + tagset.macroset.ext)

    def test_asset_project2_assemble(self, tmpdir):
        m = GetAsset(self.source[1]['filename'])
        assert m is not None
        m.assemble()
        assert os.path.exists('README.txt')
        assert os.path.exists('Minimum+Viable+Macro+1.' + tagset.macro.ext)

    def test_asset_project3_assemble(self, tmpdir):
        # p3 has macroset, project
        # p2 has macro, text
        m = GetAsset(self.source[2]['filename'])
        assert m is not None
        m.assemble()
        assert os.path.exists(self.source[2]['macrosetname'] + '.' + tagset.macroset.ext), f'{glob("*")=}'
        # These files come from Project2
        assert os.path.exists('README.txt')
        assert os.path.exists('Minimum+Viable+Macro+1.' + tagset.macro.ext)

    def test_asset_project4_assemble(self, tmpdir):
        # project 4 has a macro2 and a text with a name
        m = GetAsset(self.source[3]['filename'])
        assert m is not None
        m.assemble()
        assert os.path.exists(self.source[3]['textfile']), f'{glob("*")=}\n\n{self.source=}'
        assert os.path.exists('Minimum+Viable+Macro+2.' + tagset.macro.ext)
