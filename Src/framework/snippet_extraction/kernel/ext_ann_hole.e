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

	set_hole_id (a_id: like hole_id)
			-- Sets `hole_id'.
		do
			hole_id := a_id
		end

	out: STRING
			-- Printable representation of annotation.
		do
			Result := once "hole__" + hole_id.out
		end

end
