note
	description: "Summary description for {EB_REPOSITORIES_TREE_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_REPOSITORIES_TREE_ITEM

inherit
	EV_TREE_ITEM
		redefine
			data
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make(a_item: EB_REPOSITORIES_ITEM)
		require
			item_not_void: a_item /= Void
		do
			default_create
			data := a_item
			set_configurable_target_menu_mode
			set_configurable_target_menu_handler (agent context_menu_handler)
		end

feature -- Access

	item_url: STRING_8
		do
			if attached {EB_REPOSITORIES_TREE_ITEM}parent as p then
				Result := p.item_url + "/" + data.name
			else
				Result := data.name
			end
		end

feature {NONE} -- Attributes

	data: EB_REPOSITORIES_ITEM

feature {NONE} -- Implementation

	context_menu_handler (a_menu: EV_MENU; a_target_list: ARRAYED_LIST [EV_PND_TARGET_DATA]; a_source: EV_PICK_AND_DROPABLE; a_pebble: ANY)
			-- Context menu handler
		local
			l_menu_item: EV_MENU_ITEM
		do
			-- Display checkout contextual menu item
			create l_menu_item.make_with_text_and_action ("Checkout...", agent show_checkout_dialog)
			a_menu.extend (l_menu_item)

			-- Add new menu item
		end

	show_checkout_dialog
		local
			l_checkout_dialog: EB_CHECKOUT_DIALOG
		do
			create l_checkout_dialog.make_default
			l_checkout_dialog.set_checkout_action (agent svn_checkout)
			l_checkout_dialog.show
		end

	svn_checkout (a_path: STRING_8)
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			l_svn_client: SVN_CLIENT
			l_tools: ES_SHELL_TOOLS
		do
			create l_svn_client.make
			l_svn_client.set_working_path (a_path)
			l_svn_client.checkout.set_target (item_url)
			if attached {EB_REPOSITORIES_TREE}parent_tree as l_tree and then l_tree.development_window /= Void then
				l_tools := l_tree.development_window.shell_tools
				if attached {ES_SVN_OUTPUT_TOOL} l_tools.tool ({ES_SVN_OUTPUT_TOOL}) as l_tool then
					l_svn_client.checkout.set_on_data_received (agent l_tool.append_output)
				end
			end
			l_svn_client.checkout.execute
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
