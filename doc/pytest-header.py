#!/usr/bin/env python3
import sys
sys.path.insert(0, 'docker')
sys.path.insert(0, '/Users/michael/project/maptool-macros/docker')
from MTAssetLibrary import GetAsset
import pdb
import code
import copy
import os
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

def objectify_merge(orig, add):
    '''This merges objectify.ObjectifiedObject trees
    
    The outer wrapper is here just to make a reference
    copy before calling the internal merge.
    
    :returns: a copy of orig merged with add'''
    
    def recurse_merge(add, new, start):
        '''Wrapped to keep anything from using it
        directly, this uses the start as a reference
        to decide what from the add object to put 
        into the new object.

        Modifies the new object in place'''

        for child in add.iterchildren():
            log.debug(f'{tostring(child)=} found in add')
            xpath_child = f'{child.tag}[@name="{child.get("name")}"]'
            
            child_start = start.find(xpath_child)
            if child_start is not None:
                log.debug(f'{tostring(child_start)=} found in start')

            child_new = new.find(xpath_child)
            if child_new is not None:
                log.debug(f'{tostring(child_new)=} found in new')
            
            if child_start is None:
                log.debug(f'{xpath_child} not found in start, appending to new')
                new.append(copy.deepcopy(child))
            elif child.countchildren() > 0:
                log.debug(f'{tostring(child)=} has children, recursing')
                recurse_merge(child, child_new, child_start)

    start = copy.deepcopy(orig)
    recurse_merge(add, orig, start)
    return orig

def flatten_project(p):
    '''Projects can refer to projects (see doc/Project.md).
    This function is to flatten the current top level with
    all reference projects into one structure.

    :return: copy of p with all <project> elements removed
    and the contents of <project> transcluded.
    '''
    while projects := p.findall('project'):
        for project in projects:
            p.remove(project)
        for project in projects:
            new = GetAsset(project.get('name'))
            log.debug('recursing into', project.get('name'))
            p = objectify_merge(p, new.root)
    return p

if __name__ == '__main__':
    AP = argparse.ArgumentParser()
    AP.add_argument( 'file', default='test.xml',
                    help="initial project file to load")
    AP.add_argument('--out',
                    default='out.xml',
                    help='Output filename to use')

    args = AP.parse_args()

    q = objectify.parse(args.file).getroot()
    p = flatten_project(q)

    with open(args.out, 'w') as fh:
        fh.write(tostring(p, pretty_print=True).decode())
    
    log.info('Wrote new structure to', args.out)ls -a