import sys
import re
import getopt
import os
from time import time
import shutil

# Return a dictionary on information about a test case specified with the file name in a_full_path.
# The returned dictionary has the following keys:
#  class, feature: class and feature under test.
#  recipient_class, recipient: Recipient of the exception, same as class, feature in a successful test case.
#  bpslot: break point slot of the exception, 0 in a successful test case.
#  code: 0 in a successful test case.
#  tag: Tag of the failing assertion, 'noname' in a successful test case.
#  status: Status of the test case, 's' for a successful test case, 'f' for a failed one.
#  prefix: Prefix of the test case file name, default is 'TC'.
#  id: Identifier to determine uniqueness of a fault.
#  full_path: Full path of the test case.
# suffix: A random number to distinguish test case file names.
def test_case_info (a_full_path):
    tcinfo = {}    
    
    # Parse test case file name to retrieve information about the test case.
    parts = os.path.basename (a_full_path).split('__')
    tcinfo['prefix'] = parts[0]
    suf = parts[len(parts)-1]
    tcinfo['suffix'] = suf[0:len(suf)-2]
    
    parts.pop(0)
    parts.pop(len(parts)-1)
        
    tcinfo['class'] = parts[0]
    tcinfo['feature'] = parts[1]
    tcinfo['recipient_class'] = tcinfo['class']
    tcinfo['recipient'] = tcinfo['feature']
    tcinfo['bpslot'] = 0
    tcinfo['code'] = 0
    tcinfo['tag'] = "noname"
    tcinfo['status'] = "S"
    tcinfo['prefix'] = "TC"
    tcinfo['full_path'] = ""
    tcinfo['id'] = ""
    tcinfo['sufix'] = ""

    i = 2
    while i < len(parts):
        p = parts[i]
        if p == 'S' or p == 'F':
            tcinfo['status'] = p.lower()
        elif p.startswith('REC_'):
            tcinfo['recipient_class'] = p[4:]
            tcinfo['recipient'] = parts[i+1]
            i = i + 1
        elif p.startswith('TAG_'):
            tcinfo['tag'] = p[4:] 
        elif p.startswith('c'):
            tcinfo['code'] = int(p[1:])
        elif p.startswith('b'):
            tcinfo['bpslot'] = int(p[1:])
        i = i + 1
        
    # Build up unique fault identifier string.
    id = tcinfo['recipient_class'] + "_" + tcinfo['recipient']    
    id = id + '_' + str(tcinfo['code']) + '_' + str(tcinfo['bpslot']) + "_" + tcinfo['tag']
    tcinfo['id'] = id
    tcinfo['full_path'] = a_full_path
    return tcinfo
    
# Find all recursive folders starting from `a_base'.
def recursive_folders (a_base):
    result=[]
    for fn in os.listdir(a_base):        
        if not (fn=='.' or fn =='..'):
            l_path = os.path.join(a_base,  fn)
            if os.path.isdir(l_path):
                result.append (l_path)
                result.extend (recursive_folders(l_path))
            else:
                pass
    return result
    
# Return true if the given folder `a_folder' contains test cases.
def  is_folder_contain_test_cases (a_folder):
    assert os.path.isdir (a_folder)
    for fn in os.listdir(a_folder):
        if not (fn=='.' or fn =='..'):
            l_path = os.path.join (a_folder,  fn)
            if os.path.isfile(l_path):
                ext = os.path.splitext(fn)[1]
                if ext=='.e':
                    return True
            
    return False    

# Return true if `a_file' contains any of the strings in `a_keywords'.
# `a_keywords' is a list of strings.
def is_file_contain_text (a_file,  a_keywords):
    file = open (a_file)
    content = file.read()
    result = False
    for key in a_keywords:
        if content.find(key) > -1:
            result = True
            break
            
    file.close()
    return result
