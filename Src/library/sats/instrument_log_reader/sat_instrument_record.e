indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 74021 $"

class
	SAT_INSTRUMENT_RECORD

inherit
	HASHABLE

feature{NONE} -- Initialization

	make_with_slot_and_time (a_slot: like slot; a_time: like time) is
			-- Initialize Current.
		do
			set_slot (a_slot)
			set_time (a_time)
		end

feature -- Access

	time: INTEGER
			-- Time in second when Current record is logged.
			-- Seconds start from time base

	slot: INTEGER
			-- Index of slot of Current record

	test_case_index: INTEGER
			-- Index of test case

	hash_code: INTEGER
			-- Hash code value
		do
			Result := test_case_index
		ensure then
			good_result: Result = test_case_index
		end

feature -- Status report

	is_in_same_test_case (other: like Current): BOOLEAN is
			-- Is `other' in the same test case as `Current'?
		require
			other_attached: other /= Void
		do
			Result := test_case_index = other.test_case_index
		ensure
			good_result: Result = (test_case_index = other.test_case_index)
		end

feature -- Setting

	set_time (a_time: INTEGER) is
			-- Set `time' with `a_time'.
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

	set_slot (a_slot: INTEGER) is
			-- Set `slot' with `a_slot'.
		do
			slot := a_slot
		ensure
			slot_set: slot = a_slot
		end

	set_test_case_index (a_test_case_index: INTEGER) is
			-- Set `test_case_index' with `a_test_case_index'.
		do
			test_case_index := a_test_case_index
		ensure
			test_case_index_set: test_case_index = a_test_case_index
		end

end
