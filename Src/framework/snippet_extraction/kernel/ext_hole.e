note
	description: "Class that represents a hole in an extracted snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_HOLE

inherit
	EXT_SHARED_EQUALITY_TESTERS
		redefine
			out
		end

create
	make, make_with_annotations

feature -- Constants

	hole_name_prefix: STRING = "hole__"

feature {NONE} -- Initialization

	make (a_id: like hole_id)
			-- Default initialization.
		require
			a_id_not_void: attached a_id
		do
			hole_id := a_id
			create annotations.make_equal (10)
		end

	make_with_annotations (a_id: like hole_id; a_annotations: like annotations)
			-- Default initialization.
		require
			a_id_not_void: attached a_id
			a_annotations_not_void: attached a_annotations
		do
			hole_id := a_id
			annotations := a_annotations
		end

feature -- Access

	hole_id: NATURAL
		assign set_hole_id
			-- Numeric hole identifier. Should be unique within the context
			-- where it is used, e.g. one snippet.

	hole_name: STRING
			-- Textual hole identifier. Is a concatination of `hole_name_prefix'
			-- and `hole_id'.
		do
			create Result.make_empty
			Result.append (hole_name_prefix)
			Result.append (hole_id.out)
		end

	hole_type: detachable STRING
		assign set_hole_type
			-- String representation AST node's type the hole substitutes.
			-- Holes substituting instructions have type `Void' whereas holes that
			-- substitute expressions have the type of the evaluated expression
			-- where determinable.

	annotations: DS_HASH_SET [ANN_MENTION_ANNOTATION]
		assign set_annotations
			-- Set of (conditionally) mentioned expressions in this hole.

feature -- Configuration

	set_hole_id (a_id: like hole_id)
			-- Sets `hole_id'.
		require
			a_id_not_void: attached a_id
		do
			hole_id := a_id
		end

	set_hole_type (a_type: like hole_type)
			-- Sets `hole_type'.
		require
			a_type_not_void: attached a_type
		do
			hole_type := a_type
		end

	set_annotations (a_annotations: like annotations)
			-- Sets `annotations'.
		require
			a_annotations_not_void: attached a_annotations
		do
			annotations := a_annotations
		end

feature -- Output

	out: STRING
			-- New string containing terse printable representation
			-- of current object.
		do
			create Result.make_empty
			Result.append (hole_name)

			if attached annotations as l_annotation_set and then not l_annotation_set.is_empty then
				Result.append ("(")

 				from
 					l_annotation_set.start
 				until
 					l_annotation_set.after
 				loop
 					Result.append (l_annotation_set.item_for_iteration.out)
					if not l_annotation_set.is_last then
 						Result.append (", ")
 					end
 					l_annotation_set.forth
 				end

				Result.append (")")
			end
		end

end
