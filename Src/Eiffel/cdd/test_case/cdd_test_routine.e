indexing
	description: "Meta information (name, outcomes, but not the actual implementation) of a CDD test routine"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINE

inherit

	HASHABLE

create
	make

feature {NONE} -- Initialization

	make (a_test_class: like test_class; a_routine_name: STRING) is
			-- Initialize current with `a_test_class' as `test_class'
			-- and `a_routine_name' as `name'.
		require
			a_test_class_not_void: a_test_class /= Void
			a_routines_name_valid: a_routine_name /= Void and then not a_routine_name.is_empty
		do
			test_class := a_test_class
			name := a_routine_name
			create outcomes.make
			create refresh_actions
			create {DS_ARRAYED_LIST[STRING]} tags.make (3)
		ensure
			test_class_set: test_class = a_test_class
			routine_name_set: name = a_routine_name
		end

feature -- Status report

	has_matching_tag (a_pattern: STRING): BOOLEAN is
			-- Does routine have a tag that matches `a_pattern'?
			-- A tag matches a pattern if the tag contains the pattern (substring).
		require
			a_pattern_not_void: a_pattern /= Void
		local
			cs: DS_LINEAR_CURSOR [STRING]
			regexp: RX_PCRE_REGULAR_EXPRESSION
		do
			create regexp.make
			regexp.compile (a_pattern)
			from
				cs := tags.new_cursor
				cs.start
			until
				cs.off or Result
			loop
				if regexp.matches (cs.item) then
					Result := True
				else
					cs.forth
				end
			end
			cs.go_after
		end

feature -- Access

	test_class: CDD_TEST_CLASS
			-- Class which contains `Current'

	name: STRING
			-- Name of testable routine in `test_class'

	tags: DS_LIST [STRING]
			-- Tags associated with this test routine

	outcomes: DS_LINKED_LIST [CDD_TEST_EXECUTION_RESPONSE]
			-- List of recorded test execution responses where last item
			-- is most recent.

	hash_code: INTEGER is
			-- Hash code value
		do
			Result := name.hash_code
		end

	tags_with_prefix (a_prefix: STRING): DS_ARRAYED_LIST [STRING] is
			-- List of tags with prefix `a_prefix'
		require
			a_prefix_not_void: a_prefix /= Void
		local
			cs: DS_LINEAR_CURSOR [STRING]
			item: STRING
			count: INTEGER
		do
			from
				create Result.make (5)
				cs := tags.new_cursor
				cs.start
				count := a_prefix.count
			until
				cs.off
			loop
				item := cs.item
				if item.count >= count and item.substring (1, count).is_equal (a_prefix) then
					Result.force_last (item)
				end
				cs.forth
			end
		ensure
			list_not_void: Result /= Void
			list_doesnt_have_void: not Result.has (Void)
		end

feature -- Element change

	add_outcome (an_outcome: CDD_TEST_EXECUTION_RESPONSE) is
			-- Add `an_outcome' to `outcomes' and notify observers.
		require
			an_outcome_not_void: an_outcome /= Void
		do
			outcomes.put_last (an_outcome)
			refresh_actions.call ([])
		ensure
			added: outcomes.last = an_outcome
		end

feature -- Event handling	

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when test classes or routines have been removed or added	

invariant
	test_class_not_void: test_class /= Void
	routine_name_not_void: name /= Void
	outcomes_valid: outcomes /= Void and then not outcomes.has (Void)
	tags_not_void: tags /= Void
	tags_doesnt_have_void: not tags.has (Void)

end
