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
  -h,--help             Display this help screen.
  --cut-time <mins>     Analyze first `mins' minutes of logfiles.
                        Show warning and ignore if they are shorter.
                        Default: 60 mins.
  --testruns <nbr>      The expected number of test runs for or/ps. The
                        superfluous filenames are written to a file, but they
                        are analyzed anyway. Move or delete them if you do not
                        want to have them analyzed. Default: 30.
  --feature-hardness <float>
                        Set threshold over which a feature is considered hard
                        to test (# invalid_tc / # total_tc).
                        Must be between 0.0 and 1.0, default: 0.9
  --graph-format        File format to save the graphs as. Choices are "png",
                        "eps" or "pdf". Default: png.
  --draw-hvlines        Draw hline/vline on scatter plots. Needs files from
                        http://mathworks.com/matlabcentral/fileexchange/1039
  --draw-classnames     Draw class names on some graphs. Needs file from
                        http://mathworks.com/matlabcentral/fileexchange/3486
  --draw-titles         Print the title on each graph.
  --draw-each-class     Draw the faults + ps success rate graphs for each
                        individual class (slows down graph generation).
  --aggregate-faults    Aggregate faults instead of averaging them accross
                        test runs.
  --aggregate-features  Aggregate the features with valid test case instead of
                        averaging them accross test runs.
  --mean                Use mean for all average computations, default median.
  --no-sanity           Disable sanity checks.
'''
options = {
    'cut-time': 60,
    'testruns': 30,
    'feature-hardness': 0.9,
    'graph-format': 'png',
    'draw-hvlines': False,
    'draw-classnames': False,
    'draw-titles': False,
    'draw-each-class': False,
    'aggregate-faults': False,
    'aggregate-features': False,
    'mean': False,
    'sanity': True,
    'analysis_outfolder': 'analysis_data',
    'graphs_outfolder': 'graphs',
    'tables_outfolder': 'tables',
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


def compute_mean(list_of_values):
    if not isinstance(list_of_values, list):
        raise MyError("'%s': not a list" % (list_of_values))
    return sum(list_of_values) / float(len(list_of_values))

def compute_median(list_of_values):
    if not isinstance(list_of_values, list):
        raise MyError("'%s': not a list" % (list_of_values))
    n = len(list_of_values)
    sorted_copy = sorted(list_of_values)
    if n & 1:         # There is an odd number of elements
        return sorted_copy[n // 2]
    else:
        return (sorted_copy[n // 2 - 1] + sorted_copy[n // 2]) / 2.0

def compute_avg(list_of_values):
    if options['mean']:
        func = compute_mean
    else:
        func = compute_median
    return func(list_of_values)


class AnalyzedResult(object):
    '''Holds analysis of a result file.'''
    
    def __init__(self):
        # meta info
        self.filename = ""
        self.strategy = ""
        self.group_leader = ""
        self.test_nbr = 0
        
        self.classes_under_test = []
        self.last_timestamp = 0
        
        self.count_faults = 0
        self.faults_by_time = {}
        self.distinct_faults = []
        self.valid_tc_gen_by_time = {}
        self.valid_tc_gen_speed_by_time = {}
        self.ps_success_rate_by_time = {}
        self.aggregated_precond_features = []
        self.aggregated_precond_features_with_valid_tc = []
        self.aggregated_precond_features_with_valid_tc_after_cut_time = []
        self.aggregated_precond_features_without_valid_tc = []
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
        ret.strategy = match.group(2)
        ret.group_leader = match.group(3)
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
        
        # aggregated_precond_features, aggregated_precond_features_with_valid_tc,
        # aggregated_precond_features_with_valid_tc_after_cut_time,
        # aggregated_precond_features_without_valid_tc, count_valid_tc_by_feature,
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
            if iter_feature_name in ('standard_is_equal',
                                     'conforms_to',
                                     'same_type',
                                     'deep_copy',
                                     'is_deep_equal',
                                     'copy',
                                     'standard_copy',
                                     'is_equal'):
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
            ret.aggregated_precond_features.append(iter_feature_id)
            iter_time_first_valid_tc = int(match.group(12))
            if iter_time_first_valid_tc / 60.0 >= options['cut-time']:
                ret.aggregated_precond_features_with_valid_tc_after_cut_time.append(iter_feature_id)
                ret.aggregated_precond_features_without_valid_tc.append(iter_feature_id)
            elif iter_time_first_valid_tc == -1:
                ret.aggregated_precond_features_without_valid_tc.append(iter_feature_id)
            else:
                ret.aggregated_precond_features_with_valid_tc.append(iter_feature_id)
        ret.time_spent_on_invalid_tc_as_percentage = 100.0 * float(time_spent_on_invalid_tc_sum) / ret.last_timestamp
        
        # sanity check on the number of tested and untested features
        if options['sanity']:
            assert(len(ret.aggregated_precond_features) == len(ret.aggregated_precond_features_with_valid_tc) + len(ret.aggregated_precond_features_without_valid_tc))
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
            if len(untested_features_in_cus) != len(ret.aggregated_precond_features_without_valid_tc) - len(ret.aggregated_precond_features_with_valid_tc_after_cut_time):
                print untested_features_in_cus
                print ret.aggregated_precond_features_without_valid_tc
                raise MyError("%s: # untested features: expected %s, got %s." % (ret.filename, len(untested_features_in_cus), len(ret.aggregated_precond_features_without_valid_tc) - len(ret.aggregated_precond_features_with_valid_tc_after_cut_time)))
        
        return ret
    
    @classmethod
    def init_by_avg(cls, list_of_ar):
        if not isinstance(list_of_ar, list):
            raise MyError("'%s': not a list" % (list_of_ar))
        ret = cls()
        len_list_of_ar = len(list_of_ar)
        
        # count_faults
        iter_list = map(lambda x: x.count_faults, list_of_ar)
        ret.count_faults = compute_avg(iter_list)
        
        # faults_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.faults_by_time[i], list_of_ar)
            ret.faults_by_time[i] = compute_avg(iter_list)
        
        # distinct_faults
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.distinct_faults)
        ret.distinct_faults = list(set(iter_list))

        # valid_tc_gen_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.valid_tc_gen_by_time[i], list_of_ar)
            ret.valid_tc_gen_by_time[i] = compute_avg(iter_list)

        # valid_tc_gen_speed_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.valid_tc_gen_speed_by_time[i], list_of_ar)
            ret.valid_tc_gen_speed_by_time[i] = compute_avg(iter_list)
        
        # ps_success_rate_by_time
        for i in range(1, options['cut-time']+1):
            iter_list = map(lambda x: x.ps_success_rate_by_time[i], list_of_ar)
            ret.ps_success_rate_by_time[i] = compute_avg(iter_list)
        
        # aggregated_precond_features
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.aggregated_precond_features)
        ret.aggregated_precond_features = list(set(iter_list))
        
        # aggregated_precond_features_with_valid_tc
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.aggregated_precond_features_with_valid_tc)
        ret.aggregated_precond_features_with_valid_tc = list(set(iter_list))
        
        # aggregated_precond_features_without_valid_tc
        iter_list = []
        for ar in list_of_ar:
            iter_list.extend(ar.aggregated_precond_features_without_valid_tc)
        ret.aggregated_precond_features_without_valid_tc = list(set(iter_list) - set(ret.aggregated_precond_features_with_valid_tc))
        
        # sanity check
        if options['sanity']:
            if len(ret.aggregated_precond_features) != len(ret.aggregated_precond_features_with_valid_tc) + len(ret.aggregated_precond_features_without_valid_tc):
                print ar.filename
                print "expected %i, but got %i valid + %i invalid = %i" % (len(ret.aggregated_precond_features), len(ret.aggregated_precond_features_with_valid_tc), len(ret.aggregated_precond_features_without_valid_tc), len(ret.aggregated_precond_features_with_valid_tc) + len(ret.aggregated_precond_features_without_valid_tc))
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
            ret.count_valid_tc_by_feature[iter_feat] = compute_avg(iter_list)
        
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
            ret.count_invalid_tc_by_feature[iter_feat] = compute_avg(iter_list)
        
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
            ret.hardness_by_feature[iter_feat] = compute_avg(iter_list)
        
        # time_spent_on_invalid_tc_as_percentage
        iter_list = map(lambda x: x.time_spent_on_invalid_tc_as_percentage, list_of_ar)
        ret.time_spent_on_invalid_tc_as_percentage = compute_avg(iter_list)
        
        return ret


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "h",
                    ["help",
                     "cut-time=",
                     "testruns=",
                     "feature-hardness=",
                     "graph-format=",
                     "draw-hvlines",
                     "draw-classnames",
                     "draw-titles",
                     "draw-each-class",
                     "aggregate-faults",
                     "aggregate-features",
                     "mean",
                     "no-sanity",
                     ])
        except getopt.error, msg:
            raise Usage(msg)
        
        # option processing
        for option, value in opts:
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
            
            if option in ("--testruns"):
                try:
                    if int(value) > 0:
                        options['testruns'] = int(value)
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
            
            if option in ("--graph-format"):
                if value in ("png", "eps", "pdf"):
                    options["graph-format"] = value
                else:
                    raise Usage("arg must be 'png', 'eps' or 'pdf' ('%s')." % value)
            
            if option in ("--draw-hvlines"):
                options["draw-hvlines"] = True
            if option in ("--draw-classnames"):
                options["draw-classnames"] = True
            if option in ("--draw-titles"):
                options["draw-titles"] = True
            if option in ("--draw-each-class"):
                options["draw-each-class"] = True
            
            if option in ("--aggregate-faults"):
                options["aggregate-faults"] = True
            
            if option in ("--aggregate-features"):
                options["aggregate-features"] = True
            
            if option in ("--mean"):
                options['mean'] = True
            
            if option in ("--no-sanity"):
                options['sanity'] = False
        
        # arguments processing
        if len(args) != 2:
            raise Usage(help_message)
        
        if os.path.isdir(args[0]):
            options['inpath'] = args[0]
        else:
            raise Usage("arg must be a folder ('%s')." % args[0])
        
        options['outpath'] = args[1]
        options['analysis_outpath'] = os.path.join(options["outpath"], options["analysis_outfolder"])
        options['graphs_outpath'] = os.path.join(options["outpath"], options["graphs_outfolder"])
        options['tables_outpath'] = os.path.join(options["outpath"], options["tables_outfolder"])
        try:
            os.makedirs(options["outpath"])
            os.makedirs(options["analysis_outpath"])
            os.makedirs(options["graphs_outpath"])
            os.makedirs(options["tables_outpath"])
        except OSError, exc:
            if exc.errno == errno.EEXIST:
                pass
            else:
                raise
    
    except Usage, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        return 2
    
    
    # run the beef
    # format: processed_results[group_leader][strategy][test_nbr/'avg']
    processed_results = {}
    try:
        for fn in os.listdir(options['inpath']):
            try:
                ar = AnalyzedResult.init_from_file(os.path.join(options['inpath'], fn))
            except MyWarning, err:
                print >> sys.stderr, err
                continue
            except MyError, err:
                print >> sys.stderr, err
                return 3
            
            # update the list of processed cases
            if not ar.group_leader in processed_results:
                processed_results[ar.group_leader] = {}
            if not ar.strategy in processed_results[ar.group_leader]:
                processed_results[ar.group_leader][ar.strategy] = {}
            if options['sanity']:
                if ar.test_nbr in processed_results[ar.group_leader][ar.strategy]:
                    raise MyError("Should not happen")
            processed_results[ar.group_leader][ar.strategy][ar.test_nbr] = ar
            
    except OSError, err:
        print >> sys.stderr, err
        return 3
    
    
    # calculate the averages
    for group_leader, i in processed_results.iteritems():
        for strategy, j in i.iteritems():
            j['avg'] = AnalyzedResult.init_by_avg(j.values())
    
    
    # write output
    for test_main_class, i in processed_results.iteritems():
        for strategy, j in i.iteritems():
            # create directories
            iter_outpath = os.path.join(options['analysis_outpath'], test_main_class, strategy)
            try:
                os.makedirs(iter_outpath)
            except OSError, exc:
                if exc.errno == errno.EEXIST:
                    pass
                else:
                    raise
            
            # write faults_by_time
            iter_outfile = os.path.join(iter_outpath, 'faults_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].faults_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write distinct_faults
            iter_outfile = os.path.join(iter_outpath, 'distinct_faults.txt')
            iter_fp = open(iter_outfile, 'w')
            for v in j['avg'].distinct_faults:
                iter_fp.write("%s\n" % (v))
            iter_fp.close()
            
            # write valid_tc_gen_by_time
            iter_outfile = os.path.join(iter_outpath, 'valid_tc_gen_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].valid_tc_gen_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write valid_tc_gen_speed_by_time
            iter_outfile = os.path.join(iter_outpath, 'valid_tc_gen_speed_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].valid_tc_gen_speed_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write ps_success_rate_by_time
            iter_outfile = os.path.join(iter_outpath, 'ps_success_rate_by_time.txt')
            iter_fp = open(iter_outfile, 'w')
            for k, v in j['avg'].ps_success_rate_by_time.iteritems():
                iter_fp.write("%s\t%s\n" % (k, v))
            iter_fp.close()
            
            # write aggregated_precond_features_with_valid_tc
            iter_outfile = os.path.join(iter_outpath, 'aggregated_precond_features_with_valid_tc.txt')
            iter_fp = open(iter_outfile, 'w')
            for v in j['avg'].aggregated_precond_features_with_valid_tc:
                iter_fp.write("%s\n" % (v))
            iter_fp.close()
            
            # write aggregated_precond_features_without_valid_tc
            iter_outfile = os.path.join(iter_outpath, 'aggregated_precond_features_without_valid_tc.txt')
            iter_fp = open(iter_outfile, 'w')
            for v in j['avg'].aggregated_precond_features_without_valid_tc:
                iter_fp.write("%s\n" % (v))
            iter_fp.close()
    
    
    # comes in handy
    test_main_classes = sorted(processed_results.keys())
    
    
    # write the superfluous test runs to file
    iter_outfile = os.path.join(options['analysis_outpath'], '_superfluous_testruns.txt')
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
    iter_outfile = os.path.join(options['analysis_outpath'], '_count_valid_test_runs.txt')
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
        iter_count_pf = len(iter_or.aggregated_precond_features)
        iter_or_untested_pf = 100.0 * float(len(iter_or.aggregated_precond_features_without_valid_tc)) / float(iter_count_pf)
        iter_ps_untested_pf = 100.0 * float(len(iter_ps.aggregated_precond_features_without_valid_tc)) / float(iter_count_pf)
        precond_features_count_by_class[iter_test_main_class] = iter_count_pf
        precond_features_untested_perc_or_by_class[iter_test_main_class] = iter_or_untested_pf
        precond_features_untested_perc_ps_by_class[iter_test_main_class] = iter_ps_untested_pf
    
    # table tested_precond_features_sorted_incr
    iter_outfile = os.path.join(options['tables_outpath'], 'tested_precond_features_sorted_incr.txt')
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
    iter_outfile = os.path.join(options['tables_outpath'], 'classes_under_test.txt')
    iter_fp = open(iter_outfile, 'w')
    for iter_class in sorted(processed_results.keys()):
        iter_fp.write("%s\\\\\n" % iter_class.replace('_', '\_'))
    iter_fp.close()
    
    # table classes_under_test_two_cols
    iter_outfile = os.path.join(options['tables_outpath'], 'classes_under_test_two_cols.txt')
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
    iter_outfile = os.path.join(options['tables_outpath'], 'time_spent_on_invalid_tc.txt')
    iter_fp = open(iter_outfile, 'w')
    # first, calculate overall averages
    time_invalid_tc_or = []
    time_invalid_tc_ps = []
    for iter_test_main_class, i in processed_results.iteritems():
        if 'or' in i.keys():
            time_invalid_tc_or.append(i['or']['avg'].time_spent_on_invalid_tc_as_percentage)
        if 'ps' in i.keys():
            time_invalid_tc_ps.append(i['ps']['avg'].time_spent_on_invalid_tc_as_percentage)
    time_invalid_tc_or_avg = compute_avg(time_invalid_tc_or)
    time_invalid_tc_ps_avg = compute_avg(time_invalid_tc_ps)
    iter_fp.write("Average ^ %.2f ^ %.2f\\\\\n" % (time_invalid_tc_or_avg, time_invalid_tc_ps_avg))
    for iter_test_main_class in sorted(processed_results.keys()):
        i = processed_results[iter_test_main_class]
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "time_spent_on_invalid_tc: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_fp.write("%s ^ %.2f ^ %.2f\\\\\n" % (iter_test_main_class.replace('_', '\_'), i['or']['avg'].time_spent_on_invalid_tc_as_percentage, i['ps']['avg'].time_spent_on_invalid_tc_as_percentage))
    iter_fp.close()
    
    # table TC in hard features and average
    # first, some computations
    valid_tc_or_by_hard_feature = {}
    valid_tc_ps_by_hard_feature = {}
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "tc_hard_features: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        for iter_feat in i['or']['avg'].hardness_by_feature.keys():
            if i['or']['avg'].hardness_by_feature[iter_feat] < options['feature-hardness']:
                continue
            iter_feat_dest = iter_feat
            while iter_feat_dest in valid_tc_or_by_hard_feature.keys():
                iter_feat_dest += 'd'
            if iter_feat not in i['ps']['avg'].count_valid_tc_by_feature.keys():
                print >> sys.stderr, "tc_hard_features: '%s' found in or but not in ps." % iter_feat
                continue
            valid_tc_or_by_hard_feature[iter_feat_dest] = i['or']['avg'].count_valid_tc_by_feature[iter_feat]
            valid_tc_ps_by_hard_feature[iter_feat_dest] = i['ps']['avg'].count_valid_tc_by_feature[iter_feat]
    iter_outfile = os.path.join(options['tables_outpath'], 'tc_hard_features.txt')
    iter_fp = open(iter_outfile, 'w')
    iter_fp.close()
    
    ####################$###################################################################################################
    
    
    # write matlab script for graph generation
    matlab_fp = open(os.path.join(options['outpath'], 'gen_graphs.m'), 'w')
    
    # graph line_speed_all_classes
    matlab_fp.write("\n")
    matlab_fp.write("%% line_speed_all_classes\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("hold on;\n")
    matlab_fp.write("x = 1:1:60;\n")
    matlab_fp.write("y = [];\n")
    matlab_fp.write("classnames = [];\n")
    matlab_fp.write("yspecial = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_or)):
            matlab_fp.write("data_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "line_speed_all_classes: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_ps)):
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
    matlab_fp.write("classlines = plot(x, y, 'y-');\n")
    matlab_fp.write("speciallines = plot(x, yspecial(1,:), 'g-', x, yspecial(2,:), 'b-', x, yspecial(3,:), 'r-', 'LineWidth', 2);\n")
    matlab_fp.write("legendnames = strvcat('All classes', 'Median of all classes', classnames(Imax,:), classnames(Imin,:));\n")
    matlab_fp.write("legend([classlines(1); speciallines], legendnames, 'Location', 'SouthEast');\n")
    matlab_fp.write("xlabel('Duration of test run (minutes)');\n")
    matlab_fp.write("ylabel('Relative speed');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Relative speed of all classes');\n")
    matlab_fp.write("saveas(gcf, 'graphs/line_speed_all_classes', '%s');\n" % (options['graph-format']))
    matlab_fp.write("hold off;\n")
    matlab_fp.write("close(f);\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("hold on;\n")
    matlab_fp.write("classlines = plot(x, y);\n")
    matlab_fp.write("speciallines = plot(x, yspecial(1,:), 'g-', x, yspecial(2,:), 'b-', x, yspecial(3,:), 'r-', 'LineWidth', 2);\n")
    matlab_fp.write("legendnames = strvcat('Median of all classes', classnames(Imax,:), classnames(Imin,:));\n")
    matlab_fp.write("legend(speciallines, legendnames, 'Location', 'SouthEast');\n")
    matlab_fp.write("xlabel('Duration of test run (minutes)');\n")
    matlab_fp.write("ylabel('Relative speed');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Relative speed of all classes');\n")
    matlab_fp.write("saveas(gcf, 'graphs/line_speed_all_classes_colors', '%s');\n" % (options['graph-format']))
    matlab_fp.write("hold off;\n")
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    # graph line_ps_success_rate_all_classes
    matlab_fp.write("\n")
    matlab_fp.write("%% line_ps_success_rate_all_classes\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("x = 1:1:60;\n")
    matlab_fp.write("y = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "ps_success_rate_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_ps)):
            matlab_fp.write("data_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "line_ps_success_rate_all_classes: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        matlab_fp.write("y = [y;data_ps(:,2)'];\n")
    matlab_fp.write("plot(x, y);\n")
    matlab_fp.write("xlabel('Duration of test run (minutes)');\n")
    matlab_fp.write("ylabel('PS success rate');\n")
    if options['draw-titles']:
        matlab_fp.write("title('PS success rate of all classes');\n")
    matlab_fp.write("saveas(gcf, 'graphs/line_ps_success_rate_all_classes', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    # graph line_faults-ps_success_rate
    if options["draw-each-class"]:
        matlab_fp.write("\n")
        matlab_fp.write("%% line_faults-ps_success_rate\n")
        for iter_test_main_class in test_main_classes:
            iter_outpath = os.path.join("graphs", "line_faults-ps_success_rate", "%s" % (iter_test_main_class))
            try:
                os.makedirs(os.path.join(options['graphs_outpath'], 'line_faults-ps_success_rate'))
            except OSError, exc:
                if exc.errno == errno.EEXIST:
                    pass
                else:
                    raise
            matlab_fp.write("\n")
        
            iter_faults_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "faults_by_time.txt")
            if os.path.exists(os.path.join(options['outpath'], iter_faults_file_or)):
                matlab_fp.write("faults_data_or = dlmread('%s', '\\t');\n" % iter_faults_file_or)
            else:
                print >> sys.stderr, "line_faults-ps_success_rate: '%s_or_faults' not found, ignoring class." % iter_test_main_class
                continue
        
            iter_faults_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "faults_by_time.txt")
            if os.path.exists(os.path.join(options['outpath'], iter_faults_file_ps)):
                matlab_fp.write("faults_data_ps = dlmread('%s', '\\t');\n" % iter_faults_file_ps)
            else:
                print >> sys.stderr, "line_faults-ps_success_rate: '%s_ps_faults' not found, ignoring class." % iter_test_main_class
                continue
        
            iter_success_rate_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "ps_success_rate_by_time.txt")
            if os.path.exists(os.path.join(options['outpath'], iter_success_rate_file_ps)):
                matlab_fp.write("success_rate_data_ps = dlmread('%s', '\\t');\n" % iter_success_rate_file_ps)
            else:
                print >> sys.stderr, "line_faults-ps_success_rate: '%s_ps_success_rate_by_time' not found, ignoring class." % iter_test_main_class
                continue
        
            matlab_fp.write("f = figure;\n")
            matlab_fp.write("hold on;\n")
            matlab_fp.write("x = 1:1:60;\n")
            matlab_fp.write("y1 = [faults_data_or(:,2)'; faults_data_ps(:,2)'];\n")
            matlab_fp.write("y2 = success_rate_data_ps(:,2)';\n")
            matlab_fp.write("labels = {'ps' 'or' 'success\_rate'};\n")
            matlab_fp.write("plot(x, y1(2,:), '-b', 'LineWidth', 2);\n")
            matlab_fp.write("[AX,H1,H2] = plotyy(x, y1(1,:), x, y2);\n")
            # matlab_fp.write("set(H1,'LineStyle','-g');\n")
            matlab_fp.write("set(H2,'LineStyle','--');\n")
            matlab_fp.write("set(get(AX(1),'Ylabel'),'String','Number of found faults');\n")
            matlab_fp.write("ylim(AX(1), [0 max(y1(:))*1.1]);\n")
            matlab_fp.write("set(get(AX(2),'Ylabel'),'String','PS success rate');\n")
            matlab_fp.write("ylim(AX(2), [0 1]);\n")
            matlab_fp.write("xlabel('Duration of test run (minutes)');\n")
            matlab_fp.write("legend(labels, 'Location', 'SouthEast');\n")
            if options['draw-titles']:
                matlab_fp.write("title('Number of found faults + PS success rate -- %s');\n" % iter_test_main_class.replace('_', '\_'))
            matlab_fp.write("saveas(gcf, '%s', '%s');\n" % (iter_outpath, options['graph-format']))
            matlab_fp.write("hold off;\n")
            matlab_fp.write("close(f);\n")
            matlab_fp.write("\n")
    
    # graph bar_distinct_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_distinct_faults\n")
    matlab_fp.write("f = figure;\n")
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
    matlab_fp.write("[y,sortindex] = sortrows(y,[-4]);\n")
    matlab_fp.write("bar(y(:,1:3), 'stacked');\n")
    matlab_fp.write("xlabel('Class under test');\n")
    matlab_fp.write("ylabel('Number of distinct faults');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Number of distinct faults for each class under test');\n")
    matlab_fp.write("legend({'both' 'or' 'ps'});\n")
    matlab_fp.write("saveas(gcf, 'graphs/bar_distinct_faults', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    if options['draw-classnames']:
        matlab_fp.write("f = figure;\n");
        matlab_fp.write("bar(y(:,1:3), 'stacked');\n")
        matlab_fp.write("xlabel('Class under test');\n")
        matlab_fp.write("ylabel('Number of distinct faults');\n")
        if options['draw-titles']:
            matlab_fp.write("title('Number of distinct faults for each class under test');\n")
        matlab_fp.write("set(gca, 'XTick', 1:size(y,1));\n")
        matlab_fp.write("set(gca, 'XTickLabel', classnames(sortindex,:));\n")
        matlab_fp.write("xticklabel_rotate;\n")
        matlab_fp.write("saveas(gcf, 'graphs/bar_distinct_faults_with_names', '%s');\n" % (options['graph-format']))
        matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    # graph bar_distinct_faults_norm
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_distinct_faults_norm\n")
    matlab_fp.write("f = figure;\n")
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
    matlab_fp.write("[y,sortindex] = sortrows(y,[3 -1]);\n")
    matlab_fp.write("bar(y, 'stacked');\n")
    matlab_fp.write("ylim([0 1.15]);\n")
    matlab_fp.write("xlabel('Class under test');\n")
    matlab_fp.write("ylabel('Discovery distribution of distinct faults');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Discovery distribution of distinct faults for each class under test');\n")
    matlab_fp.write("legend({'both' 'or' 'ps'});\n")
    matlab_fp.write("saveas(gcf, 'graphs/bar_distinct_faults_norm', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    if options['draw-classnames']:
        matlab_fp.write("f = figure;\n");
        matlab_fp.write("bar(y, 'stacked');\n")
        matlab_fp.write("ylim([0 1.15]);\n")
        matlab_fp.write("xlabel('Class under test');\n")
        matlab_fp.write("ylabel('Discovery distribution of distinct faults');\n")
        if options['draw-titles']:
            matlab_fp.write("title('Discovery distribution of distinct faults for each class under test');\n")
        matlab_fp.write("set(gca, 'XTick', 1:size(y,1));\n")
        matlab_fp.write("set(gca, 'XTickLabel', classnames(sortindex,:));\n")
        matlab_fp.write("xticklabel_rotate;\n")
        matlab_fp.write("saveas(gcf, 'graphs/bar_distinct_faults_norm_with_names', '%s');\n" % (options['graph-format']))
        matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")

    # graph bar_pf
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_pf\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("y = [")
    for v in precond_features_tested_increase_perc_by_class.values():
        matlab_fp.write("%s," % v)
    matlab_fp.write("];\n")
    matlab_fp.write("hist(y, 50);\n")
    matlab_fp.write("xlabel('% increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("ylabel('Number of classes');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Class distribution by increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("saveas(gcf, 'graphs/bar_pf', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    # # graph bar_coverage_in_ps_of_untested_pf_in_or
    # matlab_fp.write("\n")
    # matlab_fp.write("%% bar_coverage_in_ps_of_untested_pf_in_or\n")
    # matlab_fp.write("f = figure;\n")
    # matlab_fp.write("y = [")
    # for iter_test_main_class, i in processed_results.iteritems():
    #     if not 'or' in i.keys() or not 'ps' in i.keys():
    #         print >> sys.stderr, "bar_coverage_in_ps_of_untested_pf_in_or: '%s' or/ps not found, ignoring class." % iter_test_main_class
    #         continue
    #     iter_divisor = float(len(i['or']['avg'].aggregated_precond_features_without_valid_tc))
    #     if iter_divisor == 0:
    #         continue
    #     iter_cov = 100 * float(len(i['ps']['avg'].aggregated_precond_features_with_valid_tc) - len(i['or']['avg'].aggregated_precond_features_with_valid_tc)) / iter_divisor
    #     matlab_fp.write("%s," % iter_cov)
    # matlab_fp.write("];\n")
    # matlab_fp.write("hist(y, 50);\n")
    # matlab_fp.write("xlabel('% of untestable features in or newly tested in ps');\n")
    # matlab_fp.write("ylabel('Number of classes');\n")
    # if options['draw-titles']:
    #     matlab_fp.write("title('Class distribution by increase in number of newly tested precondition-equipped features');\n")
    # matlab_fp.write("saveas(gcf, 'graphs/bar_coverage_in_ps_of_untested_pf_in_or', '%s');\n" % (options['graph-format']))
    # matlab_fp.write("close(f);\n")
    # matlab_fp.write("\n")
    
    # graph bar_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_faults\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("y = [")
    # ugly hack, should be somewhere else...
    faults_increase_ps_over_or_by_class = {}
    for iter_test_main_class, i in processed_results.iteritems():
        if not 'or' in i.keys() or not 'ps' in i.keys():
            print >> sys.stderr, "bar_faults: '%s' or/ps not found, ignoring class." % iter_test_main_class
            continue
        iter_divisor = float(i['or']['avg'].count_faults)
        if iter_divisor == 0:
            iter_increase = 0
            ### TODO: IS THIS OK?
        else:
            iter_increase = 100 * (float(i['ps']['avg'].count_faults) / iter_divisor - 1)
        matlab_fp.write("%s," % iter_increase)
        faults_increase_ps_over_or_by_class[iter_test_main_class] = iter_increase
    matlab_fp.write("];\n")
    matlab_fp.write("hist(y, 50);\n")
    matlab_fp.write("xlabel('% increase in number of found faults');\n")
    matlab_fp.write("ylabel('Number of classes');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Class distribution by increase in number of found faults');\n")
    matlab_fp.write("saveas(gcf, 'graphs/bar_faults', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    # graph scatter_speed_vs_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_speed_vs_faults\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("xraw = [];\n")
    matlab_fp.write("y = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_or)):
            matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "scatter_speed_vs_faults: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_ps)):
            matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_speed_vs_faults: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        matlab_fp.write("xraw = [xraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
        matlab_fp.write("y = [y;%s];\n" % faults_increase_ps_over_or_by_class[iter_test_main_class])
    matlab_fp.write("x = mean(xraw,2);\n")
    matlab_fp.write("scatter(x, y);\n")
    if options['draw-hvlines']:
        matlab_fp.write("hline(0, 'r-.');\n")
        matlab_fp.write("vline(0, 'r-.');\n")
    matlab_fp.write("ylabel('% increase in number of found faults');\n")
    matlab_fp.write("xlabel('Relative speed');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Relative speed vs. increase in number of found faults');\n")
    matlab_fp.write("saveas(gcf, 'graphs/scatter_speed_vs_faults', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")

    # graph scatter_speed_vs_pf
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_speed_vs_pf\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("xraw = [];\n")
    matlab_fp.write("y = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_or)):
            matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "scatter_speed_vs_pf: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_ps)):
            matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_speed_vs_pf: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        matlab_fp.write("xraw = [xraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
        matlab_fp.write("y = [y;%s];\n" % precond_features_tested_increase_perc_by_class[iter_test_main_class])
    matlab_fp.write("x = mean(xraw,2);\n")
    matlab_fp.write("scatter(x, y);\n")
    if options['draw-hvlines']:
        # matlab_fp.write("hline(0, 'r-.');\n")
        matlab_fp.write("vline(0, 'r-.');\n")
    matlab_fp.write("ylabel('% increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("xlabel('Relative speed');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Relative speed vs. increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("saveas(gcf, 'graphs/scatter_speed_vs_pf', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")

    # graph scatter_success_rate_vs_speed
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_success_rate_vs_speed\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("xraw = [];\n")
    matlab_fp.write("yraw = [];\n")
    for iter_test_main_class in test_main_classes:
        iter_file_or = os.path.join("analysis_data", iter_test_main_class, "or", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_or)):
            matlab_fp.write("speed_or = dlmread('%s', '\\t');\n" % iter_file_or)
        else:
            print >> sys.stderr, "scatter_success_rate_vs_speed: '%s_or' not found, ignoring class." % iter_test_main_class
            continue
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "valid_tc_gen_speed_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_ps)):
            matlab_fp.write("speed_ps = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_success_rate_vs_speed: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        iter_file_ps = os.path.join("analysis_data", iter_test_main_class, "ps", "ps_success_rate_by_time.txt")
        if os.path.exists(os.path.join(options['outpath'], iter_file_ps)):
            matlab_fp.write("ps_success_rate = dlmread('%s', '\\t');\n" % iter_file_ps)
        else:
            print >> sys.stderr, "scatter_success_rate_vs_speed: '%s_ps' not found, ignoring class." % iter_test_main_class
            continue
        
        matlab_fp.write("yraw = [yraw;(speed_ps(:,2)./speed_or(:,2) - 1)'];\n")
        matlab_fp.write("xraw = [xraw;ps_success_rate(:,2)'];\n")
    matlab_fp.write("x = mean(xraw,2);\n")
    matlab_fp.write("y = mean(yraw,2);\n")
    matlab_fp.write("scatter(x, y);\n")
    if options['draw-hvlines']:
        matlab_fp.write("hline(0, 'r-.');\n")
    matlab_fp.write("xlabel('Mean success rate');\n")
    matlab_fp.write("ylabel('Relative speed');\n")
    if options['draw-titles']:
       matlab_fp.write("title('Mean success rate vs. relative speed');\n")
    matlab_fp.write("saveas(gcf, 'graphs/scatter_success_rate_vs_speed', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")

    # graph scatter_pf_vs_faults
    matlab_fp.write("\n")
    matlab_fp.write("%% scatter_pf_vs_faults\n")
    matlab_fp.write("f = figure;\n")
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
    if options['draw-hvlines']:
        matlab_fp.write("hline(0, 'r-.');\n")
        matlab_fp.write("vline(0, 'r-.');\n")
    matlab_fp.write("ylabel('% increase in number of found faults');\n")
    matlab_fp.write("xlabel('% increase in number of tested precondition-equipped features');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Increase in number of found faults vs. increase in number of tested precondition-equipped features');\n")
    matlab_fp.write("saveas(gcf, 'graphs/scatter_pf_vs_faults', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    # graph bar_hf
    matlab_fp.write("\n")
    matlab_fp.write("%% bar_hf\n")
    matlab_fp.write("f = figure;\n")
    matlab_fp.write("y = [")
    for iter_feat in valid_tc_or_by_hard_feature.keys():
        matlab_fp.write("%s,%s;" % (valid_tc_or_by_hard_feature[iter_feat], valid_tc_ps_by_hard_feature[iter_feat]))
    matlab_fp.write("];\n")
    matlab_fp.write("y = sortrows(y, -1);\n")
    matlab_fp.write("bar(y, 'stacked');\n")
    matlab_fp.write("legend({'or' 'ps'});\n")
    matlab_fp.write("ylabel('Number of valid test cases');\n")
    matlab_fp.write("xlabel('Hard-to-test feature');\n")
    if options['draw-titles']:
        matlab_fp.write("title('Number of valid test cases for hard-to-test features');\n")
    matlab_fp.write("saveas(gcf, 'graphs/bar_hf', '%s');\n" % (options['graph-format']))
    matlab_fp.write("close(f);\n")
    matlab_fp.write("\n")
    
    matlab_fp.close()
    

if __name__ == "__main__":
    sys.exit(main())
