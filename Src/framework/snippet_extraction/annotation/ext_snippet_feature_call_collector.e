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

		-- TODO: remove (for debugging reasons only)
	EXT_SHARED_LOGGER

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
			create l_collector.make
			l_collector.collect_from_ast (a_snippet.ast, a_snippet.operand_names)
			l_calls := l_collector.last_calls

			-- TODO: post-process `l_calls' to handle holes in snippets.
			--		 then merge both calls collected from normal statements and holes
			--		 into `last_calls'.

			if not a_snippet.holes.is_empty then
					-- If the snippet contains holes, remove feature calls of the form hole__x (..) and mentions (...)

				across l_calls as l_hash_table loop
					-- Iterate through hash table containing lists of calls

						-- Iterate through the list of calls and remove holes
					from l_hash_table.item.start
					until l_hash_table.item.after
					loop
						if attached {ACCESS_FEAT_AS} l_hash_table.item.item as l_access_as then
							if l_access_as.access_name.is_equal ("mentions")
							 or l_access_as.access_name.is_equal ("mentions_conditionally")
							  or a_snippet.holes.has (l_access_as.access_name) then
									-- If the feature call is a hole, remove it
								l_hash_table.item.prune (l_access_as)
							else
								l_hash_table.item.forth
							end
						else
							l_hash_table.item.forth
						end
					end
				end

			end

				-- Set last_calls attribute
			last_calls := l_calls

				-- TODO: remove (debugging)
			print_calls
		end


feature {NONE} -- TODO: remove (debugging)

	print_calls
			-- Print all calls available in last_calls
		local
			l_list: LINKED_LIST [CALL_AS]
			l_signature: TUPLE [feature_name: STRING; operands: HASH_TABLE[STRING,INTEGER]]
			l_operand: STRING
		do
			log.put_string ("%N========================%NPRINTING COLLECTED CALLS%N========================%N")

			from last_calls.start
			until last_calls.after
			loop
				l_list := last_calls.item_for_iteration
				if l_list /= Void then
					from l_list.start
					until l_list.after
					loop
							-- Print type
						if attached {NESTED_AS} l_list.item then
							log.put_string ("NESTED_AS:%N")

						elseif attached {ACCESS_FEAT_AS} l_list.item as l_access_feat_as then
							log.put_string ("ACCESS_FEAT_AS:%N")

						elseif attached {CREATION_EXPR_AS} l_list.item then
							log.put_string ("CREATION_EXPR_AS:%N")

						elseif attached {CURRENT_AS} l_list.item then
							log.put_string ("CURRENT_AS:%N")

						elseif attached {RESULT_AS} l_list.item then
							log.put_string ("RESULT_AS:%N")

						elseif attached {PRECURSOR_AS} l_list.item then
							log.put_string ("PRECURSOR_AS:%N")

						elseif attached {NESTED_EXPR_AS} l_list.item then
							log.put_string ("NESTED_EXPR_AS:%N")

						end

							-- Print breakpoint-slot
						log.put_string ("...breakpoint slot: " + l_list.item.breakpoint_slot.out + "%N")

							-- Print feature-name with arguments, and the target
						l_signature := signature_of_call (l_list.item)

						if l_signature /= Void then

							log.put_string ("...feature name:     "+l_signature.feature_name+"%N")

							if l_signature.operands /= Void then

								from l_signature.operands.start
								until l_signature.operands.after
								loop
									if l_signature.operands.item_for_iteration = Void then
										l_operand := "VOID"
									else
										l_operand := l_signature.operands.item_for_iteration
									end
									if l_signature.operands.key_for_iteration = 0 then
										log.put_string ("...target:           " + l_operand + "%N")
									else
										log.put_string ("...operand number " + l_signature.operands.key_for_iteration.out + ": " + l_operand + "%N")
									end
									l_signature.operands.forth
								end

							end

						end

						l_list.forth
					end
				end

				last_calls.forth
			end

			log.put_string ("================================================%N")
		end

end
