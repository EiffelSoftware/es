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

	new_ann_flatten_retain_if: EXT_ANNOTATION
		do
			create {EXT_ANN_FLATTEN} Result.make_with_mode ({EXT_ANN_FLATTEN}.retain_if)
		end

	new_ann_flatten_retain_else: EXT_ANNOTATION
		do
			create {EXT_ANN_FLATTEN} Result.make_with_mode ({EXT_ANN_FLATTEN}.retain_else)
		end

end
