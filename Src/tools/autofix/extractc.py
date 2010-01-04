import sys
import re
import getopt
import os
from time import time

help_message = '''extractc [options] <input_folder> <output_folder>
This script generates Eiffel classes representing test cases from log files 
in <input_folder> into folder <output_folder>.

Arguments:
<input_folder> is the folder containing files storing serialized test cases.
<output_folder> is the folder to store deserialized test cases.

Options
    -h,--help        Display this help screen.
    --tag            Include the failed assertion name in the test case 
                     file name if current analyzed test case is a failing one.
                     If the current analyzed test case is a successful one, this
                     option is ignored.
    --bpslot         Include the break point slot number in the test case
                     file name if current analyzed test case is a failing one.
                     If the current analyzed test case is a successful one, this
                     option is ignored.
    --failed-only    Only output failing test cases. Default: False.
    --prefix <pre>   Prefix of generated test case class names. Default: TC.
    --name <tcname>  class/feature name included in the generated test case file name.
                     <tcname> can be either "feat-under-test" or "recipient".
                     "feat-under-test" means the feature currently under test;
                     "recipient" means the recipient of the exception. This 
                     option has effect only for failing test cases. For successful
                     test cases, only feature under test is available.
                     Default: "feat-under-test".
    --code           Include exception code in test case file name. Default: False
    --recipient      Include recipient name (class and feature) in test case file name.
                     Default: False
'''

options = {
    'tag': False,
    'bpslot': False,
    'failed-only': False,
    'input-folder': "",
    'output-folder': "",
    'prefix': 'TC',
    'name': 'feat-under-test',
    'code': True,
    'recipient': False
}
tc_id = 1

class_template = '''
class
    $(CLASS_NAME)
    
inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routines

    setup
        local
            data: STRING
        do
            data := serialized_data
            operands ?= deserialized_object (data)
        end

    $(test_feature_name)
        note
            testing: "$(GENERATION_TYPE)"
            testing: "$(SUMMARY)"
        local
            $(TYPES)
        do
            $(BODY)
        end
        
-- Object states
$(STATE_SUMMARY)

-- Exception trace
    exception_trace_string: STRING = "[
$(TRACE)
]"

feature{NONE} -- Implementation
    
    serialized_data: STRING
            -- Serialized test case
        local
            l_array: ARRAY [NATURAL_8]
        do
            l_array := <<
$(SERIALIZED_INT_DATA)>>
            
            Result := string_from_array (l_array)
        end
        
    string_from_array (a_array: ARRAY [NATURAL_8]): STRING is
            -- String from `a_array'.
        local
            l_lower, l_upper: INTEGER
            i: INTEGER
            j: INTEGER
        do
            l_lower := a_array.lower
            l_upper := a_array.upper
            create Result.make_filled (' ', l_upper - l_lower + 1)
            from
                j := 1
                i := l_lower
            until
                i > l_upper
            loop
                Result.put (a_array.item (i).to_character_8, j)
                i := i + 1
                j := j + 1
            end
        end
        
end

'''
#Return a list of integers, each representing a character in string a_str.
def int_list_representation (a_str):
    l = ''
    i = 0
    cnt = len(a_str)
    for c in a_str:
        l = l + str(ord(c))

        if i<cnt-1:
            l = l + ', '
        i = i + 1
        
        if i % 30 == 0:
            l = l + '\n'
        
    return l
        
# Return the generated test case file in a 3-tuple <text, tc_type, tc_file_name>
# text is the content of the test case file.
# tc_type is a dictionary describing the type of current test case, see function test_case_type for details, with two more keys: class-under-test and feature-under-test.
# tc_file_name is the file name for the generated test case.
def print_test_case (body, index_of_tc):    
    #Concatenate all lines into one line.
    s = ""
    for l in body:
        s = s + l
        
    p = re.compile ("<class>(.*)</class>.*<time>(.*)</time>.*<test\_case>(.*)</test\_case>.*<types>(.*)</types>.*<trace>(.*)</trace>.*<object\_state>(.*)</object\_state>.*<data_length>(.*)</data_length>.*<data>(.*)</data>", re.MULTILINE | re.DOTALL)
    m = p.search (s)    
    trace = m.group(5)
    tc_type = test_case_type (trace)
    if tc_type['type'] in ('pass', 'failed'):
        class_name = strip_heading_trailing_newline (m.group(1)) 
        test_case= strip_heading_trailing_newline (m.group(3))
        types = strip_heading_trailing_newline (m.group(4))    
        types = re.sub ("\[like (.+)\] ",  "",  types)
        object_state = m.group(6)
        data_length = m.group(7)
        #data = strip_heading_trailing_newline (strip_heading_trailing_newline (m.group(7)).lstrip('<![CDATA').rstrip(']]>'))    
        data = m.group(8)
        data = data.lstrip('<![CDATA')
        data = data.rstrip("]]>")
        p2 = re.compile ("\.(.+)")
        m2 = p2.search (test_case)
        
        feature_name = m2.group(1)
        i = feature_name.find (' ')
        if i != -1:
            feature_name = feature_name[0:i]
        
        text = class_template.replace('$(test_feature_name)', 'generated_test_1') 
        text = text.replace('$(GENERATION_TYPE)', 'AutoTest test case serialization')
        text = text.replace('$(SUMMARY)', class_name + '.' + feature_name)
        text = text.replace('$(TYPES)', types + newline_char())
        text = text.replace('$(SERIALIZED_INT_DATA)', int_list_representation (data))
        text = text.replace('$(SERIALIZED_DATA)', data)
#        text = text.replace('$(CLASS_NAME)', tclass_name)
        text = text.replace('$(STATE_SUMMARY)', object_state)
        text = text.replace('$(TRACE)', commented_trace(trace))
        
        body = ""
        defs = variable_definitions (types)
        opds = operands (test_case)
        for i in range(0,len(opds)):
            body = body + '\t' + opds[i] + ' ?= operands.item (' + str(i) + ')\n'
    
        body = body + '\t\t\t-- Test case\n'
        body = body + '\t\t' + test_case + '\n'
        
        text = text.replace ("$(BODY)", body)
        
        test_case_fname = test_case_file_name (class_name, feature_name, tc_type, index_of_tc)
        text = text.replace ("$(CLASS_NAME)", test_case_fname)
    else:
        text = ""
        test_case_fname = ""
        class_name = ""
        feature_name = ""
    tc_type['class-under-test'] = class_name
    tc_type['feature-under-test'] = feature_name
    return (text, tc_type, test_case_fname)
    
# Name of the class for current test case.
# class_under_test and feature_under_test indicates the feature under test.
# type_of_tc is the type of current test case, see function test_case_type for details.
def test_case_file_name (class_under_test, feature_under_test, type_of_tc, index_of_tc):    
    fname = options['prefix'] + "__"
    
    if options['name'] == 'feat-under-test':
        fname = fname + class_under_test + "__" + feature_under_test
    else:
        fname = fname + type_of_tc['class'] + "__" + type_of_tc['feature']
    
    if type_of_tc['type'] == 'pass':
        fname = fname + "__S"
    elif type_of_tc['type'] == 'failed':
        fname = fname + "__F"
    else:
        fname = fname + "__I"
        
    if options['code']:
        fname = fname + "__c" + str(type_of_tc['code'])
        
    if options['bpslot']:
        fname = fname + "__b" + str(type_of_tc['bpslot'])
    
    if options['recipient']:
        rcname = type_of_tc['class']
        if rcname == '':
            rcname = class_under_test
            
        rfname = type_of_tc['feature']
        if rfname =='':
            rfname = feature_under_test
            
        fname = fname + "__REC_" + rcname + "__" + rfname
        
    if options['tag']:
        fname = fname + "__TAG_"
        if type_of_tc['tag'] == "":
            fname = fname + "noname"
        else:
            tn = type_of_tc['tag']
            tn = tn.replace(' ', '_')
            tn = tn.replace(':',  '_')
            fname = fname + tn
        
    tm = str(int(time()))    
    fname = fname + "__" + str(tm) + str (index_of_tc)
    
    return fname
    
# Does the exception trace in `a_trace' indicate a valid test case?
# Return value is a dictionary containing the following keys: type, code, bpslot, class, feature, tag]
# type is a string containing one of the following value: "pass", "failed", "invalid",
# code is an integer, representing the exception code, 0 in a passing test case.
# bpslot is an integer, representing the breakpoint slot of the exception, 0 in a passing test case. The breakpoint is the breakpoint of the recipient.
# class and feature are strings representing the recipient of the exception, both are empty strings in a passing test case.
# tag is the tag name of the failed assertion. It is an empty string in a passing test case.
def test_case_type (a_trace):
    lines = a_trace.split('\n')
    except_code = 0
    bpslot = 0
    rec_class_name = ""
    rec_feature_name = ""
    tctype = ""
    tag_name = ""
    if len(lines) > 7:
        except_code = int(lines[2])
        rec_feature_name = lines[3]
        rec_class_name = lines[4]
        tag_name = lines[5]
        invariant_violation_on_entry = (lines[6].find('True') == 0)
        if invariant_violation_on_entry or (rec_feature_name.find('execute_byte_code')==0 and except_code == 3):            
            tctype = 'invalid'       
        else:
            reg = re.compile ("@([0-9]+)", re.MULTILINE)
            m = reg.search (a_trace)
            bpslot = int(m.group(1))            
            tctype = 'failed'
    else:
        tctype = 'pass'
    result = {}
    result['type'] = tctype
    result['code'] = except_code
    result['bpslot'] = bpslot
    result['class'] = rec_class_name
    result['feature']= rec_feature_name
    result['tag'] = tag_name
    return result
    
# Return the commented exception trace
def commented_trace (a_trace):
    trc = a_trace.replace('\r\n', '\n')
    rlt = ''
    for l in trc.split('\n'):
        rlt = rlt + "--" + l + '\n'
    return rlt
    
# Return the new line character
def newline_char():
    return '\n'
    
def strip_trailing_newline (str):
    if str.endswith('\r\n'):
        str1 = str[:-2]
    elif str.endswith('\n'):
        str1 = str[:-1]
    return str1

def strip_heading_trailing_newline (str):
    if str.startswith('\r\n'):
        str1 = str.lstrip('\r\n')
    elif str.startswith('\n'):
        str1 = str.lstrip('\n')
        
    if str1.endswith('\r\n'):
        str1 = str1.rstrip('\r\n')
    elif str1.endswith('\n'):
        str1 = str1.rstrip('\n')
        
    return str1

# Return a dictionary containing the variable definitions specified in string types.
# Key of the dictionary is variable name, value is type (represented as a string) of that variable.
def variable_definitions (types):
    # Decide the new line character.
    i = types.find('\r\n')
    if i != -1:
        nl_char = '\r\n'
    else:
        nl_char = '\n'
    
    # Construct variable-type dictionary.
    vtypes = {}
    for vdef in types.split (nl_char):
        [vname, vtype] = vdef.split (': ') 
        vname = vname.strip(' ')
        vtype = vtype.strip(' ')
        vtypes[vname] = vtype
    
    return vtypes 

# Return a dictionary containing the variables that are serialized.
# Key of the dictionary is the 0-based index of the operands in the serialized data.
# value of the dictionary is the name of the operand as appeared in the test case.
def operands (test_case):
    opds = {}
    
    i = test_case.find('create')
    tc_is_create = (i==0)
    
    i = test_case.find(':=')
    tc_is_query = (i > 0)
    
    index = 0
    
    # Decide the target operand
    if tc_is_create:
        pass
    elif tc_is_query:
        i = test_case.find(':= ')
        j = test_case.find('.')
        target = test_case[i+3:j]
        opds[index] = target 
        index = index + 1       
    else:
        i = 0
        j = test_case.find('.')  
        target = test_case[i:j]      
        opds[index] = target
        index = index + 1
    
    i = test_case.find ('(')
    j = test_case.find (')')
    
    if i > 0:
        # There are arguments.
        for arg in test_case[i+1:j].split(', '):
            opds[index] = arg
            index = index + 1
    
    return opds

# Analyze command line options and arguments
opts, args = getopt.getopt(sys.argv[1:], "h",
        ["help",
         "tag",
         "bpslot",
         "failed-only",
         "prefix=",
         "name=",
         "recipient",
         "code"
         ])
# Parse command line options.
for option, value in opts:
    if option in ('-h', '--help'):
        print help_message
        sys.exit(0)
    elif option in ('--tag'):
        options['tag'] = True
    elif option in ('--bpslot'):
        options['bpslot'] = True
    elif option in ('--failed-only'):
        options['failed-only'] = True
    elif option in ('--prefix'):
        options['prefix'] = value
    elif option in ('--name'):
        if value == 'recipient':
            options['name'] = value
    elif option in ('--code'):
        options['code'] = True
    elif option in ('--recipient'):
        options['recipient'] = True

options['input-folder'] = args[0]
options['output-folder'] = args[1]

# Create folder (if not already exists) based on `a_output_folder' to store test cases for
# a_feature in a_class. 
# Return the feature folder.
def create_folder_for_feature (a_class, a_feature, a_output_folder):
    # Create folder for a_class.
    class_dir_name = a_class
    class_dir_path = os.path.join(a_output_folder, class_dir_name)
    if not os.path.isdir(class_dir_path):
        os.makedirs(class_dir_path)
    
    # Create folder for a_feature.
    feature_dir_name = a_feature
    feature_dir_path = os.path.join(class_dir_path, feature_dir_name)                                                
    if not os.path.isdir(feature_dir_path):
        os.makedirs(feature_dir_path)
                            
    return feature_dir_path

# Analyze the serialization file `a_file' and output test cases in output folder.
def analyze_file (a_file):
    global tc_id
    print "Analyzing ", a_file
    f = open (a_file, 'r') 
    # Are we inside the body of a test case?    
    is_in_tc = False
        
    # Iterate through the file to find test case serialization blocks.
    for line in f:
        #line = line.replace("\n", "")
        #line = line.replace("\r", "")
        if line.startswith("<serialization>"):
            # A test case start is met.
            current_tc = []
            is_in_tc = True;
            
        elif line.startswith("</serialization>"):
            # A test case end is met.
            (tc_body, tc_type, tc_fname) = print_test_case (current_tc, tc_id)
            if tc_type['type'] in ('failed') or (tc_type['type'] in ('pass') and options['failed-only']==False):
                fpath = create_folder_for_feature (tc_type['class-under-test'], tc_type['feature-under-test'], options['output-folder'])
                f = open (os.path.join(fpath, tc_fname + '.e'), 'w')
                f.write (tc_body)
                f.close 
            tc_id = tc_id + 1
            is_in_tc = False;
            
        elif is_in_tc:
            current_tc.append(line)

# Iterate through input folder and analyze every found serialization file.
for fn in os.listdir(options['input-folder']):
    if fn.endswith('.txt'):
        analyze_file (os.path.join(options['input-folder'], fn))
        
print "finished"
