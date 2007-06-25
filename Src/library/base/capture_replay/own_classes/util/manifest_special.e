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
			--
		require
			from_value_not_void: from_value /= Void
		local
			special_size: INTEGER
		do
			special_size := from_value.occurrences (',') + 1
			create item.make (special_size)
			load_value (from_value)
		ensure
			item_not_void: item /= Void
		end


feature -- Access
	item: SPECIAL[T]

	is_character_special: BOOLEAN

	out: STRING is
			--
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

feature -- Measurement

feature -- Status report

feature -- Status setting
	set_item(new_item: SPECIAL[T]) is
			-- set `item' to `new_item'
		require
			new_item_not_void: new_item /= Void
		do
			item := new_item
		ensure
			item_set: item = new_item
		end


feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	escape_character(c: CHARACTER): CHARACTER is
			-- replace a character by a corresponding escape sequence.
		do
			if c.is_equal ('"') then
				Result := '#'
			elseif c.is_equal(',') then
				Result := '#'
			else
				Result := c
			end
		end

	any_out(any_special: SPECIAL[ANY]): STRING is
			--
				local
			i: INTEGER
		do
			create Result.make(0)
			if any_special.count >= 1 then
				Result.append(any_special.out)
			end
			from
				i := any_special.lower
			until
				i >= any_special.upper
			loop
				Result.append(",")
				Result.append(any_special[i].out)
				i := i + 1
			end
		end

	character_out(char_special: SPECIAL[CHARACTER]): STRING is
			--
		local
			i: INTEGER
		do
			create Result.make(char_special.upper)
			if char_special.upper >= 1 then
				Result.append_character(escape_character(char_special[i]))
			end
			from
				i := char_special.lower + 1
			until
				i >= char_special.upper
			loop
				Result.append(",")
				Result.append_character(escape_character(char_special[i]))
				i := i + 1
			end
		end

	load_value (a_value: STRING) is
			--
		do
			--TODO: implement.
		end

--	create_special_entity(basic: BASIC_ENTITY): SPECIAL[ANY] is
--			--
--		local
--			type:STRING
--			dtype: INTEGER
--			special_size: INTEGER
--			item_type: STRING
--			item_dtype: INTEGER
--		do
--			dtype := dynamic_type_from_string(basic.type)

--			if is_special_type(dtype) then
--				special_size := basic.value.occurrences (',') + 1

--				if is_special_any_type(dtype) then
--					Result := new_special_any_instance (dtype, special_size)
--				else
--					type := basic.type
--						-- It's safe to assume that there's only 1 pair of '[]', because the item type is a basic type.
--					item_type := type.substring (type.index_of ('[', 1) + 1, type.index_of(']',1) -1)
--					item_dtype := dynamic_type_from_string(item_type)
--					inspect item_dtype
--					when character_8_type then
--						Result := create {SPECIAL [CHARACTER_8]}.make (special_size)
--					else
--						-- XXX implement this for all basic types.
--					end
--				end
--			else
--				-- TODO: report error
--			end
--		end


invariant
	item_not_void: item /= Void
end
