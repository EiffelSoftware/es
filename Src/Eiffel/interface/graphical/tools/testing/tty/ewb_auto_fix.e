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
			l_session: AFX_SESSION
			l_initializer: AFX_INITIALIZER
			l_fix_proposer: AFX_FIX_PROPOSER

			l_fixing_project_builder: AFX_FIXING_PROJECT_BUILDER
		do
			create l_parser.make_with_arguments (autofix_arguments, system)
			l_parser.parse
			l_config := l_parser.config

				-- Save configuration into the shared session object.
			create l_session.make (l_config)
			set_session (l_session)

				-- Initialize infrastructure.
			create l_initializer
			l_initializer.prepare (config)

				-- Re-structure the project to include test cases.
			if config.should_build_test_cases then
				create l_fixing_project_builder
				l_fixing_project_builder.execute
			end

			create l_fix_proposer.make
			l_fix_proposer.execute

			system.remove_explicit_root(afx_project_root_class, afx_project_root_feature)
			system.make_update (False)
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
