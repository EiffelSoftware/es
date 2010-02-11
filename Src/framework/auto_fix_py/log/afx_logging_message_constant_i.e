note
	description: "Summary description for {AFX_LOGGING_MESSAGE_CONSTANT_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LOGGING_MESSAGE_CONSTANT_I

feature -- General error msg

	Err_bad_session_object: STRING = "Internal error: bad session object."

feature -- Message Constants

	Msg_processor_started: STRING = "AutoFix processor started."

feature -- Exception analyser

	Msg_started_fix_proposer: STRING = "Started fix proposer."

	Msg_started_exception_analysis: STRING = "Started exception analysis."

	Msg_finished_analysing_exception_trace_header: STRING = "Finished analysing exception trace header."

	Msg_finished_analysing_exception_trace_frame_pre: STRING = "Finished analysing exception trace frame:%N%T"

	Msg_finished_analysing_exception_trace_rescue_frame_pre: STRING = "Finished analysing exception trace rescue frame:%N%T"

	Msg_finished_exception_analysis_pre: STRING = "Finished exception analysis, "
	msg_number_exception_frames_analysed_post: STRING = " exception frames analysed."

	Msg_number_exception_frame_rescue_removed_post: STRING = " exception rescue frame removed."

	Msg_finished_resolving_exception_frame_e_feature_pre: STRING = "Resolved exception frame 'e_feature': "
	Msg_finished_resolving_exception_frame_breakpoint_slot_info_pre: STRING = "Resolved exception frame 'breakpoint_info': "

	Msg_finished_resolving_all_exception_frames: STRING = "Finished resolving all exception frames."

	Msg_finished_marking_relevant_exception_frames: STRING = "Finished marking relevant exception frames,"
	Msg_number_relevant_exception_frames_found: STRING = " relevant exception frames found."

feature -- Fix Synthesizer

	Msg_created_fix_synthesizer: STRING = "Created fix synthesizer."

	Msg_started_fix_synthesizer: STRING = "Started fix synthesizer."

	Msg_starting_fix_evaluation: STRING = "Starting fix evaluation."

feature -- Fix Proposer

	Msg_ready_for_evaluation_1: STRING = "Starting to evaluate "
	Msg_ready_for_evaluation_2: STRING = " fixes over "
	Msg_ready_for_evaluation_3: STRING = " tests in total."

	Msg_starting_fix_validation: STRING = "Starting fix validation."
	Msg_no_fix_to_be_validated: STRING = "No fix to be validated."

	Msg_evaluations_started: STRING = " evaluations started."

	Msg_evaluation_result_1: STRING = "Evaluation result: fix_id: "
	Msg_evaluation_result_2: STRING = ", test_id: "
	Msg_evaluation_result_3: STRING = ", "

	Msg_proposer_report_pre: STRING = "Proposer report:%N"

	Msg_finished_fix_proposer: STRING = "Finished fix proposer."

	Err_bad_exception_trace_header: STRING = "Bad exception trace header."

	Err_bad_exception_trace_frame_format_pre: STRING = "Bad exception trace frame format:%N%T"

	Err_no_relevant_exception_frame_found: STRING = "No relevant exception frame found."

	Err_bad_failing_test_case_number: STRING = "Bad failing test case number."



note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
