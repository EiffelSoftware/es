import sys
import re
import getopt
import os
from time import time
import shutil
from tcutility import test_case_info,  is_folder_contain_test_cases,  recursive_folders,  is_file_contain_text

help_message = '''cleantc [options] <input-folder> <out-folder>
This script selects test cases inside <input-dolfer> which do not contain failing test cases, and put
result in <output-folder>

Arguments:
<input-folder> is the folder containing test cases.
<output-folder> is the folder to store result.

Options
    -h,--help                            Display this help screen.
    --keep-extreme-int             Keep test cases related to extreme (minimal, maximal) integers. 
                                             Default: False
    --keep-void-on-target         Keep test cases related to void-on-target.
                                             Default: False
    --keep-seg-fault                  Keep test cases related to segmentation violation.
                                            Default: False
    --keep-mismatch               Keep test cases related to type mismatch.
                                            Default: False
    --keep-no-more-memory    Keep test cases related to No more memory.
                                            Default: False
    --min-passing <n>            Remove faults which have less than `n'  number of passing test cases. Default: 0
    --min-failing <n>              Remove faults which have less than 'n' number of failing test cases. Default: 1
'''

options = {
    'input-folder': "", 
    'output-folder': "", 
    'keep-extreme-int': False,
    'keep-void-on-target': False,
    'keep-seg-fault': False, 
    'keep-mismatch': False, 
    'keep-no-more-memory': False, 
    'min-passing': 0, 
    'min-failing': 1
}
                
# Return true if the test case specified by `a_tcinfo' should be kept.
def is_failing_test_case_satisfied (a_tcinfo):
    keywords=[]
    if not options['keep-extreme-int']:
        keywords.append('2147483647')
        keywords.append('-2147483648')
        
    if not options['keep-void-on-target']:
        keywords.append('Feature call on void target')
        
    if not options['keep-seg-fault']:
        keywords.append('Segmentation fault')

    if not options['keep-mismatch']:
        keywords.append('Mismatch')
        
    if not options['keep-no-more-memory']:
        keywords.append('No more memory')

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
                
            print ("Created folder: " + folder_name)
                
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
    print ("Processing folder " + a_folder)
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
        ["help", 
         "keep-extreme-int",
         "keep-void-on-target",
         "keep-seg-fault", 
         "keep-mismatch", 
         "min-passing", 
         "min-failing", 
         "keep-no-more-memory"
         ])
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print help_message
        sys.exit(0)
    elif option in ('--keep-extreme-int'):
        options['extreme-int'] = True
    elif option in ('--keep-void-on-target'):
        options['void-on-target'] = True
    elif option in ('--keep-seg-fault'):
        options['seg-fault'] = True
    elif option in ('--keep-mismatch'):
        options['keep-mismatch'] = True
    elif option in ('--min-passing'):
        options['min-passing'] = int(value)
    elif option in ('--min-failing'):
        options['min-failing'] = int(value)
    elif option in ('--keep-no-more-memory'):
        options['keep-no-more-memory']=True

options['input-folder'] = args[0]
options['output-folder'] = args[1]

# Get the list of test case containing folders, store result in `tc_folders'.
print ("Searching for test case folders.")
folders = recursive_folders (options['input-folder'])
tc_folders = filter (is_folder_contain_test_cases,  folders)
print ("Found " + str (len(tc_folders)) + " folders.")
# Process all the folders containing test cases according to the given options
map(process_folder, tc_folders)

print("Finished.")
