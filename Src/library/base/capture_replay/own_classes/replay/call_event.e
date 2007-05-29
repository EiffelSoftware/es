indexing
	description: "[
					Common interface for call events.
					]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CALL_EVENT

inherit
	EVENT

feature -- Creation

	make(a_target: NON_BASIC_ENTITY; a_feature_name: STRING; the_arguments: DS_LIST[ENTITY])
			-- Make the event of the call `a_target'.`a_feature_name'(`the_arguments').
		require
			a_target_not_void: a_target /= Void
			a_feature_name_not_void: a_feature_name /= Void
			the_arguments_not_void: the_arguments /= Void
		do
				target := a_target
				feature_name := a_feature_name
				arguments := the_arguments
		end

feature -- Access

	target: NON_BASIC_ENTITY
		-- The target of the call
		-- Note:	can't be a basic entity, because these classes won't be
		--			instrumented and thus will never receive calls.

	feature_name: STRING
		-- The name of the called feature.

	arguments: DS_LIST[ENTITY]
		-- The arguments of the called feature.

invariant
		target_not_void: target /= Void
		feature_name_not_void: feature_name /= Void
		arguments_not_void: arguments /= Void

end
