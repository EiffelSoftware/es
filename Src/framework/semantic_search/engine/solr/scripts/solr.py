#This script manages Solr related files.

import os
import re
import subprocess
import getopt
import sys
import platform
import urllib
import tarfile
import shutil

def process_dir(a_directory, a_pattern, a_solr_home):
    ''' Process a_directory, and post all files matching a_pattern into Solr index.
        a_directory and a_pattern are of string type.
    '''
        
    os.chdir(a_directory)            
    empty_files=[]
    # Clean all empty files.
    for path in os.listdir(a_directory):
        if os.path.isfile(path) and os.path.getsize(path) == 0:
            empty_files.append(path)
    for path in empty_files:
        os.remove(os.path.join(a_directory, path))
        
    # Post all files specified by a_pattern to Solr engine.        
    jar_path = os.path.join(a_solr_home, "example", "exampledocs", "post.jar")    
    #print (a_directory + " " + "java -jar " + jar_path + " " + a_pattern)
    os.system("java -jar " + jar_path + " " + a_pattern)    
    
    # Iterate through a_directory recursively.
    dirs=[]
    for path in os.listdir(a_directory):
        if os.path.isdir(path):
            dirs.append (os.path.join(a_directory, path))
    for path in dirs:
        process_dir (path, a_pattern, a_solr_home)
    

help_message = ''''
Usage: 
1. solr.py start
    Start solr engine.
    After start the engine, this script won't return until the engine is stopped.
    
2. solr.py clean
    Clean the Solr database, this requires that the Solr engine is stopped.

3. solr.py post <directory>
    Post all .solr files in <directory> in the search engine.  If --file-pattern option is specified,
    only the matched files are posted.
    

Options:    
    --solr-home <directory>
    Use <directory> as the home directory for Solr, if not present, use the environment variable SOLR_HOME
    
    --pattern <pattern>
    Post only files specified by <pattern>. If not present, post files with extension .solr only.
    
    -h,--help:
    Display this help screen.
'''

options = {
    'solr-home': "",
    'pattern': "*.solr",
    'directory': ""
}

# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["help",
         "solr-home=",
        'pattern='
         ])
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print (help_message)
        sys.exit(0)
    elif option in ('--solr-home'):
        options['solr-home'] = value
    elif option in ('--pattern'):
        options['pattern'] = value
        
# Check if there is enough arguments.
if len(args) == 0:
    print ("Argument is missing.")
    print (help_message);
    sys.exit(1)
else:
    command = args[0]
    if command == "post":
        if len(args) != 2:
            print ("Argument is missing.")
            print (help_message);
            sys.exit(1)
        else:
            options['directory'] = args[1]
            
if options['solr-home'] == "":
    options['solr-home'] = os.getenv('SOLR_HOME')
    

if command == "start":
    # Start Solr engine.
    os.chdir(os.path.join (options['solr-home'], "example"))
    os.system("java -jar start.jar")

elif command == "clean":
    # Clean Solr index.
    current_dir = os.getcwd()
    index_dir = os.path.join (options['solr-home'], "example", "solr", "data")
    os.chdir(index_dir)
    shutil.rmtree(os.path.join(index_dir, "index"))
    shutil.rmtree(os.path.join(index_dir, "spellchecker"))
    os.chdir(current_dir)
    
elif command == "post":
    # Post files into Solr index.
    current_dir = os.getcwd()
    process_dir (options['directory'], options['pattern'], options['solr-home'])
    os.chdir(current_dir)
    
    
    
