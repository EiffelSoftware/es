indexing
	description	: "Add user Wizard Step 2."
				  "User name and password."
	author		: "Bernhard S. Buss"
	date		: "19.June.2006"
	revision	: "1.0.0"

class
	wizard_second_state

inherit
	WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
			build,
			pixmap_location,
			make,
			can_go_next
		end

create
	make


feature -- Creation

	make (an_info: like wizard_information) is
			-- make the new state.
		do
			Precursor(an_info)
		end


feature -- Basic Operation


	build is
			-- Build entries.
		local
			label_text_vb: EV_VERTICAL_BOX
			center_hb, user_name_hb, user_pass_hb: EV_HORIZONTAL_BOX
			space: EV_CELL
			system: APPLICATION
			label_width: INTEGER
		do
			label_width := 100
			system ?= current_application

			-- create the center horizontal box which is used to center the text_field box in the dialog.
			create center_hb
			main_box.extend (center_hb)
			-- left space of the center box.
			create space
			space.set_minimum_width (80)
			system.add_without_expand (center_hb, space)
			-- create the vertical box in which the labels and text field boxes are displayed.
			create label_text_vb
			system.add_without_expand (center_hb, label_text_vb)
			-- right space of the center box
			create space
			space.set_minimum_width (80)
			system.add_without_expand (center_hb, space)

			-- fill label and text field box
			create user_name_hb
			system.add_label (user_name_hb, "user name: ", label_width)
			create user_name_txt
			user_name_txt.set_minimum_width_in_characters (20)
			if system.user_name /= Void then
				user_name_txt.set_text (system.user_name)
			end
			system.add_without_expand (user_name_hb, user_name_txt)
			system.add_without_expand (label_text_vb, user_name_hb)
			create user_pass_hb
			system.add_label (user_pass_hb, "user password: ", label_width)
			create user_pass_txt
			if system.user_pass /= Void then
				user_pass_txt.set_text (system.user_pass)
			end
			user_pass_txt.set_minimum_width_in_characters (20)
			system.add_without_expand (user_pass_hb, user_pass_txt)
			system.add_without_expand (label_text_vb, user_pass_hb)

			set_updatable_entries(<<user_name_txt.change_actions, user_pass_txt.change_actions>>)
			check_wizard_status
		end

	proceed_with_current_info is
			-- User has clicked next, go to next step.
		do
			Precursor
			proceed_with_new_state(create {WIZARD_THIRD_STATE}.make(wizard_information))
		end

	update_state_information is
			-- Check User Entries
		local
			system: APPLICATION
		do
			Precursor
			-- save entries
			system ?= current_application
			if system /= Void then
				if not user_name_txt.text.is_empty then
					system.set_user_name (user_name_txt.text)
				end
				if not user_pass_txt.text.is_empty then
					system.set_user_pass (user_pass_txt.text)
				end
			end
		end


feature -- Queries

	can_go_next: BOOLEAN is
			-- returns true if entries are valid; not empty.
		do
			Result := not (user_name_txt.text.is_empty or user_pass_txt.text.is_empty)
		end



feature {NONE} -- Implementation

	display_state_text is
			-- Set the messages for this state.
		do
			title.set_text ("Add user to EMU Project (Step 2).")
			subtitle.set_text ("Specify user name and password")
			message.set_text ("Now enter the name and a password for the user to add.")
		end



feature -- Text fields

	user_name_txt: EV_TEXT_FIELD
			-- the name of the user to create.

	user_pass_txt: EV_TEXT_FIELD
			-- the password of the user to create.



feature -- Pixmap

	pixmap_location: FILE_NAME is
			-- Pixmap location
		once
			create Result.make_from_string ("emu_icon_01")
			Result.add_extension (pixmap_extension)
		end

end -- class wizard_second_state
