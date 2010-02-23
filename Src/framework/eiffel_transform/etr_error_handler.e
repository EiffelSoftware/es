note
	description: "Error handling for EiffelTransform classes."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ERROR_HANDLER
inherit
	ETR_SHARED_LOGGER

feature -- Access
	has_errors: BOOLEAN
	last_error: detachable STRING
	errors: detachable LIST[attached like last_error]

	error_count: INTEGER
			-- Number of errors
		do
			if attached errors then
				Result := errors.count
			end
		end

feature -- Operations

	reset_errors
			-- set `has_errors' to false
		do
			if attached errors then
				errors.wipe_out
			end

			has_errors := false
		end

	add_error(a_class: detachable ANY; a_feature: detachable STRING; an_error_message: STRING)
			-- set `last_error' to `an_error_message'
		local
			l_error_msg: STRING
		do
			if not attached errors then
				create {LINKED_LIST[like last_error]}errors.make
			end

			has_errors := true
			create l_error_msg.make_empty
			if attached a_class and attached a_feature then
				l_error_msg.append ("{"+a_class.generating_type+"}."+a_feature+": ")
			end
			l_error_msg.append (an_error_message)
			logger.log_error(l_error_msg)
			last_error := l_error_msg
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
