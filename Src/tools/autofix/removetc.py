import sys
import re
import getopt
import os
import random
import shutil
from time import time

help_message = '''
Remove test cases spedified by certain criteria
Usage: removetc [options] <folder>

Arguments:
    <folder>              Folder containing test cases.
    
Options:
    -h,--help               Display this message.
    
'''

options = {
    'folder': ""
}




