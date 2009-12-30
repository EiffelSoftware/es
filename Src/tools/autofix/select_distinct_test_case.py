import sys
import re
import getopt
import os
from time import time
import shutil
from tcutility import test_case_info,  recursive_folders,  is_folder_contain_test_cases

help_message = ''''select_distinct_test_case [options] <input-folder> <out-folder>
This script selects distinct test cases according to recipient inside <input-dolfer>, and put
result in <output-folder>

Arguments:
<input-folder> is the folder containing test cases.
<output-folder> is the folder to store result.

Options
    -h,--help                            Display this help screen.
'''

options = {
    'input-folder': "", 
    'output-folder': "", 
}
            
# Distinct faults seen so far. Key is the fault ID, value is an arbitrary integer (not used).
distinct_faults={}

# Return True if a_folder contains distinct according to distinct_faults.
def is_fault_distinct (a_folder):
    # Find the first failing test cases in `a_folder'.
    found = False    
    for f in os.listdir(a_folder):
        if f.find('F__') != -1:
            tcname = f
            found = True
            break
            
    # Only proceed if there is at least one failing test case in `a_folder'.
    if found:    
        full_path = os.path.join(a_folder,  tcname)
        tcinfo = test_case_info(full_path)
        id = tcinfo['id']
        if id in distinct_faults.keys():
            print('Ignored: ' + a_folder)
            return False
        else:
            distinct_faults[id] = 1
            return True
    else:
        return False
    
# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["help"
         ])
# Parse command line options.
for option, value in opts:
    pass
    
options['input-folder'] = args[0]
options['output-folder'] = args[1]

#Copy `a_folder' into <output-folder>.
def copy_folder (a_folder):
    print("Processing folder: " + a_folder)
    temp = os.path.dirname(a_folder)
    feature_part = os.path.basename(a_folder)
    class_part = os.path.basename(temp)
    
    l_dest = os.path.join(options['output-folder'],  class_part,  feature_part)
    shutil.copytree (a_folder,  l_dest)

# Get the list of test case containing folders, store result in `tc_folders'.
folders = recursive_folders (options['input-folder'])
tc_folders = filter (is_folder_contain_test_cases,  folders)
distinct_tc_folders = filter (is_fault_distinct,  tc_folders)

# Copy folders containing distinct faults into <output-folder>
map(copy_folder,  distinct_tc_folders)

print('Finished.')
