note
	description: "Iterator to transform AST and remove nodes irrelevant w.r.t. the snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_PRUNER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			make_with_output
		end

	REFACTORING_HELPER

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output' and initialize empty `annotations'.
		do
			Precursor (a_output)
			create annotations.make (0)
		end

feature -- Configuration		

	set_annotations (a_annotations: like annotations)
			-- Configure with annotations associated to ast path nodes.
		require
			a_annotations_attached: a_annotations /= Void
			a_annotations_comparing_objects: a_annotations.object_comparison
		do
			annotations := a_annotations
		end

feature {NONE} -- Data Structures

	annotations: HASH_TABLE [LINKED_LIST [EXT_ANNOTATION], AST_PATH]
			-- Annotations associated to ast path nodes. AST tranformations \
			-- take place on basis of these annotations during AST traversal.

feature {NONE} -- Implementation

invariant
	annotations_attached: attached annotations
end
