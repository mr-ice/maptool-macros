import os
import sys
import pytest
from glob import glob
from shutil import copy
from lxml import objectify
from lxml.etree import tostring
sys.path.insert(0, 'docker')
from MTAssetLibrary import dirname, basename, flatten_project


class TestUtilities:
    def test_linux_style_dirname(context):
        assert dirname('./DoesNotExist.rptok') == os.path.dirname('./DoesNotExist.rptok')
        assert dirname('./Where/DoesThis.Go') == os.path.dirname('./Where/DoesThis.Go')
        assert dirname('/path/to/DoesNotExist.rptok') == os.path.dirname('/path/to/DoesNotExist.rptok')
        assert dirname('DoesNotExist.rptok') == os.path.dirname('DoesNotExist.rptok')
        assert dirname('junk/that/DoesNotExist.rptok') == os.path.dirname('junk/that/DoesNotExist.rptok')

    def test_windows_style_dirname(context):
        assert dirname('.\\Lib-Foo.rptok') == '.'
        assert dirname('macro\\Junk\\B.rptok') == 'macro\\Junk'
        assert dirname('C:\\Where\\Is\\D') == 'C:\\Where\\Is'

    def test_linux_style_basename(context):
        assert basename('./DoesNotExist.rptok') == os.path.basename('./DoesNotExist.rptok')
        assert basename('./Where/DoesThis.Go') == os.path.basename('./Where/DoesThis.Go')
        assert basename('/path/to/DoesNotExist.rptok') == os.path.basename('/path/to/DoesNotExist.rptok')
        assert basename('DoesNotExist.rptok') == os.path.basename('DoesNotExist.rptok')
        assert basename('junk/that/DoesNotExist.rptok') == os.path.basename('junk/that/DoesNotExist.rptok')
        assert basename('junk/that/') == os.path.basename('junk/that/')
        assert basename('junk/that/.') == os.path.basename('junk/that/.')

    def test_windows_style_basename(context):
        assert basename('.\\Lib-Foo.rptok') == 'Lib-Foo.rptok'
        assert basename('macro\\Junk\\B.rptok') == 'B.rptok'
        assert basename('C:\\Where\\Is\\D') == 'D'
        assert basename('.\\Does\\Not\\Exist.text') == 'Exist.text'
        assert basename('.\\Where\\') == ''

class Test_Utils_in_Tmpdir:
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        test_start_dir = os.getcwd()
        for pf in glob('test/data/Project/*'):
            copy(pf, tmpdir)
        os.chdir(tmpdir)

    def test_project_merge(context, tmpdir):
        assert os.path.exists('alpha.project')
        assert os.path.exists('beta.project')
        assert os.path.exists('gamma.project')
        assert os.path.exists('delta.xml')
        assert os.path.exists('omega.xml')
        proj = objectify.parse('alpha.project').getroot()
        flat = flatten_project(proj)
        assert tostring(flat, pretty_print=True).decode() == open('omega.xml').read()
