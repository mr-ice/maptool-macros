#!/usr/bin/env python3
import sys
sys.path.insert(0, 'docker')
sys.path.insert(0, '/Users/michael/project/maptool-macros/docker')
from MTAssetLibrary import flatten_project
import code
from lxml import objectify
from lxml.etree import tostring

import argparse


class LogO:
    '''Simple logging class for jupyter notebooks'''
    def __init__(self):
        pass

    def info(self, message='', *args):
        print('INFO:', message.format(*args))

    def debug(self, message='', *args):
        print('DEBUG:', message.format(*args))

    def warn(self, message='', *args):
        print('WARN:', message.format(*args))

    def error(self, message='', *args):
        print('ERROR:', message.format(*args))


log = LogO()

code.interact(local=locals())
# pdb.set_trace()
if __name__ == '__main__':
    AP = argparse.ArgumentParser()
    AP.add_argument('file',
                    default='test.xml',
                    help="initial project file to load")
    AP.add_argument('--out',
                    default='out.xml',
                    help='Output filename to use')

    args = AP.parse_args()

    q = objectify.parse(args.file).getroot()
    p = flatten_project(q)

    with open(args.out, 'w') as fh:
        fh.write(tostring(p, pretty_print=True).decode())

    log.info('Wrote new structure to', args.out)
