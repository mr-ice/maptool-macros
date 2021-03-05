import os
import sys
import pytest

sys.path.insert(0, 'docker')
from MTAssetLibrary import GetAsset


class TestExtract():
    @pytest.fixture(autouse=True)
    def setup_method(self, tmpdir):
        self.origdir = os.getcwd()
        os.chdir(tmpdir)
        try:
            yield
        finally:
            os.chdir(self.origdir)

    @pytest.mark.parametrize('token_file', [
        'test/data/DNDB-Test/BaseToken30957877.rptok',
        'test/data/DNDB-Test/BaseToken30957978.rptok',
        'test/data/DNDB-Test/BaseToken30959709.rptok',
        'test/data/DNDB-Test/BaseToken30960137.rptok',
    ])
    def test_token_extract(self, token_file, tmpdir):
        tokfile = os.path.join(self.origdir, token_file)
        tokname = os.path.basename(os.path.splitext(token_file)[0])
        assert os.path.exists(tokfile), f'{tokfile} does not exist'
        tok = GetAsset(tokfile)
        assert tok is not None
        tok.extract()
        assert os.path.exists(tokname), f'{tokname} does not exist'
        assert os.path.isdir(tokname), f'{tokname} is not a directory'
        assert os.path.exists(os.path.join(tokname, 'content.xml')), f'content.xml not in {tokname}'
        assert os.path.exists(os.path.join(tokname, 'properties.xml')), f'properties.xml not in {tokname}'
        assert os.path.exists(os.path.join(tokname, 'thumbnail')), f'thumbnail not in {tokname}'
        assert os.path.exists(os.path.join(tokname, 'thumbnail_large')), f'thumbnail_large not in {tokname}'
