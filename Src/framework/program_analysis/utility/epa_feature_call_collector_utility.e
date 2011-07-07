note
	description: "Utility for feature call collector"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CALL_COLLECTOR_UTILITY

inherit
	EPA_UTILITY

feature -- Access

	calls_without_breakpoints (a_calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]): LINKED_LIST [CALL_AS]
			-- Calls from `a_calls, with calls from different calls at various
			-- breakpoints accumulated together, and with duplicates removed.
			-- `a_calls' is a hash-table, keys are break point slots,
			-- values are feature calls associated with those break points.			
		local
			l_set: LINKED_SET [STRING]
			l_text: STRING
		do
			create Result.make
			create l_set.make
			l_set.compare_objects
			across a_calls as l_bps loop
				across l_bps.item as l_calls loop
					l_text := text_from_ast (l_calls.item)
					if not l_set.has (l_text) then
						l_set.force (l_text)
						Result.extend (l_calls.item)
					end
				end
			end
		end

	signature_of_call (a_call: CALL_AS): TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]
			-- Signature information extracted from `a_call'.
			-- In result, `feature_name' is the name of the feature appeared in `a_call'.
			-- `operands' is a hash-table. Keys are 0-based operand indices, 0 represents the target,
			-- 1 represents the first actual argument, and so on.			
		do
			-- TODO: To implement
		end


end
