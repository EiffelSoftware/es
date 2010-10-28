note
	description: "Path report dialog"
	author: "Teseo Schneider, MArco Piccioni"
	date: "07.04.09"

class
	SET_HANDLER_REPORT

	create
		make

feature {NONE} -- Status

	dialog: SET_DIALOG_FACTORY
	menu: EV_COMBO_BOX
	text: EV_TEXT
	messages: DS_HASH_TABLE[STRING,STRING]

feature -- Creation

	make (msg: DS_HASH_TABLE [STRING,STRING])
			-- Create a reportwith the given messages.
		require
			msg_not_void: msg /= Void
		local
			main_container: EV_VERTICAL_BOX
			ok: EV_BUTTON
			horiz: EV_HORIZONTAL_BOX
		do
			messages:=msg
			create dialog.make ("Handler report")
			create text
			text.disable_edit
			text.enable_word_wrapping
			text.set_text (messages.first)
			create menu.default_create
			menu.disable_edit
			from messages.start until messages.after loop
				menu.extend (create {EV_LIST_ITEM}.make_with_text (messages.key_for_iteration))
				messages.forth
			end
			menu.select_actions.extend (agent selected)
			create ok.make_with_text_and_action ("Ok", agent dialog.destroy)
			create main_container
			main_container.extend (menu)
			main_container.disable_item_expand (menu)
			main_container.extend (text)
			create horiz
			horiz.extend (create {EV_CELL})
			horiz.extend (ok)
			horiz.disable_item_expand (ok)
			horiz.extend (create{EV_CELL})
			main_container.extend (horiz)
			main_container.disable_item_expand (horiz)
			dialog.extend (main_container)
			dialog.set_size (200, 300)
			dialog.show
		end

feature {NONE} -- Actions

	selected
			-- item seleced
		do
			text.set_text (messages.item (menu.selected_item.text))
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
