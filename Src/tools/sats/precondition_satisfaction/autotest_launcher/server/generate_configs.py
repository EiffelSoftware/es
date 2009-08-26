'''
Usage: command_name <class_file> <machin_indexes>

@author: jasonw
'''

import sys
import os
import math

# Get names of machines that are to be used, stored in `machines'.
machines = []
for m in sys.argv[2].split (','):
    machine_index = int (m)
    if machine_index < 10:
        n = "0" + m
    else:
        n = m
    machines.append(n)

#The file where a complete list of classes are stored, each line represents a test run
file = open (sys.argv[1], 'r')

sessions = []
for line in file:
    classes = line.replace("\n", "").replace("\r", "")
    classes = classes + "\n"
    if len(classes) > 0:
        sessions.append(classes)
    else:
        pass

#Classes number of test sessions per machine
session_per_machine = math.floor (len(sessions) / len(machines))
remainder = len(sessions) - session_per_machine * len(machines) 

start_session = 0
end_session = session_per_machine - 1
indexes = range (0, len (machines))
for i in indexes:
    if remainder > 0:
        end_session = end_session + 1
        remainder = remainder - 1
    else:
        pass
    print (str(start_session) + ", " + str(end_session))
    file = open ("testi" + machines[i] + "_classes.txt", "w")
    file.writelines(sessions[int(start_session):int(end_session+1)])
    file.close()
    start_session = end_session + 1
    end_session = start_session + session_per_machine - 1


       
       
       
       
       
       
       
