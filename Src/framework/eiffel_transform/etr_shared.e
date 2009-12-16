note
	description: "Summary description for {ETR_SHARED_HELPERS}."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_SHARED
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	SHARED_EIFFEL_PARSER
		export
			{NONE} all
		end

feature -- Constants

	ast_modifier: ETR_AST_MODIFIER is
			-- shared instance of ETR_AST_MODIFIER
		do
			create Result
		end

	path_initializer: ETR_AST_PATH_INITIALIZER is
			-- shared instance of ETR_AST_PATH_INITIALIZER
		once
			create Result
		end

	ast_locator: ETR_AST_LOCATOR is
			-- shared instance of ETR_AST_LOCATOR
		once
			create Result
		end

	basic_operators: ETR_BASIC_OPS is
			-- shared instance of ETR_BASIC_OPS
		once
			create Result
		end

feature -- Access

	duplicated_ast: detachable AST_EIFFEL
			-- Result of `duplicate_ast'

	ast_parent(an_ast: AST_EIFFEL): detachable AST_EIFFEL is
			-- gets the parent of `an_ast' using paths
		require
			ast_attached: an_ast /= void
		local
			parent_path: AST_PATH
		do
			create parent_path.make_from_child (an_ast, 1)

			Result := find_node (parent_path)
		end

	find_node(a_path: AST_PATH): detachable AST_EIFFEL is
			-- finds a node from `a_path'
		require
			non_void: a_path /= void
			valid: a_path.is_valid
			root_set: a_path.root /= void
		do
			ast_locator.find_from_root (a_path)

			Result := ast_locator.found_node
		end

feature -- New

	new_invalid_transformable: ETR_TRANSFORMABLE is
			-- create an invalid transformable
		do
			create Result.make_invalid
		end

	new_instr(an_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE is
			-- create a new instruction from `an_instr' with context `a_context'
		do
			entity_feature_parser.parse_from_string ("feature new_instr_dummy_feature is do "+an_instr+" end",void)
			if attached {DO_AS}entity_feature_parser.feature_node.body.as_routine.routine_body as body then
				index_ast_from_root (body.compound.first)
				create Result.make_from_node (body.compound.first, a_context)
			end
		end

	new_expr(an_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE is
			-- create a new exression from `an_expr' with context `a_context'
		do
			expression_parser.parse_from_string("check "+an_expr,void)
			index_ast_from_root (expression_parser.expression_node)
			create Result.make_from_node (expression_parser.expression_node, a_context)
		end

feature -- Operations

	index_ast_from_root(an_ast: AST_EIFFEL) is
			-- indexes and ast with root `an_ast'
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from_root(an_ast)
		end

	reindex_ast(an_ast: AST_EIFFEL) is
			-- reindexes `an_ast'
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from(an_ast)
		end

	duplicate_ast(an_ast: AST_EIFFEL) is
			-- duplicates `an_ast' and stores the result in `duplicated_ast'
		require
			non_void: an_ast /= void
		do
			-- is cloning the way to go?
			-- alternative would be:
			-- print + reparse (are some ids lost? adjust for context again?)
			-- 		needs facility to print ast without matchlist
			-- recreating from scratch
			--		very dependant on ast structure

			duplicated_ast := an_ast.deep_twin
		end

	single_instr_list(instr: INSTRUCTION_AS): EIFFEL_LIST [like instr] is
			-- creates list with a single instruction `instr'
		require
			instr_not_void: instr/=void
		do
			create Result.make (1)
			Result.extend (instr)
		ensure
			one: Result.count = 1
		end
note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
