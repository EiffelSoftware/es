note
	description: "Summary description for {EPA_EXCEPTION_TRACE_EXPLAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXCEPTION_TRACE_EXPLAINER

inherit
	EXCEP_CONST

	EPA_UTILITY

create
	default_create

feature -- Access

	last_explanation: detachable EPA_EXCEPTION_TRACE_SUMMARY
			-- Explanation for last exception trace.
		require
			was_successful: was_successful
		do
			Result := last_explanation_cache
		end

feature -- Basic operation

	explain (a_trace: STRING)
			-- Explain the exception trace `a_trace'.
			-- If the operation finishes successfully,
			-- 		set `was_successful' to True and make the explanation available via other queries.
		require
			trace_not_empty: a_trace /= Void and then not a_trace.is_empty
		local
			l_parser: EPA_EXCEPTION_TRACE_PARSER
			l_frames: DS_ARRAYED_LIST [EPA_EXCEPTION_TRACE_FRAME]
			l_frame: EPA_EXCEPTION_TRACE_FRAME
		do
			reset_explainer

			create l_parser
			l_parser.parse (a_trace)
			if l_parser.is_successful then
				l_frames := l_parser.last_exception_frames
				last_trace_frames := l_frames
				check more_than_one_frame: l_frames.count > 1 end

				l_frame := l_frames.first
				if l_frame.is_nature_precondition_violation then
					explain_precondition_violation
				elseif l_frame.is_nature_postcondition_violation then
					explain_postcondition_violation
				elseif l_frame.is_nature_assertion_violation then
					explain_assertion_violation
				elseif l_frame.is_nature_class_invariant_violation then
					explain_class_invariant_violation
				elseif l_frame.is_nature_feature_call_on_void_target then
					explain_feature_call_on_void_target
				elseif l_frame.is_nature_unmatched_inspect_value then
					explain_unmatched_inspect_value
				elseif l_frame.is_rescue_frame then
					quit (Msg_rescue_block_not_supported)
				else
					explain_unsupported_exception
				end
			else
				quit (Msg_trace_parsing_failed)
			end
		end

feature{NONE} -- Implementation

	explain_precondition_violation
			-- Explain exception as a precondition violation.
		require
			precon_violation: last_trace_frames /= Void
							and then last_trace_frames.count >= 2
							and then last_trace_frames.first.is_nature_precondition_violation
		do
			last_exception_code := precondition

			explain_non_invariant_related_violations
		end

	explain_postcondition_violation
			-- Explain exception as a postcondition violation.
		require
			postcon_violation: last_trace_frames /= Void
							and then last_trace_frames.count >= 2
							and then last_trace_frames.first.is_nature_postcondition_violation
		do
			last_exception_code := postcondition

			explain_non_invariant_related_violations
		end

	explain_feature_call_on_void_target
			-- Explain exception as a feature-call-on-void-target violation.
		require
			call_on_void_violation: last_trace_frames /= Void
							and then last_trace_frames.count >= 2
							and then last_trace_frames.first.is_nature_feature_call_on_void_target
		do
			last_exception_code := Void_call_target

			explain_non_invariant_related_violations
		end

	explain_assertion_violation
			-- Explain exception as an assertion violation.
		require
			assertion_violation: last_trace_frames /= Void
							and then last_trace_frames.count >= 2
							and then last_trace_frames.first.is_nature_assertion_violation
		do
			last_exception_code := check_instruction

			explain_non_invariant_related_violations
		end

	explain_unmatched_inspect_value
			-- Explain exception due to unmatched inspect value.
		require
			last_trace_frames /= Void
					and then last_trace_frames.count >= 2
					and then last_trace_frames.first.is_nature_unmatched_inspect_value
		do
			last_exception_code := Incorrect_inspect_value

			explain_non_invariant_related_violations
		end

	explain_class_invariant_violation
			-- Explain exception as a class invariant violation.
		require
			class_inv_violation: last_trace_frames /= Void
							and then not last_trace_frames.is_empty
							and then last_trace_frames.first.is_nature_class_invariant_violation
		local
			l_frame: EPA_EXCEPTION_TRACE_FRAME
		do
			last_exception_code := class_invariant

			-- First frame describes the failing class invariant.
			last_trace_frames.start
			l_frame := last_trace_frames.item_for_iteration
			check for_invariant_violation: l_frame.is_routine_name_invariant and then l_frame.is_nature_class_invariant_violation end
			last_failing_context_class_name := l_frame.context_class_name
			last_failing_feature_name := l_frame.routine_name
			check name_invariant: last_failing_feature_name ~ "_invariant" end
			last_failing_position_breakpoint_index := l_frame.breakpoint_slot_index
--			check index_zero: last_failing_position_breakpoint_index = 0 end
			last_failing_assertion_tag := l_frame.tag
			last_failing_written_class_name := l_frame.written_class_name

			-- Second frame is for the invariants as a routine. Skip it.
			last_trace_frames.forth
			l_frame := last_trace_frames.item_for_iteration
			check in_invariant_routine: l_frame.is_routine_name_invariant and then l_frame.is_nature_routine_failure end

			-- Third frame describes the recipient feature context.
			last_trace_frames.forth
			l_frame := last_trace_frames.item_for_iteration
			check in_recipient_context: l_frame.is_feature_related and then l_frame.is_nature_routine_failure end
			last_recipient_context_class_name := l_frame.context_class_name
			last_recipient_feature_name := l_frame.routine_name
			last_recipient_breakpoint_index := l_frame.breakpoint_slot_index
			last_recipient_written_class_name := l_frame.written_class_name

			create last_explanation_cache.make (
							last_exception_code,
							last_failing_context_class_name,
							last_failing_feature_name,
							last_failing_position_breakpoint_index,
							last_failing_assertion_tag,
							last_recipient_context_class_name,
							last_recipient_feature_name,
							last_recipient_breakpoint_index)
		end

	explain_unsupported_exception
			-- Explain exceptions other than pre/post, assert, inv violation or call-on-void.
		require
			other_violation: last_trace_frames /= Void
							and then last_trace_frames.count >= 2
							and then not last_trace_frames.first.is_nature_precondition_violation
							and then not last_trace_frames.first.is_nature_postcondition_violation
							and then not last_trace_frames.first.is_nature_assertion_violation
							and then not last_trace_frames.first.is_nature_feature_call_on_void_target
							and then not last_trace_frames.first.is_nature_class_invariant_violation
		do
			last_exception_code := 0

			explain_non_invariant_related_violations
		end

	explain_non_invariant_related_violations
			-- Explain exception as not related to class invariants.
		require
			non_inv_violation: last_trace_frames /= Void
							and then last_trace_frames.count >= 2
							and then not last_trace_frames.first.is_nature_class_invariant_violation
		local
			l_frame: EPA_EXCEPTION_TRACE_FRAME
		do
			last_trace_frames.start
			l_frame := last_trace_frames.item_for_iteration
			check feature_related: l_frame.is_feature_related end

			last_failing_context_class_name := l_frame.context_class_name
			last_failing_feature_name := l_frame.routine_name
			last_failing_position_breakpoint_index := l_frame.breakpoint_slot_index
			last_failing_assertion_tag := l_frame.tag
			last_failing_written_class_name := l_frame.written_class_name

			last_trace_frames.forth
			l_frame := last_trace_frames.item_for_iteration
			check
				feature_related: l_frame.is_feature_related -- and then l_frame.is_nature_routine_failure
			end

			last_recipient_context_class_name := l_frame.context_class_name
			last_recipient_feature_name := l_frame.routine_name
			last_recipient_breakpoint_index := l_frame.breakpoint_slot_index
			last_recipient_written_class_name := l_frame.written_class_name

			create last_explanation_cache.make (
							last_exception_code,
							last_failing_context_class_name,
							last_failing_feature_name,
							last_failing_position_breakpoint_index,
							last_failing_assertion_tag,
							last_recipient_context_class_name,
							last_recipient_feature_name,
							last_recipient_breakpoint_index)
		end

--	explain_frame_list (a_frame_list: DS_ARRAYED_LIST [EPA_EXCEPTION_TRACE_FRAME])
--			-- Explain an exception based on `a_frame_list'.
--		require
--			list_not_empty: a_frame_list /= Void and then not a_frame_list.is_empty
--		local
--			l_frame: EPA_EXCEPTION_TRACE_FRAME
--		do
--			l_frame := a_frame_list.first
--			if l_frame.is_rescue_frame then
--				quit (Msg_rescue_block_not_supported)
--			else
--				if l_frame.is_nature_precondition_violation then

--				end
--			end
--		end

feature{NONE} -- Intermediate explanation

	last_trace_frames: DS_ARRAYED_LIST [EPA_EXCEPTION_TRACE_FRAME]

	last_exception_code: INTEGER

	last_failing_position_breakpoint_index: INTEGER

	last_failing_feature_name: STRING

	last_failing_context_class_name: STRING

	last_failing_written_class_name: STRING

	last_failing_assertion_tag: STRING

	last_recipient_breakpoint_index: INTEGER

	last_recipient_feature_name: STRING

	last_recipient_context_class_name: STRING

	last_recipient_written_class_name: STRING

feature -- Status report

	was_successful: BOOLEAN
			-- Was last analysis successful?

feature -- Access (analyzer)

	error_message: STRING
			-- Description of the error, if `was_successful' is set to False.

feature{NONE} -- Status set

	set_last_explanation (a_exp: like last_explanation)
			-- Set `last_explanation'.
		do
			last_explanation_cache := a_exp
		end

feature -- Constant

	Msg_trace_parsing_failed: STRING = "Trace parsing failed."
	Msg_rescue_block_not_supported: STRING = "Rescue block not supported."
	Msg_exception_type_not_supported: STRING = "Exception type not supported."

feature{NONE} -- Cache

	last_explanation_cache: like last_explanation
			-- Cache for `last_explanation'.

feature{NONE} -- Implementation

	reset_explainer
			-- Reset the internal state of the explainer.
		do
			was_successful := True
			error_message := once ""
			last_explanation_cache := Void
		end

	quit (a_msg: STRING)
			-- Stop trying to explain the trace.
			-- Set `was_successful' to False and `error_message' to `a_msg'.
		do
			was_successful := False
			error_message := a_msg.twin
		end


end
