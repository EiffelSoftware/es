note
	description: "Summary description for {AFX_FAILURE_EXPLAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FAILURE_EXPLAINER

inherit
    AFX_FAILURE_EXPLAINER_I

    SHARED_AFX_LOGGING_INFRASTRUCTURE

    SHARED_AFX_SESSION

    SHARED_AFX_INTERNAL_PROGRESS_CONSTANT

feature -- Operate

	explain (a_test: AFX_TEST)
			-- <Precursor>
		local
		    l_exception_frames: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
		    l_trace_analyser: AFX_EXCEPTION_TRACE_ANALYSER_I
		    l_position_resolver: AFX_EXCEPTION_POSITION_RESOLVER_I
		    l_marking_strategy: AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY_I
		    l_session: like session
		    l_progress: REAL
		do
		    l_session := session
		    l_progress := Failure_explanation_phase_fraction / 3

    		exception := a_test.test.outcomes.last.test_response.exception

			check exception.trace /= Void and then not exception.trace.is_empty end

		    create {AFX_EXCEPTION_TRACE_ANALYSER}l_trace_analyser
		    l_trace_analyser.analyse (exception.trace)
		    l_exception_frames := l_trace_analyser.last_relevant_exception_frames
		    l_session.progress (l_progress)

		    create {AFX_EXCEPTION_POSITION_RESOLVER}l_position_resolver
		    l_position_resolver.resolve (l_exception_frames)
		    l_session.progress (l_progress)

				-- we could send the frame list to different fixing strategies, e.g. strategy of insertion and that of conditional execution
				-- from different strategies, we have different fixes, which could be integrated together into the program

		    create {AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY}l_marking_strategy
		    l_marking_strategy.mark (exception, l_exception_frames)
		    l_session.progress (l_progress)

		    last_exception_explanation := l_marking_strategy.last_marking_result
		end

feature -- Access

	exception: detachable EQA_TEST_INVOCATION_EXCEPTION
			-- the exception which needs explanation

	last_exception_explanation: detachable DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- <Precursor>

	dash_line: STRING = "-------------------------------------------------------------------------------"

	header_line: STRING = "Class / Object      Routine                Nature of exception           Effect"

	rescue_line_prefix: STRING = "~~~~~~~~~~~~~~~~~~~~~~~~~"

	internal_exception_frames: detachable DS_ARRAYED_LIST [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- internal storage for exception frames

;note
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
