note
	description: "Summary description for {ETR_SHARED_HELPERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_SHARED_HELPERS
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	SHARED_EIFFEL_PARSER
		export
			{NONE} all
		end

feature -- Access



	new_instr(an_instr: STRING; class_context: ABSTRACT_CLASS_C): INSTRUCTION_AS is
			-- parse an instruction in the context of a compiled class
			-- todo: make this use ETR_CONTEXT
		local
			body: DO_AS
		do
			entity_feature_parser.parse_from_string ("feature parse_instr_dummy_feature is do "+an_instr+" end",void)
			body ?= entity_feature_parser.feature_node.body.as_routine.routine_body
			Result := body.compound.first
		end

	new_expr(an_expr: STRING; class_context: ABSTRACT_CLASS_C): EXPR_AS is
			-- parse an expression in the context of a compiled class
			-- todo: make this use ETR_CONTEXT
		do
			expression_parser.parse_from_string("check "+an_expr,void)
			Result := expression_parser.expression_node
		end

	end_keyword: KEYWORD_AS is
			-- simple end keyword with no location or text information
		once
			create Result.make_null
			Result.set_code ({EIFFEL_TOKENS}.te_end)
		ensure
			Result.is_end_keyword
		end

feature {NONE} -- Internal

	compiled_class(a_class_node: CLASS_AS; a_context: ETR_CONTEXT):CLASS_C is
			-- get compiled class of a_class_node by id
			-- has to conform to context
--		require
--			class conforms to context
		do
			Result := a_context.system.class_of_id (a_class_node.class_id)
		ensure
			Result /= void
		end


feature -- Operations

	replace_class_in_context(a_class: CLASS_AS; a_context: ETR_CONTEXT) is
			-- replace ast of a class in context
--		require
--			class conforms to context
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

			to_implement("Error reporting")
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
