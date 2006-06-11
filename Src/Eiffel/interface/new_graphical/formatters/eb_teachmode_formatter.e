indexing
	description: "Formatter that displays the text of a feature with no analysis."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "Xavier Rousselot"
	date: "$Date$"
	revision: "$Revision: 58663 $"

class
	EB_TEACHMODE_FORMATTER

inherit
	EB_BASIC_TEXT_FORMATTER
		redefine
			command_name,
			symbol,
			menu_name,
			format
		end

create
	make


feature {NONE} -- Properties

	command_name: STRING is
			-- Name of the command.
		do
			Result := Interface_names.l_teachmode
		end

	symbol: ARRAY [EV_PIXMAP] is
			-- Graphical representation of the command.
		once
			create Result.make (1, 2)
			Result.put (Pixmaps.Icon_format_text, 1)
			Result.put (Pixmaps.Icon_format_text, 2)
		end

	menu_name: STRING is
			-- Identifier of `Current' in menus.
		do
			Result := Interface_names.m_teachmode
		end

feature -- Formatting

	format is
			-- Refresh `widget'.
		local
			class_file: RAW_FILE
			f_name: STRING
		do
			if
				classi /= Void and then
				selected and then
				displayed
			then
				display_temp_header
				create class_file.make (classi.file_name)
				if class_file.exists then
					if not equal (classi.file_name, editor.file_name) then
						editor.set_stone (stone)
						editor.load_file (classi.file_name)
						go_to_position
					end
					if editor.load_file_error then
						f_name := editor.file_name
						editor.clear_window
						if f_name = Void or else f_name.is_empty then
							f_name := classi.file_name
						end
						editor.display_message (Warning_messages.w_Cannot_read_file (f_name))
					end
				else
					editor.clear_window
					editor.display_message (Warning_messages.w_file_not_exist (classi.file_name))
				end
				editable :=	not classi.is_read_only and not editor.load_file_error
				editor.set_read_only (not editable)
				if has_breakpoints then
					editor.enable_has_breakable_slots
				else
					editor.disable_has_breakable_slots
				end
				display_header
			end
		end


indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_TEACHMODE_FORMATTER
