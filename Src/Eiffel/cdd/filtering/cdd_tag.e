indexing
	description: "Objects that both tags and tag patterns; used to filter and group test cases."
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TAG

create
	make

feature {NONE} -- Initialization

	make is
			-- Create new tag.
		do
			set_including
			set_prefix_code (any_prefix_code)
			create tokens.make
		ensure
			including: is_including
			tag_code_is_any: prefix_code = any_prefix_code
		end

feature -- Access

	is_including: BOOLEAN
			-- Does a match mean that a test case should be included?
			-- If `False' a match means that a test case should be excluded.
			-- Think Google '+' and '-'.

	prefix_code: INTEGER
			-- Prefix code; this is a sort of namespace for tags.

	covers_prefix_code, outcome_prefix_code, other_prefix_code, any_prefix_code: INTEGER is unique
			-- Valid codes for `prefix_code'; "others" means no particular code, while
			-- "any" is used in tag patters to match any prefix.

	is_valid_code (a_code: like prefix_code): BOOLEAN is
			-- Is `a_code' a valid tag code?
		do
			Result := (a_code = covers_prefix_code) or (a_code = outcome_prefix_code) or (a_code = other_prefix_code) or (a_code = any_prefix_code)
		end

	tokens: DS_LINKED_LIST [STRING]
			-- List of string for evaluating the pattern
			-- with respect to `prefix_code'

feature -- Status settings

	set_prefix_code (a_code: like prefix_code) is
			-- Set `prefix_code' to `a_code'.
		require
			a_code_valid: is_valid_code (a_code)
		do
			prefix_code := a_code
		ensure
			tag_code_set: prefix_code = a_code
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

	is_matching_routine (other: CDD_TAG): BOOLEAN is
			-- Does `other' (interpreted as a tag) match
			-- Current (interpreted as a tag pattern)?
		require
			other_not_void: other /= Void
		local
			cs: DS_LINEAR_CURSOR [STRING]
			cs_other: DS_LINEAR_CURSOR [STRING]
		do
			Result := True
			if prefix_code /= any_prefix_code then
				Result := prefix_code = other.prefix_code
			end
			if Result and tokens.count <= other.tokens.count then
				from
					cs := tokens.new_cursor
					cs.start
					cs_other := other.tokens.new_cursor
					cs_other.start
				until
					cs.off or not Result
				loop
					Result := cs.item.is_equal (cs_other.item)
					cs.forth
					cs_other.forth
				end
				cs.go_after
				cs_other.go_after
			end
		end

invariant

	tag_code_valid: is_valid_code (prefix_code)
	tokens_valid: tokens /= Void and then not tokens.has (Void)

end -- class CDD_FILTER_PATTERN
