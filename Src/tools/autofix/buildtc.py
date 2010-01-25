import sys
import re
import getopt
import os
from time import time
import shutil
from subprocess import *
from tcutility import test_case_info,  recursive_folders,  is_folder_contain_test_cases

help_message = ''''buildtc [options] <prj-template-folder> <tc-folder> <prj-out-folder>
This script builds test case projects for AutoFix.

Arguments:
<prj-template-folder> is the folder where the project template is stored.
<tc-folder> is the folder containing test cases.
<output-folder> is the folder to store result.

Options
    --ec                                   The ec executable used as Eiffel compiler. Default: the one in $PATH.
    --config                             The ecf config name. Default: project.ecf
    --target                              The target name of the Eiffel project. Default: project
    --max-tc-number               The maximum number of test cases for a fault. Default: 10
    -h,--help                            Display this help screen.
'''

options = {
    'prj-template-folder': "", 
    'tc-folder': "", 
    'output-folder': "", 
    'ec': 'ec', 
    'config': "project.ecf", 
    'target': "project", 
    'max-tc-number': 10
}

# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["help",
         "ec=",
         "max-tc-number=", 
         "config=", 
         "target="
         ])
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print help_message
        sys.exit(0)
    elif option in ('--ec'):
        options['ec'] = value
    elif option in ('--max-tc-number'):
        options['max-tc-number'] = value
    elif option in ('--config'):
        options['config'] = value
    elif option in ('--target'):
        options['target'] = value        
        
options['prj-template-folder'] = args[0]
options['tc-folder'] = args[1]
options['output-folder'] = args[2]

# Build project for test cases from `a_folder'.
def build_tc_project_from_folder (a_folder):
    # Create folder and copy project template files.
    head_path,  feature_name = os.path.split (a_folder)
    head_path,  class_name = os.path.split (head_path)
    prj_folder = os.path.join (options['output-folder'],  class_name + "__" + feature_name)
    shutil.copytree (options['prj-template-folder'],  prj_folder)
    
    # Build project.
    current_dir = os.getcwd()
    os.chdir(prj_folder)
    ec_cmd = options['ec'] + " -config " +  options['config'] + " -target " + options['target'] + " -auto_fix --build-tc " + a_folder + " --max-tc-number " + str(options['max-tc-number'])
    print(ec_cmd)
    p = Popen(ec_cmd,   shell=True)
    sts = os.waitpid(p.pid, 0)[1]
    os.chdir(prj_folder)
    shutil.rmtree("EIFGENs")
    os.chdir(current_dir)
    
# Get the list of test case containing folders, store result in `tc_folders'.
folders = recursive_folders (options['tc-folder'])
tc_folders = filter (is_folder_contain_test_cases,  folders)

# Process all the folders containing test cases according to the given options
map(build_tc_project_from_folder, tc_folders)

print("Finished.")
