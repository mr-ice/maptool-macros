import os
import shutil
import pytest

class TestExtract():

    @pytest.mark.parametrize('token_file',[
        'test/data/DNDB-Test/BaseToken30957877.rptok',
        'test/data/DNDB-Test/BaseToken30957978.rptok',
        'test/data/DNDB-Test/BaseToken30959709.rptok',
        'test/data/DNDB-Test/BaseToken30960137.rptok',
    ])
    def test_token_extract(tmp_path, token_file):
        print(token_file)


