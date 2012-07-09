note
	description: "Class to (post) process collected runtime data."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_ONLINE_PROCESSOR

inherit
	DPA_OFFLINE_PROCESSOR
		redefine
			make,
			process
		end

create
	make

feature {NONE} -- Initialization

	make (a_program_locations: like program_locations; a_post_state_map: like post_state_map; a_debugger_manager: like debugger_manager)
			-- Initialize Current.
		do
			Precursor (a_program_locations, a_post_state_map, a_debugger_manager)
			threshold := 5000
		ensure then
			threshold_set: threshold = 5000
		end

feature -- Access

	threshold: INTEGER
			--

	callback_function: PROCEDURE [ANY, TUPLE]
			--

feature -- Setting

	set_treshold (a_treshold: like threshold)
			--
		require
			a_treshold_valid: a_treshold > 0
		do
			threshold := a_treshold
		ensure
			threshold_set: threshold = a_treshold
		end

	set_callback_function (a_callback_function: like callback_function)
			--
		require
			a_callback_function_not_void: a_callback_function /= Void
		do
			callback_function := a_callback_function
		ensure
			callback_function_set: callback_function = a_callback_function
		end

feature {EPA_DYNAMIC_ANALYSIS_CMD} -- Process

	process (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Add `a_bp' and `a_state' to `collected_states'.
		local
			l_temp_list: ARRAYED_LIST [TUPLE [INTEGER, INTEGER, EPA_STATE]]
		do
			Precursor (a_bp, a_state)
			if collected_states.count > threshold then
				post_process
				callback_function.call ([])
				create l_temp_list.make (0)
				l_temp_list.extend (collected_states.last)
				collected_states := l_temp_list
			end
		end

end
