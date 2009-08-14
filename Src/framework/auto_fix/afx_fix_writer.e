note
	description: "Summary description for {AFX_FIX_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_WRITER

inherit
	ES_CLASS_TEXT_AST_MODIFIER
		export
		    {ANY} all
		redefine
		    make,
		    new_modified_data
		end

create
    make

feature

	make (a_class: like context_class)
			-- <Precursor>
			-- always use class text from disk file
		local
			l_text: detachable STRING_32
			l_editor: like active_editor_for_class
			l_editor_text: detachable STRING_32
			l_encoding: ENCODING
		do
			context_class := a_class

			debug ("autofix")
					-- text from editor and that from disk are different
    			l_editor := active_editor_for_class (a_class)
    			if l_editor /= Void and then is_editor_text_ready (l_editor) then
    				l_editor_text := l_editor.wide_text
    				l_encoding := l_editor.encoding
    			end
    		end

				-- text
			l_text := a_class.text
			check l_text /= Void end

				-- encoding
			l_encoding ?= a_class.encoding
			if l_encoding /= Void then
				encoding_converter.detected_encoding := l_encoding
			else
				encoding_converter.detected_encoding := (create {EC_ENCODINGS}).default_encoding
			end

			original_text := l_text
			original_file_date := a_class.file_date
			modified_data := new_modified_data
		end

	new_modified_data: attached like modified_data
			-- <Precursor>
			-- We need to be sure the modifier reads class text from disk file,
			-- rather than from editor, where "%R%N"s are trimed to "%N"s and therefore may result in ast mismatch later.
		local
			l_class: attached like context_class
			l_text: attached STRING_32
		do
			l_class := context_class
			l_text := original_text
			create Result.make (l_class, l_text)
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
