note
	description: "Summary description for {EBB_CODE_ANALYSIS_INSTANCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CA_INSTANCE

inherit

	EBB_TOOL_INSTANCE

	EBB_SHARED_BLACKBOARD

create
	make

feature -- Status report

	is_running: BOOLEAN
			-- <Precursor>
		do
			Result := code_analyzer.is_running
		end


feature -- Basic operations

	start
			-- <Precursor>
		do
			create code_analyzer.make
			across input.individual_classes as c loop code_analyzer.add_class (c.item.eiffel_class_c.original_class) end
			across input.individual_features as f loop
				code_analyzer.add_class (f.item.written_class.eiffel_class_c.original_class)
			end
			code_analyzer.add_output_action (agent set_status_message)
			code_analyzer.add_completed_action (agent handle_analysis_results)
			code_analyzer.analyze
		end

	cancel
			-- <Precursor>
		do
			-- Don't know how to cancel CA_CODE_ANALYZER.
		end

	handle_analysis_results (a_exceptions: ITERABLE [TUPLE [EXCEPTION, CLASS_C]])
		local
			l_result: EBB_CA_VERIFICATION_RESULT
		do
			blackboard.record_results
			--create l_result.make ("the feature", configuration, 100); TODO: How can we access the feature when we can only check whole classes?
																		   -- Especially if some rules apply to a class and not a specific feature!
			blackboard.add_verification_result (l_result)
			blackboard.commit_results
		end

feature {NONE} -- Implementation

	code_analyzer: CA_CODE_ANALYZER

invariant
note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
