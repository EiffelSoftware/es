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
			l_hole: EXT_HOLE
			l_expr: EXPR_AS
			l_mention_ann_exprs: LINKED_LIST[EXPR_AS]
			l_mentioned_call_collector: EPA_FEATURE_CALL_COLLECTOR
			l_mentioned_calls: like last_calls
			l_call: CALL_AS
		do
			create l_collector.make
			l_collector.collect_from_ast (a_snippet.ast, a_snippet.operand_names)
			l_calls := l_collector.last_calls

			-- TODO: post-process `l_calls' to handle holes in snippets.
			--		 then merge both calls collected from normal statements and holes
			--		 into `last_calls'.

			create l_mention_ann_exprs.make
				-- List that will store expressions of corresponding annotations found in holes of this snippet

			if not a_snippet.holes.is_empty then
					-- If the snippet contains holes, remove feature calls of the form hole__x (..) and mentions (...)

				across l_calls as l_hash_table loop
					-- Iterate through hash table containing lists of calls

						-- Iterate through the list of calls and remove holes
					from l_hash_table.item.start
					until l_hash_table.item.after
					loop

						if attached {ACCESS_FEAT_AS} l_hash_table.item.item as l_access_as then
								-- Holes are only possible for feature access AS

							if a_snippet.holes.has (l_access_as.access_name) then
									-- If it is indeed a hole, iterate through its annotations

								l_hole := a_snippet.holes.item (l_access_as.access_name)
								from l_hole.annotations.start
								until l_hole.annotations.after
								loop
										-- Add the corresponding EXPR_AS of this annotation to the list of annotations
									l_expr := l_hole.annotations.item_for_iteration.ast_of_expression
									l_expr.set_breakpoint_slot (l_access_as.breakpoint_slot)
									l_mention_ann_exprs.extend (l_expr)
									l_hole.annotations.forth
								end

									-- Remove the hole (all its annotations will be added to l_calls afterwards)
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

				-- Let an additional feature call collector collect all feature calls found in the expressions of the annotations
			create l_mentioned_call_collector.make

			from l_mention_ann_exprs.start
			until l_mention_ann_exprs.after
			loop
					-- For every expression of a corresponding annotation, collect the included feature call(s)
				l_mentioned_call_collector.last_calls.wipe_out
				l_mentioned_call_collector.collect_from_ast (l_mention_ann_exprs.item_for_iteration, a_snippet.operand_names)
				l_mentioned_calls := l_mentioned_call_collector.last_calls.twin

					-- Iterate through the feature calls of this expression / annotation
				from l_mentioned_calls.start
				until l_mentioned_calls.after
				loop
					if l_calls.has (l_mention_ann_exprs.item_for_iteration.breakpoint_slot) then
							-- l_calls already contains a list of calls with this breakpoint slot as a key -> add additional ones to this list
						from l_mentioned_calls.item_for_iteration.start
						until l_mentioned_calls.item_for_iteration.after
						loop
							l_call := l_mentioned_calls.item_for_iteration.item_for_iteration
							l_call.set_breakpoint_slot (l_mention_ann_exprs.item_for_iteration.breakpoint_slot)
							l_calls.item (l_mention_ann_exprs.item_for_iteration.breakpoint_slot).extend (l_call)
							l_mentioned_calls.item_for_iteration.forth
						end
					else
							-- l_calls doesn't contain a list of calls with this breakpoint slot as a key -> add list (and update brakpoints befor)
						from l_mentioned_calls.item_for_iteration.start
						until l_mentioned_calls.item_for_iteration.after
						loop
							l_mentioned_calls.item_for_iteration.item_for_iteration.set_breakpoint_slot (l_mention_ann_exprs.item_for_iteration.breakpoint_slot)
							l_mentioned_calls.item_for_iteration.forth
						end
						l_calls.put (l_mentioned_calls.item_for_iteration.twin, l_mention_ann_exprs.item_for_iteration.breakpoint_slot)
					end

					l_mentioned_calls.forth
				end
				l_mention_ann_exprs.forth
			end

				-- Set last_calls attribute
			last_calls := l_calls
		end


feature {NONE} -- Debugging

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
