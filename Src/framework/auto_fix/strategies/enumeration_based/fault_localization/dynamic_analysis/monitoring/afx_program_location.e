class
	AFX_PROGRAM_LOCATION

inherit
	EPA_HASH_CALCULATOR
		redefine
			is_equal
		end

create
	make,
	make_entry,
	make_exit

feature{NONE} 	-- Initialization

	make (a_context: EPA_FEATURE_WITH_CONTEXT_CLASS; a_breakpoint: INTEGER)
			-- Initialization.
		require
			context_attached: a_context /= Void
			valid_breakpoint: 1 <= a_breakpoint and then a_breakpoint <= a_context.feature_.number_of_breakpoint_slots
		do
			context := a_context
			breakpoint_index := a_breakpoint
		ensure
			context_set: context = a_context
			breakpoint_index_set: breakpoint_index = a_breakpoint
		end

	make_entry (a_context: EPA_FEATURE_WITH_CONTEXT_CLASS)
			-- Initialization.
		require
			context_attached: a_context /= Void
		do
			context := a_context
			breakpoint_index := Entry_breakpoint_index
		ensure
			context_set: context = a_context
			is_entry: is_entry_location
		end

	make_exit (a_context: EPA_FEATURE_WITH_CONTEXT_CLASS)
			-- Initialization.
		require
			context_attached: a_context /= Void
		do
			context := a_context
			breakpoint_index := Exit_breakpoint_index
		ensure
			context_set: context = a_context
			is_exit: is_exit_location
		end

feature 		-- Access

	context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Context feature containing the location.

	breakpoint_index: INTEGER
			-- Breakpoint index of the location inside the `context'.

feature			-- Status report

	is_entry_location: BOOLEAN
			-- Is location the entry of `context'?
		do
			Result := breakpoint_index = Entry_breakpoint_index
		end

	is_exit_location: BOOLEAN
			-- Is location the exit of `context'?
		do
			Result := breakpoint_index = Exit_breakpoint_index
		end

	is_boundary_location: BOOLEAN
			-- Is location the entry or the exit of `context'?
		do
			Result := is_entry_location or else is_exit_location
		end

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := context ~ other.context and then breakpoint_index = other.breakpoint_index
		end

feature			-- Override

	key_to_hash: DS_LINEAR [INTEGER_32]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER_32]
		do
			create l_list.make (3)
			l_list.force_last (context.feature_.feature_name_id)
			l_list.force_last (context.context_class.class_id)
			l_list.force_last (breakpoint_index)
			Result := l_list
		end

feature			-- Constant

	Entry_breakpoint_index: INTEGER =  0
			-- Breakpoint index for feature entry.

	Exit_breakpoint_index:  INTEGER = -1
			-- Breakpoint index for feature exit.


invariant

	context_attached: context /= Void

	valid_breakpoint_index: is_boundary_location or else
			(0 < breakpoint_index and then breakpoint_index <= context.feature_.number_of_breakpoint_slots)
end
