note
	description: "Summary description for {CA_BACKWARD_ITERATION_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_BACKWARD_ITERATION_RULE

inherit
	CA_RULE
	CA_BACKWARD_FEATURE_ITERATOR
		export {NONE}
			process_none_id_as
			-- TODO: more
		{CA_CODE_ANALYZER}
			process_class_as
		end

end
