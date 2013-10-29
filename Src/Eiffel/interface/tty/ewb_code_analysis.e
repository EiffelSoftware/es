note
	description: "Summary description for {EWB_CODE_ANALYSIS}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_CODE_ANALYSIS

inherit
	EWB_CMD

	SHARED_SERVER
		export {NONE} all end

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialization for `Current'.
		do

		end

feature -- Execution (declared in EWB_CMD)

	execute
			-- UNDER TEST
		local
			l_code_analyzer: CA_CODE_ANALYZER
			l_rule_name, l_line, l_col: STRING
		do
			output_window.add ("{EWB_CODE_ANALYSIS}.execute was called! (:%N")
			output_window.add ("Creating a CA_CODE_ANALYZER instance...%N")
			create l_code_analyzer.make
			output_window.add ("Calling analyze_sytem...%N")
			l_code_analyzer.add_whole_system
			l_code_analyzer.analyze
			print ("%N")

			across l_code_analyzer.rule_violations as l_vlist loop

				if not l_vlist.item.is_empty then
					print ("%NIn class '" + l_vlist.key.name + "':%N")

					-- Sort


					across l_vlist.item as l_v loop
						l_rule_name := l_v.item.rule.title
						l_line := l_v.item.location.line.out
						l_col := l_v.item.location.column.out

						print ("  (" + l_line + ":" + l_col + "): " + l_rule_name + ": ")
						l_v.item.format_violation_description (output_window)
						print ("%N")
					end
				end
			end
		end

feature -- Info (declared in EWB_CMD)

	name: STRING
		do
			Result := "Code Analysis"
		end

	help_message: STRING_GENERAL
		do
			Result := "Code Analysis performs static analyses on the source code and %
			           %outputs a list of issues found according to a set of rules."
		end

	abbreviation: CHARACTER
		do
			Result := 'a'
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
