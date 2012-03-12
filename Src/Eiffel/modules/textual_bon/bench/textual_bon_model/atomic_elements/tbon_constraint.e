note
	description: "A constraint for a class or feature."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TBON_CONSTRAINT

inherit
	TEXTUAL_BON_ELEMENT
	redefine
		process_to_informal_textual_bon
	end

feature -- Access
	get_assertion: like assertion
			-- What is the assertion of this constraint?
		do
			Result := assertion
		end

	get_label: like label
			-- What is the label for this constraint?
		require
			has_a_label: has_label
		do
			Result := label
		ensure
			Result_not_void: Result /= Void
		end

feature -- Processing
	process_to_informal_textual_bon
			-- Process a constraint to informal bon.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			assertion.process_to_informal_textual_bon
		end

feature {NONE} -- Status
	assertion: TBON_ASSERTION
			-- The assertion of a constraint.

	label: STRING
			-- The label of a constraint.

feature -- Status report
	has_label: BOOLEAN
			-- Does this constraint have a label?
		do
			Result := (label /= Void)
		ensure
			has_a_labl: Result implies label /= Void
		end

feature -- Status setting
	set_assertion (l_assertion: like assertion)
			-- Update the assertion of the constraint
		require
			input_not_void: l_assertion /= Void
		do
			assertion ?= l_assertion
		ensure
			l_assertion /= Void implies assertion = l_assertion
		end
		
	set_label (l_label: like label)
			-- Update the label of the constraint.
		do
			label := l_label
		end

invariant
	has_assertion: assertion /= Void

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
