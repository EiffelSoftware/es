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
			l_annotation_expression: EXPR_AS
			l_list: LINKED_LIST [CALL_AS]
		do
			create l_collector
			l_collector.collect_from_ast (a_snippet.ast, a_snippet.operand_names)
			l_calls := l_collector.last_calls

			-- TODO: post-process `l_calls' to handle holes in snippets.
			--		 then merge both calls collected from normal statements and holes
			--		 into `last_calls'.

				-- Handle holes contained a_snippet
			across l_calls as l_hash_table loop
					-- Iterater through hash table containing lists of calls
				across l_hash_table.item as l_call_list loop
						-- Iterate through a list of calls contained in the hash table

					if attached {ACCESS_FEAT_AS} l_call_list.item as l_feat_call then
							-- Holes are handled as calls of type ACCESS_FEAT_AS by class EPA_FEATURE_CALL_COLLECTOR

							-- Iterate through holes
						from a_snippet.holes.start
						until a_snippet.holes.after
						loop
								-- Check whether the call of type ACCESS_FEAT_AS is a hole of a_snippet
							if l_feat_call.access_name.starts_with (a_snippet.holes.key_for_iteration) then

									-- Remove the call that is actually a hole from the list of calls
								l_hash_table.item.prune (l_feat_call)

									-- Add calls that are mentioned by this hole --> iterate through mention annotations of this hole
								from a_snippet.holes.item_for_iteration.annotations.start
								until a_snippet.holes.item_for_iteration.annotations.after
								loop
										-- Create an object of type EXPR_AS out of the string representation of the expression stored in the mention annotation
									l_annotation_expression := ast_from_expression_text (a_snippet.holes.item_for_iteration.annotations.item_for_iteration.expression)

										-- Add the corresponding feature call of the expression to the list of calls, if the expression is of type EXPR_CALL_AS
									if attached {EXPR_CALL_AS} l_annotation_expression as l_expr_call then
										l_expr_call.call.breakpoint_slot := l_feat_call.breakpoint_slot
										l_hash_table.item.extend (l_expr_call.call)
									end

									a_snippet.holes.item_for_iteration.annotations.forth
								end

							end
							a_snippet.holes.forth
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
						if attached {NESTED_AS} l_list.item then
							log.put_string ("NESTED_AS:%N")
							log.put_string ("...breakpoint slot: " + l_list.item.breakpoint_slot.out + "%N")

						elseif attached {ACCESS_FEAT_AS} l_list.item as l_feat_call then
							log.put_string ("ACCESS_FEAT_AS:%N")
							log.put_string ("...breakpoint slot: " + l_list.item.breakpoint_slot.out + "%N")

						elseif attached {CREATION_EXPR_AS} l_list.item as l_creation_expr then
							log.put_string ("CREATION_EXPR_AS:%N")
							log.put_string ("...breakpoint slot: " + l_list.item.breakpoint_slot.out + "%N")

						else
							log.put_string (l_list.item.breakpoint_slot.out + ": " + text_from_ast (l_list.item) + "%N")
						end

						l_signature := signature_of_call (l_list.item)

						if l_signature /= Void then

							log.put_string ("...feature name:     "+l_signature.feature_name+"%N")

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


						l_list.forth
					end
				end

				last_calls.forth
			end

			log.put_string ("========================================================================%N")
		end

end
