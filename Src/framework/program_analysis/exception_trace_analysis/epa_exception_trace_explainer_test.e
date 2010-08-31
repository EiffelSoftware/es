note
	description: "Summary description for {EPA_EXCEPTION_TRACE_EXPLAINER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXCEPTION_TRACE_EXPLAINER_TEST

create
	default_create

feature -- Test

	test
			-- Test if {EPA_EXCEPTION_TRACE_EXPLAINER} works fine.
		local
			l_trace: STRING_8
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
		do
			create l_explainer

			l_trace := trace_precondition_violation
			l_explainer.explain (l_trace)
			l_summary := l_explainer.last_explanation
			check
				l_summary.failing_context_class_name ~ "TWO_WAY_SORTED_SET"
				l_summary.failing_feature_name ~ "item"
				l_summary.failing_position_breakpoint_index = 2
				l_summary.failing_assertion_tag ~ "readable"
				l_summary.failing_written_class_name ~ "LINKED_LIST"
				l_summary.recipient_context_class_name ~ "TWO_WAY_SORTED_SET"
				l_summary.recipient_feature_name ~ "duplicate"
				l_summary.recipient_breakpoint_index = 9
				l_summary.recipient_written_class_name ~ "TWO_WAY_SORTED_SET"
			end

			l_trace := trace_postcondition_violation
			l_explainer.explain (l_trace)
			l_summary := l_explainer.last_explanation
			check
				l_summary.failing_context_class_name ~ "NATURAL_32"
				l_summary.failing_feature_name ~ "is_less_equal"
				l_summary.failing_position_breakpoint_index = 3
				l_summary.failing_assertion_tag ~ "definition"
				l_summary.failing_written_class_name ~ "COMPARABLE"
				l_summary.recipient_context_class_name ~ "NATURAL_32"
				l_summary.recipient_feature_name ~ "is_less_equal"
				l_summary.recipient_breakpoint_index = 3
				l_summary.recipient_written_class_name ~ "COMPARABLE"
			end

			l_trace := trace_feature_call_on_void_target
			l_explainer.explain (l_trace)
			l_summary := l_explainer.last_explanation
			check
				l_summary.failing_context_class_name ~ "TWO_WAY_SORTED_SET"
				l_summary.failing_feature_name ~ "search_after"
				l_summary.failing_position_breakpoint_index = 2
				l_summary.failing_assertion_tag ~ "is_less_equal"
				l_summary.failing_written_class_name ~ "PART_SORTED_LIST"
				l_summary.recipient_context_class_name ~ "TWO_WAY_SORTED_SET"
				l_summary.recipient_feature_name ~ "search_after"
				l_summary.recipient_breakpoint_index = 2
				l_summary.recipient_written_class_name ~ "PART_SORTED_LIST"
			end

			l_trace := trace_assertion_violation
			l_explainer.explain (l_trace)
			l_summary := l_explainer.last_explanation
			check
				l_summary.failing_context_class_name ~ "SUBSET_STRATEGY_HASHABLE"
				l_summary.failing_feature_name ~ "disjoint"
				l_summary.failing_position_breakpoint_index = 26
				l_summary.failing_assertion_tag ~ "hashable_item"
				l_summary.failing_written_class_name ~ "SUBSET_STRATEGY_HASHABLE"
				l_summary.recipient_context_class_name ~ "SUBSET_STRATEGY_HASHABLE"
				l_summary.recipient_feature_name ~ "disjoint"
				l_summary.recipient_breakpoint_index = 26
				l_summary.recipient_written_class_name ~ "SUBSET_STRATEGY_HASHABLE"
			end

			l_trace := trace_class_invariant_violation
			l_explainer.explain (l_trace)
			l_summary := l_explainer.last_explanation
			check
				l_summary.failing_context_class_name ~ "TWO_WAY_SORTED_SET"
				l_summary.failing_feature_name ~ "_invariant"
				l_summary.failing_position_breakpoint_index = 0
				l_summary.failing_assertion_tag ~ "index_small_enough"
				l_summary.failing_written_class_name ~ "CHAIN"
				l_summary.recipient_context_class_name ~ "TWO_WAY_SORTED_SET"
				l_summary.recipient_feature_name ~ "split"
				l_summary.recipient_breakpoint_index = 18
				l_summary.recipient_written_class_name ~ "TWO_WAY_LIST"
			end

		end


feature -- Exception traces for testing

	Trace_precondition_violation: STRING =
		"[
******************************** Thread exception *****************************
In thread           Root thread            0x0 (thread id)
*******************************************************************************
-------------------------------------------------------------------------------
Class / Object      Routine                Nature of exception           Effect
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  item @2                readable:                    
<0000000003579108>  (From LINKED_LIST)     Precondition violated.        Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  duplicate @9                                        
<0000000003579108>                         Routine failure.              Fail
-------------------------------------------------------------------------------
TC__TWO_WAY_SORTED_SET__DUPLICATE__F__C3__B9__REC_TWO_WAY_SORTED_SET__DUPLICATE__TAG_READABLE__335125304__1564331320
                    generated_test_1 @9    
<0000000003570828>                         Routine failure.              Fail
-------------------------------------------------------------------------------
APPLICATION         execute_test_case_0 @4                              
<0000000003570408>                         Routine failure.              Fail
-------------------------------------------------------------------------------
APPLICATION         execute_test_cases @1                               
<0000000003570408>                         Routine failure.              Fail
-------------------------------------------------------------------------------
APPLICATION         make @4                                             
<0000000003570408>  (From AFX_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
APPLICATION         root's creation                                     
<0000000003570408>                         Routine failure.              Exit
-------------------------------------------------------------------------------
		]"

	Trace_feature_call_on_void_target: STRING =
		"[
-------------------------------------------------------------------------------
Class / Object      Routine                Nature of exception           Effect
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  search_after @2        is_less_equal:
<00000000044AF83C>  (From PART_SORTED_LIST)
Feature call on void target.  Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  search_after @2
<00000000044AF83C>  (From PART_SORTED_LIST)
Routine failure.              Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  extend @2
<00000000044AF83C>                         Routine failure.              Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  fill @7
<00000000044AF83C>  (From CHAIN)           Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_byte_code @4
<0000000004460438>                         Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_protected @5
<0000000004460438>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
report_execute_request @13
<0000000004460438>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
parse @6
<0000000004460438>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
main_loop @5
<0000000004460438>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
start @8
<0000000004460438>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute @40
<0000000004460438>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
root's creation
<0000000004460438>                         Routine failure.              Exit
-------------------------------------------------------------------------------
		]"

	Trace_postcondition_violation: STRING =
		"[
-------------------------------------------------------------------------------
Class / Object      Routine                Nature of exception           Effect
-------------------------------------------------------------------------------
NATURAL_32          is_less_equal @3       definition:
<000000000486F68C>  (From COMPARABLE)      Postcondition violated.       Fail
-------------------------------------------------------------------------------
NATURAL_32          is_less_equal @3
<000000000486F68C>  (From COMPARABLE)      Routine failure.              Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  search_after @2
<00000000050B7160>  (From PART_SORTED_LIST)
Routine failure.              Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  extend @2
<00000000050B7160>                         Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_byte_code @3
<000000000507CBF4>                         Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_protected @5
<000000000507CBF4>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
report_execute_request @13
<000000000507CBF4>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
parse @6
<000000000507CBF4>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
main_loop @5
<000000000507CBF4>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
start @8
<000000000507CBF4>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute @40
<000000000507CBF4>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
root's creation
<000000000507CBF4>                         Routine failure.              Exit
-------------------------------------------------------------------------------
		]"

	Trace_assertion_violation: STRING =
		"[
-------------------------------------------------------------------------------
Class / Object      Routine                Nature of exception           Effect
-------------------------------------------------------------------------------
SUBSET_STRATEGY_HASHABLE
disjoint @26           hashable_item:
<00000000041D5850>                         Assertion violated.           Fail
-------------------------------------------------------------------------------
SUBSET_STRATEGY_HASHABLE
disjoint @26
<00000000041D5850>                         Routine failure.              Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  disjoint @5
<0000000004F1E738>  (From TRAVERSABLE_SUBSET)
Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_byte_code @5
<0000000004E07AB0>                         Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_protected @5
<0000000004E07AB0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
report_execute_request @13
<0000000004E07AB0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
parse @6
<0000000004E07AB0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
main_loop @5
<0000000004E07AB0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
start @8
<0000000004E07AB0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute @40
<0000000004E07AB0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
root's creation
<0000000004E07AB0>                         Routine failure.              Exit
-------------------------------------------------------------------------------
		]"

	Trace_class_invariant_violation: STRING =
		"[
-------------------------------------------------------------------------------
Class / Object      Routine                Nature of exception           Effect
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  _invariant             index_small_enough:
<00000000049B5018>  (From CHAIN)           Class invariant violated.     Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  _invariant
<00000000049B5018>  (From CHAIN)           Routine failure.              Fail
-------------------------------------------------------------------------------
TWO_WAY_SORTED_SET  split @18
<0000000004617644>  (From TWO_WAY_LIST)    Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_byte_code @3
<0000000004FD57D0>                         Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute_protected @5
<0000000004FD57D0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
report_execute_request @13
<0000000004FD57D0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
parse @6
<0000000004FD57D0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
main_loop @5
<0000000004FD57D0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
start @8
<0000000004FD57D0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
execute @40
<0000000004FD57D0>  (From ITP_INTERPRETER) Routine failure.              Fail
-------------------------------------------------------------------------------
ITP_INTERPRETER_ROOT
root's creation
<0000000004FD57D0>                         Routine failure.              Exit
-------------------------------------------------------------------------------
		]"

end
