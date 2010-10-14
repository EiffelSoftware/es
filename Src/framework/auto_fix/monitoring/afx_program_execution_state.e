note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_STATE

create
	make_with_state_and_bp_index

feature -- Initialization

	make_with_state_and_bp_index (a_state: EPA_STATE; a_index: INTEGER)
			-- Initialization.
		do
			set_state (a_state)
			set_breakpoint_slot_index (a_index)
		end

feature -- Access

	state: EPA_STATE assign set_state
			-- State.

	breakpoint_slot_index: INTEGER assign set_breakpoint_slot_index
			-- Breakpoint slot index where the state is observed.

feature{NONE} -- Status set

	set_state (a_state: EPA_STATE)
			-- Set `state'.
		do
			state := a_state
		end

	set_breakpoint_slot_index (a_index: INTEGER)
			-- Set `breakpoint_slot_index'.
		do
			breakpoint_slot_index := a_index
		end

invariant
	state_attached: state /= Void
	valid_index: breakpoint_slot_index > 0 and then breakpoint_slot_index <= state.feature_.number_of_breakpoint_slots

end
