note
	description: "Prints an ast while replacing assigment attempts with object tests"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ASS_ATTMPT_REPL_VISITOR
inherit
	AST_ITERATOR
		redefine
			process_reverse_as,
			process_feature_as
		end
	ETR_SHARED
create
	make

feature {NONE} -- Implementation

	type_checker: ETR_TYPE_CHECKER

	class_context: ETR_CLASS_CONTEXT

	current_feature: STRING

feature {NONE} -- Creation

	make(a_class_context: like class_context)
		do
			class_context := a_class_context
			create type_checker
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
		end

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]

feature {AST_EIFFEL} -- Roundtrip

	process_feature_as (l_as: FEATURE_AS)
		do
			current_feature := l_as.feature_name.name
			l_as.body.process (Current)
		end

	process_reverse_as (l_as: REVERSE_AS)
		local
			l_feat_context: ETR_FEATURE_CONTEXT
			l_target_type: TYPE_A
			l_printed_type: STRING
			l_target_string: STRING
			l_source_string: STRING
			l_replacement: STRING
			l_mod: ETR_AST_MODIFICATION
		do
			l_feat_context := class_context.written_in_features_by_name[current_feature]

			if attached l_feat_context then
				type_checker.check_ast_type (l_as.target, l_feat_context)
				l_target_type := type_checker.last_type
				l_printed_type := print_type(l_target_type,class_context.written_in_features_by_name[current_feature])

				-- print object-test version
				l_target_string := ast_to_string (l_as.target)
				l_source_string := ast_to_string (l_as.source)

				create l_replacement.make_empty

				l_replacement.append_string("if attached {"+l_printed_type+"}"+l_target_string+" as "+"l_etr_ot_local then%N")
				l_replacement.append_string (l_target_string+" := l_etr_ot_local%N")
				l_replacement.append_string ("else%N")
				l_replacement.append_string (l_target_string+" := void%N")
				l_replacement.append_string ("end%N")

				modifications.extend (basic_operators.replace_with_string (l_as.path, l_replacement))
			else
				fixme("Print error")
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
