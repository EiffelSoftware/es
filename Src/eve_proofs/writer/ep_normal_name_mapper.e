indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_NORMAL_NAME_MAPPER

inherit

	EP_NAME_MAPPER

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do

		end

feature -- Access

	current_feature: !FEATURE_I
			-- Current feature where mapping is made

	heap_name: STRING
			-- Name of heap in Boogie code
		do
			Result := "Heap"
		end

	current_name (a_node: CURRENT_B): STRING
			-- Name of current reference in Boogie code
		do
			Result := "Current"
		end

	result_name (a_node: RESULT_B): STRING
			-- Name of result reference in Boogie code
		do
			Result := "Result"
		end

	argument_name (a_node: ARGUMENT_B): STRING
			-- Name of argument in Boogie code
		do
			Result := name_generator.argument_name (current_feature.arguments.item_name (a_node.position))
		end

	feature_name (a_node: FEATURE_B): STRING
			-- Name of feature in Boogie code
		do

		end

	local_name (a_node: LOCAL_B): STRING
			-- Name of local in Boogie code
		do

		end

end
