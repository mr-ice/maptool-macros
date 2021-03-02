import os
import sys
import shutil
import pytest

sys.path.insert(0, 'docker')
from MTAssetLibrary import GetAsset
# class TestExtract():
#     @pytest.fixture(autouse=True)
#     def setup_method(self, tmpdir):
#         self.origdir = os.getcwd()
#         os.chdir(tmpdir)

#     @pytest.mark.parametrize('token_file',[
#         'test/data/DNDB-Test/BaseToken30957877.rptok',
#         'test/data/DNDB-Test/BaseToken30957978.rptok',
#         'test/data/DNDB-Test/BaseToken30959709.rptok',
#         'test/data/DNDB-Test/BaseToken30960137.rptok',
#     ])
#     def test_token_extract(self, token_file, tmpdir):
#         tokfile = os.path.join(self.origdir, token_file)
        # assert os.path.exists(tokfile), f'{tokfile} does not exist'
        # tok = GetAsset(tokfile)
        # assert tok is not None
        # tok.extract()
        # assert os.path.exists(tok.best_name_escaped())
        # assert os.path.exists(os.path.join(tok.best_name_escaped(), 'content.xml'))
        # assert os.path.exists(os.path.join(tok.best_name_escaped(), 'properties.xml'))
        # assert os.path.exists(os.path.join(tok.best_name_escaped(), 'thumbnail'))
        # assert os.path.exists(os.path.join(tok.best_name_escaped(), 'thumbnail_large'))
