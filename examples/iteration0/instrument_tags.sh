#!/bin/bash
# create the content for the methodstart & methodbodyend- tags.
#arg1: file where the starttags should be instrumented.
file_step1=$1_1
file_step2=$1_2
file_step3=$1_3

feature_start_tag1='-- <methodbody_start'
feature_start_tag2='-- <\/methodbody_start'
feature_start_action=\
's/.*-- <methodbody_start name=\(\"[^\"]*\"\) args=\"\([^\"]*\)\".*\n\([^\n]*\)/\t\t\t-- <methodbody_start name=\1 args=\"\2\">\
\t\t\tif program_flow_sink.is_capture_replay_enabled then\
\t\t\t\tprogram_flow_sink.enter\
\t\t\t\tprogram_flow_sink.put_feature_invocation\ (\1, Current, \2)\
\t\t\t\tprogram_flow_sink.leave\
\t\t\tend\
\t\t\tif (not program_flow_sink.is_replay_phase) or is_observed then\
\t\t\t-- <\/methodbody_start>/; # baba'

feature_end_res_tag1='-- <methodbody_end return_value="True"'
feature_end_res_tag2='-- <\/methodbody_end'
feature_end_res_content='\t\t\tend\
\t\t\tif program_flow_sink.is_capture_replay_enabled then\
\t\t\t\tprogram_flow_sink.enter\
\t\t\t\tResult ?= program_flow_sink.put_feature_exit\ (Result)\
\t\t\t\tprogram_flow_sink.leave\
\t\t\tend'

feature_end_no_res_tag1='-- <methodbody_end return_value="False"'
feature_end_no_res_tag2='-- <\/methodbody_end'
feature_end_no_res_content='\t\t\tend\
\t\t\tif program_flow_sink.is_capture_replay_enabled then\
\t\t\t\tprogram_flow_sink.enter\
\t\t\t\tignore_result ?= program_flow_sink.put_feature_exit\ (Void)\
\t\t\t\tprogram_flow_sink.leave\
\t\t\tend'


instrument_feature_end(){
# inserts content between two tags (tag1 , tag2) . all old content will be removed.
# usage:
# arg1: start tag of first line (escaped)
# arg2 start tag of second line (escaped)
# arg3 content that should be inserted between start and end line
# arg4: source file
# arg5: target file
echo "1:" $1
echo "2:" $2
echo "3:" $3
echo "4:" $4
echo "5:" $5

sed -e ":t
     /${1}/,/${2}/ {    # For each line between these block markers..
        /${2}/!{         #   If we are not at the /end/ marker
           $!{          #     nor the last line of the file,
              N;        #     add the Next line to the pattern space
              bt
           }            #   and branch (loop back) to the :t label.
        }               # This line matches the /end/ marker.
        s/\([^\n]*\).*\n\([^\n]*\)/\1\n${3}\n\2/;       # baba
     }                  # Otherwise, the block will be printed.
" $4 > $5
}


sed -e ":t
     /${feature_start_tag1}/,/${feature_start_tag2}/ {    # For each line between these block markers..
        /${feature_start_tag2}/!{         #   If we are not at the /end/ marker
           $!{          #     nor the last line of the file,
              N;        #     add the Next line to the pattern space
              bt
           }            #   and branch (loop back) to the :t label.
        }               # This line matches the /end/ marker.
	${feature_start_action}
     }                  # Otherwise, the block will be printed.
" $1 > $file_step1

instrument_feature_end "${feature_end_res_tag1}" "${feature_end_res_tag2}" "${feature_end_res_content}" "${file_step1}" "${file_step2}"
instrument_feature_end "${feature_end_no_res_tag1}" "${feature_end_no_res_tag2}" "${feature_end_no_res_content}" "${file_step2}" "${file_step3}"

#!/bin/bash

cp $file_step3 $1
rm $file_step1
rm $file_step2
rm $file_step3
cat $1
#mv $1_tmp $1
