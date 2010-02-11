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

feature -- Initialization

	make (a_class: like context_class)
			-- <Precursor>
			-- we always use the text from the CLASS_AS, which should be conform with the information in the AST.
		local
			l_text: detachable STRING_32
			l_editor_text: detachable STRING_32
		do
			context_class := a_class

				-- text
			l_text := a_class.text
			check l_text /= Void end

			original_text := l_text
			original_file_date := a_class.file_date
			modified_data := new_modified_data
		end

feature -- Operation

	tailing_whitespace (a_pos: INTEGER): attached STRING_32
			-- Retrieve the tailing whitespace at a given position on `text'
			--
			-- `a_pos': Orginal position in `original_text' to retrieve the whitespace for.
			-- `Result': The initial whitespace string.
		require
			is_interface_usable: is_interface_usable
			a_pos_non_negative: a_pos > 0
			a_pos_small_enough: a_pos < text.count
		local
			l_text: like text
			l_count: INTEGER
			l_pos: INTEGER
			i: INTEGER
		do
			l_text := text
			l_count := l_text.count
			l_pos := modified_data.adjusted_position (a_pos) + 1
			from i := l_pos
			until i > l_count or not l_text.item (i).is_space or l_text.item (i) = '%N'
			loop
				i := i + 1
			end

			if i <= l_count and then l_text.item (i) = '%N' then
			    i := i + 1
			end



			if i > l_pos then
				Result := l_text.substring (l_pos, i - 1)
				from
					i := 1
					l_pos := Result.count
				until
					i > l_pos
				loop
					if not Result.item (i).is_space then
							-- Replace any characters with spaces.
						Result.put (' ', i)
					end
					i := i + 1
				end
			else
				create Result.make_empty
			end
		end

	new_modified_data: attached like modified_data
			-- <Precursor>
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
