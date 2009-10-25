import sys
import re
import getopt
import os
from time import time

help_message = '''
    -h, --help                      Display this message.
    --code <c>                   Select test cases with exception code <c>, if <c> is -1, this option
                        i               is disabled. Default: -1.
    --bpslot <b>                Select test cases with breakpoint slot <b>. If <b> is -1, this option 
                                        is disables. Default: -1.
    --status  <s>                    Select test cases with type <s>. <s> is a string consisting of letter 's' or 'f'.
                                        ''s' means successful test cases, 'f' means failed test cases. Default: 'sf'.
    --unique  <u>               Routine to identify unique test cases. <u> can be either 'f' or 'r'.
                                        'f' means feature under test, 'r' means recipient. Default: 'r'.
    --name <n>                  Name of the output test cases. <n> is a format string, consisting only letters [frcbst].
                                        The order of the letters in <n> determines the order of the corresponding components in
                                        the final test case name. 
                                        'f': feature under test.
                                        'r': recipient of the exception. Same as feature under test for successful test cases.s
                                        'c': exception code. 0 for successful test cases.
                                        'b': break point slot. 0 for successful test cases.
                                        's': test case status.
                                        't': Tag of the exception. 'noname' for successful test cases.
                                        Default: 'fscbrt'
    --count <l>                   Number of test cases for each unique test case. <l> specified the number. -1 means keep all test cases.
                                        Default: -1.                                     
'''

# Default values for command line options
options={
    'input-folder': '', 
    'output-folder': '', 
    'code': -1, 
    'bpslot': -1, 
    'status': 'sf', 
    'unique': 'r', 
    'name': 'fscbrt', 
    'count': -1
}

# Dictionary  of found test cases. Key is the identifier of a test case, value is a list of files for test cases of the same identifier.
# Identifier is either: feature_under_test, status, exception code, break point slot or
#                               recipient, status, exception code, break point slot
test_cases = {}

def traverse_folder (a_folder):
    directories = [a_folder]
    while len(directories)>0:
        directory = directories.pop()
        for name in os.listdir(directory):
            fullpath = os.path.join(directory,name)
            if os.path.isfile(fullpath):
                if fullpath.endswith('.e'):
                    analyze_test_case (fullpath)                # That's a file. Do something with it.
            elif os.path.isdir(fullpath):
                directories.append(fullpath)  # It's a directory, store it.

# Return a dictionary on information about a test case specified with the file name in a_full_path.
# The returned dictionary has the following keys:
#  class, feature: class and feature under test.
#  recipient_class, recipient: Recipient of the exception, same as class, feature in a successful test case.
#  bpslot: break point slot of the exception, 0 in a successful test case.
#  code: 0 in a successful test case.
#  tag: Tag of the failing assertion, 'noname' in a successful test case.
#  status: Status of the test case, 'S' for a successful test case, 'F' for a failed one.
#  prefix: Prefix of the test case file name, default is 'TC'.
#  id: Identifier to determine uniqueness of a fault.
def test_case_info (a_full_path):
    tcinfo = {}    
    
    # Parse test case file name to retrieve information about the test case.
    parts = os.path.basename (a_full_path).split('__')
    tcinfo['prefix'] = parts[0]
    parts.pop(0)
    parts.pop(len(parts)-1)
        
    tcinfo['class'] = parts[0]
    tcinfo['feature'] = parts[1]
    
    i = 2
    while i < len(parts):
        p = parts[i]
        if p == 'S' or p == 'F':
            tcinfo['status'] = p
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
    if options['unique'] == 'r':
        id = tcinfo['recipient_class'] + "_" + tcinfo['recipient']
    else:
        id = tcinfo['class'] + "_" + tcinfo['feature']
    
    id = id + '_' + str(tcinfo['code']) + '_' + str(tcinfo['bpslot']) + "_" + tcinfo['tag']
    tcinfo['id'] = id
    return tcinfo
    
    
# Analyze test case stored in file a_full_path.
def analyze_test_case (a_full_path):
    tcinfo = test_case_info(a_full_path)    
    is_matched = True # Should current test case specified by tcinfo be considered?
    
    
traverse_folder ('/home/jasonw/temp')
print ('finished.')
