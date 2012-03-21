note
	description: "Represents a repository query that returns stored objects"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_QUERY [G -> ANY]
inherit
	PS_QUERY [G]
		redefine set_criterion, query_result end

create make


feature

	set_criterion (a_criterion: PS_CRITERION)
			-- Set the criteria `a_criterion', against which the objects will be selected
		require else
			set_before_execution: not is_executed
			criterion_can_handle_objects: is_criterion_fitting_generic_type (a_criterion)
		do
			criteria := a_criterion
		end


	query_result: PS_RESULT_SET[G]

	is_object_query:BOOLEAN = True
			-- Is `Current' an instance of PS_OBJECT_QUERY?


end
