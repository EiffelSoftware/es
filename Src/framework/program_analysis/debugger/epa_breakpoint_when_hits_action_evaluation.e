note
	description: "Class to evaluate a set of expressions at a break point"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_BREAKPOINT_WHEN_HITS_ACTION_EVALUATION

inherit
	BREAKPOINT_WHEN_HITS_ACTION_I

	EPA_DEBUGGER_UTILITY

feature -- Access

	on_hit_actions: ACTION_SEQUENCE [TUPLE [a_breakpoint: BREAKPOINT; a_state: EPA_STATE]]
			-- List of actions to be performed when current is hit
		note
     		option: transient
   		attribute
   		end

	class_: CLASS_C
			-- Class from which Current state is derived
		note
     		option: transient
   		attribute
   		end

	feature_: detachable FEATURE_I
			-- Feature from which Current state is derived
			-- If Void, it means that Current state is derived for the whole class,
			-- instead of particular feature.
		note
     		option: transient
   		attribute
   		end

feature -- Basic operations

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
			-- Execute when `a_bp' is hit inside `a_dm'.
		deferred
		end

end
