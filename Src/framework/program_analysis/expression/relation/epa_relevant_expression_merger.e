note
	description: "Class to merge sets of expressions which are relevant to each other"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_RELEVANT_EXPRESSION_MERGER

inherit
	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature -- Creation procedure

	make (a_relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]])
			-- Sets `relevant_expression_sets' to `a_relevant_expression_sets'
		require
			a_relevant_expression_sets_not_void: a_relevant_expression_sets /= Void
		do
			relevant_expression_sets := a_relevant_expression_sets
		ensure
			relevant_expression_sets_set: relevant_expression_sets = a_relevant_expression_sets
		end

feature -- Basic operation

	merge
			-- Merges the sets of relevant expressions (`relevant_expression_sets'),
			-- if two different sets are not disjoint.
		require
			relevant_expression_sets_not_void: relevant_expression_sets /= Void
		local
			m,n: INTEGER
			l_count: INTEGER
			l_sets, l_edited_sets: like relevant_expression_sets
		do
			l_sets := relevant_expression_sets
			create l_edited_sets.make (relevant_expression_sets.count)
			across relevant_expression_sets as l_revs loop
				l_edited_sets.extend (l_revs.item.cloned_object)
			end
			remove_unnecessary_expressions (l_edited_sets)
			l_count := l_edited_sets.count

			from
				m := 1
			until
				m > l_count
			loop
				from
					n := m + 1
				until
					n > l_count
				loop

					-- Merge sets
					if
						m /= n and then
						l_edited_sets.i_th (m) /= Void and then
						l_edited_sets.i_th (n) /= Void and then
						not l_edited_sets.i_th (m).is_disjoint (l_edited_sets.i_th (n))
					then
						l_sets.i_th (m).merge (l_sets.i_th (n))
						l_sets.put_i_th (Void, n)
						l_edited_sets.i_th (m).merge (l_edited_sets.i_th (n))
						l_edited_sets.put_i_th (Void, n)
						n := m + 1
					else
						n := n + 1
					end
				end

				-- Find the next set which may be merged with another set.
				from
					m := m + 1
				until
				   m > l_count or else l_edited_sets.i_th (m) /= Void
				loop
					m := m + 1
				end
			end
		end

feature -- Access

	relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]

feature {NONE} -- Implementation

	remove_unnecessary_expressions (a_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]])
			-- Removes the unnecessary expressions from `a_sets' namely
			-- constants and the expressions "Void" and "Result".
		require
			a_expression_sets_not_void: a_expression_sets /= Void
		local
			i, l_count: INTEGER
			l_edited_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			from
				i := 1
				l_count := a_expression_sets.count
			until
				i > l_count
			loop
				l_edited_set := set_without_unnecessary_expressions (a_expression_sets.i_th (i))
				a_expression_sets.put_i_th (l_edited_set, i)
				i := i + 1
			end
		end

	set_without_unnecessary_expressions (a_expression_set: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- A set whose elements from `a_set' are not constants, the expressions "Void" and "Result".
		require
			a_expression_set_not_void: a_expression_set /= Void
		do
			create Result.make (a_expression_set.count)
			Result.set_equality_tester (expression_equality_tester)
			a_expression_set.do_if (agent Result.force_last, agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.is_constant and not a_expr.is_void and not a_expr.is_result end)
		ensure
			Result_not_void: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

end
