indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FORALL_NAME_MAPPER

inherit

	EP_NORMAL_NAME_MAPPER
		redefine
			make,
			heap_name,
			result_name
		end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do
			internal_current_name := "current"
		end

feature -- Access

	heap_name: STRING
			-- Name of heap in Boogie code
		do
			Result := "heap"
		end

	result_name: STRING
			-- Name of result reference in Boogie code
		do
			Result := "Result"
		end

end
