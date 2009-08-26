'''
analyze_logs <log_file_directory> <result_file_directory> <project_directory>

Analyze all AutoTest log files (proxy_log files) in <log_file_directory>,
and store results in <result_file_directory>.
<project_directory> is the directory containing the Eiffel project which was tested.

'''

import os
import sys
import re

log_file_dir = sys.argv[1]
result_file_dir = sys.argv[2]
project_dir = sys.argv[3]
current_dir = os.curdir

os.chdir(project_dir)
#os.system("ecp -config project.ecf -target project -c_compile -clean")

files = os.listdir(log_file_dir)

i = 1
count = len(files)

for log_name in files:    
    if re.match(".*proxy_log.*\.txt$", log_name) != None:
        #We only analyze log files.
        log_path = os.path.join (log_file_dir, log_name)         
        
        #Get test method.
        test_method = log_name[0:2]
        
        mlog_name = log_name[3:]
        mlog_name = mlog_name.replace ("_min", "")
        mlog_name = mlog_name.replace ("_proxy_log", "")
        mlog_name = mlog_name[::-1]
        mlog_name = mlog_name[4:]
        parts = mlog_name.split ('_')
        
        #Get testing time and session index.
        index = int(parts[0][::-1])
        time = int(parts[1][::-1])
        
        #Get class name.
        class_name = mlog_name[len(str(index) + "_" + str(time) + "_"):][::-1]
        
        result_file_name = test_method + "_" + class_name + "_result_" + str(time) + "_min_" + str(index) + ".txt" 
        result_path = os.path.join(result_file_dir, result_file_name)
        print("Analyzing: " + log_path + " " + str(i) + "/" + str(count))
        os.system("ecp -config project.ecf -target project -auto_test -a --log-file " + log_path + " --log-processor ps --log-processor-output " + result_path)
        print("")
    else:
        pass
    
    i = i + 1
os.chdir(current_dir)

