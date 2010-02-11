note
	description: "Summary description for {AFX_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX

inherit
	DEBUG_OUTPUT
		undefine
			is_equal
		end

	HASHABLE
		redefine
			is_equal
		end

	REFACTORING_HELPER
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_spot: like exception_spot; a_id: INTEGER)
			-- Initialize.
		require
			a_spot_attached: a_spot /= Void
		do
			exception_spot := a_spot
			text := ""
			feature_text := ""
			id := a_id
		end

feature -- Access

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception related information

	text: STRING
			-- Text of the feature body containing current fix

	feature_text: STRING
			-- Text of the whole feature `exception_spot'.`recipient'

	ranking: AFX_FIX_RANKING
			-- Ranking for current fix

	precondition: detachable AFX_STATE
			-- Precondition of the snippet part of current fix

	postcondition: detachable AFX_STATE
			-- Postcondition of the snippet part of current fix

	recipient_: FEATURE_I
			-- Recipient of current fault
		do
			Result := exception_spot.recipient_
		end

	recipient_class: CLASS_C
			-- Class of `recipient_'
		do
			Result := exception_spot.recipient_class_
		end

	origin_recipient: FEATURE_I
			-- Origin recipient
		do
			Result := exception_spot.origin_recipient
		end

	recipient_written_class: CLASS_C
			-- Written class of `recipient'
		do
			Result := exception_spot.recipient_written_class
		end


	id: INTEGER
			-- ID of current fix

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id
		ensure then
			good_result: Result = id
		end

	pre_fix_execution_status: detachable HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]
			-- Table to store test case execution status before applying current fix
			-- Key is test case UUID, value is the execution status
			-- associated with that test case

	post_fix_execution_status: detachable HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]
			-- table to store test case execution status when applying current fix
			-- Key is test case UUID, value is the execution status
			-- associated with that test case

	impact_on_passing_test_cases: DOUBLE
			-- Impact of current fix on passing test cases.
			-- Calculated from `pre_fix_execution_status' and `post_fix_execution_status'.
			-- Value is the mean of the distances between the post states of all passing test cases.
			-- The smaller the value, the better.
		local
			l_pre_status: AFX_TEST_CASE_EXECUTION_STATUS
			l_post_status: AFX_TEST_CASE_EXECUTION_STATUS
			l_done: BOOLEAN
			l_passing_tc: INTEGER
			l_distance_sum: DOUBLE
		do
			fixme ("Better impact formula is needed. 26.12.2009 Jasonw")
			if
				attached {HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]} pre_fix_execution_status as l_pre and then
				attached {HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]} post_fix_execution_status as l_post
			then
				from
					l_pre.start
				until
					l_pre.after or l_done
				loop
					l_pre_status := l_pre.item_for_iteration
					l_post_status := l_post.item (l_pre.key_for_iteration)
					fixme ("l_pre_status and l_post_status should always be attached. 26.1.2010 Jasonw")
					if l_pre_status /= Void and then l_post_status /= Void then
						if  attached {AFX_STATE} l_pre_status.post_state as l_pre_post then
							l_passing_tc := l_passing_tc + 1
							if attached {AFX_STATE} l_post_status.post_state as l_post_post then
									-- Current test case is passing before and after current fix.
								l_distance_sum := l_distance_sum + l_pre_status.post_state_distance (l_post_status).to_double
							else
									-- Current test case passed before current fix and failed after current fix.
								l_done := True
								Result := max_impact_on_passing_test_cases
							end
						else
							-- Current test case failed before current fix.
						end
					end
					l_pre.forth
				end
				if not l_done then
					if l_passing_tc = 0 then
						Result := 0
					else
						Result := l_distance_sum / l_passing_tc.to_double
					end
				end
			else
				Result := max_impact_on_passing_test_cases
			end
		end

	max_impact_on_passing_test_cases: DOUBLE = 10000.0
			-- Max impact on passing test cases

	skeleton_type: NATURAL_8
			-- Type of fix skeleton

feature -- Constants

	afore_skeleton_type: NATURAL_8 = 1
	wrapping_skeleton_type: NATURAL_8 = 2
			-- Fix skeleton type constants

feature -- Status report

	is_valid: BOOLEAN
			-- Is current a valid fix?

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := id ~ other.id
		end

feature -- Setting

	set_text (a_text: STRING)
			-- Set `text' with `a_text'.
		do
			text := a_text.twin
		end

	set_feature_text (a_text: STRING)
			-- Set `feature_text' with `a_text'.
		do
			feature_text := a_text.twin
			feature_text.replace_substring_all ("%R", "")
		end

	set_exception_spot (a_spot: like exception_spot)
			-- Set `exception_spot' with `a_spot'.
		do
			exception_spot := a_spot
		end

	set_ranking (a_ranking: like ranking)
			-- Set `ranking' with `a_ranking'.
		do
			ranking := a_ranking
		end

	set_precondition (a_precondition: like precondition)
			-- Set `precondition' with `a_precondition'.
		do
			precondition := a_precondition
		ensure
			precondition_set: precondition = a_precondition
		end

	set_postcondition (a_postcondition: like postcondition)
			-- Set `postcondition' with `a_postcondition'.
		do
			postcondition := a_postcondition
		ensure
			postcondition_set: postcondition = a_postcondition
		end

	set_pre_fix_execution_status (a_status: like pre_fix_execution_status)
			-- Set `pre_fix_execution_status' with `a_status'.
		do
			pre_fix_execution_status := a_status
			synchonize_pre_state
		ensure
			pre_fix_execution_status_set: pre_fix_execution_status = a_status
		end

	set_post_fix_execution_status (a_status: like post_fix_execution_status)
			-- Set `post_fix_execution_status' with `a_status'.
		do
			post_fix_execution_status := a_status
			synchonize_pre_state
		ensure
			post_fix_execution_status_set: post_fix_execution_status = a_status
		end

	set_is_valid (b: BOOLEAN)
			-- Set `is_valid' with `b'.
		do
			is_valid := b
		ensure
			is_valid_set: is_valid = b
		end

	set_skeleton_type (t: NATURAL_8)
			-- Set `skeleton_type' with `t'.
		require
			t_valid: t = afore_skeleton_type or t = wrappinG_skeleton_type
		do
			skeleton_type := t
		ensure
			skeleton_type_set: skeleton_type = t
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := feature_text
		end

	information: STRING
			-- Information about Current fix
		do
			create Result.make (1024)
			Result.append ("Exception: ")
			Result.append (exception_spot.id)
			Result.append_character ('%N')

			Result.append ("Precondition:%N")
			if attached {AFX_STATE} precondition as l_pre then
				Result.append (l_pre.debug_output)
			else
				Result.append ("Void%N")
			end

			Result.append ("Postcondition:%N")
			if attached {AFX_STATE} postcondition as l_post then
				Result.append (l_post.debug_output)
			else
				Result.append ("Void%N")
			end

			Result.append ("Ranking: " + ranking.syntax_score.out + "%N")
		end

feature{NONE} -- Implementation

	synchonize_pre_state
			-- Synchronize pre exeuction state between `pre_fix_execution_status' and `post_fix_execution_status'.
		do
			if
				attached {like pre_fix_execution_status} pre_fix_execution_status as l_pre and then
				attached {like post_fix_execution_status} post_fix_execution_status as l_post
			then
				from
					l_pre.start
				until
					l_pre.after
				loop
					if l_post.has (l_pre.key_for_iteration) then
						l_post.item (l_pre.key_for_iteration).set_pre_state (l_pre.item_for_iteration.pre_state)
					end
					l_pre.forth
				end
			end
		end

end
