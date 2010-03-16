note
	description: "Rewriting: Replaces assigment attempts with object tests."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ASS_ATTMPT_REPL_VISITOR
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_reverse_as,
			process_feature_as
		end
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_BASIC_OPERATORS
	ETR_SHARED_ERROR_HANDLER
create
	make

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]
			-- Modifications computed	

feature -- Operation

	replace_assignment_attempts_in (a_ast: AST_EIFFEL)
			-- Init fields and process `a_ast'
		require
			non_void: a_ast /= void
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			id_counter := 1
			a_ast.process (Current)
		end

feature {NONE} -- Creation

	make (a_class_context: like class_context)
			-- Make with `a_class_context'
		do
			class_context := a_class_context
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
		end

feature {NONE} -- Implementation

	class_context: ETR_CLASS_CONTEXT
			-- Class context we're working in

	current_feature: STRING
			-- Name of current feature

	id_counter: INTEGER
			-- Unique id of last object-test local

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
			l_cur_slot: INTEGER
			l_current_mapping: HASH_TABLE[INTEGER,INTEGER]
			l_mod: ETR_TRACKABLE_MODIFICATION
			l_ot_local_name: STRING
		do
			l_feat_context := class_context.written_in_features_by_name[current_feature]

			if l_feat_context /= Void then
				type_checker.check_ast_type (l_as.target, l_feat_context)
				l_target_type := type_checker.last_type
				l_printed_type := type_checker.print_type(l_target_type, l_feat_context)

				-- print object-test version
				l_target_string := ast_tools.ast_to_string (l_as.target)
				l_source_string := ast_tools.ast_to_string (l_as.source)

				create l_replacement.make_empty
				create l_current_mapping.make (5)
				l_cur_slot := l_as.breakpoint_slot
				l_current_mapping.extend (l_cur_slot, l_cur_slot)
				l_current_mapping.extend (l_cur_slot, l_cur_slot+1)
				l_current_mapping.extend (l_cur_slot, l_cur_slot+2)

				l_ot_local_name := "lot_" + id_counter.out
				id_counter := id_counter + 1

				l_replacement.append_string("if attached {"+l_printed_type+"}"+l_source_string+" as "+l_ot_local_name+" then%N")
				l_replacement.append_string (l_target_string+" := "+l_ot_local_name+"%N")

				-- This is to be inline with the semantics of assignment attempts
				if not l_target_type.is_expanded then
					l_replacement.append_string ("else%N")
					l_replacement.append_string (l_target_string+" := void%N")
				end

				l_replacement.append_string ("end%N")

				create l_mod.make_replace (l_as.path, l_replacement)
				l_mod.initialize_tracking_info (l_current_mapping, l_cur_slot, 1, 3)
				modifications.extend (l_mod)
			else
				error_handler.add_error (Current, "process_reverse_as", "Context of feature "+current_feature+" not found.")
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
