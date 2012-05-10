note
	description: "A binary operator in a textual BON expression."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_BINARY_OPERATOR

inherit
	TBON_OPERATOR
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (a_text_formatter_decorator: like text_formatter_decorator)
			-- Create a binary operator.
		do
			text_formatter_decorator := a_text_formatter_decorator
			is_binary_operator := True
			internal_value := Void
		end

feature -- Access
	item: STRING
			-- Which operator does this binary operator currently represent?
		require
			operator_set: is_set
				-- An operator must be set.
		do
			Result := internal_value
		ensure
			Result_not_void: Result /= Void
		end

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		require else
			operator_set: is_set
				-- An operator must be set.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_symbol_text (item)
		end

feature -- Element change
--	Operators: +, -, *, /, <, >, <=, >=, =, /=, //, \\, ^, or, xor, and, ->, <->, member_of, :

	set_as_and
			-- Set binary operator to be a logical and operator.
		do
			internal_value := bti_or_keyword
		ensure
			is_or: item.is_equal (bti_or_keyword)
		end

	set_as_colon
			-- Set binary operator to be a colon operator.
		do
			internal_value := bti_colon_operator
		ensure
			is_colon: item.is_equal (bti_colon_operator)
		end

	set_as_division
			-- Set binary operator to be a division operator.
		do
			internal_value := bti_division_operator
		ensure
			is_division: item.is_equal (bti_division_operator)
		end

	set_as_equals
			-- Set binary operator to be a equals operator.
		do
			internal_value := bti_equals_operator
		ensure
			is_equals: item.is_equal (bti_equals_operator)
		end

	set_as_greater_than
			-- Set binary operator to be a greater-than operator.
		do
			internal_value := bti_greater_than_operator
		ensure
			is_greater_than: item.is_equal (bti_greater_than_operator)
		end

	set_as_greater_than_equals
			-- Set binary operator to be a greater-than-equals operator.
		do
			internal_value := bti_greater_than_equals_operator
		ensure
			is_greater_than_equals: item.is_equal (bti_greater_than_equals_operator)
		end

	set_as_implication
			-- Set binary operator to be an implication operator.
		do
			internal_value := bti_implication_operator
		ensure
			is_implication: item.is_equal (bti_implication_operator)
		end

	set_as_integer_division
			-- Set binary operator to be an integer division operator.
		do
			internal_value := bti_integer_division_operator
		ensure
			is_integer_division: item.is_equal (bti_integer_division_operator)
		end

	set_as_less_than
			-- Set binary operator to be a less-than operator.
		do
			internal_value := bti_less_than_operator
		ensure
			is_less_than: item.is_equal (bti_less_than_operator)
		end

	set_as_less_than_equals
			-- Set binary operator to be a less-than-equals operator.
		do
			internal_value := bti_less_than_equals_operator
		ensure
			is_less_than_equals: item.is_equal (bti_less_than_equals_operator)
		end

	set_as_logical_equivalence
			-- Set binary operator to be a logical equivalence operator.
		do
			internal_value := bti_logical_equivalence_operator
		ensure
			is_logical_equivalence: item.is_equal (bti_logical_equivalence_operator)
		end

	set_as_member_of
			-- Set binary operator to be a set membership operator.
		do
			internal_value := bti_member_of_keyword
		ensure
			is_member_of: item.is_equal (bti_member_of_keyword)
		end

	set_as_minus
			-- Set binary operator to be a minus.
		do
			internal_value := bti_minus_operator
		ensure
			is_minus: item.is_equal (bti_minus_operator)
		end

	set_as_modulo
			-- Set binary operator to be a modulo operator.
		do
			internal_value := bti_modulo_operator
		ensure
			is_modulo: item.is_equal (bti_modulo_operator)
		end

	set_as_multiplication
			-- Set binary operator to be a multiplication operator.
		do
			internal_value := bti_multiplication_operator
		ensure
			is_multiplication: item.is_equal (bti_multiplication_operator)
		end

	set_as_not_equals
			-- Set binary operator to be a not equals operator.
		do
			internal_value := bti_not_equals_operator
		ensure
			is_not_equals: item.is_equal (bti_not_equals_operator)
		end

	set_as_or
			-- Set binary operator to be a logical or operator.
		do
			internal_value := bti_or_keyword
		ensure
			is_or: item.is_equal (bti_or_keyword)
		end

	set_as_plus
			-- Set binary operator to be a plus.
		do
			internal_value := bti_plus_operator
		ensure
			is_plus: item.is_equal (bti_plus_operator)
		end

	set_as_power
			-- Set binary operator to be a power operator.
		do
			internal_value := bti_power_operator
		ensure
			is_power: item.is_equal (bti_power_operator)
		end

	set_as_xor
			-- Set binary operator to be a logical or operator.
		do
			internal_value := bti_xor_keyword
		ensure
			is_xor: item.is_equal (bti_xor_keyword)
		end

feature -- Status report
	is_set: BOOLEAN
			-- Is the binary operator set to represent a specific operator?
		do
			Result := internal_value /= Void
		end


feature {NONE} -- Implementation
	internal_value: STRING
			-- What is the internal value of this binary operator?

invariant
	is_binary: is_binary_operator
			-- This operator will always be a binary operator.

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
