note
	description: "Summary description for {AUT_SMTLIB_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SMTLIB_GENERATOR

feature -- Access

	valid_object_state_proof_obligation (a_class: CLASS_C; a_state: HASH_TABLE [STRING, STRING]): STRING is
			-- Proof obligation to show if `a_state' is a valid state for `a_class'.
			-- `a_state' is in the form [query_value, argument_less_query_name].
			-- The result is a string in SMT-LIB format which can be put into a theorem prover.
		require
			a_class_attached: a_class /= Void
			a_state_attached: a_state /= Void
		do
		ensure
			result_attached: Result /= Void
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
