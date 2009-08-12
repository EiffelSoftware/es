note
	description: "Summary description for {AUT_CONSTANT_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_CONSTANT_POOL

inherit
	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize Current.
		do
			create integer_32_values.make (1000)
			create integer_32_variables.make (1000)
			create variable_retriever_table.make (20)
			variable_retriever_table.set_key_equality_tester (create {KL_STRING_EQUALITY_TESTER_A [STRING]})
			variable_retriever_table.force_last (agent variable_index_of_integer_32_value, "INTEGER_32")
		end

feature -- Access

	variable (a_constant: ITP_CONSTANT): detachable ITP_VARIABLE is
			-- Variable which contains the same value as `a_constant' in object pool
			-- Void if no variable in the object pool has value `a_constant'.
		do
			if attached {FUNCTION [ANY, TUPLE [ITP_CONSTANT], detachable ITP_VARIABLE]} variable_retriever_table.item (a_constant.type_name) as l_retriever then
				Result := l_retriever.item ([a_constant])
			end
		end

	value (a_variable: ITP_VARIABLE): detachable ITP_CONSTANT is
			-- Constant from `a_variable'
		local
			l_tbl: like integer_32_variables
		do
			fixme ("Support variables of other types too. 2009.8.12 Jason")
			l_tbl := integer_32_variables
			l_tbl.search (a_variable.index)
			if l_tbl.found then
				create Result.make (l_tbl.found_item)
			end
		end

feature -- Status report

	has (a_constant: ITP_CONSTANT): BOOLEAN is
			-- Does current pool contain `a_constant'?
		do
			if attached {FUNCTION [ANY, TUPLE [ITP_CONSTANT], detachable ITP_VARIABLE]} variable_retriever_table.item (a_constant.type_name) as l_retriever then
				Result := l_retriever.item ([a_constant]) /= Void
			end
		end

feature -- Basic operations

	put (a_constant: ITP_CONSTANT; a_variable: ITP_VARIABLE) is
			-- Put `a_variable' storing `a_constant' into Current pool.
		require
			a_constant_attached: a_constant /= Void
			a_variable_attached: a_variable /= Void
		do
			if attached {INTEGER_32} a_constant.value as l_integer_32 then
				integer_32_values.force_last (a_variable.index, l_integer_32)
				integer_32_variables.force_last (l_integer_32, a_variable.index)
			end
		ensure
--			variable_put: has (a_constant) and then (variable (a_constant) /= Void and then variable (a_constant).index = a_variable.index)
		end

	put_with_value_and_type (a_value: STRING; a_type: TYPE_A; a_variable: ITP_VARIABLE) is
			-- Put `a_variable' with value `a_value', whose type is `a_type' into Current pool.
		require
			a_value_attached: a_value /= Void
			a_type_attacheed: a_type /= Void
			a_variable_attached: a_variable /= Void
		local
			l_int: INTEGER
		do
			if a_type.is_integer and then a_value.is_integer then
				l_int := a_value.to_integer
				integer_32_values.force_last (a_variable.index, l_int)
				integer_32_variables.force_last (l_int, a_variable.index)
			end
		end

	wipe_out is
			-- Wipe all values.
		do
			integer_32_values.wipe_out
			integer_32_variables.wipe_out
		ensure
			integer_32_values_wiped_out: integer_32_values.is_empty
			integer_32_variables_wiped_out: integer_32_variables.is_empty
		end

feature{NONE} -- Implementation

	integer_32_values: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Tables for {INTEGER_32} variables
			-- [Variable index, integer value]

	integer_32_variables: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Tables for {INTEGER_32} variables
			-- [Integer value, variable index]

	variable_retriever_table: DS_HASH_TABLE [FUNCTION [ANY, TUPLE [ITP_CONSTANT], detachable ITP_VARIABLE], STRING]
			-- Table for constant value retrievers indexed by type names
			-- [constant variable retriever, type name]

	variable_index_of_integer_32_value (a_constant: ITP_CONSTANT): detachable ITP_VARIABLE is
			-- Variable index for {INTEGER_32} value stored in `a_constant'
			-- Void if no value is available.
		require
			a_constant_attached: a_constant /= Void
			a_constant_is_integer_32: a_constant.type_name.is_equal ("INTEGER_32")
		local
			l_value: INTEGER
			l_value_tbl: like integer_32_values
		do
			l_value ?= a_constant.value
			l_value_tbl := integer_32_values
			l_value_tbl.search (l_value)
			if l_value_tbl.found then
				create Result.make (l_value_tbl.found_item)
			end
		end

invariant
	integer_32_values_attached: integer_32_values /= Void
	variable_retriever_table_attached: variable_retriever_table /= Void

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
