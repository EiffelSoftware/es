note
	description: "Class to collect feature calls from a snippet"
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_FEATURE_CALL_COLLECTOR

inherit
	AST_ITERATOR

	EPA_UTILITY

	EPA_FEATURE_CALL_COLLECTOR_UTILITY

feature -- Access

	last_calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]
			-- Feature calls collected by last call to `collect'
			-- Keys are break point slots, values are feature calls
			-- associated with those break points.

	last_calls_without_breakpoints: LINKED_LIST [CALL_AS]
			-- Calls from `last_calls, with calls from different calls
			-- at various breakpoints accumulated together, and with
			-- duplicates removed
		do
			Result := calls_without_breakpoints (last_calls)
		end

feature -- Basic operations

	collect (a_snippet: EXT_SNIPPET)
			-- Collect feature calls from `a_snippet' and
			-- make results available in `last_calls'.		
		local
			l_collector: EPA_FEATURE_CALL_COLLECTOR
			l_calls: like last_calls;
		do
			create l_collector
			l_collector.collect_from_ast (a_snippet.ast, a_snippet.operand_names)
			l_calls := l_collector.last_calls
			-- TODO: post-process `l_calls' to handle holes in snippets.
			--		 then merge both calls collected from normal statements and holes
			--		 into `last_calls'.
		end

end
