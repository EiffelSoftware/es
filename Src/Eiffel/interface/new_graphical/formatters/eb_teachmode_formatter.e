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
			ebw : EB_DEVELOPMENT_WINDOW
			fs: FEATURE_STONE
			teaching_mode : BOOLEAN
		do
			if
				classi /= Void and then
				selected and then
				displayed
			then

				teaching_mode := False
				ebw ?= manager
				fs ?= stone
				if ebw /= Void AND fs /= Void then
					associated_feature := fs.e_feature
					if associated_feature /= Void then
						teaching_mode := True
--					else
--						editor.load_text (fs.origin_text)
					end
					--editor.display_message ("Yes: both")
--				elseif ebw /= Void then
--					editor.display_message ("Yes: ebw")
--				elseif fs /= Void then
--					editor.display_message ("Yes: fs")
--				else
--					editor.display_message ("ERROR")
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

				display_header
			end
		end


feature {NONE} -- Implementation

	associated_feature: E_FEATURE
			-- Feature about which information is displayed.

	generate_text is
			-- Create `formatted_text'.
		local
			retried: BOOLEAN
			ynk_win: YANK_STRING_WINDOW
		do
			if associated_feature /= Void then
				create ynk_win.make
				if not retried then
					last_was_error := associated_feature.text (ynk_win)
				else
					last_was_error := True
				end
				if not last_was_error then
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
