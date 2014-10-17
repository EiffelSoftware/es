import sys
import os, os.path
import shutil
import time
from subprocess import call, check_output
from colorama import init, Fore, Back, Style

classes = [
  'V_CONTAINER',
  'V_INPUT_STREAM',
  'V_OUTPUT_STREAM',
  'V_ITERATOR',  
  'V_MAP',
  'V_MAP_ITERATOR',
  'V_SEQUENCE',
  'V_SEQUENCE_ITERATOR',
  'V_MUTABLE_SEQUENCE',
  'V_IO_ITERATOR',
  'V_MUTABLE_SEQUENCE_ITERATOR',
  'V_LIST',
  'V_LIST_ITERATOR',
  'V_CELL',
  'V_LINKABLE',
  'V_LINKED_LIST',  
  'V_LINKED_LIST_ITERATOR',
  'V_DISPENSER',
  'V_STACK',
  'V_LINKED_STACK',
  'V_LINKED_STACK_ITERATOR',
  'V_QUEUE',
  'V_LINKED_QUEUE',
  'V_LINKED_QUEUE_ITERATOR',
  'V_DOUBLY_LINKABLE',
  'V_DOUBLY_LINKED_LIST',
  'V_DOUBLY_LINKED_LIST_ITERATOR',
  'V_ARRAY',
  'V_INDEX_ITERATOR',
  'V_ARRAY_ITERATOR',
  'V_ARRAYED_LIST',
  'V_ARRAYED_LIST_ITERATOR',
  'V_ARRAY2',
  'V_LOCK',
  'V_SET',
  'V_SET_ITERATOR',
  'V_HASHABLE',
  'V_HASH_LOCK',
  'V_HASH_SET',
  'V_HASH_SET_ITERATOR'
]

outfile_name = 'base2.out'
tempfile_name = 'temp.out'

def run_all(project_path):
  args = ['-config', 'base-eve.ecf', 
    '-target', 'base', 
    '-batch',
    '-project_path', project_path,
    '-boogie',
    '-ownership',
    '-arithtrigger'
    ]
  args = args + classes
                  
  with open(outfile_name, 'w') as outfile:
    start = time.clock()
    call([os.path.join(os.getenv("ISE_LIBRARY"), 'Eiffel', 'Ace', 'EIFGENs', 'bench', 'F_code', 'ec.exe')] + args, stdout=outfile, stderr=outfile)
    end = time.clock()
    
  if 'Verification failed' in open(outfile_name).read():
    print Back.RED + Fore.RED + Style.BRIGHT + ': failed' + Style.RESET_ALL + ' (' +  '{0:0.2f}'.format(end - start) + ' sec)'
  elif 'Successfully verified' in open(outfile_name).read():
    print Back.GREEN + Fore.GREEN + Style.BRIGHT + ': ok' + Style.RESET_ALL + ' (' +  '{0:0.2f}'.format(end - start) + ' sec)'
  else:
    print Back.RED + Fore.RED + Style.BRIGHT + ':OOPS' + Style.RESET_ALL + ' (' +  '{0:0.2f}'.format(end - start) + ' sec)'

def run_each(project_path):
  args = ['-config', 'base-eve.ecf', 
    '-target', 'base', 
    '-batch',
    '-project_path', project_path,
    '-boogie',
    '-ownership',]
    
  outfile = open(outfile_name, 'w')
  
  for c in classes:
    print c,
    
    with open(tempfile_name, 'w') as tempfile:
      args1 = args + [c]
      start = time.clock()
      call([os.path.join(os.getenv("ISE_LIBRARY"), 'Eiffel', 'Ace', 'EIFGENs', 'bench', 'F_code', 'ec.exe')] + args1, stdout=tempfile, stderr=tempfile)
      end = time.clock()      
        
    if 'Verification failed' in open(tempfile_name).read():
      print Back.RED + Fore.RED + Style.BRIGHT + ': failed' + Style.RESET_ALL + ' (' +  '{0:0.2f}'.format(end - start) + ' sec)'
    elif 'Successfully verified' in open(tempfile_name).read():
      print Back.GREEN + Fore.GREEN + Style.BRIGHT + ': ok' + Style.RESET_ALL + ' (' +  '{0:0.2f}'.format(end - start) + ' sec)'
    else:
      print Back.RED + Fore.RED + Style.BRIGHT + ':OOPS' + Style.RESET_ALL + ' (' +  '{0:0.2f}'.format(end - start) + ' sec)'
    
    outfile.write(open(tempfile_name).read())
    if os.path.isfile(tempfile_name):
      os.remove(tempfile_name)      

  
# Run tests  
init()

if len(sys.argv) > 1:
  # run all together
  run_all ('H:\\Temp\\bin\\fin')
else:
  # run one by one
  run_each ('H:\\Temp\\bin\\fin')
