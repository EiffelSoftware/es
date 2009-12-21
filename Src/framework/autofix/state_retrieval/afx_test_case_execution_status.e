note
	description: "Summary description for {AFX_TEST_CASE_EXECUTION_STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_EXECUTION_STATUS

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make,
	make_with_data

feature{NONE} -- Initialization

	make (a_info: like info; a_uuid: like uuid)
			-- Initialize Current.
		do
			info := a_info
			uuid := a_uuid.twin
		end

	make_with_data (a_info: like info; a_pre_state: like pre_state; a_post_state: like post_state; a_uuid: like uuid)
			-- Initialize Current.
		do
			make (a_info, a_uuid)
			set_pre_state (a_pre_state)
			set_post_state (a_post_state)
		end

feature -- Access

	info: AFX_TEST_CASE_INFO
			-- Information of current test case

	pre_state: AFX_STATE
			-- State before current test case is executed

	post_state: detachable AFX_STATE
			-- State after current test case is executed
			-- Void if current is a failing test case.

	uuid: STRING
			-- Universal identifier for Current test case

	first_break_point_slot: INTEGER
			-- Index of the first break point slot.
			-- Include those of pre/post conditions.
		do
			Result := info.first_break_point_slot
		end

	last_break_point_slot: INTEGER
			-- Index of the last break point slot.
			-- Include those of pre/post conditions.
		do
			Result := info.last_break_point_slot
		end

	data_as_string: TUPLE [tc_info: AFX_TEST_CASE_INFO; pre_state: detachable STRING; post_state: detachable STRING]
			-- Strings representing Current
		local
			l_pre_str: detachable STRING
			l_post_str: detachable STRING
		do
			if attached {AFX_STATE} pre_state as l_pre then
				l_pre_str := l_pre.debug_output
			end
			if attached {AFX_STATE} post_state as l_post then
				l_post_str := l_post.debug_output
			end
			check l_pre_str /= Void end
			Result := [info, l_pre_str, l_post_str]
		end

feature -- Status report

	is_passing: BOOLEAN
			-- Is current test case passing?
		do
			Result := info.is_passing
		end

	is_failing: BOOLEAN
			-- Is current test case failing?
		do
			Result := info.is_failing
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := uuid ~ other.uuid
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := uuid.hash_code
		end

feature -- Setting

	set_pre_state (a_state: like pre_state)
			-- Set `pre_state' with `a_state'.
		require
			a_state_attached: a_state /= Void
		do
			pre_state := a_state
		ensure
			pre_state_set: pre_state = a_state
		end

	set_post_state (a_state: like post_state)
			-- Set `post_state' with `a_state'.
		do
			post_state := a_state
		ensure
			post_state_set: post_state = a_state
		end

end
