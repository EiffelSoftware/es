note
	description: "Summary description for {EB_CHECKOUT_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_CHECKOUT_DIALOG

inherit
	EB_DIALOG

	EB_VISION2_FACILITIES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make_default

feature {NONE} -- Initialization

	make_default
		local
			l_v_box: EV_VERTICAL_BOX
			l_h_box, l_h_box2, l_h_space: EV_HORIZONTAL_BOX
			l_cancel_button: EV_BUTTON
		do
			default_create
			create choose_folder_dialog.make_with_title ("Checkout repository")
			choose_folder_dialog.ok_actions.extend (agent on_chose_folder)
			create l_v_box
			create l_h_box
			create l_h_box2
			create l_h_space
			create folder_path
			create choose_folder_button.make_with_text_and_action ("Checkout folder...", agent choose_folder_dialog.show_modal_to_window (Current))
			create l_cancel_button.make_with_text_and_action ("Cancel", agent hide)
			create checkout_button.make_with_text_and_action ("Checkout", agent on_checkout)
			checkout_button.disable_sensitive

			l_v_box.set_border_width (14)
			l_h_box.set_border_width (7)
			l_h_box2.set_border_width (7)

			folder_path.align_text_left

			extend_no_expand (l_h_box2, choose_folder_button)
			extend_no_expand (l_v_box, l_h_box2)
			l_v_box.extend (folder_path)
			folder_path.set_minimum_width (400)

			extend_no_expand (l_h_box, checkout_button)
			extend_no_expand (l_h_box, l_h_space)
			extend_no_expand (l_h_box, l_cancel_button)

			l_h_space.set_minimum_width (20)
			l_cancel_button.set_minimum_width (160)
			checkout_button.set_minimum_width (160)
			choose_folder_button.set_minimum_width (160)

			set_minimum_size (500, 150)

			extend_no_expand (l_v_box, l_h_box)

			extend (l_v_box)
		end

feature -- Element change

	set_checkout_action (a_action: like checkout_action)
		require
			action_not_void: a_action /= Void
		do
			checkout_action := a_action
		end

feature {NONE} -- Implementation

	on_checkout
		do
			if checkout_action /= Void then
				checkout_action.call ([folder_path.text.as_string_8])
			end
			hide
		end

	on_chose_folder
		do
			checkout_button.enable_sensitive
			folder_path.set_text (choose_folder_dialog.directory)
		end

	checkout_action: PROCEDURE[ANY, TUPLE[STRING_8]]

	checkout_button: EV_BUTTON

	choose_folder_button: EV_BUTTON

	choose_folder_dialog: EV_DIRECTORY_DIALOG

	folder_path: EV_LABEL;

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
