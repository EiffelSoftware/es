note
	description: "Prints an ast while replacing assigment attempts with object tests"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ASS_ATTMPT_REPL_VISITOR
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_reverse_as,
			process_feature_as
		end
	ETR_SHARED
	REFACTORING_HELPER
		export
			{NONE} all
		end
create
	make

feature {NONE} -- Implementation

	type_checker: ETR_TYPE_CHECKER

	class_context: ETR_CLASS_CONTEXT

	current_feature: STRING

feature {NONE} -- Creation

	make(an_output: like output; a_class_context: like class_context)
		do
			make_with_output(an_output)

			class_context := a_class_context

			create type_checker
		end

feature {AST_EIFFEL} -- Roundtrip

	process_feature_as (l_as: FEATURE_AS)
		do
			current_feature := l_as.feature_name.name
			process_child_list(l_as.feature_names, ", ", l_as, 1)
			process_child(l_as.body, l_as, 2)
		end

	process_reverse_as (l_as: REVERSE_AS)
		local
			l_feat_context: ETR_FEATURE_CONTEXT
			l_target_type: TYPE_A
			l_printed_type: STRING
			l_target_string: STRING
			l_source_string: STRING
		do
			l_feat_context := class_context.written_in_features_by_name[current_feature]

			if attached l_feat_context then
				type_checker.check_ast_type (l_as.target, l_feat_context)
				l_target_type := type_checker.last_type
				l_printed_type := print_type(l_target_type,class_context.written_in_features_by_name[current_feature])

				-- print object-test version
				l_target_string := ast_to_string (l_as.target)
				l_source_string := ast_to_string (l_as.source)

				output.append_string("if attached {"+l_printed_type+"}"+l_target_string+" as "+"l_etr_ot_local then%N")
				output.enter_block
				output.append_string (l_target_string+" := l_etr_ot_local%N")
				output.exit_block
				output.append_string ("else%N")
				output.enter_block
				output.append_string (l_target_string+" := void%N")
				output.exit_block
				output.append_string ("end%N")
			else
				fixme("Print error")

				process_child (l_as.target, l_as, 1)
				output.append_string(" ?= ")
				process_child (l_as.source, l_as, 2)
				output.append_string("%N")
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
