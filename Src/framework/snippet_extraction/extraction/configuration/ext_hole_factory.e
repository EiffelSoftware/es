note
	description: "Factory class to instantiate holes."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_HOLE_FACTORY

create
	make

feature -- Initialization

	make
			-- Default initialization.
		do
			reset_hole_id_counter
		end

feature -- Access

	new_hole (a_annotations: LINKED_SET [EXT_MENTION_ANNOTATION]): EXT_HOLE
		do
				-- Create and setup `{EXT_HOLE}'.
			create Result
			Result.set_hole_id (next_hole_id)
			Result.set_annotations (a_annotations)
		end

	next_hole_id: NATURAL
			-- Returns an identifier for a newly created `{EXT_HOLE}' and increases the counter by one.
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
			-- Counter value to be used for as identifier for a newly created `{EXT_HOLE}'.	

end
