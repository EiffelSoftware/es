note
	description: "Formatter decorator for textual BON views. Works as a mediator between formatter and output strategy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class -- This class is not used for the time being.
	TEXTUAL_BON_TEXT_FORMATTER_DECORATOR

inherit
	TEXT_FORMATTER_DECORATOR
		rename
			is_informal_bon as format_is_informal_bon,
			is_formal_bon as format_is_formal_bon,
			set_is_informal_bon as format_set_is_informal_bon,
			set_is_formal_bon as format_set_is_formal_bon
		end

feature -- Status report
	is_informal_bon: BOOLEAN
			-- Are we currently formatting informal BON?

	is_formal_bon: BOOLEAN
			-- Are we currently formatting formal BON?

feature -- Status setting
--	set_for_informal_bon
--			-- Prepare formatter decorator for informal BON.
--		do
--			set_is_informal_bon
--			create {TEXTUAL_BON_INFORMAL_OUTPUT_STRATEGY} ast_output_strategy.make (Current)
--			setup_output_strategy
--		end

--	set_for_formal_bon
--			-- Prepare formatter decorator for formal BON.
--		do
--			set_is_formal_bon
--			create {TEXTUAL_BON_FORMAL_OUTPUT_STRATEGY} ast_output_strategy.make (Current)
--			setup_output_strategy
--		end


	set_is_informal_bon
			-- Set is_informal_bon to True.
		do
			is_informal_bon := True
			is_formal_bon := False
		ensure
			is_informal_bon: is_informal_bon
			not_formal_bon: not is_formal_bon
		end

	set_is_formal_bon
			-- Set is_formal_bon to True.
		do
			is_formal_bon := True
			is_informal_bon := False
		ensure
			is_formal_bon: is_formal_bon
			not_informal_bon: not is_informal_bon
		end

invariant
	not_informal_and_formal_bon: is_informal_bon implies not is_formal_bon

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
