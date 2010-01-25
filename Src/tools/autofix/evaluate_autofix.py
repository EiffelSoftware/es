import sys
import re
import getopt
import os
import time
import shutil
from tcutility import test_case_info,  recursive_folders,  is_folder_contain_test_cases
from subprocess import *

help_message = ''''evaluate_autofix [options] <model-folder> <project-folder>
This script will run AutoFix for project in <project-folder>. <model-folder> is where the behavior models are stored.

Arguments:
<input-folder> is the folder containing test cases.
<output-folder> is the folder to store result.

Options
    -h,--help                            Display this help screen.
    --vallid-fix-number             The number of valid fixes that needs to be generated. 
                                            The algorithm will stop after this number of valid fixes is found.
                                             Default: 5
    --time-out                          Time in minute for the whole run, the algorithm will exit after this time. Default: 15
    --ec                                    The location of the Eiffel compiler. Default "ec"
   --config                             The ecf config name. Default: project.ecf
    --target                              The target name of the Eiffel project. Default: project
    --batch                             Boolean value, True indicates that <project-folder> is a list of projects, and this script will go through all projects. 
                                            Default: False
'''

options = {
    'valid-fix-number': 5, 
    'time-out': 15, 
    'ec': "ec", 
    'log-file': "autofix_log.txt", 
    'model-folder': "", 
    'project-folder': "", 
    'config': "project.ecf", 
    'target': "project", 
    'batch': False
}

# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["help",
        "batch",         
         "ec=",
         "valid-fix-number=", 
         "time-out=", 
         "config=", 
         "target=",
        "log-file=" 
         ])
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print help_message
        sys.exit(0)
    elif option in ('--ec'):
        options['ec'] = value
    elif option in ('--valid-fix-number'):
        options['valid-fix-number'] = int(value)
    elif option in ('--time-out'):
        options['time-out'] = int(value)
    elif option in ('--config'):
        options['config'] = value
    elif option in ('--target'):
        options['target'] = value        
    elif option in ('--log-file'):
        options['log-file'] = value 
    elif option in ('--batch'):
        options['batch'] = True
        
options['model-folder'] = args[0]
options['project-folder'] = args[1]

def wait_timeout(proc, seconds):
    start = time.time()
    end = start + seconds
    interval = min(seconds / 1000.0, .25)

    while True:
        result = proc.poll()
        if result is not None:
            return result
        if time.time() >= end:
            proc.kill()
        time.sleep(interval)


# Build project
def compile_project(a_folder):
    print("Compile the project.")
    current_dir = os.getcwd()
    os.chdir(a_folder)    
    ec_cmd = options['ec'] + " -config " +  options['config'] + " -target " + options['target']  + " -clean -freeze -c_compile"    

    logfile = open(options['log-file'], 'w')
    p = Popen(ec_cmd,   shell=True,  stdout=logfile,  stderr=STDOUT)
    logfile.close()
        
    try:
        sts = os.waitpid(p.pid, 0)[1]
    except OSError, e:
        pass
        
    os.chdir(current_dir)
    
# Launch AutoFix.
def autofix(a_folder):    
    print("Start AutoFix.")
    os.system ('rm ~/.es/64/session/*' + options['target'] + '.dbg.ses')
    current_dir = os.getcwd()
    os.chdir(a_folder) 
    ec_cmd = options['ec'] + " -config " +  options['config'] + " -target " + options['target']  + " -auto_fix --analyze-tc --daikon --skeleton afore,wrap -f --max-tc-execution-time 30 --max-valid-fix " + str(options['valid-fix-number'])  + " --model-dir " + options['model-folder']

    logfile = open(options['log-file'], 'w')
    p = Popen(ec_cmd,   shell=True,  stdout=logfile,  stderr=STDOUT)
    wait_timeout(p, options['time-out'] * 60)    
    logfile.close()
    try:
        sts = os.waitpid(p.pid, 0)[1]
    except OSError, e:
        pass
    
    logfile = open(options['log-file'], 'r')
    content = logfile.read()
    if content.find('Good fix No') > -1:
        result = "Found valid fix."
    elif content.find('Class / Object') > -1:
        result = "Crashed."
    elif content.find('Application exited') > -1:
        result = "Error."
    elif content.find('Dump core') > -1:
        result = "Dump core."
    else:
        result = "Not found valid fix."
    logfile.close()
    print(result)
    
    # Remove files to save space.
    shutil.rmtree(os.path.join(options['project-folder'],  'EIFGENs',  options['target'],  'W_code'),  ignore_errors=True)
    shutil.rmtree(os.path.join(options['project-folder'],  'EIFGENs',  options['target'],  'COMP'),  ignore_errors=True)
    os.chdir(current_dir)
    
# Compile and run AutoFix for project in `a_folder'.
def process_project (a_project_folder):
    head_path,  prj_name = os.path.split (a_project_folder)
    print("------------------------------------------------------------------")
    print("Processing " + prj_name)
    
    compile_project(a_project_folder)
    autofix(a_project_folder)

folders  = []
if options['batch'] == True:
    for d in os.listdir(options['project-folder']):
        folders.append (os.path.join (options['project-folder'],  d))
else:
    folders.append (options['project-folder'])

folders.sort()

# Apply AutoFix to every item in `folders'.
map(process_project, folders)

print("Finished.")
