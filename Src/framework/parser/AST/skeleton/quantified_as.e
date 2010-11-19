note
	description: "[
			AST node for quantified expression
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	QUANTIFIED_AS

inherit
	EXPR_AS

feature{NONE} -- Initialization

	initialize (a_variables: like variables; a_expression: like expression)
			-- Initialize Current.
		require
			at_least_one_variable: not a_variables.is_empty
		do
			variables := a_variables
			expression := a_expression
		end

feature -- Access

	variables: EIFFEL_LIST [TYPE_DEC_AS]
			-- List of variables of Current quantification

	expression: EXPR_AS
			-- Expression of Current quantification

	first_token (a_list: LEAF_AS_LIST): LEAF_AS
			-- First token in current AST node
		do
			Result := variables.first.first_token (a_list)
		end

	last_token (a_list: LEAF_AS_LIST): LEAF_AS
			-- Last token in current AST node
			--| Note: see comment on `last_token'.
		do
			Result := expression.last_token (a_list)
		end

feature -- Status report

	is_for_all: BOOLEAN
			-- Is Current an universal quantification?
		do
		end

	is_there_exists: BOOLEAN
			-- Is Current an existential quantification?
		do
		end

	is_equivalent (other: like Current): BOOLEAN
			-- Is `other' equivalent to the current object ?
		local
			l_cursor1: CURSOR
			l_cursor2: CURSOR
		do
			Result :=
				variables.count = other.variables.count and then
				expression.same_type (other.expression) and then expression.is_equivalent (other.expression)
			if Result then
				l_cursor1 := variables.cursor
				l_cursor2 := other.variables.cursor
				from
					variables.start
					other.variables.start
				until
					variables.after or else not Result
				loop
					Result := variables.item.same_type (other.variables.item) and then variables.item.is_equivalent (other.variables.item)
					variables.forth
					other.variables.forth
				end
			end
		end

;note
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
