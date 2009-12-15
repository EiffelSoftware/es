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
			-- inserts into ast nodes & replaces
		do
			create Result
		end

	path_initializer: ETR_AST_PATH_INITIALIZER is
			-- initalizes path information
		once
			create Result
		end

	ast_locator: ETR_AST_LOCATOR is
			-- locates a node given a path
		once
			create Result
		end

feature -- Access

	ast_parent(an_ast: AST_EIFFEL): AST_EIFFEL is
			-- gets the parent of an_ast using paths
		require
			ast_attached: an_ast /= void
		local
			parent_path: AST_PATH
		do
			create parent_path.make_from_child (an_ast, 1)

			Result := find_node (parent_path)
		end

	find_node(a_path: AST_PATH): AST_EIFFEL is
			-- finds a node from a path
		require
			non_void: a_path /= void
			valid: a_path.is_valid
			root_set: a_path.root /= void
		do
			ast_locator.find_from_root (a_path)

			Result := ast_locator.found_node
		end

	index_ast_from_root(an_ast: AST_EIFFEL) is
			-- indexes and ast with path information
			-- using an_ast as root
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from_root(an_ast)
		end

	reindex_ast(an_ast: AST_EIFFEL) is
			-- indexes and ast with path information
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from(an_ast)
		end


	duplicated_ast: detachable AST_EIFFEL
			-- Result of duplicate_ast

	basic_operators: ETR_BASIC_OPS is
			-- basic mutation operators
		once
			create Result
		end

	new_instr(an_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE is
			-- parse an instruction in the context of a compiled class
		do
			entity_feature_parser.parse_from_string ("feature parse_instr_dummy_feature is do "+an_instr+" end",void)
			if attached {DO_AS}entity_feature_parser.feature_node.body.as_routine.routine_body as body then
				index_ast_from_root (body.compound.first)
				create Result.make_with_node (body.compound.first, a_context)
			end
		end

	new_expr(an_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE is
			-- parse an expression in the context of a compiled class
		do
			expression_parser.parse_from_string("check "+an_expr,void)
			index_ast_from_root (expression_parser.expression_node)
			create Result.make_with_node (expression_parser.expression_node, a_context)
		end

	conforms_to_context(an_ast: AST_EIFFEL; a_context: ETR_CONTEXT):BOOLEAN is
			-- check if an_ast is valid in a_context
		require
			non_void: an_ast /= void and a_context /= void
		local
			visitor: ETR_CONTEXT_VISITOR
		do
			create visitor.make_with_context (a_context)
			visitor.set_checking_only (true)
			an_ast.process (visitor)
			Result := visitor.is_conforming
		end

feature {NONE} -- Internal

	compiled_class(a_class_node: CLASS_AS; a_context: ETR_CONTEXT):CLASS_C is
			-- get compiled class of a_class_node by id
			-- has to conform to context
		require
			conforming: conforms_to_context(a_class_node, a_context)
		do
			Result := a_context.system.class_of_id (a_class_node.class_id)
		ensure
			Result /= void
		end

feature -- Operations

	duplicate_ast(an_ast: AST_EIFFEL) is
			-- duplicate an_ast
			-- result in duplicated_ast
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

	replace_class_in_context(a_class: CLASS_AS; a_context: ETR_CONTEXT) is
			-- replace ast of a class in context (by id)
		require
			conforming: conforms_to_context(a_class, a_context)
		do
			a_context.system.ast_server.remove (a_class.class_id)
			a_context.system.ast_server.put (a_class)
		end

	-- not sure if this belongs in here/in the library
	mark_for_reparse(a_class: CLASS_AS; a_context: ETR_CONTEXT) is
			-- mark class as not parsed
			-- will be done next melt
		local
			l_compiled_class: CLASS_C
		do
			l_compiled_class := compiled_class(a_class, a_context)

			l_compiled_class.set_changed (true)
			a_context.degree_5.insert_new_class (l_compiled_class)
			a_context.degree_4.insert_class (l_compiled_class)
			a_context.degree_3.insert_class (l_compiled_class)
			a_context.degree_2.insert_class (l_compiled_class)
			a_context.degree_1.insert_class (l_compiled_class)
		end

	-- not sure if this belongs in here/in the library
	mark_ast_changed(a_class: CLASS_AS; a_context: ETR_CONTEXT) is
			-- mark ast as changed (degrees <=4)
		local
			l_compiled_class: CLASS_C
		do
			l_compiled_class := compiled_class(a_class, a_context)

			l_compiled_class.set_changed (true)
			a_context.degree_4.insert_class (l_compiled_class)
			a_context.degree_3.insert_class (l_compiled_class)
			a_context.degree_2.insert_class (l_compiled_class)
			a_context.degree_1.insert_class (l_compiled_class)
		end

	-- not sure if this belongs in here/in the library	
	restore_ast(a_class: CLASS_AS; a_context: ETR_CONTEXT) is
			-- restore original ast
			-- i.e. reparse
			-- todo: make this not require the whole melting process
		do
			mark_for_reparse(a_class, a_context)
			a_context.system.eiffel_project.quick_melt
		end

	adjust_for_context(an_ast: AST_EIFFEL; a_context: ETR_CONTEXT) is
			-- make sure an_ast is valid in a_context
		require
			none_void: an_ast /= void and a_context /= void
		local
			visitor: ETR_CONTEXT_VISITOR
		do
			create visitor.make_with_context (a_context)
			an_ast.process (visitor)

			check
				visitor.is_conforming
			end
			to_implement("Proper error handlin")
		end

	single_instr_list(instr: INSTRUCTION_AS): EIFFEL_LIST [INSTRUCTION_AS] is
			-- create list with a single instruction
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
