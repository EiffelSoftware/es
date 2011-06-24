note
	description: "Summary description for {EB_CREATE_REPOSITORY_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_CREATE_REPOSITORY_DIALOG

inherit
	EB_DIALOG
		-- TODO: use extend_no_expand!!
	EB_VISION2_FACILITIES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make_default

feature {NONE} -- Initialization

	make_default(a_repositories_manager: EB_REPOSITORIES_MANAGER)
			-- Create the dialog and link it to a given repositories manager.
		require
			a_repositories_manager_not_void: a_repositories_manager /= Void
		local
			l_ev_vertical_box_1, l_ev_vertical_box_2: EV_VERTICAL_BOX
			l_ev_horizontal_box_1, l_ev_horizontal_box_2, l_ev_horizontal_box_3, l_ev_horizontal_box_4, l_ev_horizontal_box_5: EV_HORIZONTAL_BOX
			l_ev_label_1, l_ev_label_2, l_ev_label_3: EV_LABEL
		do
			make_with_title (Interface_names.t_New_repository)
			repositories_manager := a_repositories_manager

				-- Create all widgets (generated with EiffelBuild)
				-- TODO: rename boxes and label, simplify structure
			create l_ev_vertical_box_1
			create l_ev_vertical_box_2
			create l_ev_horizontal_box_1
			create l_ev_label_1
			create repository_url
			create l_ev_horizontal_box_2
			create l_ev_label_2
			create username
			create l_ev_horizontal_box_3
			create l_ev_label_3
			create password
			create l_ev_horizontal_box_4
			create l_ev_horizontal_box_5
			create add_button.make_with_text_and_action (interface_names.b_add, agent create_new_repository)
			create cancel_button.make_with_text_and_action (interface_names.b_cancel, agent hide)

			l_ev_vertical_box_1.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_label_1)
			l_ev_horizontal_box_1.extend (repository_url)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_label_2)
			l_ev_horizontal_box_2.extend (username)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (l_ev_label_3)
			l_ev_horizontal_box_3.extend (password)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_4)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_5)
			l_ev_horizontal_box_5.extend (add_button)
			l_ev_horizontal_box_5.extend (cancel_button)

			l_ev_vertical_box_1.set_padding (4)
			l_ev_vertical_box_1.set_border_width (4)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_1)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_2)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_3)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_4)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_5)
			l_ev_horizontal_box_1.disable_item_expand (l_ev_label_1)
			l_ev_label_1.set_text ("Repository URL:")
			l_ev_label_1.set_minimum_width (105)
			l_ev_label_1.align_text_right
			l_ev_horizontal_box_2.disable_item_expand (l_ev_label_2)
			l_ev_label_2.set_text ("Username:")
			l_ev_label_2.set_minimum_width (105)
			l_ev_label_2.align_text_right
			l_ev_horizontal_box_3.disable_item_expand (l_ev_label_3)
			l_ev_label_3.set_text ("Password:")
			l_ev_label_3.set_minimum_width (105)
			l_ev_label_3.align_text_right
			l_ev_horizontal_box_4.set_minimum_height (25)
			l_ev_horizontal_box_5.set_minimum_height (29)
			set_default_cancel_button (cancel_button)
			set_default_push_button (add_button)
			set_minimum_width (400)
			set_minimum_height (175)

			extend(l_ev_vertical_box_1)
		end

feature

	call_default
		do
			show
		end

feature -- Implementation

	create_new_repository
			-- Add a new repository to the set of repositories
		do
			repositories_manager.new_repository (repository_url.text, username.text, password.text)
			hide
			repository_url.set_text ("")
			username.set_text ("")
			password.set_text ("")
		end

feature -- Access

	repository_url, username: EV_TEXT_FIELD
	password: EV_PASSWORD_FIELD
	add_button, cancel_button: EV_BUTTON

feature {NONE} -- Implementation

	repositories_manager: EB_REPOSITORIES_MANAGER;

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
