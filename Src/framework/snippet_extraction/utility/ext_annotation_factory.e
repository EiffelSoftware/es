note
	description: "Factory class to create annotation objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ANNOTATION_FACTORY

create
	make

feature -- Initialization

	make
			-- Default initialization.
		do
			reset_hole_id_counter
		end

feature -- Access

	new_ann_prune: EXT_ANNOTATION
		do
			create {EXT_ANN_PRUNE} Result
		end

	new_ann_hole (a_mentions_set: LINKED_SET [STRING]): EXT_ANNOTATION
		local
			l_hole_annotation: EXT_ANN_HOLE
		do
				-- Create and setup `{EXT_ANN_HOLE}' typed annotation.
			create l_hole_annotation
			l_hole_annotation.set_hole_id (next_hole_id)
			l_hole_annotation.set_mentions_set (a_mentions_set)

				-- Set result of general type `{EXT_ANNOTATION}'.
			Result := l_hole_annotation
		end

	new_ann_flatten_retain_if: EXT_ANNOTATION
		do
			create {EXT_ANN_FLATTEN} Result.make_with_mode ({EXT_ANN_FLATTEN}.retain_if)
		end

	new_ann_flatten_retain_else: EXT_ANNOTATION
		do
			create {EXT_ANN_FLATTEN} Result.make_with_mode ({EXT_ANN_FLATTEN}.retain_else)
		end

	next_hole_id: NATURAL
			-- Returns an identifier for a newly created `{EXT_ANN_HOLE}' and increases the counter by one.
		do
			Result := next_hole_id_counter
			next_hole_id_counter := next_hole_id_counter + 1
		end

	reset_hole_id_counter
			-- Resets counter to default value, hence `next_hole_id' will return that value a next call.
		do
			next_hole_id_counter := 1
		end

feature {NONE}

	next_hole_id_counter: NATURAL
			-- Counter value to be used for as identifier for a newly created `{EXT_ANN_HOLE}'.	

end
