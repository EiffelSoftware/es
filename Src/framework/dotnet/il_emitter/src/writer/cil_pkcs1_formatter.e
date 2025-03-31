note
	description: "[
		format a message hash into PKCS1 format
		assumes SHA-1 hashing
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_PKCS1_FORMATTER

inherit

	REFACTORING_HELPER


create
	make

feature {NONE} -- Initialization

	make (a_msg: ARRAY [NATURAL_8])
		do
			msg := a_msg
		end

feature -- Access

	msg: ARRAY [NATURAL_8]


feature -- Operations

	calculate (a_result: ARRAY [NATURAL_8])
		local
			l_pos: INTEGER
			l_tmp: NATURAL_8
		do
			a_result.fill_with (0xff)
			a_result [1] := 0
			a_result [2] := 1
			l_pos := a_result.count - 20 - der_header.count
				-- C++ version uses sizeof.
				--|result.size() - 20 - sizeof(DerHeader) - 1;
			a_result [l_pos] := 0
			a_result.subcopy (der_header, 1, der_header.count, l_pos + 1)
			l_pos := a_result.count - 20

				-- C++ code copy 20 bytes without checking if there are enough data
				-- memcpy(result() + result.size() - 20, msg_, 20);
			check valid_size_mgs: msg.count >= 20 end
			a_result.subcopy (msg, 1, 20, l_pos)

			  -- reverse it before encryption..
		    across 1 |..| (a_result.count // 2) as i loop
		    	l_tmp := a_result [i]
				a_result [i] := a_result [a_result.count - i]
				a_result [a_result.count - i] := l_tmp
		    end
		end


feature -- Static

	der_header: ARRAY [NATURAL_8]
		do
			Result := {ARRAY [NATURAL_8]} <<0x30, 0x21, 0x30, 0x09, 0x06, 0x05, 0x2b, 0x0e, 0x03, 0x02, 0x1a, 0x05, 0x00, 0x04, 0x14>>
		ensure
			instance_free: class
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
