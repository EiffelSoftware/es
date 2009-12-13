note
	description: "[
			Boolean expressions from code, candidates for predicates used in AutoTest.
			For example, these expressions can come from contracts or from conditions in
			control flow graph of features.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_EXPRESSION

inherit
	SHARED_WORKBENCH

	SHARED_SERVER

	REFACTORING_HELPER

	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_expr: like ast; a_written_class: like written_class; a_context_class: like context_class) is
			-- Set `ast' with `a_expr' and `written_class' with `a_written_class'.
		do
			set_expression (a_expr)
			set_written_class (a_written_class)
			set_context_class (a_context_class)
		end

feature -- Access

	ast: EXPR_AS
			-- AST node for the predicate expression

	name: STRING is
			-- Name of the predicate
			-- If current assertion is from contract, this
			-- can be the tag of that contract.
		do
			if name_internal = Void then
				Result := ""
			else
				Result := name_internal
			end
		end

	written_class: CLASS_C
			-- Class where `ast' is written

	context_class: CLASS_C
			-- Class where `ast' is viewed

	text: STRING is
			-- Text of `ast' as writtend in the source file
		do
			Result := ast.text (match_list_server.item (written_class.class_id))
		end

	tag: detachable STRING
			-- Tag for current expression

feature -- Status report

	is_require_else: BOOLEAN
			-- Is current expression from a require else clause?

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Access/Internal

	line_number: INTEGER is
			-- Line number of the assertion
		do
			Result := ast.first_token (match_list_server.item (written_class.class_id)).line
		end

	index: INTEGER
			-- Index number indicating the order when current assertion appears
			-- A small number means that the assertion appear earlier.
			-- Note: intended for internal use

feature -- Setting

	set_expression (a_tag: like ast) is
			-- Set `ast' with `a_tag'.
		require
			a_tag_attached: a_tag /= Void
		do
			ast := a_tag
		ensure
			tag_set: ast = a_tag
		end

	set_written_class (a_written_class: like written_class) is
			-- Set `written_class' with `a_written_class'.
		require
			a_written_class_attached: a_written_class /= Void
		do
			written_class := a_written_class
		ensure
			written_class_set: written_class = a_written_class
		end

	set_context_class (a_context_class: like context_class) is
			-- Set `context_class' with `a_context_class'.
		require
			a_context_class_attached: a_context_class /= Void
		do
			context_class := a_context_class
		ensure
			context_class_set: context_class = a_context_class
		end

	set_index (a_index: INTEGER) is
			-- Set `index' with `a_index'.
		do
			index := a_index
		ensure
			index_set: index = a_index
		end

	set_name (a_name: like name) is
			-- Set `name' with `a_name'.
			-- Copy content of `a_name' into `name'.
		do
			name_internal := a_name.twin
		ensure
			name_set: name ~ a_name
		end

	set_is_require_else (b: BOOLEAN) is
			-- Set `is_require_else' with `b'.
		do
			is_require_else := b
		ensure
			is_require_else_set: is_require_else = b
		end

	set_tag (a_tag: like tag)
			-- Set `tag' with `a_tag'.
			-- Make a new copy from `a_tag'.
		do
			if a_tag = Void then
				tag := Void
			else
				tag := a_tag.twin
			end
		end

feature{NONE} -- Implementation

	name_internal: detachable like name
			-- Implementation of `name'

;note
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
