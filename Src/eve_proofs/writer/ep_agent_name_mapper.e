indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_AGENT_NAME_MAPPER

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
			internal_current_name := "Current"
			internal_heap_name := "Heap"
			internal_target_name := "Current"
			internal_result_name := "Result"
		end

feature -- Access

	current_feature: !FEATURE_I
			-- Current feature where mapping is made

	heap_name: STRING
			-- Name of heap in Boogie code
		do
			Result := internal_heap_name
		end

	current_name: STRING
			-- Name of current reference in Boogie code
		do
			Result := internal_current_name
		end

	target_name: STRING
			-- Name of current reference in Boogie code
		do
			Result := internal_target_name
		end

	result_name: STRING
			-- Name of result reference in Boogie code
		do
			Result := internal_result_name
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
			Result := name_generator.local_name (a_node.position)
		end

feature -- Element change

	set_current_feature (a_feature: like current_feature)
			-- Set `current_feature' to `a_feature'.
		do
			current_feature := a_feature
		ensure
			current_feature_set: current_feature = a_feature
		end

	set_current_name (a_name: STRING)
			-- Set `current_name' to `a_name'.
		do
			internal_current_name := a_name
		end

	set_heap_name (a_name: STRING)
			-- Set `heap_name' to `a_name'.
		do
			internal_heap_name := a_name
		end

	set_target_name (a_name: STRING)
			-- Set `target_name' to `a_name'.
		do
			internal_target_name := a_name
		end

	set_result_name (a_name: STRING)
			-- Set `result_name' to `a_name'.
		do
			internal_result_name := a_name
		end

feature {NONE} -- Implementation

	internal_current_name: STRING
			-- TODO

	internal_heap_name: STRING
			-- TODO

	internal_target_name: STRING
			-- TODO

	internal_result_name: STRING
			-- TODO

end
