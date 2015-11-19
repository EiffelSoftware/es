note
	description: "Breakpoint tokens for the alias analyser gui."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EDITOR_TOKEN_ALIAS_BREAKPOINT

inherit
	EDITOR_TOKEN_BREAKPOINT
		redefine
			pixmap
		end

create
	make_replace

feature {NONE}

	make_replace (a_to_replace: EDITOR_TOKEN_BREAKPOINT; a_line_number: INTEGER_32; a_previous_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT)
		require
			a_to_replace /= Void
			a_to_replace.previous = Void
			a_to_replace.next /= Void
			a_to_replace.pebble /= Void
			a_line_number >= 0
		do
			make

			set_next_token (a_to_replace.next)
			a_to_replace.set_next_token (Void)
			next.set_previous_token (Current)
			set_pebble (a_to_replace.pebble)
			a_to_replace.set_pebble (Void)
			line_number := a_line_number

			if a_previous_alias_breakpoint /= Void then
				set_previous_alias_breakpoint (a_previous_alias_breakpoint)
				a_previous_alias_breakpoint.set_next_alias_breakpoint (Current)
			end
		ensure
			previous = Void
			next = old a_to_replace.next
			a_to_replace.next = Void
			a_to_replace.previous = Void
			next.previous = Current
			pebble = old a_to_replace.pebble
			a_to_replace.pebble = Void
			line_number = a_line_number
		end

feature

	line_number: INTEGER_32

	next_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT assign set_next_alias_breakpoint

	set_next_alias_breakpoint (a_next_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT)
		do
			next_alias_breakpoint := a_next_alias_breakpoint
		end

	previous_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT assign set_previous_alias_breakpoint

	set_previous_alias_breakpoint (a_previous_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT)
		do
			previous_alias_breakpoint := a_previous_alias_breakpoint
		end

	active: BOOLEAN assign set_active

	set_active (a_active: BOOLEAN)
		do
			active := a_active
		end

	pixmap: EV_PIXMAP
		do
			if active then
				Result := active_icon
			else
				Result := inactive_icon
			end
		end

feature {NONE}

	inactive_icon: EV_PIXMAP
		once
			Result := (create {EB_SHARED_PIXMAPS}).small_pixmaps.bp_slot_icon
		end

	active_icon: EV_PIXMAP
		once
			Result := (create {EB_SHARED_PIXMAPS}).small_pixmaps.bp_slot_current_line_icon
		end

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
