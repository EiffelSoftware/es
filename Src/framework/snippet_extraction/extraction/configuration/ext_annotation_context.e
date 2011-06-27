note
	description: "Maintaining annotation variable information."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ANNOTATION_CONTEXT

inherit
	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
		end

feature -- Access

	add_annotation (location: AST_PATH; annotation: EXT_ANNOTATION)
			-- Add an AST annotation for the given path `location'.
		local
			l_location_marks: LINKED_LIST [EXT_ANNOTATION]
		do
			if not annotations.has (location) then
				create l_location_marks.make
				annotations.force (l_location_marks, location)
			else
				l_location_marks := annotations.at (location)
			end

			check annotations.has (location) and attached l_location_marks and annotations.at (location) = l_location_marks end
			fixme ("Rethink semantics of marks (set, list, bag, ...)?!")
			l_location_marks.force (annotation)
		end

	has_annotation_hole (location: AST_PATH): BOOLEAN
		do
			Result := annotations.has (location) and then
						across annotations.item (location) as l_annotations some attached {EXT_ANN_HOLE} l_annotations.item end
		end

	get_first_annotation_hole (location: AST_PATH): EXT_ANN_HOLE
			-- Returns the first annotation of type `{EXT_ANN_HOLE}'.
		require
			annotation_exists: has_annotation_hole (location)
		do
			if attached annotations.item (location) as l_annotations then
				from
					l_annotations.start
				until
					l_annotations.after or Result /= Void
				loop
					if attached {EXT_ANN_HOLE} l_annotations.item_for_iteration as l_hole_annotation then
						Result := l_hole_annotation
					end
				end
			end
		ensure
			annotation_result_set: attached Result
		end

	set_annotations (a_annotations: like annotations)
			-- Configures this class with a set of annotations.
		require
			a_annotations_attached: a_annotations /= Void
		do
			annotations := a_annotations
		ensure
			annotations_attached: annotations /= Void
		end

feature -- Implementation

	annotations: HASH_TABLE [LINKED_LIST [EXT_ANNOTATION], AST_PATH]
		assign set_annotations
			-- Annotations associated to ast path nodes.

end
