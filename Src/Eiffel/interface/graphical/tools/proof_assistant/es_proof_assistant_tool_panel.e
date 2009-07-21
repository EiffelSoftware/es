indexing
	description: "Summary description for {ES_PROOF_ASSISTANT_TOOL_PANEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_PROOF_ASSISTANT_TOOL_PANEL

inherit

	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_TEXT]

	EXCEPTIONS
	export {NONE} all end

create
	make

feature

	create_widget: EV_TEXT
		do
			create Result
		end

	build_tool_interface (root_widget: EV_TEXT)
		do
			create jstar_proofs.make (agent user_widget.set_text)
			propagate_drop_actions (Void)
		end

	create_tool_bar_items: ?DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		do
			Result := Void
		end

feature {NONE}

	on_stone_changed (a_old_stone: ?like stone)
		local
			l_retry: BOOLEAN
			l_error_prompt: ES_ERROR_PROMPT
		do
			if not l_retry then
				if {st: !CLASSC_STONE} stone and then {c: !CLASS_C} st.e_class then
					jstar_proofs.prove (c)
				end
			end
		rescue
			create l_error_prompt.make_standard (tag_name)
			l_error_prompt.show_on_active_window
			l_retry := True
			retry
		end

	jstar_proofs: JSTAR_PROOFS

;indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
