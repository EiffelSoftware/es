note
	description: "Eiffel Vision Environment. Cocoa implementation."
	author: "Daniel Furrer"
	keywords: "environment, global, system"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_ENVIRONMENT_IMP

inherit
	EV_ENVIRONMENT_I
		export
			{ANY} is_destroyed
		end

	EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	old_make (an_interface: like interface)
			-- Pass `an_interface' to base make.
		do
			assign_interface (an_interface)
		end

	make
			-- No initialization needed.
		do
			set_is_initialized (True)
		end

feature -- Access

	supported_image_formats: LINEAR [STRING_32]
			-- `Result' contains all supported image formats
			-- on current platform, in the form of their three letter extension.
			-- e.g. PNG, BMP, ICO
		once
			Result := create {ARRAYED_LIST [STRING_32]}.make_from_array (<<"PNG">>)
			Result.compare_objects
		end

	mouse_wheel_scroll_lines: INTEGER
			-- Default number of lines to scroll in response to
			-- a mouse wheel scroll event.
		do
			Result := 3
		end

	default_pointer_style_width: INTEGER
			-- Default pointer style width.
		local
			l_cursor: NS_CURSOR
		do
			l_cursor := (create {NS_CURSOR_UTILS}).arrow_cursor
			Result := l_cursor.image.size.width.truncated_to_integer
		end

	default_pointer_style_height: INTEGER
			-- Default pointer style height.
		local
			l_cursor: NS_CURSOR
		do
			l_cursor := (create {NS_CURSOR_UTILS}).arrow_cursor
			Result := l_cursor.image.size.height.truncated_to_integer
		end

	has_printer: BOOLEAN
			-- Is a default printer available?
			-- `Result' is `True' if at least one printer is installed.
		do
			system ("which lpr > /dev/null 2>&1")
			Result := return_code = 0
		end

	font_families: LINEAR [STRING_32]
			-- List of fonts available on the system
		local
			l_font_manager: NS_FONT_MANAGER
			l_font_families: NS_ARRAY
			l_font_list: LINKED_LIST [STRING_32]
			i: NATURAL_64
		once
--			create {LINKED_LIST [STRING_32]}Result.make
			create l_font_list.make
			create l_font_manager.make
			l_font_families := l_font_manager.available_font_families
			from i := 0
			until i >= l_font_families.count
			loop
				if attached {NS_STRING} l_font_families.object_at_index_ (i) as l_font then
					l_font_list.extend (l_font.to_eiffel_string.as_string_32)
				end
				i := i + 1
			end
			Result := l_font_list
		end

end -- class EV_ENVIRONMENT_IMP
