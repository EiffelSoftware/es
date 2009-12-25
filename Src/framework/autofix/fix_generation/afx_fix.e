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

			Result.append ("Ranking: " + ranking.score.out + "%N")
		end

end
