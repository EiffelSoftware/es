note
	description: "Error handling for EiffelTransform classes"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ERROR_HANDLER

feature -- Output
	has_errors: BOOLEAN
	last_error: detachable STRING
	errors: detachable LIST[attached like last_error]

feature {NONE} -- Implementation

	reset_errors
			-- set `has_errors' to false
		do
			if attached errors then
				errors.wipe_out
			end

			has_errors := false
		end

	add_errors(a_list: attached like errors)
			-- add errors
		do
			if not attached errors then
				create {LINKED_LIST[attached like last_error]}errors.make
			end

			from
				a_list.start
			until
				a_list.after
			loop
				errors.extend (a_list.item)
				a_list.forth
			end

			if not a_list.is_empty then
				last_error := a_list.last
				has_errors := true
			end
		end

	add_error(an_error_message: attached like last_error)
			-- set `last_error' to `an_error_message'
		do
			if not attached errors then
				create {LINKED_LIST[like last_error]}errors.make
			end

			has_errors := true
			last_error := an_error_message
			errors.extend (last_error)
		end
note
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
