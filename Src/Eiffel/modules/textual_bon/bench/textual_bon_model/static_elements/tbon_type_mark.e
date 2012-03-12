note
	description: "A type mark for a static client relation."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_TYPE_MARK

inherit
	TEXTUAL_BON_ELEMENT
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element
			-- Create a type mark.
		do
			internal_value := Void
		end

feature -- Access
	item: STRING
			-- Which kind of type mark is this type mark?
		require
			type_mark_set: is_set
				-- A type mark must be set.
		do
			Result := internal_value
		ensure
			Result_not_void: Result /= Void
		end

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		require else
			type_mark_set: is_set
				-- A type mark must be set.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_symbol_text (item)
		end

feature -- Element change
	set_as_aggregation
			-- Set type mark to be an aggregation.
		do
			internal_value := bti_aggregation_mark
		ensure
			is_aggregation: item.is_equal (bti_aggregation_mark)
		end

	set_as_association
			-- Set type mark to be an association.
		do
			internal_value := bti_colon_operator
		ensure
			is_association: item.is_equal (bti_colon_operator)
		end

	set_as_shared_association (multiplicity: INTEGER)
			-- Set type mark to be a shared association with the given multiplicity.
		local
			l_mark: STRING
		do
			l_mark := bti_colon_operator
			l_mark.append (ti_l_parenthesis)
			l_mark.append_integer (multiplicity)
			l_mark.append (ti_r_parenthesis)
			internal_value := l_mark
		end

feature -- Status report
	is_set: BOOLEAN
			-- Is the type mark set?
		do
			Result := internal_value /= Void
		end

feature {NONE} -- Implementation
	internal_value: STRING
			-- What is the internal value of this type mark?

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
