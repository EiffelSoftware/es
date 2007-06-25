indexing
	description: "Objects that represent a special that is captured as basic type"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	MANIFEST_SPECIAL [T]
inherit
	ANY
	redefine
		out
	end

creation
	make_empty,
	restore

feature -- Initialization

	make_empty is
			-- Create an empty instance.
		do
		end


	restore (from_value: STRING) is
			-- Restore `item' from the element sequence `from_value'
		require
			from_value_not_void: from_value /= Void
		local
			special_size: INTEGER
		do
			special_size := from_value.occurrences (',') + 1
			create item.make (special_size)
			load_values (from_value)
		ensure
			item_not_void: item /= Void
		end


feature -- Access
	item: SPECIAL[T]

	is_character_special: BOOLEAN

	out: STRING is
			-- Serialize `item'.
		local
			char_special: SPECIAL[CHARACTER]
		do
			char_special ?= item
			if char_special /= Void then

				Result := character_out(char_special)
			else
				Result := any_out(item)
			end
		end

feature -- Status setting
	set_item(new_item: SPECIAL[T]) is
			-- Set `item' to `new_item'
		require
			new_item_not_void: new_item /= Void
		do
			item := new_item
		ensure
			item_set: item = new_item
		end

feature {NONE} -- Implementation


	-- TODO: add 'real' escaping logic

	escape_character(c: CHARACTER): STRING is
			-- replace a character by a corresponding escape sequence.
		do
			if c.is_equal ('"') then
				Result := "#"
			elseif c.is_equal(',') then
				Result := "#"
			else
				create Result.make_filled (c, 1)
			end
		end

	character_from_escaped_string (escaped_sequence: STRING): CHARACTER is
			-- Restore a character from a escaped string
		do
			if escaped_sequence.count = 1 then
				Result := escaped_sequence.item (1)
			else
				Result := '#'
			end
		end

	any_out(any_special: SPECIAL[ANY]): STRING is
			-- Serialize a SPECIAL with elements of any type.
			-- note: XXX works correctly only for SPECIALs that contain basic types.
				local
			i: INTEGER
		do
			create Result.make(0)
			if any_special.count >= 1 then
				Result.append (any_special.out)
			end
			from
				i := any_special.lower
			until
				i >= any_special.upper
			loop
				Result.append (",")
				Result.append (any_special[i].out)
				i := i + 1
			end
		end

	character_out(char_special: SPECIAL[CHARACTER]): STRING is
			-- Serialize `character_special' and escape the characters if necessary.
		local
			i: INTEGER
		do
			create Result.make(char_special.upper)
			if char_special.upper >= 1 then
				Result.append (escape_character(char_special[i]))
			end
			from
				i := char_special.lower + 1
			until
				i >= char_special.upper
			loop
				Result.append (",")
				Result.append(escape_character (char_special[i]))
				i := i + 1
			end
		end

	load_values (a_value_list: STRING) is
			-- Load the values from a value - STRING into `item'
		local
			position: INTEGER
			next_position: INTEGER
			value: STRING
			i: INTEGER
		do
			from
				position := 1
				i := 0
			until
				position > a_value_list.count
			loop
				next_position := a_value_list.index_of (',', position)
				if next_position = 0 then
					next_position := a_value_list.count + 1
				end
				value := a_value_list.substring (position, next_position - 1)
				load_value (value, i)
				i := i + 1
				position := next_position + 1
			end
		end

	load_value (a_value: STRING; index: INTEGER) is
			-- Load `a_value' into item at position `index'
		require
			valid_index: item.valid_index (index)
		local
			character_special: SPECIAL [CHARACTER]
		do
			character_special ?= item
			if character_special /= Void then
				character_special.put (character_from_escaped_string(a_value), index)
			end
		end

invariant
	item_not_void: item /= Void
end
