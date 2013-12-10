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

inherit {NONE}
	CA_SHARED_NAMES

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialization for `Current'.
		do
			create class_name_list.make

			across a_arguments as l_args loop
				if l_args.item.is_equal ("-caclass") or l_args.item.is_equal ("-caclasses") then
					from l_args.forth
					until l_args.after or l_args.item.starts_with ("-")
					loop class_name_list.extend (l_args.item); l_args.forth
					end
				end
			end
		end

feature {NONE} -- Options

	class_name_list: LINKED_LIST [STRING]

feature -- Execution (declared in EWB_CMD)

	execute
		local
			l_code_analyzer: CA_CODE_ANALYZER
			l_rule_name, l_rule_id, l_line, l_col: STRING
		do
			create l_code_analyzer.make

			if class_name_list.is_empty then
				l_code_analyzer.add_whole_system
			else
				across class_name_list as l_cn loop
					try_add_class_with_name (l_code_analyzer, l_cn.item)
				end
			end

			l_code_analyzer.analyze

			print ("%NEiffel Code Analysis%N")
			print ("--------------------%N")

			across l_code_analyzer.rule_violations as l_vlist loop

				if not l_vlist.item.is_empty then
					print (ca_messages.cmd_class + l_vlist.key.name + "':%N")

					across l_vlist.item as l_v loop
						l_rule_name := l_v.item.rule.title
						l_rule_id := l_v.item.rule.id
						if attached l_v.item.location as l_loc then
							l_line := l_v.item.location.line.out
							l_col := l_v.item.location.column.out

							print ("  (" + l_line + ":" + l_col + "): "
								+ l_rule_name + " (" + l_rule_id + "): ")
						else -- No location attached. Print without location.
							print ("  "	+ l_rule_name + " (" + l_rule_id + "): ")
						end
						l_v.item.format_violation_description (output_window)
						print ("%N")
					end
				end
			end
		end

	try_add_class_with_name (a_analyzer: CA_CODE_ANALYZER; a_class_name: STRING)
		do
			if attached universe.compiled_classes_with_name (a_class_name) as l_c then
				across l_c as l_classes loop
					a_analyzer.add_class (l_classes.item)
				end
			else
				print (ca_messages.cmd_class_not_found_1 + a_class_name + ca_messages.cmd_class_not_found_2)
			end
		end

feature -- Info (declared in EWB_CMD)

	name: STRING = "Code Analysis"

	help_message: STRING_GENERAL
		do
			Result := ca_messages.cmd_help_message
		end

	abbreviation: CHARACTER = 'a'

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
