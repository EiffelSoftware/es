note
	description: "Summary description for {AFX_MODIFIED_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_MODIFIED_EXPRESSION

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_expr: like original_expression; a_negated: BOOLEAN)
			-- Initialize `original_expression' with `a_expr' and
			-- `is_negated' with `a_negated'.
		do
			original_expression := a_expr
			is_negated := a_negated
			if is_negated then
				text := "not (" + a_expr.text + ")"
			else
				text := a_expr.text.twin
			end
		ensure
			original_expression_set: original_expression = a_expr
			is_negated_set: is_negated = a_negated
		end

feature -- Access

	expression: AFX_EXPRESSION
			-- Expression representing current.
		do
			if is_negated then
				Result := not original_expression
			else
				Result := original_expression
			end
		end

	original_expression: AFX_EXPRESSION
			-- The original expression

	negated alias "not": like Current
			-- Negation: not Current
		do
			create Result.make (original_expression, not is_negated)
		ensure
			good_result: Current ~ not Result
		end

	text: STRING
			-- Text of current expression

feature -- Status report

	is_negated: BOOLEAN
			-- Does current expression start with
			-- a negation?			

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				is_negated = other.is_negated and then
				Current.original_expression ~ other.original_expression
		end

	has_same_context (other: like Current): BOOLEAN
			-- Does `other' have the same context as Current?
		do
			Result := original_expression.has_same_context (other.original_expression)
		end

feature{NONE} -- Setting

	set_is_negated (b: BOOLEAN)
			-- Set `is_negated' with `b'.
		do
			is_negated := b
		ensure
			is_negated_set: is_negated = b
		end

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
