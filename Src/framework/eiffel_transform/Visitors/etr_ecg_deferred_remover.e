note
	description: "Replaces deferred by do in features it prints and uses fully resolved return types"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ECG_DEFERRED_REMOVER
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_deferred_as,
			process_feature_as,
			process_body_as,
			process_routine_as
		end
	ETR_SHARED_TYPE_CHECKER
create
	make_with_output

feature {NONE} -- Implementation
	context: FEATURE_I
			-- Context of the current feature

feature -- Output
	print_modified_feature(a_feature: FEATURE_I)
			-- prints `an_ast' to `output'
		do
			context := a_feature
			process_child (a_feature.e_feature.ast, void, 0)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_routine_as (l_as: ROUTINE_AS)
		do
			-- don't print locals or contracts

			if processing_needed (l_as.obsolete_message, l_as, 1) then
				output.append_string (ti_obsolete_keyword+ti_New_line)
				process_block (l_as.obsolete_message, l_as, 1)
				output.append_string (ti_New_line)
			end

			process_child(l_as.routine_body, l_as, 4)

			output.append_string(ti_End_keyword+ti_New_line)
		end

	process_body_as (l_as: BODY_AS)
		local
			l_resolved_type: TYPE_A
		do
			-- copied from precursor but fully resolve the type

			if processing_needed (l_as.arguments, l_as, 1) then
				output.append_string (ti_space+ti_l_parenthesis)
				process_child_list(l_as.arguments, ti_semi_colon+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string (ti_colon+ti_space)
				process_child (l_as.type, l_as, 2)
			end

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string (ti_colon+ti_space)
				-- always print the fully explicit type to be sure it's valid in the new context
				l_resolved_type := type_checker.explicit_type_from_type_as (l_as.type, context.written_class, context.written_class.feature_of_feature_id (context.feature_id))

				if attached {CL_TYPE_A}l_resolved_type as l_class_type then
					output.append_string (l_class_type.associated_class.name_in_upper)
				else
					check
						not_supported: false
					end
				end

				process_child (l_as.type, l_as, 2)
			end

			if l_as.is_constant then
				output.append_string(ti_Space+ti_is_keyword+ti_Space)
			elseif processing_needed (l_as.assigner, l_as, 3) then
				output.append_string (ti_Space+ti_assign_keyword+ti_Space)
				process_child (l_as.assigner, l_as, 3)
				output.append_string(ti_New_line)
			elseif l_as.is_unique then
				output.append_string (ti_Space+ti_is_keyword+ti_Space+ti_unique_keyword)
			else
				output.append_string(ti_New_line)
			end

			if processing_needed (l_as.content, l_as, 4) then
				process_child_block(l_as.content, l_as, 4)
			end

			process_child(l_as.indexing_clause, l_as, 5)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			-- print the correct name in the current class
			output.append_string (context.feature_name)
			process_child(l_as.body, l_as, 2)
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			-- print do instead of deferred
			output.append_string (ti_do_keyword+ti_new_line)
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
