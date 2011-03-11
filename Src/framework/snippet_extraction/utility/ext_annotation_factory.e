note
	description: "Factory class to create annotation objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ANNOTATION_FACTORY

feature -- Access

	new_ann_prune: EXT_ANNOTATION
		do
			create {EXT_ANN_PRUNE} Result
		end

	new_ann_hole: EXT_ANNOTATION
		do
			create {EXT_ANN_HOLE} Result
		end

end
