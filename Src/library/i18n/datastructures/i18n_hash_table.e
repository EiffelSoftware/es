indexing
	description: "Store objects for internalization purposes into a hash table."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_HASH_TABLE

inherit
	I18N_DATASTRUCTURE

create {I18N_DATASTRUCTURE_FACTORY}

	make,
	make_with_datasource

feature {NONE} -- Initialization

	initialize is
			-- Initialize the hash table
		local
			i: INTEGER
				-- Iterator
		do
			create hash_table.make(base_array.count)
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= base_array.count + 1
			variant
				base_array.count + 1 - i
			until
				i > base_array.count
			loop
				base_array.item(i).set_hash(hash_string(base_array.item(i).originals.i_th(1)))
				if not base_array.item(i).get_original(1).is_equal("") then
					hash_table.put(base_array.item(i), base_array.item(i).hash)
				end
				i := i + 1
			end
		ensure then
			hash_table /= Void
		end

feature {NONE} -- Basic operations

	search (a_string: STRING_32; i_th: INTEGER): STRING_32 is
			-- Can you give me the translation?
		local
			l_hash: INTEGER
				-- Temporary hash
		do
			l_hash := hash_string(a_string)
			if hash_table.has(l_hash) then
				-- The string is into the hashing table.
				Result := hash_table.item(l_hash).get_translated(i_th)
			else
				-- Do nothing, return void
			end
		end


feature {NONE} -- Miscellaneous

    hash_string (a_string: STRING_32): INTEGER is
			-- What is the hash of a_string?
		require
			valid_string: a_string /= Void
		local
			position: INTEGER
			l_result, g: NATURAL_32
		do
			from
				position := 1
			invariant
				position >= 1
				position <= a_string.count + 1
			variant
				a_string.count + 1 - position
			until
				position > a_string.count
			loop
				l_result := l_result |<< 4
				l_result := l_result + a_string.code(position) -- for eiffel 5.7.x
				--l_result := l_result + a_string.item_code(position).as_natural_32 --for eiffel 5.6
				g := l_result & ({NATURAL_32} 0xf |<< 28)
				if g /= 0 then
					l_result := l_result.bit_xor(g |>> 24)
					l_result := l_result.bit_xor(g)
				end
				position := position + 1
			end
			Result := l_result.as_integer_32
		end

feature {NONE} -- Implementation

	hash_table: HASH_TABLE[I18N_STRING, INTEGER]
		-- Table with all the strings

invariant

	valid_hash_table: hash_table /= Void
	hash_table.count <= base_array.count

end
