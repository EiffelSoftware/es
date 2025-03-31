note
	description: "Summary description for {MD_DEBUG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MD_DEBUG

feature -- Access	

	dump_pool (pool: PE_POOL): STRING_8
		local
			i: INTEGER
--			s: STRING
			arr: SPECIAL [NATURAL_8]
			n: INTEGER
		do
			arr := pool.base
			n := pool.size.to_integer_32
			from
				i := 0
				create Result.make (n)
--				create s.make_empty
			until
				i >= n
			loop
--				if arr [i] = {NATURAL_8} 0 then
--					s.append (arr [i].out)
--					s.append_character (',')
--				else
--					if not s.is_empty then
--						Result.append (s)
--						s.wipe_out
--					end
					Result.append (arr [i].out)
					Result.append_character (',')
--				end
				i := i + 1
			end
		ensure
			class
		end

	dump_special (sp: SPECIAL [NATURAL_8]; a_start_index, n: INTEGER): STRING_8
		require
			sp.valid_index (a_start_index)
			valid_count: a_start_index + n <= sp.count
		local
			i: INTEGER
		do
			from
				i := 0
				create Result.make (n)
			until
				i >= n
			loop
				Result.append (sp [i].to_hex_string)
				Result.append_character (' ')
				i := i + 1
			end
		ensure
			class
		end

note
	copyright: "Copyright (c) 1984-2025, Eiffel Software"
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
