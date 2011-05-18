note
	description: "[
		This class represents annotations associated with a break point location
		from some AST node.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_ANNOTATION

inherit
	EPA_SHARED_EQUALITY_TESTERS

	HASHABLE

feature -- Access

	breakpoint_slot: INTEGER
			-- Breakpoint slot to which current annotation is associated

	pre_state: EPA_HASH_SET [EPA_EQUATION]
			-- Annotations in pre-state
		do
			if pre_state_internal = Void then
				create pre_state_internal.make (20)
				pre_state_internal.set_equality_tester (equation_equality_tester)
			end
			Result := pre_state_internal
		end

	post_state: EPA_HASH_SET [EPA_EQUATION]
			-- Annotations in post-state
		do
			if post_state_internal = Void then
				create post_state_internal.make (20)
				post_state_internal.set_equality_tester (equation_equality_tester)
			end
			Result := post_state_internal
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := breakpoint_slot
		ensure then
			good_result: Result = breakpoint_slot
		end

feature -- Setting

	set_breakpoint_slot (b: INTEGER)
			-- Set `breakpoint_slot' with `b'.
		require
			b_non_negative: b >= 0
		do
			breakpoint_slot := b
		ensure
			breakpoint_slot_set: breakpoint_slot = b
		end

feature{NONE} -- Implimentation

	pre_state_internal: like pre_state
			-- Cache for `pre_state'

	post_state_internal: like post_state
			-- Cache for `post_state'

end
