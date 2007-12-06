indexing
	description: "Objects that represent a pattern for filtering test routines in some test suite"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_FILTER_PATTERN

feature {NONE} -- Initialization

	make is
			-- Create a filter for `a_test_suite'.
		do
			set_including
			set_tag_code (any_code)
			create tokens.make
		ensure
			including: is_including
			tag_code_is_any: tag_code = any_code
		end

feature -- Access

	is_including: BOOLEAN

	tag_code: INTEGER
			-- For what kind of tags does `Current' apply to?

	cnf_code, outcome_code, others_code, any_code: INTEGER is unique
			-- Valid codes for `tag_code'

	is_valid_code (a_code: like tag_code): BOOLEAN is
			-- Is `a_code' a valid tag code?
		do
			Result := tag_code = cnf_code or tag_code = outcome_code or tag_code = others_code or tag_code = any_code
		end

	tokens: DS_LINKED_LIST [STRING]
			-- List of regular expressions for evaluating the pattern
			-- with respect to `tag_code'

feature -- Status settings

	set_tag_code (a_code: like tag_code) is
			-- Set `tag_code' to `a_code'.
		require
			a_code_valid: is_valid_code (a_code)
		do
			tag_code := a_code
		ensure
			tag_code_set: tag_code = a_code
		end

	set_including is
			-- Set `is_including' to `True'.
		do
			is_including := True
		ensure
			including: is_including
		end

	set_excluding is
			-- Set `is_including' to `False'.
		do
			is_including := False
		ensure
			not_including: not is_including
		end

feature -- Basic operations

	evaluate_test_routine (a_test_routine: CDD_TEST_ROUTINE): BOOLEAN is
			-- Does `Current' evaluate to `True' for `a_test_routine'?
		do

		end

invariant

	tag_code_valid: is_valid_code (tag_code)
	tokens_valid: tokens /= Void and then not tokens.has (Void)

end -- class CDD_FILTER_PATTERN
