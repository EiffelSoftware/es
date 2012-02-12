note
	description: "Eiffel Vision spin button. Cocoa Implementation."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SPIN_BUTTON_IMP

inherit
	EV_SPIN_BUTTON_I
		redefine
			interface
		end

	EV_GAUGE_IMP
		undefine
			on_key_event,
			default_key_processing_blocked,
			set_value,
			set_range,
			is_height_resizable
		redefine
			interface,
			make,
			dispose
		end

	EV_TEXT_FIELD_IMP
		rename
			create_change_actions as create_text_change_actions,
			change_actions as text_change_actions,
			change_actions_internal as text_change_actions_internal
		redefine
			make,
			interface,
			dispose,
			on_change_actions
		end

create
	make

feature {NONE} -- Implementation

	make
		do
			create view.make
			view.set_translates_autoresizing_mask_into_constraints_ (False)
			cocoa_view := view
			create stepper.make

			create value_range.make (0, 100)
			Precursor {EV_TEXT_FIELD_IMP}
			Precursor {EV_GAUGE_IMP}
			initialize_gauge_imp

			view.add_subview_ (text_field)
			view.add_subview_ (stepper)
				-- NSTodo: build spin button as shown below
				--  +--------- view --------+
				--  | [text_field][stepper] |
				--  |_______________________|

			stepper.set_value_wraps_ (False)
--			stepper.set_action (agent
--				do
--					set_value (stepper.double_value.floor)
--					change_actions.call ([value])
--				end)

			align_text_left
			text_field.set_string_value_ (create {NS_STRING}.make_with_eiffel_string (value.out))

				-- NSTodo: if possible, remove set_minimum_size from creation procedure
			set_minimum_size (maximum_character_width * 4 + stepper_width, 24)
		end

feature -- Element change

	set_value (a_value: INTEGER)
			-- Set `value' to `a_value'.
		do
			Precursor {EV_GAUGE_IMP} (a_value)
			set_text (a_value.out)
		end

	set_range
			-- Update widget range from `value_range'
		do
			Precursor {EV_GAUGE_IMP}
			stepper.set_min_value_ (value_range.lower)
			stepper.set_max_value_ (value_range.upper)
		end

feature {NONE} -- Implementation

	on_change_actions
		do
			gauge_change_actions
		 	Precursor {EV_TEXT_FIELD_IMP}
		end


	gauge_change_actions
			-- A change action has occurred.
		local
			a_data: TUPLE [INTEGER_32]
		do
			if change_actions_internal /= Void then
				create a_data.default_create
				a_data.put (value, 1)
				change_actions_internal.call (a_data)
			end
		end

	dispose
		do
			Precursor {EV_TEXT_FIELD_IMP}
			Precursor {EV_GAUGE_IMP}
		end

feature {EV_ANY_I} -- Implementation

	stepper_width: INTEGER = 15

	stepper: NS_STEPPER;

	view: NS_VIEW;

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_SPIN_BUTTON note option: stable attribute end;

end -- class EV_SPIN_BUTTON_IMP
