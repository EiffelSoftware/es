note
	description: "Class to collect feature calls from a snippet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_FEATURE_CALL_COLLECTOR

inherit
	AST_ITERATOR

feature -- Access

	last_calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]
			-- Feature calls collected by last call to `collect'
			-- Keys are break point slots, values are feature calls
			-- associated with those break points.

feature -- Basic operations

	collect (a_snippet: EXT_SNIPPET)
			-- Collect feature calls from `a_snippet' and
			-- make results available in `last_calls'.
		do
		end

end
