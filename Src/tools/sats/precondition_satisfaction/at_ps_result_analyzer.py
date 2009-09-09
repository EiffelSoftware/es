#!/usr/bin/env python
# encoding: utf-8

import sys
import os
import errno
import getopt
import re
import math
from operator import itemgetter


help_message = '''[options] <input_folder> <output_folder>

Options:
  -h,--help           Display this help screen.
  --cut-time <mins>   Analyze first `mins' minutes of logfiles.
                      Error if they are shorter.
                      Default: 60 mins.
  --feature-hardness <float>
                      Set threshold over which a feature is considered hard
                      to test (# invalid_tc / # total_tc).
                      Must be between 0.0 and 1.0, default: 0.9
  --pdf               Save graphs as PDF, default png.
  --eps               Save graphs as EPS, default png.
  --hvlines           Draw hline/vline on scatter plots. Needs files from
                      http://www.mathworks.com/matlabcentral/fileexchange/1039
  --title             Print a title on each graph.
  --testruns <nbr>    The expected number of test runs for or/ps. The
                      superfluous filenames are written to a file, but they
                      are still analyzed. Move or delete them if you do not
                      want to analyze them.
  --median                              Use median for all, default mean.
  --median-count-faults                 Use median, default mean.
  --median-faults-by-time               Use median, default mean.
  --median-valid-tc-gen-by-time         Use median, default mean.
  --median-valid-tc-gen-speed-by-time   Use median, default mean.
  --median-ps-success-rate              Use median, default mean.
  --median-count-valid-tc-by-feature    Use median, default mean.
  --median-count-invalid-tc-by-feature  Use median, default mean.
  --median-feature-hardness             Use median, default mean.
  --median-time-spent-on-invalid-tc     Use median, default mean.
'''
options = {
    'cut-time': 60,
    'feature-hardness': 0.9,
    'pdf': False,
    'eps': False,
    'graph_format': 'png',
    'hvlines': False,
    'title': False,
    'testruns': 15,
    'median': False,
    'median-count-faults': False,
    'median-faults-by-time': False,
    'median-valid-tc-gen-by-time': False,
    'median-valid-tc-gen-speed-by-time': False,
    'median-ps-success-rate': False,
    'median-feature-hardness': False,
    'median-count-valid-tc-by-feature': False,
    'median-count-invalid-tc-by-feature': False,
    'median-time-spent-on-invalid-tc': False,
}


class MyException(Exception):
    def __init__(self, msg):
        self.msg = msg
    def __str__(self):
        return self.msg

class Usage(MyException):
    pass

class MyError(MyException):
    pass

class MyWarning(MyException):
    pass


class AnalyzedResult(object):
    '''Holds analysis of a result file.'''
    
    def __init__(self):
        # meta info
        self.filename = ""
        self.test_mode = ""
        self.test_main_class = ""
        self.test_duration_mins = 0
        self.test_nbr = 0
        
        self.classes_under_test = []
        self.last_timestamp = 0
        
        self.count_faults = 0
        self.faults_by_time = {}
        self.distinct_faults = []
        self.valid_tc_gen_by_time = {}
        self.valid_tc_gen_speed_by_time = {}
        self.ps_success_rate_by_time = {}
        self.precond_features = []
        self.precond_features_with_valid_tc = []
        self.precond_features_with_valid_tc_after_cut_time = []
        self.precond_features_without_valid_tc = []
        self.count_valid_tc_by_feature = {}
        self.count_invalid_tc_by_feature = {}
        self.hardness_by_feature = {}
        self.time_spent_on_invalid_tc_as_percentage = 0
    
    @classmethod
    def init_from_file(cls, filepath):
        ret = cls()
        (dn, fn) = os.path.split(filepath)
        
        # check and parse filename
        pattern = re.compile("((or|ps)_([_A-Z]+))_result_([0-9]+)_min_([0-9]+)\.txt")
        match = re.match(pattern, fn)
        if not match:
            raise MyWarning("'%s' does not match filename pattern, ignoring." % fn)
        ret.filename = fn
        ret.test_mode = match.group(2)
        ret.test_main_class = match.group(3)
        ret.test_duration_mins = int(match.group(4))
        ret.test_nbr = int(match.group(5))
        
        # read file in
        fp = open(filepath)
        contents = fp.read()

        # classes_under_test
        pattern = re.compile("--\[Class under test\]\n([A-Z0-9-_\n]*)\n\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Class under test]" % fn)
        for class_under_test in match.group(1).split('\n'):
            ret.classes_under_test.append(class_under_test)
        
        # last_timestamp
        pattern = re.compile("--\[Last time stamp\]\n([0-9]+)\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Last time stamp]" % fn)
        if int(match.group(1)) < options['cut-time'] * 60:
            raise MyWarning("'%s' too short duration, ignoring." % fn)
        ret.last_timestamp = int(match.group(1))

        # count_faults, faults_by_time and distinct_faults
        pattern = re.compile("--\[Faults\].*\n((.+\n)*)\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Faults]" % fn)
        times = {}
        for line in match.group(1).split('\n')[1:-1]:
            pattern = re.compile("([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)?\t([^\t]+)\t([^\t]+)\t([^\t]+)")
            match = re.search(pattern, line)
            if not match:
                raise MyError("%s:'%s': wrong fault-line format" % (fn, line))
            iter_time_minute = int(match.group(7)) // 60 + 1
            if iter_time_minute > options['cut-time']:
                break
            if iter_time_minute in times.keys():
                times[iter_time_minute] += 1
            else:
                times[iter_time_minute] = 1
            iter_fault_id = match.group(2) + ':' + match.group(3) + ':' + match.group(4) + ':' + str(match.group(5)) + ':' + match.group(6)
            if not iter_fault_id in ret.distinct_faults:
                ret.distinct_faults.append(iter_fault_id)
        ret.count_faults = len(ret.distinct_faults)
        # for fault/time curve, cap at options['cut-time'] minutes
        sum_count = 0
        for i in range(1, options['cut-time']+1):
            if i in times.keys():
                sum_count += times[i]
            ret.faults_by_time[i] = sum_count

        # valid_tc_gen_by_time
        pattern = re.compile("--\[Valid test case generation speed\]\n((.+\n)*)\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Valid test case generation speed]" % fn)
        for line in match.group(1).split('\n')[1:-1]:
            pattern = re.compile("(\d+)\t(\d+)")
            match = re.search(pattern, line)
            if not match:
                raise MyError("%s:'%s': wrong valid_tc_gen-line format" % (fn, line))
            iter_time_minute = int(match.group(1))
            # cap at options['cut-time'] minutes
            if iter_time_minute > options['cut-time']:
                break
            ret.valid_tc_gen_by_time[iter_time_minute] = int(match.group(2))
        
        # valid_tc_gen_speed_by_time
        ret.valid_tc_gen_speed_by_time[1] = ret.valid_tc_gen_by_time[1]
        for i in range(2, options['cut-time']+1):
            ret.valid_tc_gen_speed_by_time[i] = ret.valid_tc_gen_by_time[i] - ret.valid_tc_gen_by_time[i-1]
        
        # ps_success_rate_by_time
        pattern = re.compile("--\[Precondition satisfaction failure rate\]\n((.+\n)*)\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Precondition satisfaction failure rate]" % fn)
        for line in match.group(1).split('\n')[1:-1]:
            pattern = re.compile("(\d+)\t(\d+)\t(\d+)\t(\d+)")
            match = re.search(pattern, line)
            if not match:
                raise MyError("%s:'%s': wrong ps_success_rate_by_time-line format" % (fn, line))
            iter_time_minute = int(round(int(match.group(1)) / 60.0))
            iter_divisor = float(int(match.group(2)))
            if iter_divisor == 0:
                iter_success_rate = 1
            else:
                iter_success_rate = float(int(match.group(2)) - int(match.group(3))) / iter_divisor
            if iter_time_minute > options['cut-time']:
                break
            if iter_time_minute in ret.ps_success_rate_by_time.keys() and iter_success_rate != ret.ps_success_rate_by_time[iter_time_minute]:
                raise MyError("%s:'%s': iter_time_minute(%i) already exists" % (fn, line, iter_time_minute))
            ret.ps_success_rate_by_time[iter_time_minute] = iter_success_rate
        # make sure there is a value for each minute
        for i in range(1, options['cut-time']+1):
            if i in ret.ps_success_rate_by_time.keys():
                continue
            if i == 1:
                ret.ps_success_rate_by_time[1] = 1
            else:
                ret.ps_success_rate_by_time[i] = ret.ps_success_rate_by_time[i-1]
        
        # precond_features, precond_features_with_valid_tc,
        # precond_features_with_valid_tc_after_cut_time,
        # precond_features_without_valid_tc, count_valid_tc_by_feature,
        # count_invalid_tc_by_feature, hardness_by_feature
        # time_spent_on_invalid_tc_as_percentage
        pattern = re.compile("--\[Feature statistics\]\n((.+\n)*)\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Feature statistics]" % fn)
        time_spent_on_invalid_tc_sum = 0
        for line in match.group(1).split('\n')[1:-1]:
            pattern = re.compile("([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)")
            match = re.search(pattern, line)
            if not match:
                raise MyError("%s:'%s': wrong feature_stats-line format" % (fn, line))
            
            iter_class_name = match.group(1)
            iter_feature_name = match.group(2)
            if iter_feature_name in ['standard_is_equal', 'conforms_to', 'same_type', 'deep_copy', 'is_deep_equal', 'copy', 'standard_copy', 'is_equal']:
                continue
            if iter_class_name not in ret.classes_under_test:
                continue
            iter_feature_id = iter_class_name + ':' + iter_feature_name + ':' + match.group(3)
            time_spent_on_invalid_tc_sum += int(match.group(11))
            iter_valid_tc = int(match.group(4)) + int(match.group(5)) + int(match.group(6))
            iter_invalid_tc = int(match.group(7))
            iter_total_tc = iter_valid_tc + iter_invalid_tc
            if iter_total_tc > 0:
                iter_hardness = float(iter_invalid_tc) / iter_total_tc
            else:
                # might happen, for example with feature 'clone'
                iter_hardness = 0
            ret.count_valid_tc_by_feature[iter_feature_id] = iter_valid_tc
            ret.count_invalid_tc_by_feature[iter_feature_id] = iter_invalid_tc
            ret.hardness_by_feature[iter_feature_id] = iter_hardness
            if match.group(3) != 'has_precondition':
                continue
            ret.precond_features.append(iter_feature_id)
            iter_time_first_valid_tc = int(match.group(12))
            if iter_time_first_valid_tc / 60.0 >= options['cut-time']:
                ret.precond_features_with_valid_tc_after_cut_time.append(iter_feature_id)
                ret.precond_features_without_valid_tc.append(iter_feature_id)
            elif iter_time_first_valid_tc == -1:
                ret.precond_features_without_valid_tc.append(iter_feature_id)
            else:
                ret.precond_features_with_valid_tc.append(iter_feature_id)
        ret.time_spent_on_invalid_tc_as_percentage = 100.0 * float(time_spent_on_invalid_tc_sum) / ret.last_timestamp
        
        # sanity check on the number of tested and untested features
        assert(len(ret.precond_features) == len(ret.precond_features_with_valid_tc) + len(ret.precond_features_without_valid_tc))
        pattern = re.compile("--\[Untested features\].*\n((.+\n)*)\n")
        match = re.search(pattern, contents)
        if not match:
            raise MyError("'%s': missing [Untested features]" % fn)
        untested_features_in_cus = []
        for line in match.group(1).split('\n')[1:-1]:
            pattern = re.compile("([^\t]+)\t([^\t]+)\t.*")
            match = re.search(pattern, line)
            if not match:
                raise MyError("%s:'%s': wrong untested_feature-line format" % (fn, line))
            if match.group(1) in ret.classes_under_test:
                untested_features_in_cus.append(match.group(1) + ":" + match.group(2))
        if len(untested_features_in_cus) != len(ret.precond_features_without_valid_tc) - len(ret.precond_features_with_valid_tc_after_cut_time):
            print untested_features_in_cus
            print ret.precond_features_without_valid_tc
            raise MyError("%s: # untested features: expected %s, got %s." % (ret.filename, len(untested_features_in_cus), len(ret.precond_features_without_valid_tc)))
        
        return ret
    
    @classmethod
    def init_by_avg(cls, list_of_ar):
        if not isinstance(list_of_ar, list):
            raise MyError("'%s': not a list" % (list_of_ar))
        ret = cls()
        len_list_of_ar = len(list_of_ar)
        
        # count_faults
        iter_list = map(lambda x: x.count_faults, list_of_ar)
        if options['median-count-faults']:
            ret.count_faults = cls.compute_median(iter_list)
        else:
            ret.count_faults = cls.compute_mean(iter_list)
        
        # faults_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.faults_by_time[i], list_of_ar)
            if options['median-faults-by-time']:
                ret.faults_by_time[i] = cls.compute_median(iter_list)
            else:
                ret.faults_by_time[i] = cls.compute_mean(iter_list)
        
        # distinct_faults
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.distinct_faults)
        ret.distinct_faults = list(set(iter_list))

        # valid_tc_gen_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.valid_tc_gen_by_time[i], list_of_ar)
            if options['median-valid-tc-gen-by-time']:
                ret.valid_tc_gen_by_time[i] = cls.compute_median(iter_list)
            else:
                ret.valid_tc_gen_by_time[i] = cls.compute_mean(iter_list)

        # valid_tc_gen_speed_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.valid_tc_gen_speed_by_time[i], list_of_ar)
            if options['median-valid-tc-gen-speed-by-time']:
                ret.valid_tc_gen_speed_by_time[i] = cls.compute_median(iter_list)
            else:
                ret.valid_tc_gen_speed_by_time[i] = cls.compute_mean(iter_list)
        
        # ps_success_rate_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.ps_success_rate_by_time[i], list_of_ar)
            if options['median-ps-success-rate']:
                ret.ps_success_rate_by_time[i] = cls.compute_median(iter_list)
            else:
                ret.ps_success_rate_by_time[i] = cls.compute_mean(iter_list)
        
        # precond_features
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.precond_features)
        ret.precond_features = list(set(iter_list))
        
        # precond_features_with_valid_tc
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.precond_features_with_valid_tc)
        ret.precond_features_with_valid_tc = list(set(iter_list))
        
        # precond_features_without_valid_tc
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.precond_features_without_valid_tc)
        ret.precond_features_without_valid_tc = list(set(iter_list) - set(ret.precond_features_with_valid_tc))
        
        # sanity check
        if len(ret.precond_features) != len(ret.precond_features_with_valid_tc) + len(ret.precond_features_without_valid_tc):
            print ar.filename
            print "expected %i, but got %i valid + %i invalid = %i" % (len(ret.precond_features), len(ret.precond_features_with_valid_tc), len(ret.precond_features_without_valid_tc), len(ret.precond_features_with_valid_tc) + len(ret.precond_features_without_valid_tc))
            raise MyError("assertion failure")
        
        # count_valid_tc_by_feature
        # first, fill the holes
        all_features = set()
        for ar in list_of_ar:
            all_features.update(ar.count_valid_tc_by_feature.keys())
        for iter_feat in all_features:
            for ar in list_of_ar:
                if not iter_feat in ar.count_valid_tc_by_feature.keys():
                    ar.count_valid_tc_by_feature[iter_feat] = 0
            # second, compute the average
            iter_list = map(lambda x: x.count_valid_tc_by_feature[iter_feat], list_of_ar)
            if options['median-count-valid-tc-by-feature']:
                ret.count_valid_tc_by_feature[iter_feat] = cls.compute_median(iter_list)
            else:
                ret.count_valid_tc_by_feature[iter_feat] = cls.compute_mean(iter_list)
        
        # count_invalid_tc_by_feature
        # first, fill the holes
        all_features = set()
        for ar in list_of_ar:
            all_features.update(ar.count_invalid_tc_by_feature.keys())
        for iter_feat in all_features:
            for ar in list_of_ar:
                if not iter_feat in ar.count_invalid_tc_by_feature.keys():
                    ar.count_invalid_tc_by_feature[iter_feat] = 0
            # second, compute the average
            iter_list = map(lambda x: x.count_invalid_tc_by_feature[iter_feat], list_of_ar)
            if options['median-count-invalid-tc-by-feature']:
                ret.count_invalid_tc_by_feature[iter_feat] = cls.compute_median(iter_list)
            else:
                ret.count_invalid_tc_by_feature[iter_feat] = cls.compute_mean(iter_list)
        
        # hardness_by_feature
        # first, fill the holes
        all_features = set()
        for ar in list_of_ar:
            all_features.update(ar.hardness_by_feature.keys())
        for iter_feat in all_features:
            for ar in list_of_ar:
                if not iter_feat in ar.hardness_by_feature.keys():
                    ar.hardness_by_feature[iter_feat] = 0
            # second, compute the average
            iter_list = map(lambda x: x.hardness_by_feature[iter_feat], list_of_ar)
            if options['median-feature-hardness']:
                ret.hardness_by_feature[iter_feat] = cls.compute_median(iter_list)
            else:
                ret.hardness_by_feature[iter_feat] = cls.compute_mean(iter_list)
        
        # time_spent_on_invalid_tc_as_percentage
        iter_list = map(lambda x: x.time_spent_on_invalid_tc_as_percentage, list_of_ar)
        if options['median-time-spent-on-invalid-tc']:
            ret.time_spent_on_invalid_tc_as_percentage = cls.compute_median(iter_list)
        else:
            ret.time_spent_on_invalid_tc_as_percentage = cls.compute_mean(iter_list)
        
        return ret
    
    @classmethod
    def compute_mean(cls, list_of_values):
        if not isinstance(list_of_values, list):
            raise MyError("'%s': not a list" % (list_of_values))
        return sum(list_of_values) / float(len(list_of_values))

    @classmethod
    def compute_median(cls, list_of_values):
        if not isinstance(list_of_values, list):
            raise MyError("'%s': not a list" % (list_of_values))
        n = len(list_of_values)
        sorted_copy = sorted(list_of_values)
        if n & 1:         # There is an odd number of elements
            return sorted_copy[n // 2]
        else:
            return (sorted_copy[n // 2 - 1] + sorted_copy[n // 2]) / 2.0

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "h",
                    ["help", "cut-time=",
                            "feature-hardness=",
                            "pdf",
                            "eps",
                            "hvlines",
                            "title",
                            "testruns",
                            "median",
                            "median-count-faults",
                            "median-faults-by-time",
                            "median-valid-tc-gen-by-time",
                            "median-valid-tc-gen-speed-by-time",
                            "median-ps-success-rate",
                            "median-count-valid-tc-by-feature",
                            "median-count-invalid-tc-by-feature",
                            "median-feature-hardness",
                            "median-time-spent-on-invalid-tc"])
        except getopt.error, msg:
            raise Usage(msg)
        
        # option processing
        for option, value in opts:
            # if option == "-v":
            #     verbose = True
            
            if option in ("-h", "--help"):
                raise Usage(help_message)
            
            if option in ("--cut-time"):
                try:
                    if int(value) > 0:
                        options['cut-time'] = int(value)
                    else:
                        raise ValueError
                except ValueError, err:
                    raise Usage("arg must be positive integer ('%s')." % value)
            
            if option in ("--feature-hardness"):
                try:
                    val = float(value)
                    if val >= 0.0 and val <= 1.0:
                        options['feature-hardness'] = val
                    else:
                        raise ValueError
                except ValueError, err:
                    raise Usage("arg must be between 0.0 and 1.0 ('%s')." % value)
            
            if option in ("--pdf"):
                options['pdf'] = True
                options['graph_format'] = 'pdf'
            if option in ("--eps"):
                options['eps'] = True
                options['graph_format'] = 'epsc2'
            
            if option in ("--hvlines"):
                options["hvlines"] = True
            
            if option in ("--title"):
                options["title"] = True
            
            if option in ("--testruns"):
                try:
                    if int(value) > 0:
                        options['testruns'] = int(value)
                    else:
                        raise ValueError
                except ValueError, err:
                    raise Usage("arg must be positive integer ('%s')." % value)
            
            if option in ("--median"):
                options['median'] = True
                options['median-count-faults'] = True
                options['median-faults-by-time'] = True
                options['median-valid-tc-gen-by-time'] = True
                options['median-valid-tc-gen-speed-by-time'] = True
                options['median-ps-success-rate'] = True
                options['median-count-valid-tc-by-feature'] = True
                options['median-count-invalid-tc-by-feature'] = True
                options['median-feature-hardness'] = True
                options['median-time-spent-on-invalid-tc'] = True
            
            if option in ("--median-faults-by-time"):
                options['median-faults-by-time'] = True
            if option in ("--median-count-faults"):
                options['median-count-faults'] = True
            if option in ("--median-valid-tc-gen-by-time"):
                options['median-valid-tc-gen-by-time'] = True
            if option in ("--median-valid-tc-gen-speed-by-time"):
                options['median-valid-tc-gen-speed-by-time'] = True
            if option in ("--median-ps-success-rate"):
                options['median-ps-success-rate'] = True
            if option in ("--median-count-valid-tc-by-feature"):
                options['median-count-valid-tc-by-feature'] = True
            if option in ("--median-count-invalid-tc-by-feature"):
                options['median-count-invalid-tc-by-feature'] = True
            if option in ("--median-feature-hardness"):
                options['median-feature-hardness'] = True
            if option in ("--median-time-spent-on-invalid-tc"):
                options['median-time-spent-on-invalid-tc'] = True
        
        # arguments processing
        if len(args) != 2:
            raise Usage(help_message)
        
        if os.path.isdir(args[0]):
            options['infolder'] = args[0]
        else:
            raise Usage("arg must be a folder ('%s')." % args[0])
        
        options['outfolder'] = args[1]
        options['analysis_outfolder'] = os.path.join(options["outfolder"], "analysis_data")
        options['graphs_outfolder'] = os.path.join(options["outfolder"], "graphs")
        options['tables_outfolder'] = os.path.join(options["outfolder"], "tables")
        try:
            os.makedirs(options["outfolder"])
            os.makedirs(options["analysis_outfolder"])
            os.makedirs(options["graphs_outfolder"])
            os.makedirs(options["tables_outfolder"])
        except OSError, exc:
            if exc.errno == errno.EEXIST:
                pass
            else:
                raise
    
    except Usage, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        return 2
    
    
    # debug output
    #print >> sys.stderr, "Options: %s" % options
    
    # run the beef
    # format: processed_results[main_class][test_mode][test_nbr/'avg']
    processed_results = {}
    try:
        for fn in os.listdir(options['infolder']):
            try:
                ar = AnalyzedResult.init_from_file(os.path.join(options['infolder'], fn))
            except MyWarning, err:
                print >> sys.stderr, err
                continue
            except MyError, err:
                print >> sys.stderr, err
                return 3
            
            # update the list of processed cases
            if not ar.test_main_class in processed_results:
                processed_results[ar.test_main_class] = {}
            if not ar.test_mode in processed_results[ar.test_main_class]:
                processed_results[ar.test_main_class][ar.test_mode] = {}
            if ar.test_nbr in processed_results[ar.test_main_class][ar.test_mode]:
                raise MyError("Should not happen")
            processed_results[ar.test_main_class][ar.test_mode][ar.test_nbr] = ar
            
    except OSError, err:
        print >> sys.stderr, err
        return 3
    
    
    # calculate the averages
    for test_main_class, i in processed_results.iteritems():
        for test_mode, j in i.iteritems():
            avg = AnalyzedResult.init_by_avg(j.values())
            j['avg'] = avg
    
    
    # write output
    for test_main_class, i in processed_results.iteritems():
        for test_mode, j in i.iteritems():
            # create directories
            iter_outfolder = os.path.join(options['analysis_outfolder'], test_main_class, test_mode)
            try:
                os.makedirs(iter_outfolder)
            except OSError, exc:
                if exc.errno == errno.EEXIST:
                    pass
                else:
                    raise
            
            # write faults_by_time
            iter_outfile = os.path.join(iter_outfolder, 'faults_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].faults_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write distinct_faults
            iter_outfile = os.path.join(iter_outfolder, 'distinct_faults.txt')
            iter_fp = open(iter_outfile, 'w')
            for v in j['avg'].distinct_faults:
                iter_fp.write("%s\n" % (v))
            iter_fp.close()

            # write valid_tc_gen_by_time
            iter_outfile = os.path.join(iter_outfolder, 'valid_tc_gen_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].valid_tc_gen_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write valid_tc_gen_speed_by_time
            iter_outfile = os.path.join(iter_outfolder, 'valid_tc_gen_speed_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].valid_tc_gen_speed_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write ps_success_rate_by_time
            iter_outfile = os.path.join(iter_outfolder, 'ps_success_rate_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].ps_success_rate_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write precond_features_with_valid_tc
            iter_outfile = os.path.join(iter_outfolder, 'precond_features_with_valid_tc.txt')
            iter_fp = open(iter_outfile, 'w')
            for v in j['avg'].precond_features_with_valid_tc:
                iter_fp.write("%s\n" % (v))
            iter_fp.close()
            
            # write precond_features_without_valid_tc
            iter_outfile = os.path.join(iter_outfolder, 'precond_features_without_valid_tc.txt')
            iter_fp = open(iter_outfile, 'w')
            for v in j['avg'].precond_features_without_valid_tc:
                iter_fp.write("%s\n" % (v))
            iter_fp.close()
    
    
    # comes in handy
    test_main_classes = sorted(processed_results.keys())
    
    
    # write the superfluous test runs to file
    iter_outfile = os.path.join(options['analysis_outfolder'], '_superfluous_testruns.txt')
    iter_fp = open(iter_outfile, 'w')
    for iter_test_main_class, i in processed_results.iteritems():
        if 'or' in i.keys():
            for iter_k in (([k for k in i['or'].keys() if k != 'avg'])[options['testruns']:]):
                iter_fp.write("%s\n" % i['or'][iter_k].filename)
        if 'ps' in i.keys():
            for iter_k in (([k for k in i['ps'].keys() if k != 'avg'])[options['testruns']:]):
                iter_fp.write("%s\n" % i['ps'][iter_k].filename)
    iter_fp.close()
    
    
    # write comparison on nbr of valid test runs
    iter_outfile = os.path.join(options['analysis_outfolder'], '_count_valid_test_runs.txt')
    iter_fp = open(iter_outfile, 'w')
    for iter_test_main_class, i in processed_results.iteritems():
        iter_len_or = 0
        if 'or' in i.keys():
            iter_len_or = len(i['or'])-1
        iter_len_ps = 0
        if 'ps' in i.keys():
            iter_len_ps = len(i['ps'])-1
        iter_fp.write("%s\t%i\t%i\n" % (iter_test_main_class, iter_len_or, iter_len_ps))
    iter_fp.close()
    
    
    # write tables
    
    ### pf(_untested) does not make sense anymore
    # # table untested_precond_features_sorted_name
    # iter_outfile = os.path.join(options['tables_outfolder'], 'untested_precond_features_sorted_name.txt')
    # iter_fp = open(iter_outfile, 'w')
    # # ugly hack, should be somewhere else...
    # precond_features_count_by_class = {}
    # precond_features_untested_perc_or_by_class = {}
    # precond_features_untested_perc_ps_by_class = {}
    # precond_features_untested_increase_perc_by_class = {}
    # for iter_test_main_class in sorted(processed_results.keys()):
    #     i = processed_results[iter_test_main_class]
    #     if not 'or' in i.keys() or not 'ps' in i.keys():
    #         print >> sys.stderr, "untested_precond_features_sorted_name: '%s' or/ps not found, ignoring class." % iter_test_main_class
    #         continue
    #     iter_or = i['or']['avg']
    #     iter_ps = i['ps']['avg']
    #     iter_count_pf = len(iter_or.precond_features)
    #     iter_or_untested_pf = 100.0 * float(len(iter_or.precond_features_without_valid_tc)) / float(iter_count_pf)
    #     iter_ps_untested_pf = 100.0 * float(len(iter_ps.precond_features_without_valid_tc)) / float(iter_count_pf)
    #     if iter_or_untested_pf == 0:
    #         if iter_ps_untested_pf == 0:
    #             iter_increase = 0
    #         else:
    #             print >> sys.stderr, "untested_precond_features_sorted_name: '%s' or==0, but ps!=0..." % iter_test_main_class
    #     else:
    #         iter_increase = 100.0 * (1 - float(iter_ps_untested_pf) / float(iter_or_untested_pf))
    #     iter_fp.write("%s & %i & %.2f & %.2f & %.2f\\\\\n" %
    #             (iter_test_main_class.replace('_', '\_'),
    #             iter_count_pf,
    #             iter_or_untested_pf,
    #             iter_ps_untested_pf,
    #             iter_increase))
    #     precond_features_count_by_class[iter_test_main_class] = iter_count_pf
    #     precond_features_untested_perc_or_by_class[iter_test_main_class] = iter_or_untested_pf
    #     precond_features_untested_perc_ps_by_class[iter_test_main_class] = iter_ps_untested_pf
    #     precond_features_untested_increase_perc_by_class[iter_test_main_class] = iter_increase
    # iter_fp.close()
    
    ### pf(_untested) does not make sense anymore
    # # table untested_precond_features_sorted_incr
    # iter_outfile = os.path.join(options['tables_outfolder'], 'untested_precond_features_sorted_incr.txt')
    # iter_fp = open(iter_outfile, 'w')
    # # sort reversed by percentual increase
    # for iter_class, iter_precond_feat_incr in sorted(precond_features_untested_increase_perc_by_class.items(), key=itemgetter(1), reverse=True):
    #     iter_fp.write("%s & %i & %.2f & %.2f & %.2f\\\\\n" %
    #             (iter_class.replace('_', '\_'),
    #             precond_features_count_by_class[iter_class],
    #             precond_features_untested_perc_or_by_class[iter_class],
    #             precond_features_untested_perc_ps_by_class[iter_class],
    #             precond_features_untested_increase_perc_by_class[iter_class]))
    # iter_fp.close()
    
    
    # calculate some values
    # ugly hack, should be somewhere else...
    precond_features_count_by_class = {}
    precond_features_untested_perc_or_by_class = {}
    precond_features_untested_perc_ps_by_class = {}
    for iter_test_main_class in sorted(processed_results.keys()):
        i = processed_results[iter_test_main_class]
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "untested_precond_features_sorted_name: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_or = i['or']['avg']
        iter_ps = i['ps']['avg']
        iter_count_pf = len(iter_or.precond_features)
        iter_or_untested_pf = 100.0 * float(len(iter_or.precond_features_without_valid_tc)) / float(iter_count_pf)
        iter_ps_untested_pf = 100.0 * float(len(iter_ps.precond_features_without_valid_tc)) / float(iter_count_pf)
        precond_features_count_by_class[iter_test_main_class] = iter_count_pf
        precond_features_untested_perc_or_by_class[iter_test_main_class] = iter_or_untested_pf
        precond_features_untested_perc_ps_by_class[iter_test_main_class] = iter_ps_untested_pf
    
    # table tested_precond_features_sorted_incr
    iter_outfile = os.path.join(options['tables_outfolder'], 'tested_precond_features_sorted_incr.txt')
    iter_fp = open(iter_outfile, 'w')
    # ugly hack, should be somewhere else...
    precond_features_tested_perc_or_by_class = {}
    precond_features_tested_perc_ps_by_class = {}
    precond_features_tested_increase_perc_by_class = {}
    # first, calculate new increase
    for iter_test_main_class in precond_features_untested_perc_or_by_class.keys():
        iter_tested_pf_or = 100 - precond_features_untested_perc_or_by_class[iter_test_main_class]
        iter_tested_pf_ps = 100 - precond_features_untested_perc_ps_by_class[iter_test_main_class]
        iter_tested_pf_increase = 100.0 * (float(iter_tested_pf_ps) / float(iter_tested_pf_or) - 1)
        precond_features_tested_perc_or_by_class[iter_test_main_class] = iter_tested_pf_or
        precond_features_tested_perc_ps_by_class[iter_test_main_class] = iter_tested_pf_ps
        precond_features_tested_increase_perc_by_class[iter_test_main_class] = iter_tested_pf_increase
    for iter_class, iter_precond_feat_incr in sorted(precond_features_tested_increase_perc_by_class.items(), key=itemgetter(1), reverse=True):
        iter_fp.write("%s & %i & %.2f & %.2f & %.2f\\\\\n" %
                (iter_class.replace('_', '\_'),
                precond_features_count_by_class[iter_class],
                precond_features_tested_perc_or_by_class[iter_class],
                precond_features_tested_perc_ps_by_class[iter_class],
                precond_features_tested_increase_perc_by_class[iter_class]))
    iter_fp.close()
    
    # table classes_under_test
    iter_outfile = os.path.join(options['tables_outfolder'], 'classes_under_test.txt')
    iter_fp = open(iter_outfile, 'w')
    for iter_class in sorted(processed_results.keys()):
        iter_fp.write("%s\\\\\n" % iter_class.replace('_', '\_'))
    iter_fp.close()
    
    # table classes_under_test_two_cols
    iter_outfile = os.path.join(options['tables_outfolder'], 'classes_under_test_two_cols.txt')
    iter_fp = open(iter_outfile, 'w')
    test_main_classes_zipped = dict(zip(range(1,len(test_main_classes)+1), test_main_classes))
    test_main_classes_cut_at = int(math.ceil(len(test_main_classes_zipped) / 2.0))
    for iter_index in range(1, test_main_classes_cut_at+1):
        iter_fp.write("%s & " % test_main_classes_zipped[iter_index].replace('_', '\_'))
        if (iter_index + test_main_classes_cut_at) in test_main_classes_zipped.keys():
            iter_fp.write("%s " % test_main_classes_zipped[iter_index + test_main_classes_cut_at].replace('_', '\_'))
        iter_fp.write("\\\\\n")
    iter_fp.close()
    
    # table time_spent_on_invalid_tc
    iter_outfile = os.path.join(options['tables_outfolder'], 'time_spent_on_invalid_tc.txt')
    iter_fp = open(iter_outfile, 'w')
    # first, calculate overall averages
    time_invalid_tc_or = []
    time_invalid_tc_ps = []
    for iter_test_main_class, i in processed_results.iteritems():
        if 'or' in i.keys():
            time_invalid_tc_or.append(i['or']['avg'].time_spent_on_invalid_tc_as_percentage)
        if 'ps' in i.keys():
            time_invalid_tc_ps.append(i['ps']['avg'].time_spent_on_invalid_tc_as_percentage)
    if options['median-time-spent-on-invalid-tc']:
        time_invalid_tc_or_avg = AnalyzedResult.compute_median(time_invalid_tc_or)
        time_invalid_tc_ps_avg = AnalyzedResult.compute_median(time_invalid_tc_ps)
    else:
        time_invalid_tc_or_avg = AnalyzedResult.compute_mean(time_invalid_tc_or)
        time_invalid_tc_ps_avg = AnalyzedResult.compute_mean(time_invalid_tc_ps)
    iter_fp.write("Average ^ %.2f ^ %.2f\\\\\n" % (time_invalid_tc_or_avg, time_invalid_tc_ps_avg))
    for iter_test_main_class in sorted(processed_results.keys()):
        i = processed_results[iter_test_main_class]
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "time_spent_on_invalid_tc: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_fp.write("%s ^ %.2f ^ %.2f\\\\\n" % (iter_test_main_class.replace('_', '\_'), i['or']['avg'].time_spent_on_invalid_tc_as_percentage, i['ps']['avg'].time_spent_on_invalid_tc_as_percentage))
    iter_fp.close()
    
    # write matlab script for graph generation
    matlab_fp = open(os.path.join(options['outfolder'], 'gen_graphs.m'), 'w')
    
    # graph line_speed_all_classes
    matlab_fp.write("\n")
    matlab_fp.write("%% line_speed_all_classes\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("hold on;\n")
    matlab_fp.write("x = 1:1:60;\n")
    matlab_fp.write("y = [];\n")
    matlab_fp.write("classnames = [];\n")
    matlab_fp.write("yspecial = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_or)):
            matlab_fp.write("data_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "line_speed_all_classes: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
            matlab_fp.write("data_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "line_speed_all_classes: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        matlab_fp.write("y = [y;(data_ps(:,2)./data_or(:,2) - 1)'];\n")
        matlab_fp.write("classnames = strvcat(classnames, '%s');\n" % iter_test_main_class.replace('_', '\_'))
    matlab_fp.write("yspecial = [yspecial; median(y)];\n")
    matlab_fp.write("ymean = mean(y,2);\n")
    matlab_fp.write("[C,Imin] = min(ymean);\n")
    matlab_fp.write("[C,Imax] = max(ymean);\n")
    matlab_fp.write("yspecial = [yspecial; y(Imax,:); y(Imin,:)];\n")
    matlab_fp.write("classlines = plot(h, x, y, 'y-');\n")
    matlab_fp.write("speciallines = plot(h, x, yspecial(1,:), 'g-', x, yspecial(2,:), 'b-', x, yspecial(3,:), 'r-', 'LineWidth', 2);\n")
    matlab_fp.write("legendnames = strvcat('All classes', 'Median of all classes', classnames(Imax,:), classnames(Imin,:));\n")
    matlab_fp.write("legend([classlines(1); speciallines], legendnames, 'Location', 'SouthEast');\n")
    matlab_fp.write("xlabel(h, 'Duration of test run (minutes)');\n")
    matlab_fp.write("ylabel(h, 'Relative speed');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Relative speed of all classes');\n")
    matlab_fp.write("saveas(h, 'graphs/line_speed_all_classes', '%s');\n" % (options['graph_format']))
    matlab_fp.write("hold off;\n")
    matlab_fp.write("\n")
    
    # graph line_ps_success_rate_all_classes
    matlab_fp.write("\n")
    matlab_fp.write("%% line_ps_success_rate_all_classes\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("x = 1:1:60;\n")
    matlab_fp.write("y = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "ps_success_rate_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
            matlab_fp.write("data_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "line_ps_success_rate_all_classes: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        matlab_fp.write("y = [y;data_ps(:,2)'];\n")
    matlab_fp.write("plot(h, x, y);\n")
    matlab_fp.write("xlabel(h, 'Duration of test run (minutes)');\n")
    matlab_fp.write("ylabel(h, 'PS success rate');\n")
    if options['title']:
        matlab_fp.write("title(h, 'PS success rate of all classes');\n")
    matlab_fp.write("saveas(h, 'graphs/line_ps_success_rate_all_classes', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")
    
    # graph line_faults-ps_success_rate
    matlab_fp.write("\n")
    matlab_fp.write("%% line_faults-ps_success_rate\n")
    for iter_test_main_class in test_main_classes:
        iter_outpath = os.path.join("graphs", "line_faults-ps_success_rate", "%s" % (iter_test_main_class))
        try:
            os.makedirs(os.path.join(options['graphs_outfolder'], 'line_faults-ps_success_rate'))
        except OSError, exc:
            if exc.errno == errno.EEXIST:
                pass
            else:
                raise
        matlab_fp.write("\n")
        
        iter_faults_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "faults_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_faults_file_or)):
            matlab_fp.write("faults_data_or = dlmread('%s', '\\t');\n" % iter_faults_file_or)
        else:
            print >> sys.stderr, "line_faults-ps_success_rate: '%s_or_faults' not found, ignoring class." % iter_test_main_class
            continue
        
        iter_faults_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "faults_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_faults_file_ps)):
            matlab_fp.write("faults_data_ps = dlmread('%s', '\\t');\n" % iter_faults_file_ps)
        else:
            print >> sys.stderr, "line_faults-ps_success_rate: '%s_ps_faults' not found, ignoring class." % iter_test_main_class
            continue
        
        iter_success_rate_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "ps_success_rate_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_success_rate_file_ps)):
            matlab_fp.write("success_rate_data_ps = dlmread('%s', '\\t');\n" % iter_success_rate_file_ps)
        else:
            print >> sys.stderr, "line_faults-ps_success_rate: '%s_ps_success_rate_by_time' not found, ignoring class." % iter_test_main_class
            continue
        
        matlab_fp.write("h = newplot;\n")
        matlab_fp.write("hold on;\n")
        matlab_fp.write("x = 1:1:60;\n")
        matlab_fp.write("y1 = [faults_data_or(:,2)'; faults_data_ps(:,2)'];\n")
        matlab_fp.write("y2 = success_rate_data_ps(:,2)';\n")
        matlab_fp.write("labels = {'ps' 'or' 'success\_rate'};\n")
        matlab_fp.write("plot(h, x, y1(2,:), '-b', 'LineWidth', 2);\n")
        matlab_fp.write("[AX,H1,H2] = plotyy(h, x, y1(1,:), x, y2);\n")
        # matlab_fp.write("set(H1,'LineStyle','-g');\n")
        matlab_fp.write("set(H2,'LineStyle','--');\n")
        matlab_fp.write("set(get(AX(1),'Ylabel'),'String','Number of found faults');\n")
        matlab_fp.write("ylim(AX(1), [0 max(y1(:))*1.1]);\n")
        matlab_fp.write("set(get(AX(2),'Ylabel'),'String','PS success rate');\n")
        matlab_fp.write("ylim(AX(2), [0 1]);\n")
        matlab_fp.write("xlabel(h, 'Duration of test run (minutes)');\n")
        matlab_fp.write("legend(labels, 'Location', 'SouthEast');\n")
        if options['title']:
            matlab_fp.write("title(h, 'Number of found faults + PS success rate -- %s');\n" % iter_test_main_class.replace('_', '\_'))
        matlab_fp.write("saveas(h, '%s', '%s');\n" % (iter_outpath, options['graph_format']))
        matlab_fp.write("hold off;\n")
        matlab_fp.write("\n")
    
    # graph bar_distinct_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_distinct_faults\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("y = [];\n")
    matlab_fp.write("classnames = [];\n")
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "bar_distinct_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_df_or = i['or']['avg'].distinct_faults
        iter_df_ps = i['ps']['avg'].distinct_faults
        iter_df_union = set(iter_df_or) | set(iter_df_ps)
        iter_df_inter = set(iter_df_or) & set(iter_df_ps)
        iter_df_diff_or = set(iter_df_or) - set(iter_df_inter)
        iter_df_diff_ps = set(iter_df_ps) - set(iter_df_inter)
        matlab_fp.write("y = [y;%i,%i,%i];\n" % (len(iter_df_inter), len(iter_df_diff_or), len(iter_df_diff_ps)))
        matlab_fp.write("classnames = strvcat(classnames, '%s');\n" % iter_test_main_class.replace('_', '\_'))
    # sort rows of y ascending by third column, then descending by first column
    matlab_fp.write("y(:,4) = sum(y,2);\n")
    matlab_fp.write("y = sortrows(y,[-4]);\n")
    matlab_fp.write("bar(h, y(:,1:3), 'stacked');\n")
    matlab_fp.write("xlabel(h, 'Class under test');\n")
    matlab_fp.write("ylabel(h, 'Number of distinct faults');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Number of distinct faults for each class under test');\n")
    matlab_fp.write("legend({'both' 'or' 'ps'});\n")
    matlab_fp.write("saveas(h, 'graphs/bar_distinct_faults', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")
    
    # graph bar_distinct_faults_norm
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_distinct_faults_norm\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("y = [];\n")
    matlab_fp.write("classnames = [];\n")
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "bar_distinct_faults_norm: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_df_or = i['or']['avg'].distinct_faults
        iter_df_ps = i['ps']['avg'].distinct_faults
        iter_df_union = list(set(iter_df_or) | set(iter_df_ps))
        iter_df_inter = list(set(iter_df_or) & set(iter_df_ps))
        iter_normed_df_inter = len(iter_df_inter) / float(len(iter_df_union))
        iter_normed_df_diff_or = len(set(iter_df_or) - set(iter_df_inter)) / float(len(iter_df_union))
        iter_normed_df_diff_ps = len(set(iter_df_ps) - set(iter_df_inter)) / float(len(iter_df_union))
        matlab_fp.write("y = [y;%f,%f,%f];\n" % (iter_normed_df_inter, iter_normed_df_diff_or, iter_normed_df_diff_ps))
        matlab_fp.write("classnames = strvcat(classnames, '%s');\n" % iter_test_main_class.replace('_', '\_'))
    # sort rows of y ascending by third column, then descending by first column
    matlab_fp.write("y = sortrows(y,[3 -1]);\n")
    matlab_fp.write("bar(h, y, 'stacked');\n")
    matlab_fp.write("ylim([0 1.15]);\n")
    matlab_fp.write("xlabel(h, 'Class under test');\n")
    matlab_fp.write("ylabel(h, 'Discovery distribution of distinct faults');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Discovery distribution of distinct faults for each class under test');\n")
    matlab_fp.write("legend({'both' 'or' 'ps'});\n")
    matlab_fp.write("saveas(h, 'graphs/bar_distinct_faults_norm', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")

    ### pf(_untested) does not make sense anymore
    # # graph bar_pf
    # matlab_fp.write("\n")
    # matlab_fp.write("%% bar_pf\n")
    # matlab_fp.write("h = newplot;\n")
    # matlab_fp.write("y = [")
    # for v in precond_features_untested_increase_perc_by_class.values():
    #     matlab_fp.write("%s," % v)
    # matlab_fp.write("];\n")
    # matlab_fp.write("hist(h, y, 50);\n")
    # matlab_fp.write("xlabel(h, '% increase in number of tested precondition-equipped features');\n")
    # matlab_fp.write("ylabel(h, 'Number of classes');\n")
    # if options['title']:
    #     matlab_fp.write("title(h, 'Class distribution by increase in number of tested precondition-equipped features');\n")
    # matlab_fp.write("saveas(h, 'graphs/bar_pf', '%s');\n" % (options['graph_format']))
    # matlab_fp.write("\n")

    # graph bar_pf
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_pf\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("y = [")
    for v in precond_features_tested_increase_perc_by_class.values():
        matlab_fp.write("%s," % v)
    matlab_fp.write("];\n")
    matlab_fp.write("hist(h, y, 50);\n")
    matlab_fp.write("xlabel(h, '% increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("ylabel(h, 'Number of classes');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Class distribution by increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("saveas(h, 'graphs/bar_pf', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")
    
    # # graph bar_coverage_in_ps_of_untested_pf_in_or
    # matlab_fp.write("\n")
    # matlab_fp.write("%% bar_coverage_in_ps_of_untested_pf_in_or\n")
    # matlab_fp.write("h = newplot;\n")
    # matlab_fp.write("y = [")
    # for iter_test_main_class, i in processed_results.iteritems():
    #     if not 'or' in i.keys() or not 'ps' in i.keys():
    #         print >> sys.stderr, "bar_coverage_in_ps_of_untested_pf_in_or: '%s' or/ps not found, ignoring class." % iter_test_main_class
    #         continue
    #     iter_divisor = float(len(i['or']['avg'].precond_features_without_valid_tc))
    #     if iter_divisor == 0:
    #         continue
    #     iter_cov = 100 * float(len(i['ps']['avg'].precond_features_with_valid_tc) - len(i['or']['avg'].precond_features_with_valid_tc)) / iter_divisor
    #     matlab_fp.write("%s," % iter_cov)
    # matlab_fp.write("];\n")
    # matlab_fp.write("hist(h, y, 50);\n")
    # matlab_fp.write("xlabel(h, '% of untestable features in or newly tested in ps');\n")
    # matlab_fp.write("ylabel(h, 'Number of classes');\n")
    # if options['title']:
    #     matlab_fp.write("title(h, 'Class distribution by increase in number of newly tested precondition-equipped features');\n")
    # matlab_fp.write("saveas(h, 'graphs/bar_coverage_in_ps_of_untested_pf_in_or', '%s');\n" % (options['graph_format']))
    # matlab_fp.write("\n")
    
    # graph bar_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_faults\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("y = [")
    # ugly hack, should be somewhere else...
    faults_increase_ps_over_or_by_class = {}
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "bar_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_increase = 100 * (float(i['ps']['avg'].count_faults) / float(i['or']['avg'].count_faults) - 1)
        matlab_fp.write("%s," % iter_increase)
        faults_increase_ps_over_or_by_class[iter_test_main_class] = iter_increase
    matlab_fp.write("];\n")
    matlab_fp.write("hist(h, y, 50);\n")
    matlab_fp.write("xlabel(h, '% increase in number of found faults');\n")
    matlab_fp.write("ylabel(h, 'Number of classes');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Class distribution by increase in number of found faults');\n")
    matlab_fp.write("saveas(h, 'graphs/bar_faults', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")
    
    # graph scatter_speed_vs_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_speed_vs_faults\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("xraw = [];\n")
    matlab_fp.write("y = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_or)):
            matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "scatter_speed_vs_faults: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
            matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_speed_vs_faults: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        matlab_fp.write("xraw = [xraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
        matlab_fp.write("y = [y;%s];\n" % faults_increase_ps_over_or_by_class[iter_test_main_class])
    matlab_fp.write("x = mean(xraw,2);\n")
    matlab_fp.write("scatter(x, y);\n")
    if options["hvlines"]:
        matlab_fp.write("hline(0, 'r-.');\n")
        matlab_fp.write("vline(0, 'r-.');\n")
    matlab_fp.write("ylabel(h, '% increase in number of found faults');\n")
    matlab_fp.write("xlabel(h, 'Relative speed');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Relative speed vs. increase in number of found faults');\n")
    matlab_fp.write("saveas(h, 'graphs/scatter_speed_vs_faults', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")

    ### pf(_untested) does not make sense anymore
    # # graph scatter_speed_vs_pf
    # matlab_fp.write("\n")
    # matlab_fp.write("%% scatter_speed_vs_pf\n")
    # matlab_fp.write("h = newplot;\n")
    # matlab_fp.write("xraw = [];\n")
    # matlab_fp.write("y = [];\n")
    # for iter_test_main_class in test_main_classes:
    #     iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
    #     if os.path.exists(os.path.join(options['outfolder'], iter_file_or)):
    #         matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
    #     else:
    #         print >> sys.stderr, "scatter_speed_vs_pf: '%s_or' not found, ignoring class." % iter_test_main_class
    #         continue
    #     iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
    #     if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
    #         matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
    #     else:
    #         print >> sys.stderr, "scatter_speed_vs_pf: '%s_ps' not found, ignoring class." % iter_test_main_class
    #         continue
    #     matlab_fp.write("xraw = [xraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
    #     matlab_fp.write("y = [y;%s];\n" % precond_features_untested_increase_perc_by_class[iter_test_main_class])
    # matlab_fp.write("x = mean(xraw,2);\n")
    # matlab_fp.write("scatter(x, y);\n")
    # if options["hvlines"]:
    #     # matlab_fp.write("hline(0, 'r-.');\n")
    #     matlab_fp.write("vline(0, 'r-.');\n")
    # matlab_fp.write("ylabel(h, '% increase in number of tested precondition-equipped features');\n")
    # matlab_fp.write("xlabel(h, 'Relative speed');\n")
    # if options['title']:
    #     matlab_fp.write("title(h, 'Relative speed vs. increase in number of tested precondition-equipped features');\n")
    # matlab_fp.write("saveas(h, 'graphs/scatter_speed_vs_pf', '%s');\n" % (options['graph_format']))
    # matlab_fp.write("\n")
    
    # graph scatter_speed_vs_pf
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_speed_vs_pf\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("xraw = [];\n")
    matlab_fp.write("y = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_or)):
            matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "scatter_speed_vs_pf: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
            matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_speed_vs_pf: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        matlab_fp.write("xraw = [xraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
        matlab_fp.write("y = [y;%s];\n" % precond_features_tested_increase_perc_by_class[iter_test_main_class])
    matlab_fp.write("x = mean(xraw,2);\n")
    matlab_fp.write("scatter(x, y);\n")
    if options["hvlines"]:
        # matlab_fp.write("hline(0, 'r-.');\n")
        matlab_fp.write("vline(0, 'r-.');\n")
    matlab_fp.write("ylabel(h, '% increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("xlabel(h, 'Relative speed');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Relative speed vs. increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("saveas(h, 'graphs/scatter_speed_vs_pf', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")

    # graph scatter_success_rate_vs_speed
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_success_rate_vs_speed\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("xraw = [];\n")
    matlab_fp.write("yraw = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_or)):
            matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "scatter_success_rate_vs_speed: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
            matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_success_rate_vs_speed: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "ps_success_rate_by_time.txt")
        if os.path.exists(os.path.join(options['outfolder'], iter_file_ps)):
            matlab_fp.write("ps_success_rate = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_success_rate_vs_speed: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        matlab_fp.write("yraw = [yraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
        matlab_fp.write("xraw = [xraw;ps_success_rate(:,2)'];\n")
    matlab_fp.write("x = mean(xraw,2);\n")
    matlab_fp.write("y = mean(yraw,2);\n")
    matlab_fp.write("scatter(x, y);\n")
    if options["hvlines"]:
        matlab_fp.write("hline(0, 'r-.');\n")
    matlab_fp.write("xlabel(h, 'Mean success rate');\n")
    matlab_fp.write("ylabel(h, 'Relative speed');\n")
    if options['title']:
       matlab_fp.write("title(h, 'Mean success rate vs. relative speed');\n")
    matlab_fp.write("saveas(h, 'graphs/scatter_success_rate_vs_speed', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")

    ### pf(_untested) does not make sense anymore
    # # graph scatter_pf_vs_faults
    # matlab_fp.write("\n")
    # matlab_fp.write("%% scatter_pf_vs_faults\n")
    # matlab_fp.write("h = newplot;\n")
    # matlab_fp.write("x = [")
    # for iter_test_main_class, i in processed_results.iteritems():
    #     if not 'or' in i.keys() or not 'ps' in i.keys():
    #         print >> sys.stderr, "scatter_pf_vs_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
    #         continue
    #     matlab_fp.write("%s," % precond_features_untested_increase_perc_by_class[iter_test_main_class])
    # matlab_fp.write("];\n")
    # matlab_fp.write("y = [")
    # for iter_test_main_class, i in processed_results.iteritems():
    #     if not 'or' in i.keys() or not 'ps' in i.keys():
    #         print >> sys.stderr, "scatter_pf_vs_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
    #         continue
    #     matlab_fp.write("%s," % faults_increase_ps_over_or_by_class[iter_test_main_class])
    # matlab_fp.write("];\n")
    # matlab_fp.write("scatter(x, y);\n")
    # if options["hvlines"]:
    #     matlab_fp.write("hline(0, 'r-.');\n")
    #     matlab_fp.write("vline(0, 'r-.');\n")
    # matlab_fp.write("ylabel(h, '% increase in number of found faults');\n")
    # matlab_fp.write("xlabel(h, '% increase in number of tested precondition-equipped features');\n")
    # if options['title']:
    #     matlab_fp.write("title(h, 'Increase in number of found faults vs. increase in number of tested precondition-equipped features');\n")
    # matlab_fp.write("saveas(h, 'graphs/scatter_pf_vs_faults', '%s');\n" % (options['graph_format']))
    # matlab_fp.write("\n")
    
    # graph scatter_pf_vs_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_pf_vs_faults\n")
    matlab_fp.write("h = newplot;\n")
    matlab_fp.write("x = [")
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "scatter_pf_vs_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        matlab_fp.write("%s," % precond_features_tested_increase_perc_by_class[iter_test_main_class])
    matlab_fp.write("];\n")
    matlab_fp.write("y = [")
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "scatter_pf_vs_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        matlab_fp.write("%s," % faults_increase_ps_over_or_by_class[iter_test_main_class])
    matlab_fp.write("];\n")
    matlab_fp.write("scatter(x, y);\n")
    if options["hvlines"]:
        matlab_fp.write("hline(0, 'r-.');\n")
        matlab_fp.write("vline(0, 'r-.');\n")
    matlab_fp.write("ylabel(h, '% increase in number of found faults');\n")
    matlab_fp.write("xlabel(h, '% increase in number of tested precondition-equipped features');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Increase in number of found faults vs. increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("saveas(h, 'graphs/scatter_pf_vs_faults', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")
    
    ### graph not needed
    # # graph hard_features_vs_nbr_valid_tc_increase
    # matlab_fp.write("\n")
    # matlab_fp.write("%% hard_features_vs_nbr_valid_tc_increase\n")
    # matlab_fp.write("h = newplot;\n")
    # # compute some more data first
    # valid_tc_increase_by_hard_feature = {}
    # for iter_test_main_class, i in processed_results.iteritems():
    #     if not 'or' in i.keys() or not 'ps' in i.keys():
    #         print >> sys.stderr, "hard_features_vs_nbr_valid_tc_increase: '%s' or/ps not found, ignoring class." % iter_test_main_class
    #         continue
    #     for iter_feat in i['or']['avg'].hardness_by_feature_in_cus.keys():
    #         if i['or']['avg'].hardness_by_feature_in_cus[iter_feat] < options['feature-hardness']:
    #             continue
    #         iter_feat_dest = iter_feat
    #         while iter_feat_dest in valid_tc_increase_by_hard_feature.keys():
    #             iter_feat_dest += 'd'
    #         # if iter_feat in valid_tc_increase_by_hard_feature.keys():
    #         #     print >> sys.stderr, "hard_features_vs_nbr_valid_tc_increase: '%s' duplicate from another run, ignoring." % iter_feat
    #         #     continue
    #         if iter_feat not in i['ps']['avg'].count_valid_tc_by_feature_in_cus.keys():
    #             print >> sys.stderr, "hard_features_vs_nbr_valid_tc_increase: '%s' found in or but not in ps." % iter_feat
    #             continue
    #         iter_divisor = float(i['or']['avg'].count_valid_tc_by_feature_in_cus[iter_feat])
    #         # if iter_divisor = 0:
    #         #     iter_divisor = 0.01
    #         # valid_tc_increase_by_hard_feature[iter_feat_dest] = float(i['ps']['avg'].count_valid_tc_by_feature_in_cus[iter_feat] - i['or']['avg'].count_valid_tc_by_feature_in_cus[iter_feat]) / iter_divisor
    #         # else:
    #         #     valid_tc_increase_by_hard_feature[iter_feat_dest] = 1
    #         if iter_divisor != 0:
    #             valid_tc_increase_by_hard_feature[iter_feat_dest] = float(i['ps']['avg'].count_valid_tc_by_feature_in_cus[iter_feat] - i['or']['avg'].count_valid_tc_by_feature_in_cus[iter_feat]) / iter_divisor
    #         else:
    #             valid_tc_increase_by_hard_feature[iter_feat_dest] = 7
    # matlab_fp.write("y = [")
    # for val in valid_tc_increase_by_hard_feature.values():
    #     matlab_fp.write("%s," % val)
    # matlab_fp.write("];\n")
    # matlab_fp.write("bar(sort(y));\n")
    # matlab_fp.write("ylabel(h, 'Increase in nbr of valid TCs');\n")
    # matlab_fp.write("xlabel(h, 'hard to test features');\n")
    # if options['title']:
    #     matlab_fp.write("title(h, 'Increase in valid TCs for hard-to-test features');\n")
    # matlab_fp.write("saveas(h, 'graphs/hard_features_vs_nbr_valid_tc_increase', '%s');\n" % (options['graph_format']))
    # matlab_fp.write("\n")

    # graph bar_hf
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_hf\n")
    matlab_fp.write("h = newplot;\n")
    # compute some more data first
    valid_tc_or_by_hard_feature = {}
    valid_tc_ps_by_hard_feature = {}
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "bar_hf: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        for iter_feat in i['or']['avg'].hardness_by_feature.keys():
            if i['or']['avg'].hardness_by_feature[iter_feat] < options['feature-hardness']:
                continue
            iter_feat_dest = iter_feat
            while iter_feat_dest in valid_tc_or_by_hard_feature.keys():
                iter_feat_dest += 'd'
            if iter_feat not in i['ps']['avg'].count_valid_tc_by_feature.keys():
                print >> sys.stderr, "bar_hf: '%s' found in or but not in ps." % iter_feat
                continue
            valid_tc_or_by_hard_feature[iter_feat_dest] = i['or']['avg'].count_valid_tc_by_feature[iter_feat]
            valid_tc_ps_by_hard_feature[iter_feat_dest] = i['ps']['avg'].count_valid_tc_by_feature[iter_feat]
    matlab_fp.write("y = [")
    for iter_feat in valid_tc_or_by_hard_feature.keys():
        matlab_fp.write("%s,%s;" % (valid_tc_or_by_hard_feature[iter_feat], valid_tc_ps_by_hard_feature[iter_feat]))
    matlab_fp.write("];\n")
    matlab_fp.write("y = sortrows(y, -1);\n")
    matlab_fp.write("bar(y, 'stacked');\n")
    matlab_fp.write("legend({'or' 'ps'});\n")
    matlab_fp.write("ylabel(h, 'Number of valid test cases');\n")
    matlab_fp.write("xlabel(h, 'Hard-to-test feature');\n")
    if options['title']:
        matlab_fp.write("title(h, 'Number of valid test cases for hard-to-test features');\n")
    matlab_fp.write("saveas(h, 'graphs/bar_hf', '%s');\n" % (options['graph_format']))
    matlab_fp.write("\n")

    matlab_fp.close()
    

if __name__ == "__main__":
    sys.exit(main())
