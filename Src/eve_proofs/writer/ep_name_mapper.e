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

	current_name: STRING
			-- Name of current reference in Boogie code
		deferred
		end

	result_name: STRING
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

feature -- Element change

	set_current_name (a_name: STRING)
			-- Set `current_name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			current_name_set: current_name.is_equal (a_name)
		end

end
