note
	description: "Formatter class for viewing Eiffel source code as informal textual BON."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TEXTUAL_BON_FORMAL_FORMATTER

inherit
	TEXTUAL_BON_FORMATTER
		redefine
			class_cmd,
			create_class_cmd,
			generate_text
		end

create
	make

feature -- creation

feature -- Access

	mode: NATURAL_8
			-- Formatter mode, see {ES_CLASS_TOOL_VIEW_MODES} for applicable values.
		do
			Result := {ES_CLASS_TOOL_VIEW_MODES}.basic
		end

feature -- Properties
	symbol: ARRAY [EV_PIXMAP]
			-- Graphical representation of the command.
		once
			create Result.make (1, 2)
			Result.put (pixmaps.icon_pixmaps.view_flat_icon, 1)
			Result.put (pixmaps.icon_pixmaps.view_flat_icon, 2)
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Graphical representation of the command.
		once
			Result := pixmaps.icon_pixmaps.view_flat_icon_buffer
		end

	post_fix: STRING = "bon"
			-- String symbol of the command, used as an extension when saving.

	capital_command_name: STRING_GENERAL
			-- Name of the command.
		do
			Result := "Formal BON view" --Interface_names.l_bon_view
		end

	menu_name: STRING_GENERAL
			-- Identifier of `Current' in menus.
		do
			Result := "Formal BON view" --Interface_names.m_Showbon
		end

	classi: CLASS_I
			-- Class currently associated with `Current'.

feature -- Status setting

feature {NONE} -- Implementation
	class_cmd: E_SHOW_FLAT
			-- Only used for compability. Do not use.

	create_class_cmd
			-- Create `class_cmd'.
		do
			create class_cmd
		end

	generate_text
			-- Fill `formatted_text' with information concerning `class'.
		local
			retried: BOOLEAN
		do
			if not retried then
				set_is_without_breakable
				editor.handle_before_processing (False)
				last_was_error := formal_bon_context_text (associated_class, editor.text_displayed)
				editor.handle_after_processing
			else
				last_was_error := True
			end
		rescue
			retried := True
			retry
		end

	has_breakpoints: BOOLEAN = False
		-- Should `Current' display breakpoints?

	line_numbers_allowed: BOOLEAN = False
		-- Should `Current' allow line numbers?

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
