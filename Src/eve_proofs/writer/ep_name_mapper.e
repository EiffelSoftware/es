indexing
	description:
		"[
			Name mapping for varibales
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class EP_NAME_MAPPER

inherit {NONE}

	SHARED_SERVER
		export {NONE} all end

feature -- Access

	heap_name: STRING
			-- Name of heap in Boogie code
		deferred
		end

	current_name (a_node: CURRENT_B): STRING
			-- Name of current reference in Boogie code
		deferred
		end

	result_name (a_node: RESULT_B): STRING
			-- Name of result reference in Boogie code
		deferred
		end

	argument_name (a_node: ARGUMENT_B): STRING
			-- Name of argument in Boogie code
		deferred
		end

	feature_name (a_node: FEATURE_B): STRING
			-- Name of feature in Boogie code
		deferred
		end

	local_name (a_node: LOCAL_B): STRING
			-- Name of local in Boogie code
		deferred
		end

end
