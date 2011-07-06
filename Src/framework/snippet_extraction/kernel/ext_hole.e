note
	description: "Class that represents a hole in an extracted snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_HOLE

inherit
	ANY
		redefine
			out
		end

feature -- Access

	hole_id: NATURAL
		assign set_hole_id
			-- Numeric hole identifier. Should be unique within the context where it is used.

	annotations: LINKED_SET [EXT_MENTION_ANNOTATION]
		assign set_annotations
			-- Set of (conditionally) mentioned expressions in the hole.

	set_hole_id (a_id: like hole_id)
			-- Sets `hole_id'.
		do
			hole_id := a_id
		end

	set_annotations (a_annotations: like annotations)
			-- Sets `annotations'.
		do
			annotations := a_annotations
		end

feature -- Output

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make_empty
			Result.append ("hole__")
			Result.append (hole_id.out)

			if attached annotations as l_annotation_set and then not l_annotation_set.is_empty then
				Result.append ("(")

 				from
 					l_annotation_set.start
 				until
 					l_annotation_set.after
 				loop
 					Result.append (l_annotation_set.item.out)
					if not l_annotation_set.islast then
 						Result.append (", ")
 					end
 					l_annotation_set.forth
 				end

				Result.append (")")
			end
		end

end
