note
	description: "The GUI for the schema evolution handler"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_HANDLER_GUI

create make

feature -- Creation

	 make (msg_box: SET_MESSAGE_BOX)
			-- create a GUI containing `msg_box'
		require
			msg_box_exists: msg_box /= Void
		local
			const: SET_UTILITY_AND_CONSTANTS
		do
			message_box := msg_box
			create const
			create handler_helper.make
			releases := const.releases_count - 1
			if releases > 1 then
				display
			else
				message_box.print_not_enough_releases
			end
		end

feature{NONE} -- Status

	releases: INTEGER
		-- Releases number.
	dialog: SET_DIALOG_FACTORY
		-- The handler dialog.
	handler_helper: SET_HANDLER
		-- Internal helper object.
	message_box: SET_MESSAGE_BOX

feature{NONE} -- Implementation

	display
			-- Display the tool window
		local
			v_panel: EV_VERTICAL_BOX
			h_panel: EV_HORIZONTAL_BOX
		do
			create h_panel
			create v_panel
			create dialog.make ("Please select two releases")
			h_panel.extend (create {EV_BUTTON}.make_with_text_and_action ("Ok", agent create_schema_evolution_handlers_files))
			h_panel.extend (create {EV_BUTTON}.make_with_text_and_action ("Cancel", agent dialog.destroy))
			v_panel.extend(create_comparison_panel)
			v_panel.extend (h_panel)
			v_panel.disable_item_expand (h_panel)
			dialog.extend (v_panel)
			dialog.show
		end

feature {NONE} -- Graphic implementation

	create_comparison_panel: EV_HORIZONTAL_BOX
			-- Create the version comparison panel.
		local
			i: INTEGER
			--radio_button: EV_RADIO_BUTTON
			v_box1,v_box2: EV_VERTICAL_BOX
		do
			create Result
			create v_box1
			create v_box2
			v_box1.extend (create {EV_LABEL}.make_with_text ("From"))
			v_box2.extend (create {EV_LABEL}.make_with_text ("To"))
			from i:=1 until i>releases loop
				v_box1.extend (create {EV_RADIO_BUTTON}.make_with_text_and_action ("version " + i.out, agent handler_helper.set_version1_int(i)))
				v_box2.extend (create {EV_RADIO_BUTTON}.make_with_text_and_action ("version " + i.out, agent handler_helper.set_version2_int(i)))
				i:=i+1
			end
			Result.extend (v_box1)
			Result.extend (v_box2)
		end

feature {NONE} --action buttons

	create_schema_evolution_handlers_files
		local
			res: TUPLE [DS_ARRAYED_LIST [STRING], DS_HASH_TABLE [STRING, STRING]]
			process: DS_HASH_TABLE [STRING, STRING]
			msg: DS_ARRAYED_LIST [STRING]
			report: SET_HANDLER_REPORT
		do
			res := handler_helper.schema_evolution_handler
			msg ?= res [1]
			process ?= res [2]
			if msg /= Void then
				message_box.print_messages (msg)
			end
			if process /= Void and then not process.is_empty then
				create report.make (process)
			end
			dialog.destroy
		end
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
