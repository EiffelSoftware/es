indexing
	description: "Meta information (name, outcomes, but not the actual implementation) of a CDD test routine"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINE

inherit

	KL_SHARED_STRING_EQUALITY_TESTER
		export
			{NONE} all
		end

	HASHABLE

create
	make

feature {NONE} -- Initialization

	make (a_test_class: like test_class; an_ast: like ast) is
			-- Initialize current.
		require
			a_test_class_not_void: a_test_class /= Void
			an_ast_not_void: an_ast /= Void
		do
			test_class := a_test_class
			set_ast (an_ast)
			hash_code := (test_class.test_class_name + "." + name).hash_code
			create internal_outcomes.make
			update
		ensure
			test_class_set: test_class = a_test_class
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
			regexp.set_caseless (True)
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

	name: STRING is
			-- Name of testable routine in `test_class'
		do
			Result := ast.feature_name.name
		ensure
			not_void: Result /= Void
			first_visual_in_ast: Result = ast.feature_names.first.visual_name
		end

	tags: DS_LINEAR [STRING] is
			-- Tags associated with this test routine
		do
			Result := internal_tags
		ensure
			not_void: Result /= Void
			valid: not Result.has (Void)
		end

	outcomes: DS_BILINEAR [CDD_TEST_EXECUTION_RESPONSE] is
			-- List of recorded test execution responses
			-- where last item is most recent.
		do
			Result := internal_outcomes
		ensure
			not_void: Result /= Void
			not_has_void: not Result.has (Void)
		end

	is_modified: BOOLEAN
			-- Has `Current' updated its tags since last call to `update' or `add_outcome'?

	hash_code: INTEGER
			-- Hash code for using `Current' in a hash table

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
			internal_outcomes.put_last (an_outcome)
			update
		ensure
			added: outcomes.last = an_outcome
		end

	set_ast (an_ast: like ast) is
			-- Set `ast' to `an_ast'.
		require
			an_ast_not_void: an_ast /= Void
		do
			ast := an_ast
		end

feature {CDD_TEST_CLASS} -- Update

	update is
			-- Update `tags' and set `is_modified' if tags have changed.
		local
			l_old_tags: like internal_tags
		do
			is_modified := False
			l_old_tags := internal_tags
			create internal_tags.make_default
			internal_tags.set_equality_tester (case_insensitive_string_equality_tester)
			internal_tags.merge (test_class.class_tags)
			add_implicit_tags
			add_explicit_tags
			if l_old_tags /= Void and then not l_old_tags.is_equal (internal_tags) then
				is_modified := True
			end
		end

feature {NONE} -- Implementation

	ast: FEATURE_AS
			-- Abstract syntax tree representation of `Current'

	internal_outcomes: DS_LINKED_LIST [CDD_TEST_EXECUTION_RESPONSE]
			-- List of recorded test execution responses
			-- where last item is most recent.

	internal_tags: DS_HASH_SET [STRING]
			-- Internal set of tags for `Current'

feature {NONE} -- Implementation

	add_explicit_tags is
			-- Add explicit indexing tags in `an_ast' to `internal_tags'.
		local
			l_ilist: INDEXING_CLAUSE_AS
			l_cs: CURSOR
			l_item: INDEX_AS
			l_value_list: EIFFEL_LIST [ATOMIC_AS]
			v: STRING
		do
			l_ilist := ast.indexes
			if l_ilist /= Void and then not l_ilist.is_empty then
				from
					l_cs := l_ilist.cursor
					l_ilist.start
				until
					l_ilist.after
				loop
					l_item := l_ilist.item
					if l_item.tag.name.is_equal ("tag") then
						from
							l_value_list := l_item.index_list
							l_value_list.start
						until
							l_value_list.after
						loop
							v := l_value_list.item.string_value.twin
							v.prune_all_leading ('"')
							v.prune_all_trailing ('"')
							internal_tags.force (v)
							l_value_list.forth
						end
					end
					l_ilist.forth
				end
				l_ilist.go_to (l_cs)
			end
		end

	add_implicit_tags is
			-- Add implicit and explicit tags found for
			-- `Current' to `internal_tags'.
		local
			l_tag: STRING
		do
			create l_tag.make (20)
			l_tag := "name."
			l_tag.append (test_class.test_class_name)
			l_tag.append_character ('.')
			l_tag.append (name)
			internal_tags.force (l_tag)
			if not outcomes.is_empty then
				create l_tag.make (20)
				l_tag.append ("outcome.")
				l_tag.append (outcomes.last.text)
				internal_tags.force (l_tag)
			end
		end

invariant
	test_class_not_void: test_class /= Void
	routine_name_not_void: name /= Void
	ast_not_void: ast /= Void
	internal_outcomes_valid: internal_outcomes /= Void and then not internal_outcomes.has (Void)
	internal_tags_valid: internal_tags /= Void and then not internal_tags.has (Void) and then
		internal_tags.equality_tester = case_insensitive_string_equality_tester

end
