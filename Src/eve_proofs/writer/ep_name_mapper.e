indexing
	description:
		"[
			Name mapping for varibales
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class EP_NAME_MAPPER

inherit

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

	target_name: STRING
			-- Name of target for nested feature invocations
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

	set_heap_name (a_name: STRING)
			-- Set `heap_name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			heap_name_set: heap_name.is_equal (a_name)
		end

	set_target_name (a_name: STRING)
			-- Set `target_name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			target_name_set: target_name.is_equal (a_name)
		end

	set_result_name (a_name: STRING)
			-- Set `result_name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			result_name_set: result_name.is_equal (a_name)
		end

end
