note
	description: "Commit the selected item with an optional message."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_COMMIT_DIALOG

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

	make_default (a_item: STRING_8)
		require
			valid_item: a_item /= Void and then not a_item.is_empty
		local
			l_v_box: EV_VERTICAL_BOX
			l_h_box, l_h_space: EV_HORIZONTAL_BOX
			l_message_label: EV_LABEL
			l_cancel_button: EV_BUTTON
		do
			make_with_title ("Commit '" + a_item + "'")

			create l_v_box
			create l_h_box
			create l_h_space
			create l_message_label.make_with_text ("Message")
			create message_text
			create l_cancel_button.make_with_text_and_action ("Cancel", agent hide)
			create commit_button.make_with_text ("Commit")
			commit_button.select_actions.extend (agent on_commit)

			l_v_box.set_border_width (14)
			l_h_box.set_border_width (7)

			l_message_label.align_text_left
			message_text.set_minimum_height (125)

			l_h_space.set_minimum_width (20)
			l_cancel_button.set_minimum_width (160)
			commit_button.set_minimum_width (160)

			set_minimum_size (400, 200)

			extend_button (l_h_box, commit_button)
			extend_no_expand (l_h_box, l_h_space)
			extend_button (l_h_box, l_cancel_button)

			extend (l_v_box)
			extend_no_expand (l_v_box, l_message_label)
			l_v_box.extend (message_text)
			extend_no_expand (l_v_box, l_h_box)
		end

feature -- Access

	message_text: EV_TEXT

	commit_button: EV_BUTTON

	set_commit_action (a_action: like commit_action)
		require
			action_not_void: a_action /= Void
		do
			commit_action := a_action
		end

feature {NONE} -- Implementation

	on_commit
		do
			if commit_action /= Void then
				commit_action.call ([message_text.text.as_string_8])
			end
			hide
		end

	commit_action: PROCEDURE[ANY, TUPLE[STRING_8]];

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
