note
	description: "Summary description for {EXT_SHARED_ANNOTATIONS}."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SHARED_ANNOTATIONS

inherit
	REFACTORING_HELPER

feature -- Access	

	reset_annotations
			-- Reset shared annotation data structures.	
		do
			annotations.wipe_out
		end

	annotation_factory: EXT_ANNOTATION_FACTORY
			-- Annotation factory to create new typed annotation instances.
		once
			create Result
		end


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

	has_annotation_prune (location: AST_PATH): BOOLEAN
		do
			Result := annotations.has (location) and then
						across annotations.item (location) as l_annotations some attached {EXT_ANN_PRUNE} l_annotations.item end
		end

	has_annotation_flatten (location: AST_PATH; mode: STRING): BOOLEAN
		do
			Result := annotations.has (location) and then
						across annotations.item (location) as l_annotations
							some attached {EXT_ANN_FLATTEN} l_annotations.item as l_ann_flatten and then l_ann_flatten.mode = mode
						end
		end

feature -- Implementation

	annotations: HASH_TABLE [LINKED_LIST [EXT_ANNOTATION], AST_PATH]
			-- Annotations associated to ast path nodes.
		once
			create Result.make (10)
			Result.compare_objects
		end

end
