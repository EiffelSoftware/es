import sys
import re
import getopt
import os
import random
import shutil
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
                                        'x': Suffix of the file name.
                                        Default: 'fscbrtx'
    --count <l>                   Number of test cases for each unique test case. <l> specified the number. -1 means keep all test cases.
                                        Default: 1
    --recursive                     Store test cases in folders according to the feature under test. Default: False
'''

# Default values for command line options
options={
    'input-folder': '', 
    'output-folder': '', 
    'code': -1, 
    'bpslot': -1, 
    'status': 'sf', 
    'unique': 'r', 
    'name': 'fscbrtx', 
    'count': 1, 
    'recursive': False
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
#  full_path: Full path of the test case.
# suffix: A random number to distinguish test case file names.
def test_case_info (a_full_path):
    tcinfo = {}    
    
    # Parse test case file name to retrieve information about the test case.
    parts = os.path.basename (a_full_path).split('__')
    tcinfo['prefix'] = parts[0]
    tcinfo['suffix'] = parts[len(parts)-1]
    parts.pop(0)
    parts.pop(len(parts)-1)
        
    tcinfo['class'] = parts[0]
    tcinfo['feature'] = parts[1]
    
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
    if options['unique'] == 'r':
        id = tcinfo['recipient_class'] + "_" + tcinfo['recipient']
    else:
        id = tcinfo['class'] + "_" + tcinfo['feature']
    
    id = id + '_' + str(tcinfo['code']) + '_' + str(tcinfo['bpslot']) + "_" + tcinfo['tag']
    tcinfo['id'] = id
    tcinfo['full_path'] = a_full_path
    return tcinfo
    
    
# Analyze test case stored in file a_full_path.
def analyze_test_case (a_full_path):
    global test_cases
    tcinfo = test_case_info(a_full_path)    
    is_matched = True # Should current test case specified by tcinfo be considered?
    
    is_matched = (options['bpslot'] == -1 or options['bpslots'] == tcinfo['bpslot']) and\
                (options['code']==-1 or options['code']==tcinfo['code']) and\
                (options['status'].find(tcinfo['status'])>=0)
    if is_matched:        
        key = tcinfo['id']
        if test_cases.has_key(key):
            cases = test_cases[key]
            if options['count'] == -1 or options['count'] > len(cases):
                cases.append(tcinfo)                
            else:
                i = random.randint (0, len(cases) - 1)
                cases[i] = tcinfo                                
        else:
            test_cases[key] = [tcinfo]
        
# Create folder (if not already exists) based on `a_output_folder' to store test cases for
# a_feature in a_class. 
# Return the feature folder.
def create_folder_for_feature (a_class, a_feature, a_output_folder):
    # Create folder for a_class.
    class_dir_name = a_class
    class_dir_path = os.path.join(a_output_folder, class_dir_name)
    if not os.path.isdir(class_dir_path):
        os.makedirs(class_dir_path)
    
    # Create folder for a_feature.
    feature_dir_name = a_feature
    feature_dir_path = os.path.join(class_dir_path, feature_dir_name)                                                
    if not os.path.isdir(feature_dir_path):
        os.makedirs(feature_dir_path)
                            
    return feature_dir_path
    
# Return a base file name for the test case specified by a_test_case.
# Base name contains the description of a test case, such as feature under test, exception code, break point slot,
# but does not include random number to avoid name clashes.
def test_case_file_base_name (a_test_case):
    base_name = a_test_case['prefix']
    
    config = options['name'].lower()
    base_name = a_test_case['prefix']
    
    for l in config:
        if l=='f':
            base_name = base_name + "__" + a_test_case['class']
            base_name = base_name + "__" + a_test_case['feature']
        elif l=='r':
            base_name = base_name + "__REC_" + a_test_case['recipient_class'] + "__" + a_test_case['recipient']
        elif l=='c':
            base_name = base_name + "__c" + str(a_test_case['code'])
        elif l=='b':
            base_name = base_name + "__b" + str(a_test_case['bpslot'])
        elif l=='s':
            base_name = base_name + "__" + a_test_case['status'].upper()
        elif l=='t':
            base_name = base_name + "__TAG_" + a_test_case['tag']
        elif l=='x':
            base_name = base_name + "__" + a_test_case['suffix']
    
    return base_name
    
# Store test cases specified by a_test_cases in output folder.
# a_test_cases is a list of test case information, see test_case_info for details.
def print_test_cases (a_test_cases):
    i = 1
    c = len(a_test_cases)
    for tc in a_test_cases:
        tc_file_name = test_case_file_base_name (tc) + ".e"
        if options['recursive']:
            full_dest_path = os.path.join (create_folder_for_feature (tc['class'],  tc['feature'],  options['output-folder']),  tc_file_name)
        else:
            full_dest_path = os.path.join (options['output-folder'],  tc_file_name)
            
        shutil.copyfile(tc['full_path'], full_dest_path)
        i = i + 1

# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["help",
         "code=",
         "bpslot=",
         "status=",
         "unique=",
         "name=", 
         "count=", 
         "recursive"
         ])
         
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print help_message
        sys.exit(0)
    elif option in ('--code'):
        options['code'] = int(value)
        
    elif option in ('--bpslot'):
        options['bpslot'] = int(value)
        
    elif option in ('--status'):
        options['status'] = value
        
    elif option in ('--unique'):
        options['unique'] = value
        
    elif option in ('--name'):
        options['name'] = value
        
    elif option in ('--count'):
        options['count'] = int(value)
    elif option in ('--recursive'):
        options['recursive'] = True

options['input-folder'] = args[0]
options['output-folder'] = args[1]

traverse_folder (options['input-folder'])

for tcs in test_cases.values():
    print_test_cases (tcs)
    
print('finished.')
    
