note
	description: "Class that represents a hole in an extracted snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ANN_HOLE

inherit
	EXT_ANNOTATION
		redefine
			out
		end

feature -- Access

	hole_id: NATURAL
		assign set_hole_id
			-- Numeric hole identifier. Should be unique within the context where it is used.

	mentions_set: LINKED_SET [STRING]
		assign set_mentions_set
			-- Set of mentioned expressions in the hole.

	set_hole_id (a_id: like hole_id)
			-- Sets `hole_id'.
		do
			hole_id := a_id
		end

	set_mentions_set (a_set: like mentions_set)
			-- Sets `mentions_set'.
		do
			mentions_set := a_set
		end

	out: STRING
			-- Printable representation of annotation.
		do
			Result := once "hole__" + hole_id.out
			Result.append ("(")
			if attached mentions_set then
				from
					mentions_set.start
				until
					mentions_set.after
				loop
					Result.append (mentions_set.item)
					if not mentions_set.islast then
						Result.append (", ")
					end
					mentions_set.forth
				end
			end
			Result.append (")")
		end

end
