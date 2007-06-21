indexing
	description: "Objects that represent a special that is captured as basic type"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	MANIFEST_SPECIAL
inherit
	ANY
	redefine
		out
	end


feature -- Access
	item: SPECIAL[ANY]

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

	replay_generating_type: STRING is
			--
		do
			Result := item.generating_type
		end


feature -- Measurement

feature -- Status report

feature -- Status setting
	set_item(new_item: SPECIAL[ANY]) is
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

invariant
	item_not_void: item /= Void
end
