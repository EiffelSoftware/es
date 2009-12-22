note
	description: "Shared components of EiffelTransform"
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

feature -- Constants

	path_initializer: ETR_AST_PATH_INITIALIZER
			-- shared instance of ETR_AST_PATH_INITIALIZER
		once
			create Result
		end

	ast_locator: ETR_AST_LOCATOR
			-- shared instance of ETR_AST_LOCATOR
		once
			create Result
		end

	basic_operators: ETR_BASIC_OPS
			-- shared instance of ETR_BASIC_OPS
		once
			create Result
		end

	syntax_version: NATURAL_8
			-- syntax version used
		once
			Result := {CONF_OPTION}.syntax_index_transitional
		end

feature -- Access

	duplicated_ast: detachable AST_EIFFEL
			-- Result of `duplicate_ast'

	ast_parent(a_path: AST_PATH; a_root: AST_EIFFEL): detachable AST_EIFFEL
			-- finds a parent from `a_path' and root `a_root'
		require
			non_void: a_path /= void and a_root /= void
			path_non_void: a_root.path /= void
			path_valid: a_path.is_valid and a_root.path.is_valid
			not_root: a_path.as_array.count>1
		local
			l_parent_path: AST_PATH
			l_parent_string: STRING
			i: INTEGER
		do
			-- construct path of parent
			from
				i := a_path.as_array.lower
				create l_parent_string.make_empty
			until
				i > a_path.as_array.upper-1
			loop
				if i /= a_path.as_array.upper-1 then
					l_parent_string := l_parent_string + a_path.as_array[i].out + {AST_PATH}.separator.out
				else
					l_parent_string := l_parent_string + a_path.as_array[i].out
				end
				i := i+1
			end

			-- find the parent
			create l_parent_path.make_from_string (a_root, l_parent_string)
			ast_locator.find_from_root (l_parent_path)
			Result := ast_locator.found_node
		end

	find_node(a_path: AST_PATH; a_root: AST_EIFFEL): detachable AST_EIFFEL
			-- finds a node from `a_path' and root `a_root'
		require
			non_void: a_path /= void and a_root /= void
			path_non_void: a_root.path /= void
			path_valid: a_path.is_valid and a_root.path.is_valid
		do
			ast_locator.find_with_root (a_path, a_root)

			Result := ast_locator.found_node
		end

feature -- Parser

	etr_class_parser: EIFFEL_PARSER
			-- internal parser used to handle classes
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_syntax_version ({CONF_OPTION}.syntax_index_transitional)
		end

	etr_expr_parser: EIFFEL_PARSER
			-- internal parser used to handle expressions
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_expression_parser
			Result.set_syntax_version(syntax_version)
		end

	etr_instr_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_feature_parser
			Result.set_syntax_version(syntax_version)
		end

feature -- New

	new_invalid_transformable: ETR_TRANSFORMABLE is
			-- create an invalid transformable
		do
			create Result.make_invalid
		end

	new_instr(an_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new instruction from `an_instr' with context `a_context'
		require
			instr_attached: an_instr /= void
			context_attached: a_context /= void
		do
			etr_instr_parser.parse_from_string ("feature new_instr_dummy_feature do "+an_instr+" end",void)

			if attached etr_instr_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
				create Result.make_from_ast (body.compound.first, a_context, false)
			else
				create Result.make_invalid
			end
		end

	new_expr(an_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new exression from `an_expr' with context `a_context'
		require
			expr_attached: an_expr /= void
			context_attached: a_context /= void
		do
			etr_expr_parser.parse_from_string("check "+an_expr,void)

			if attached etr_expr_parser.expression_node then
				create Result.make_from_ast (etr_expr_parser.expression_node, a_context, false)
			else
				create Result.make_invalid
			end
		end

feature -- Operations

	index_ast_from_root(an_ast: AST_EIFFEL)
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

	duplicate_ast(an_ast: AST_EIFFEL)
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

	single_instr_list(instr: INSTRUCTION_AS): EIFFEL_LIST [like instr]
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
