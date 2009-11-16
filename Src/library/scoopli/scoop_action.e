indexing
	description: "Objects that represent action to be executed by processor"
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"
	
class
	SCOOP_ACTION

create
	make

feature {NONE} -- Initialization

	make (an_action: ROUTINE [ANY, TUPLE]) is
			-- Creation procedure.
		require
			an_action_not_void: an_action /= void
			target_not_void: an_action.target /= void
		do
			target := an_action.target
			action := an_action
		ensure
			target_set: target = an_action.target
			action_set: action = an_action
		end
		
feature -- Access

	target: ANY
	 		-- Object on which `action' will be called.

	action: ROUTINE [ANY, TUPLE]
	 		-- Routine to be executed.
	 		
invariant
	
	target_not_void: target /= void
	action_not_void: action /= void
		
end -- class ACTION