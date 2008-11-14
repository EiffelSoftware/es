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
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			l_class := system.class_of_id (a_node.written_in)
			l_feature := l_class.feature_of_feature_id (a_node.feature_id)
			l_attached_feature ?= l_feature
			check l_feature /= Void end
			Result := name_generator.functional_feature_name (l_attached_feature)
		end

	local_name (a_node: LOCAL_B): STRING
			-- Name of local in Boogie code
		do

		end

end
