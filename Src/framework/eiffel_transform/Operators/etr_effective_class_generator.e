note
	description: "Replaces all deferred features by empty implementations"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_EFFECTIVE_CLASS_GENERATOR
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_PARSERS

feature -- Operations
	transformation_result: ETR_TRANSFORMABLE
			-- Result of last transformation

	generate_effective_class(a_class: ETR_TRANSFORMABLE)
			-- Creates an effective class from `a_class'
		local
			l_ft: FEATURE_TABLE
			l_cur_feat: FEATURE_I
			l_written_class: CLASS_C
			l_new_features: LINKED_LIST[FEATURE_I]
			l_visitor: ETR_ECG_VISITOR
			l_output: ETR_AST_STRING_OUTPUT
		do
			fixme("Use interface of class context! (add)")
			l_written_class := a_class.context.class_context.written_class
			l_ft := l_written_class.feature_table

			create l_new_features.make

			from
				l_ft.start
			until
				l_ft.after
			loop
				l_cur_feat :=  l_ft.item_for_iteration

				if l_cur_feat.is_deferred then
					if l_cur_feat.written_class /= l_written_class then
						l_new_features.extend (l_cur_feat)
						-- feature is written in an ancestor
						--  -> add feature when printing
					end
				end

				l_ft.forth
			end

			create l_output.make
			create l_visitor.make (l_output, l_new_features)
			l_visitor.print_ast_to_output(a_class.target_node)
			parsing_helper.reparse_printed_ast (a_class.target_node, l_output.string_representation)

			create transformation_result.make_from_ast (parsing_helper.reparsed_root, a_class.context, false)
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
