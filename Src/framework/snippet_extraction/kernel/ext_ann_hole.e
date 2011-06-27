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

	c_mentions_set: LINKED_SET [STRING]
		assign set_c_mentions_set
			-- Set of conditionally mentioned expressions in the hole.

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

	set_c_mentions_set (a_set: like mentions_set)
			-- Sets `mentions_set'.
		do
			c_mentions_set := a_set
		end

	out: STRING
			-- Printable representation of annotation.
		local
			l_annotation_set: LINKED_SET [STRING]
		do
			create l_annotation_set.make
			l_annotation_set.compare_objects

			if attached mentions_set as l_set then
				across
					l_set as l_cursor
				loop
					(agent (a_set: LINKED_SET [STRING]; a_expr_string: STRING)
						local
							l_cat: STRING
						do
							create l_cat.make_empty
							l_cat.append (once "mentions(")
							l_cat.append (a_expr_string)
							l_cat.append (once ")")

							a_set.force (l_cat)
						end
					).call ([l_annotation_set, l_cursor.item])
				end
			end

			if attached c_mentions_set as l_set then
				across
					l_set as l_cursor
				loop
					(agent (a_set: LINKED_SET [STRING]; a_expr_string: STRING)
						local
							l_cat: STRING
						do
							create l_cat.make_empty
							l_cat.append (once "cond_mentions(")
							l_cat.append (a_expr_string)
							l_cat.append (once ")")

							a_set.force (l_cat)
						end
					).call ([l_annotation_set, l_cursor.item])
				end
			end

			create Result.make_empty
			Result.append ("hole__")
			Result.append (hole_id.out)

			if not l_annotation_set.is_empty then
				Result.append ("(")

 				from
 					l_annotation_set.start
 				until
 					l_annotation_set.after
 				loop
 					Result.append (l_annotation_set.item)
					if not l_annotation_set.islast then
 						Result.append (", ")
 					end
 					l_annotation_set.forth
 				end

				Result.append (")")
			end
		end

end
