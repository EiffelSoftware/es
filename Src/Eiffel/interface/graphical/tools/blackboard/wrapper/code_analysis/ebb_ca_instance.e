note
	description: "Summary description for {EBB_CODE_ANALYSIS_INSTANCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CA_INSTANCE

inherit

	EBB_TOOL_INSTANCE
		rename make as make_ end

	EBB_SHARED_BLACKBOARD

	SHARED_SERVER

create
	make

feature {NONE} -- Initialization

	make (a_execution: attached like execution)
		do
			create feature_table.make (10)
			make_(a_execution)
		end

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
			-- Since the code analyzer will analyze a whole class in one cycle, there will be no use to implementing a cancel function because
			-- the verification assistant only allows to scan one class at a time.
			do_nothing
		end

	handle_analysis_results (a_exceptions: ITERABLE [TUPLE [EXCEPTION, CLASS_C]])
		local
			l_result: EBB_CA_VERIFICATION_RESULT
		do
			blackboard.record_results

			if not code_analyzer.rule_violations.is_empty then
				code_analyzer.rule_violations.start
					-- Initialize checking_class for the matchlists. Since we only check one class at most, we can use any violation for this.
				checking_class := code_analyzer.rule_violations.key_for_iteration
			end

			across code_analyzer.rule_violations.iteration_item (0) as l_violation loop
				if attached {FEATURE_I} get_feature_from_location (l_violation.item.location) as l_feature then
					if attached {CA_ERROR} l_violation.item.rule.severity then
						add_results_to_table (l_feature, 1, 0, 0)
					elseif attached {CA_WARNING} l_violation.item.rule.severity then
						add_results_to_table (l_feature, 0, 1, 0)
					elseif attached {CA_HINT} l_violation.item.rule.severity then
						add_results_to_table (l_feature, 0, 0, 1)
					end
				end
			end

				-- Create the verification results and add them to the blackboard.
			across feature_table as l_feature loop
				create l_result.make (l_feature.key,
								configuration,
								l_feature.item.integer_32_item (1),
								l_feature.item.integer_32_item (2),
								l_feature.item.integer_32_item (3))
				blackboard.add_verification_result (l_result)
			end

			blackboard.commit_results
		end

feature {NONE} -- Implementation

	get_feature_from_location (a_location: LOCATION_AS): FEATURE_I
		local
			l_feature_found: BOOLEAN
			l_table: LIST[E_FEATURE]
		do
			from
				l_table := checking_class.written_in_features
				l_table.start
				l_feature_found := False
				Result := Void
			until
				l_table.after
				or l_feature_found
			loop

				if is_contained_in (a_location, l_table.item.ast.start_location, l_table.item.ast.end_location) then
					l_feature_found := True
					Result := l_table.item.associated_feature_i
				end
				l_table.forth
			end
		end

	is_contained_in (a_location: LOCATION_AS; a_start: LOCATION_AS; a_end: LOCATION_AS): BOOLEAN
		do
			Result := (not (a_start.is_null or a_end.is_null)) and a_start.line <= a_location.line and a_end.line >= a_location.line
		end

	add_results_to_table (a_feature: FEATURE_I; a_errors: INTEGER; a_warnings: INTEGER; a_hints: INTEGER)
		local
			l_values: TUPLE [INTEGER, INTEGER, INTEGER]
		do
			if feature_table.has_key (a_feature) then
					-- Already existing entry, update values.
				l_values := feature_table.found_item

				l_values[1] := l_values.integer_32_item (1) + a_errors
				l_values[2] := l_values.integer_32_item (2) + a_warnings
				l_values[3] := l_values.integer_32_item (3) + a_hints

				feature_table.replace (l_values, a_feature)
			else
				feature_table.put ([a_errors, a_warnings, a_hints], a_feature)
			end
		end

	checking_class: CLASS_C

	matchlist: LEAF_AS_LIST
		once
			Result := Match_list_server.item (checking_class.class_id)
		end

	feature_table: HASH_TABLE [TUPLE [INTEGER, INTEGER, INTEGER], FEATURE_I]
		-- Table to represent the violations of a feature with a tuple [errors, warnings, hints].

	free_violations: TUPLE [INTEGER, INTEGER, INTEGER]
		-- Represents the violations of the checking_class that are not within a certain feature. [errors, warnings, hints]

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
