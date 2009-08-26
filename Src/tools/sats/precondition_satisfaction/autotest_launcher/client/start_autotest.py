'''
Usage: start_autotest <machine> <config_file> [-m method] [-t minute] [-s sessions]
<config_file> is the full path of a configuration file
<mathine> is the host name of the machine to be used to run the tests, for example, testi00, testi01.
[-m method] is optional, when presents, it gives the method used in testing: "or" or "ps". "or" for original AutoTest,
            "ps" for AutoTest with precondition satisfaction.
[-t minute] is optional, when presents, it gives the minute to run each test run. 
[-s sessions] is optional, when presents, it gives the number of runs per each set of classes to be tested,
            the run index starts from 1.
            
If -m, -t, -s is present, their value will override those provided in <config_file>, if any.
@author: jasonw
'''

import os
import sys
import subprocess
import getopt

# Given a comma separated string, return a set of numbers representing testing sessions
def sessions(config):
    sec = config.split(',')
    Result = []
    for s in sec:
        if s.find('-') > 0:
            ss = s.split ('-')
            Result.extend (range (int(ss[0]), int(ss[1])+1))
        else:
            Result.append(int(s))
    return set(Result)
        
#If current machine is not the machine that we want to run test on, exit.
prc = subprocess.Popen(["hostname"], shell=True, stdout=subprocess.PIPE)
hostname = prc.stdout.readline().replace("\n", "")
if hostname == sys.argv[1]:
    pass
else:
    sys.exit(0)

#Read config file to find test session information.
provided_method = "ps"
provided_time = 70
provided_runs = set (range(1,6))
is_method_provided = False
is_time_provided = False
is_runs_provided = False
config = sys.argv[2]

opts, args = getopt.getopt(sys.argv[3:], "m:t:s:", ["method=", "time=", "session="])

for opt, arg in opts:               
    if opt in ("-m", "--method"):
        is_method_provided = True
        provided_method = arg  
        
    elif opt in ("-t", "--time"):
        is_time_provided = True
        provided_time = arg
                                      
    elif opt in ("-s", "--session"):
        is_runs_provided = True
        ii = arg.split ('-')
        if len(ii) == 1:
            start_index = 1
            end_index = int(ii[0])
        else:
            start_index = int(ii[0])
            end_index = int(ii[1])
        provided_runs = range (start_index, end_index + 1)

tests=[]
file = open (config, "r")
for line in file:
    line = line.replace ("\n", "").replace("\r", "")
    if len(line) > 0:
        parts = line.split('\t')
        classes = parts[0]
        if len(parts) == 4:
            #If detailed specification is provided, use them.           
            method = parts[1]
            time = int (parts[2])
            ss = sessions(parts[3])
            test = classes, method, time, ss        
        else:
            #Otherwise use a default detailed specification.
            if len(parts) == 1:
                method = provided_method
                time = provided_time
                test = classes, method, time, provided_runs
            else:
                pass
        tests.append(test)
    else:
        pass
file.close()

ec_compile = "ecp -config project.ecf -target project -clean -c_compile"
ec_test_ps = "ecp -config project.ecf -target project -auto_test -i -p --cs --linear-constraint-solver smt,lpsolve -t 5 --ps-selection-rate 80 --smt-enforce-old-value-rate 10 --smt-use-predefined-value-rate 10 --pool-statistics-logged --max-candidates 1 --use-random-cursor -x 5 "
ec_test_or = "ecp -config project.ecf -target project -auto_test -i "
local_dir = "/local"
test_dir = "/local/project"
project_dir = "~/sats/project"
log_dir = "~/sats/logs"
proxy_log_dir = "EIFGENs/project/Testing/auto_test/log"

#Prepare testing environment.
os.system("rm -rdf " + test_dir)
os.system("cp -R " + project_dir + " " + local_dir)
os.chdir (test_dir)
os.system(ec_compile)

#Launch tests.
for test in tests:
    #Get specification for the next test. 
    classes = test[0]
    method = test[1]
    time = test[2]
    runs = test[3]
    for run in runs:
     #Prepare command to launch AutoTest.
     if method == "or":
         ec = ec_test_or
     else:
         ec = ec_test_ps
     ec = ec + " -t " + str(time) + " " + classes
     
	  #Test classes
     os.chdir(test_dir)
     os.system("rm " + proxy_log_dir + "/*.txt")
     os.system("timelimit -T 4 -t " + str(int(time) * 60 + 300) + " " + ec)
     
	  #Copy result.
     cc = classes.split(' ')
     lead_class_name = cc[0]
     final_log_name = method + "_" + lead_class_name + "_proxy_log_min_" + str(time) + "_" + str(run) + ".txt"
     os.system("cp " + proxy_log_dir + "/proxy_log.txt " + log_dir + "/" + final_log_name) 
     os.system("rm " + proxy_log_dir + "/*.txt")
        
        
        
        
        
    
