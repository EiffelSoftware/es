note
	description: "Part of code from {QL_BIT_ARRAY}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BIT_VECTOR

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_bit_count: INTEGER)
			-- Initialize Current with `a_bit_count' of bits.
		require
			a_bit_count_positive: a_bit_count > 0
		local
			l_count: INTEGER
			i: INTEGER
		do
			count := a_bit_count
			if count \\ 32 = 0 then
				create storage.make (count // 32)
			else
				create storage.make (count // 32 + 1)
			end
			from
				i := 0
				l_count := storage.count
			until
				i = l_count
			loop
				storage.put (0, i)
				i := i + 1
			end

			compute_unused_bits_mask
		ensure
			count_set: count = a_bit_count
		    unused_bits_mask_set: -- `unused_bits_mask' has been set
		end

feature -- Setting

	set_bit (a_index: INTEGER)
			-- Set `a_index'-th bit to 1.
		require
			a_index_valid: is_index_valid (a_index)
		do
			set_bit_with_value (a_index, 1)
		ensure
			bit_set: bit_at (a_index) = 1
		end

	unset_bit (a_index: INTEGER)
			-- Unset `a_index'-th bit to 0.
		require
			a_index_valid: is_index_valid (a_index)
		do
			set_bit_with_value (a_index, 0)
		ensure
			bit_unset: bit_at (a_index) = 0
		end

	set_bit_with_value (a_index: INTEGER; a_value: INTEGER)
			-- Set `a_index'-th bit to `a_value'.
		require
			a_index_valid: is_index_valid (a_index)
			a_value_valie: a_value = 0 or a_value = 1
		local
			l_div: INTEGER
			l_mod: INTEGER
			l_value: NATURAL_32
			l_storage: like storage
		do
			l_div := a_index // 32
			l_mod := a_index \\ 32
			l_storage := storage
			l_value := l_storage.item (l_div)
			if a_value = 1 then
				l_value := l_value.bit_or (bit_map.item (l_mod))
			else
				l_value := l_value.bit_and (reversed_bit_map.item (l_mod))
			end
			l_storage.put (l_value, l_div)
		ensure
			bit_set: bit_at (a_index) = a_value
		end

feature -- bitwise operations

	bit_and alias "&"(a_vector: AFX_BIT_VECTOR): AFX_BIT_VECTOR
			-- bit and
		require
		    same_count: count = a_vector.count
		do
		    Result := bit_operation (a_vector, agent bit_and_agent)
		end

	bit_or alias "|"(a_vector: AFX_BIT_VECTOR): AFX_BIT_VECTOR
			-- bit or
		require
		    same_count: count = a_vector.count
		do
		    Result := bit_operation (a_vector, agent bit_or_agent)
		end

	bit_xor (a_vector: AFX_BIT_VECTOR): AFX_BIT_VECTOR
			-- bit xor
		require
		    same_count: count = a_vector.count
		do
		    Result := bit_operation (a_vector, agent bit_xor_agent)
		end

	bit_not: AFX_BIT_VECTOR
			-- bit not
		do
		    Result := bit_operation (Void, agent bit_not_agent)
		end

	set_minus alias "-" (a_vector: AFX_BIT_VECTOR): AFX_BIT_VECTOR
			-- set minus.
			-- the bits that are set in `Current' but not in `a_vector' would be set in the `Result'
		require
		    same_count: count = a_vector.count
		local
		    l_and: AFX_BIT_VECTOR
		do
			l_and := bit_and (a_vector)
			Result := bit_xor (l_and)
		end

	is_subset_of (a_vector: AFX_BIT_VECTOR): BOOLEAN
			-- is current vector denoting a subset of `a_vector'?
		require
		    same_count: count = a_vector.count
		local
		    l_sub: AFX_BIT_VECTOR
		do
		    l_sub := Current.set_minus (a_vector)
		    if l_sub.count_of_set_bits = 0 then
		        Result := True
		    end
		end

feature{NONE} -- bitwise operation implementation

	bit_operation (a_vector: detachable AFX_BIT_VECTOR; an_agent: FUNCTION[ANY, TUPLE[NATURAL_32, NATURAL_32], NATURAL_32]): AFX_BIT_VECTOR
			-- calculate the bit and of two bit vectors
		require
		    same_count: count = a_vector.count
		local
		    l_vector: AFX_BIT_VECTOR
		    l_storage1, l_storage2, l_storage_result: like storage
		    l_size, l_index: INTEGER
		    l_nat1, l_nat2, l_nat_result: NATURAL_32
		do
		    if a_vector = Void then
		        l_vector := Current
		    else
		        l_vector := a_vector
		    end

		    l_storage1 := storage
		    l_storage2 := l_vector.storage

		    create Result.make (count)
		    l_storage_result := Result.storage

		    if count \\ 32 = 0 then
		        l_size := count // 32
		    else
		        l_size := count // 32 + 1
		    end

		    from
		        l_index := 0
		    until
		        l_index = l_size
		    loop
		        l_nat1 := l_storage1[l_index]
				l_nat2 := l_storage2[l_index]
				l_nat_result := an_agent.item ([l_nat1, l_nat2])

				l_storage_result[l_index] := l_nat_result
				l_index := l_index + 1
		    end
		ensure
		    same_count: Result.count = count
		end

	bit_and_agent (an_int_a, an_int_b: NATURAL_32): NATURAL_32
			-- bit and agent
		do
		    Result := an_int_a & an_int_b
		end

	bit_or_agent (an_int_a, an_int_b: NATURAL_32): NATURAL_32
			-- bit or agent
		do
		    Result := an_int_a | an_int_b
		end

	bit_xor_agent (an_int_a, an_int_b: NATURAL_32): NATURAL_32
			-- bit xor agent
		do
		    Result := an_int_a.bit_xor (an_int_b)
		end

	bit_not_agent (an_int_a, an_int_b: NATURAL_32): NATURAL_32
			-- bit not agent
		do
		    Result := an_int_a.bit_not
		end

feature -- Access

	count: INTEGER
			-- Number of bits

	is_index_valid (a_index: INTEGER): BOOLEAN
			-- Is `a_index' valid?
		do
			Result := a_index >= 0 and then a_index < count
		end

	bit_at (a_index: INTEGER): INTEGER
			-- Bit at position `a_index'
			-- Result is 0 or 1.
		require
			a_index_valid: is_index_valid (a_index)
		do
			if is_bit_set (a_index) then
				Result := 1
			else
				Result := 0
			end
		end

	is_bit_set (a_index: INTEGER): BOOLEAN
			-- Is bit at position `a_index' set?
		require
			a_index_valid: is_index_valid (a_index)
		local
			l_div: INTEGER
			l_mod: INTEGER
		do
			l_div := a_index // 32
			l_mod := a_index \\ 32
			Result := storage.item (l_div).bit_and (bit_map.item (l_mod)) > 0
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		local
			i: INTEGER
			l_count: INTEGER
			l_size: INTEGER
			l_rest: INTEGER
			l_storage, l_other_storage: like storage
		do
			l_count := count
			if other.count = l_count then
			    clear_unused_bits
			    other.clear_unused_bits

			    l_size := l_count // 32
			    l_rest := l_count \\ 32
			    if l_rest /= 0 then
					l_size := l_size + 1
			    end

				from
					Result := True
					l_storage := storage
					l_other_storage := other.storage
					i := 0
				until
					i = l_size or not Result
				loop
					Result := l_storage.item (i) = l_other_storage.item (i)
					i := i + 1
				end
			end
		end

	count_of_set_bits: INTEGER
			-- Number of bits whose value is 1
		local
			i: INTEGER
			l_count: INTEGER
		do
			from
				i := 0
				l_count := count
			until
				i = l_count
			loop
				if is_bit_set (i) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	count_of_unset_bits: INTEGER
			-- Number of bits whose value is 0
		do
			Result := count - count_of_set_bits
		ensure
			good_result: Result = count - count_of_set_bits
		end

	list_of_bit_index (a_set: BOOLEAN): LIST [INTEGER]
			-- List of indexes of set bits if `a_set' is True,
			-- otherwise unset bits
		local
			i: INTEGER
			l_count: INTEGER
		do
			create {LINKED_LIST [INTEGER]} Result.make
			from
				i := 0
				l_count := count
			until
				i = l_count
			loop
				if a_set then
					if is_bit_set (i) then
						Result.extend (i)
					end
				else
					if not is_bit_set (i) then
						Result.extend (i)
					end
				end
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

	clear_unused_bits
			-- clear the bits not used in vector
		require
		    unused_bits_mask_set: -- `unused_bits_mask' has been set
		local
		    l_count: INTEGER
		    l_div, l_mod: INTEGER
		    l_bits: NATURAL_32
		    l_storage: like storage
		do
			l_count := count
			l_storage := storage

			l_div := l_count // 32
			l_mod := l_count \\ 32
			if l_mod /= 0 then
			    l_bits := l_storage.item (l_div)
			    l_bits := l_bits & (unused_bits_mask.bit_not)
			    l_storage.put (l_bits, l_div)
			end
		end

feature{AFX_BIT_VECTOR} -- Implementation

	storage: SPECIAL [NATURAL_32]
			-- Array to store bits		

feature{NONE} -- Implementation

	compute_unused_bits_mask
			-- compute unused bits mask
		local
		    l_count, l_mod: INTEGER
		    l_mask: NATURAL_32
		do
		    l_count := count
		    l_mod := l_count \\ 32
		    if l_mod /= 0 then
    		    l_mask := 0
    		    l_mask := l_mask.bit_not
    		    l_mask := l_mask.bit_shift_left (l_mod)
		    end
		    unused_bits_mask := l_mask
		end

	unused_bits_mask: NATURAL_32
			-- mask for unused bits

	bit_map: SPECIAL [NATURAL_32]
			-- Map for bits
		local
			l_map: NATURAL_32
			i: INTEGER
		once
			create Result.make (32)
			from
				l_map := 1
				i := 0
			until
				i = 32
			loop
				Result.put (l_map, i)
				l_map := l_map |<< 1
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

	reversed_bit_map: SPECIAL [NATURAL_32]
			-- Reversed map for bits
		local
			l_map: NATURAL_32
			l_max: NATURAL_32
			i: INTEGER
		once
			create Result.make (32)
			from
				l_max := {NATURAL_32}.max_value
				l_map := 1
				i := 0
			until
				i = 32
			loop
				Result.put (l_max.bit_xor (l_map), i)
				l_map := l_map |<< 1
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

invariant
	storage_attached: storage /= Void
	bit_map_attached: bit_map /= Void
	reversed_bit_map_attached: reversed_bit_map /= Void


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
