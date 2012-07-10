note
	description: "Represents a query for objects of type G."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_QUERY [G -> ANY]

inherit

	ITERABLE [G]

	PS_QUERY [G]
		redefine
			set_criterion
		end

create
	make

feature -- Access

	result_cursor: PS_RESULT_SET [G]
			-- Iteration cursor containing the result of the query.

feature -- Status report

	is_object_query: BOOLEAN = True
			-- Is `Current' an instance of PS_OBJECT_QUERY?

feature -- Basic operations

	set_criterion (a_criterion: PS_CRITERION)
			-- Set the criteria `a_criterion', against which the objects will be selected.
		require else
			set_before_execution: not is_executed
			criterion_can_handle_objects: is_criterion_fitting_generic_type (a_criterion)
		do
			criteria := a_criterion
		end

feature -- Cursor generation

	new_cursor: PS_RESULT_SET [G]
			-- Return the result_cursor.
		do
			Result := result_cursor
		end

feature {NONE} -- Initialization

	make
			-- Create an new query on objects of type `G'.
		do
			initialize
		end

	create_result_cursor
			-- Create a new result set.
		do
			create result_cursor.make
		end

end
