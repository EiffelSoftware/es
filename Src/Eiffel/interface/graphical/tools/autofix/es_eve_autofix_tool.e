frozen class ES_EVE_AUTOFIX_TOOL

inherit
	ES_TOOL [ES_EVE_AUTOFIX_TOOL_PANEL]

create {NONE}
	default_create

feature -- Basic operation

	show_result (a_fault_signature: STRING)
			-- Show fixes to `a_fault_signature'.
		require
			is_tool_instantiated: is_tool_instantiated
			signature_not_empty: a_fault_signature /= Void and then not a_fault_signature.is_empty
		do
			internal_panel.reload (a_fault_signature)
		end

	show_fixes_for_all (a_fault_signatures: ARRAYED_LIST [STRING])
			-- Show fixs for all faults in `a_fault_signatures'.
		require
			is_tool_instantiated: is_tool_instantiated
			signatures_attached: a_fault_signatures /= Void
		do
			from a_fault_signatures.start
			until a_fault_signatures.after
			loop
				show_result (a_fault_signatures.item_for_iteration)
				a_fault_signatures.forth
			end
		end

feature -- Access

	title: STRING_32
			-- <Precursor>
		do
			Result :=  locale_formatter.translation (t_title)
		end

	icon: EV_PIXEL_BUFFER
			-- <Precursor>
		do
			Result := stock_pixmaps.command_send_to_external_editor_icon_buffer
		end

	icon_pixmap: EV_PIXMAP
			-- <Precursor>
		do
			Result := stock_pixmaps.command_send_to_external_editor_icon
		end

feature {NONE} -- Factory

	new_tool: ES_EVE_AUTOFIX_TOOL_PANEL
			-- <Precursor>
		do
			create Result.make (window, Current)
		end

feature {NONE} -- Internationalization

	t_title: STRING = "AutoFix Results"

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
