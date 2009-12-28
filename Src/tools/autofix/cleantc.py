import sys
import re
import getopt
import os
from time import time
import shutil

help_message = '''cleantc [options] <input-folder> <out-folder>
This script selects test cases inside <input-dolfer> which do not contain failing test cases, and put
result in <output-folder>

Arguments:
<input-folder> is the folder containing test cases.
<output-folder> is the folder to store result.

Options
    -h,--help        Display this help screen.
    --keep-extreme-int Keep test cases related to extreme (minimal, maximal) integers. 
                         Default: False
    --keep-void-on-target Keep test cases related to void-on-target.
                             Default: False
    --keep-seg-fault     Keep test cases related to segmentation violation.
                        Default: False
    --min-passing <n>   Remove faults which have less than `n'  number of passing test cases. Default: 0
    --min-failing <n>   Remove faults which have less than 'n' number of failing test cases. Default: 1
'''

options = {
    'input-folder': "", 
    'output-folder': "", 
    'extreme-int': True,
    'void-on-target': True,
    'seg-fault': True, 
    'min-passing': 0, 
    'min-failing': 1
}

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
            
# Return true if `a_file' contains any of the strings in `a_keywords'.
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
    
# Return true if the test case specified by `a_tcinfo' should be kept.
def is_failing_test_case_satisfied (a_tcinfo):
    keywords=[]
    if options['extreme-int'] == True:
        keywords.append('2147483647')
        keywords.append('-2147483648')
        
    if options['void-on-target']==True:
        keywords.append('Void call target')
        
    if options['seg-fault']==True:
        keywords.append('Segmentation fault')

    return not is_file_contain_text (a_tcinfo['full_path'], keywords)
    
# Create subfolder in `output-folder to store passing test cases `a_passing_tcs' and 
# failing test cases `a_failing_tcs' when necessary.
# `index' is used if there are more than one fault in a routine.
def create_folder (a_passing_tcs,  a_failing_tcs,  index):
    # 1. Remove all test cases which does not satisfy the given options
    # 2. Only create folder when the left test cases still satisfy the given options.
    if len(a_passing_tcs) >= options ['min-passing']:
        valid_failing_tcs=filter (is_failing_test_case_satisfied,  a_failing_tcs)
        if len (valid_failing_tcs) > options ['min-failing']:
            
            # Create folder and copy all test cases into it.
            tcinfo = a_failing_tcs[0]                        
            folder_name = options['output-folder']
            folder_name = os.path.join(folder_name,  tcinfo['class'],  tcinfo['feature'])            
            if index > 0:
                folder_name = folder_name + "__" + str(index)
                
            # Create target folder and copy test cases into it.
            os.makedirs(folder_name)
            
            # Copy passing test cases.
            for tc in a_passing_tcs:
                base_file_name = os.path.basename (tc['full_path'])
                shutil.copyfile(tc['full_path'], os.path.join (folder_name,  base_file_name))
                
            # Copy failing test cases.
            for tc in valid_failing_tcs:
                base_file_name = os.path.basename (tc['full_path'])
                shutil.copyfile(tc['full_path'], os.path.join (folder_name,  base_file_name))
    else:
        pass
        
#Process `a_folder' according to given options.
def process_folder (a_folder):
    # Get a list of test cases.
    failed_test_cases = 0
    failing_tcs ={}
    passing_tcs=[]    
    for fn in os.listdir(a_folder):
        if not (fn=='.' or fn=='..'):
            l_path = os.path.join(a_folder,  fn)
            if os.path.isfile(l_path):
                ext = os.path.splitext(fn)[1]
                if ext=='.e':
                    tcinfo = test_case_info (l_path)
                    if tcinfo['status'] == 's':
                        # Found a passing test case.
                        passing_tcs.append (tcinfo)
                    else:
                        failed_test_cases = failed_test_cases + 1
                        tcid = tcinfo['id']
                        if tcid in failing_tcs.keys():
                            failing_tcs[tcid].append (tcinfo)
                        else:
                            failing_tcs[tcid] = [tcinfo]
                        
    if failed_test_cases != 0:
        # Only continure if `a_folder' contains some failing test caess.
        i = 0
        for k, v in failing_tcs.iteritems():
            create_folder (passing_tcs,  v,  i)
            i = i + 1
    
# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["keep-extreme-int",
         "keep-void-on-target",
         "keep-seg-fault", 
         "min-passing", 
         "min-failing"
         ])
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print help_message
        sys.exit(0)
    elif option in ('--keep-extreme-int'):
        options['extreme-int'] = False
    elif option in ('--keep-void-on-target'):
        options['void-on-target'] = False
    elif option in ('--keep-seg-fault'):
        options['seg-fault'] = False
    elif option in ('--min-passing'):
        options['min-passing'] = int(value)
    elif option in ('--min-failing'):
        options['min-failing'] = int(value)

options['input-folder'] = args[0]
options['output-folder'] = args[1]

# Get the list of test case containing folders, store result in `tc_folders'.
folders = recursive_folders (options['input-folder'])
tc_folders = filter (is_folder_contain_test_cases,  folders)

# Process all the folders containing test cases according to the given options
map(process_folder, tc_folders)

print("Finished.")
