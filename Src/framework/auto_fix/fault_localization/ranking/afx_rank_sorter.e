note
	description: "Summary description for {AFX_RANKING_SORTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_RANK_SORTER

inherit

	AFX_SHARED_STATIC_ANALYSIS_REPORT

	AFX_SHARED_SESSION

create
	default_create

feature -- Basic operation

	sort_ranking (a_ranking: DS_ARRAYED_LIST [AFX_FIXING_TARGET])
			-- Sort values in `a_ranking'.
		local
			l_equality_tester: AGENT_BASED_EQUALITY_TESTER [AFX_FIXING_TARGET]
			l_sorter: DS_QUICK_SORTER [AFX_FIXING_TARGET]
		do
			create l_equality_tester.make (agent is_ranked_higher_than)
			create l_sorter.make (l_equality_tester)
			l_sorter.sort (a_ranking)
		end

feature{NONE} -- Implementation

	is_ranked_higher_than (a_target1, a_target2: AFX_FIXING_TARGET): BOOLEAN
			-- Is `a_target1' ranked higher than `a_target2', i.e. should `a_target1' be placed before `a_target2' in the list?
		local
			l_distances: TUPLE [control_relevance: INTEGER; data_relevance: INTEGER]
			l_report: AFX_CONTROL_DISTANCE_REPORT
			l_dist1, l_dist2: INTEGER
		do
			if a_target1.rank /= a_target2.rank then
				Result := a_target1.rank > a_target2.rank
			else
				if a_target1.expressions.count /= a_target2.expressions.count then
					Result := a_target1.expressions.count < a_target2.expressions.count
				else
					Result := a_target1.hash_code > a_target2.hash_code
				end
			end
		end



end
