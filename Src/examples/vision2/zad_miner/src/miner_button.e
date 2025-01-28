note
	description: "Object which representing a square"
	date: "$Date$"
	revision: "$Revision$"

class
	MINER_BUTTON

inherit
	EV_BUTTON

	MINER_CONSTANTS
		undefine
			default_create, copy
		end

create
	default_create

feature -- Initialization

	init_mine
		do
			reset
			pointer_button_press_actions.extend (agent put_a_flag_action)
		end

	flagcode: INTEGER
		do
			if is_flagged then
				Result := 1
			end
		end

	code: INTEGER
		do
			if is_trapped then
				Result := 1
			end
		end
		
	is_trapped: BOOLEAN
	is_flagged: BOOLEAN
	is_shown: BOOLEAN

	reset
		do
			is_trapped := False
			is_flagged := False
			is_shown := False
			set_pixmap (pix_first)
		end

	discover_it
		do
			if is_flagged and not is_trapped then
				set_pixmap (pix_mark_nok)
			elseif is_trapped and is_trapped then
				set_pixmap (pix_mark)
			else
				show_it
			end
		end

	show_it
		do
			is_shown := True
			if is_trapped then
				set_pixmap (pix_boum)
			else
-- 				set_pixmap()
			end
		end

	put_a_flag_action (
				z_x, z_y: INTEGER; z_button: INTEGER;
				z_x_tilt, z_y_tilt: DOUBLE; z_pressure: DOUBLE;
				z_screen_x, z_screen_y: INTEGER
			)
		do
			if z_button = 3 then
				put_a_flag
			end
		end

	put_a_flag
		do
			if not is_shown then
				set_flag (not is_flagged)
			end
		end

	set_flag (val: BOOLEAN)
		do
			is_flagged := val
			if val then
				set_pixmap (pix_mark)
			else
				set_pixmap (pix_first)
			end
		end

	set_trapped (val: BOOLEAN)
		do
			is_trapped := val
		end

note
	copyright: "2001-2025, Jocelyn Fiat, and Eiffel Software"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Mine Sweeper
			version 1.3 (2025)

			freely distributable
		]"

end

