note
	description: "Represents a repository query that returns stored objects"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_QUERY [G -> ANY]

inherit
	PS_QUERY [G]
		redefine
			set_criterion
		end

	ITERABLE[G]
--		rename new_cursor
--			as result_cursor
--		end
-- renames don't seem to work with the across syntax...

create make


feature {NONE} -- Initialization

	make
			-- Create an new query on objects of type `G'.
		do
			initialize
		end

	create_result_cursor
		do
			create result_cursor.make
		end

feature

	set_criterion (a_criterion: PS_CRITERION)
			-- Set the criteria `a_criterion', against which the objects will be selected
		require else
			set_before_execution: not is_executed
			criterion_can_handle_objects: is_criterion_fitting_generic_type (a_criterion)
		do
			criteria := a_criterion
		end


	result_cursor: PS_RESULT_SET[G]

	new_cursor: PS_RESULT_SET[G]
		-- Just return the result_cursor.
		do
			Result:= result_cursor
		end

	is_object_query:BOOLEAN = True
			-- Is `Current' an instance of PS_OBJECT_QUERY?


end
