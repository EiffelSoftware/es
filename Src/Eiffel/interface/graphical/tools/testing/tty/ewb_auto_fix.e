note
	description: "Summary description for {EWB_AUTO_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AUTO_FIX

inherit
	EWB_CMD

	AFX_SHARED_SESSION

	EPA_COMPILATION_UTILITY

	AFX_SHARED_PROJECT_ROOT_INFO

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialize `auto_test_arguments' with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create {LINKED_LIST [STRING]} autofix_arguments.make
			a_arguments.do_all (agent autofix_arguments.extend)
		ensure
			arguments_set: autofix_arguments /= Void and then autofix_arguments.count = a_arguments.count
		end

feature -- Access

	autofix_arguments: LINKED_LIST [STRING];
			-- Arguments to AutoFix command line

feature -- Properties

	name: STRING
		do
			Result := "AutoFix"
		end

	help_message: STRING_GENERAL
		do
			Result := "AutoFix"
		end

	abbreviation: CHARACTER
		do
			Result := 'a'
		end

	execute
			-- Action performed when invoked from the
			-- command line.
		local
			l_parser: AFX_COMMAND_LINE_PARSER
			l_config: AFX_CONFIG
--			l_initializer: AFX_INITIALIZER
			l_fixing_project_builder: AFX_PROJECT_FOR_FIXING_IMPLEMENTATION_BUILDER
			l_fixer: AFX_FIXER
--			l_fix_proposer: AFX_IMPLEMENTATION_FIXER
--			l_contract_fixer: AFX_CONTRACT_FIXER
		do
			create l_parser.make_with_arguments (autofix_arguments)
			l_parser.parse

			l_config := l_parser.config
			l_config.check_validity
			if l_config.is_valid then
				set_current_session (create {AFX_SESSION}.make (l_config, system))
				if session.config.is_fixing then
						-- Build project for fixing.
					create l_fixing_project_builder
					l_fixing_project_builder.collect_test_cases
					if l_fixing_project_builder.current_failing_test_signature /= Void then
							-- Directory structure is specific to the exception under consideration.
						session.set_failure_from_trace (l_fixing_project_builder.current_exception_trace_summary)
						session.set_number_of_test_cases_for_fixing (l_fixing_project_builder.number_of_test_cases_to_use_for_fixing)
						session.prepare_directories
						l_fixing_project_builder.build_project (System)
--						check fixing_project_root_exists: l_fixing_project_builder.new_root_exists end
--						if not system.is_explicit_root (afx_project_root_class, afx_project_root_feature) then
--							system.add_explicit_root (Void, afx_project_root_class, afx_project_root_feature)
--	--						system.add_explicit_root (l_fixing_project_builder.cluster_of_new_root, afx_project_root_class, afx_project_root_feature)
--						end
--						l_fixing_project_builder.compile_project (l_fixing_project_builder.eiffel_project, True)

						create l_fixer
						l_fixer.execute

--						if session.config.is_fixing_contract then
--							create l_contract_fixer
--							l_contract_fixer.execute
--						else
--							create l_fix_proposer
--							l_fix_proposer.execute
--						end

						system.remove_explicit_root(afx_project_root_class, afx_project_root_feature)
						system.make_update (False)
					else
						Io.put_string ("No failing test case found.")
					end
				elseif session.config.is_not_fixing then
					perform_non_fixing_task()
				end
			else
				Io.put_string ("AutoFix quitting due to incomplete or invalid configuration...")
			end

		end

	perform_non_fixing_task()
			-- Perform tasks other than fixing.
		require
			session.config.is_not_fixing
		local
			l_postmortem_analyzer: AFX_POSTMORTEM_ANALYZER
		do
			if session.config.is_for_postmortem_analysis then
				create l_postmortem_analyzer.make(session.config.postmortem_analysis_source)
				l_postmortem_analyzer.analyze()
				-- l_postmortem_analyzer.generate_report()
			end
		end

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
