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

--	Operators: +, -, *, /, <, >, <=, >=, =, /=, //, \\, ^, or, xor, and, ->, <->, member_of, :
create
	make_element

feature -- Initialization
	make_element
			-- Create a binary operator.
		do
			is_binary_operator := True
			internal_value := Void
		end

feature -- Access
	item: STRING
			-- Which operator does this binary operator currently represent?
		require
			operator_set: is_set
		do
			Result := internal_value
		ensure
			Result_not_void: Result /= Void
		end

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_symbol_text (item)
		end

feature -- Status setting
	set_as_plus
			-- Set binary operator to be a plus.
		do
			internal_value := bti_plus_operator
		ensure
			is_plus: internal_value = bti_plus_operator
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


;note
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
