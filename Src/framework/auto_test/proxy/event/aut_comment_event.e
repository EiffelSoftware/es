note
	description: "Summary description for {AUT_COMMENT_EVENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_COMMENT_EVENT

inherit
	AUT_PROXY_EVENT

create
	make

feature{NONE} -- Initialization

	make (a_line: like line) is
			-- Initialize `line' with `a_line'.
			-- Create a copy of `a_line' into `line'.
		require
			a_line_attached: a_line /= Void
		do
			line := a_line.twin
		ensure
			good_result: line /= Void and then line ~ a_line
		end

feature -- Access

	line: STRING
			-- Comment line

feature {AUT_PROXY_EVENT_PRODUCER} -- Basic operations

	publish (a_producer: AUT_PROXY_EVENT_PRODUCER; a_observer: AUT_PROXY_EVENT_OBSERVER)
			-- Notify observer about `Current' event.
			--
			-- `a_producer' Producer that triggered event
			-- `a_observer': Observer to be notified.
		do
			a_observer.report_comment_line (a_producer, line)
		end

invariant
	line_attached: line /= Void

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
