indexing
	description: "Formatter that displays only text of a feature with no analysis in editor-mode"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "ESTeaching Project, ETH SE SS 2006"
	date: "$Date$"
	revision: "$Revision: 58664 $"

class
	EB_TEACHMODE_FORMATTER

inherit
	EB_BASIC_TEXT_FORMATTER
	--EB_BASIC_FEATURE_FORMATTER
		redefine
			command_name,
			symbol,
			menu_name,
			format,
			generate_text

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
--			create Result.make (1, 2)
--			Result.put (Pixmaps.Icon_teach, 1) -- an erste stelle
--			Result.put (Pixmaps.Icon_teach, 2) -- an zweite stelle
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
			fs: FEATURE_STONE
			teaching_mode : BOOLEAN
		do
			if
				classi /= Void and then
				selected and then
				displayed
			then

				teaching_mode := False
				fs ?= stone
				if fs /= Void then
					associated_feature := fs.e_feature
					if associated_feature /= Void then
						associated_feature_stone := fs
						teaching_mode := True
					end
				end

				display_temp_header
				create class_file.make (classi.file_name)
				if class_file.exists then
					if not equal (classi.file_name, editor.file_name) then
						editor.set_stone (stone)
						if NOT teaching_mode then
							editor.load_file (classi.file_name)
							go_to_position
						end
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

				if teaching_mode then
					generate_text
				end

				editable :=	not classi.is_read_only and not editor.load_file_error
				editor.set_read_only (not editable)
				if has_breakpoints then
					editor.enable_has_breakable_slots
				else
					editor.disable_has_breakable_slots
				end

				if NOT teaching_mode then
					editor.display_message ("no feature for TEACHING-Mode selected!")
					editable := false
				end

				display_header
			end
		end

--	full_text is
--			-- Create `formatted_text'.
--		local
--			feature_text : STRING
--			class_text: STRING
--		do
--			feature_text := editor.text
--			class_text := class_header_text + feature_text + class_footer_text
--			editor.set_stone (stone)
--			editor.load_text (class_text)
--		end

	full_text:STRING is
			-- Create `formatted_text'.
		local
			feature_text : STRING
			class_text: STRING
		do
			feature_text := editor.text
			class_text := class_header_text + feature_text + class_footer_text
			Result := class_text
		end

feature {NONE} -- Implementation

	associated_feature: E_FEATURE
			-- Feature about which information is displayed.

	associated_feature_stone:  FEATURE_STONE

	class_header_text: STRING
	class_footer_text: STRING

generate_text is
			-- Create `formatted_text'.
		local
			retried: BOOLEAN
			ynk_win: YANK_STRING_WINDOW
			ynk_win1: YANK_STRING_WINDOW
			ynk_win2: YANK_STRING_WINDOW
		do
			if associated_feature /= Void then
				create ynk_win.make
				create ynk_win1.make
				create ynk_win2.make
				if not retried then
					last_was_error := associated_feature.plain_text (ynk_win)
					last_was_error := associated_feature.class_header_text (ynk_win1) OR ELSE last_was_error
					last_was_error := associated_feature.class_footer_text (ynk_win2) OR ELSE last_was_error
				else
					last_was_error := True
				end
				if not last_was_error then
					class_header_text := ynk_win1.stored_output
					class_footer_text := ynk_win2.stored_output
					editor.set_stone (stone)
					editor.load_text (ynk_win.stored_output)
				end
			end
		rescue
			retried := True
			retry
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
