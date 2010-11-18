note
	description: "Blackboard data for a class."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CLASS_DATA

inherit

	EBB_CHILD_ELEMENT [EBB_CLUSTER_DATA, EBB_CLASS_DATA]

	EBB_PARENT_ELEMENT [EBB_CLASS_DATA, EBB_FEATURE_DATA]

	EBB_CLASS_ASSOCIATION

	SHARED_WORKBENCH
		export {NONE} all end

	EBB_SHARED_ALL

create
	make

feature {NONE} -- Initialization

	make (a_class: attached like associated_class)
			-- Initialize empty verification state associated to `a_class'.
		do
			make_parent
			make_with_class (a_class)

			work_state := {EBB_STATE}.compilation
			result_state := {EBB_STATE}.unknown
		ensure
			consistent: associated_class = a_class
		end

feature -- Access

	features: attached LIST [EBB_FEATURE_DATA]
			-- List of features of this class.
		do
			create {LINKED_LIST [EBB_FEATURE_DATA]} Result.make
			across features_written_in_class (compiled_class) as l_cursor loop
				Result.extend (blackboard.data.feature_data (l_cursor.item))
			end
		end

	work_state: INTEGER
			-- Work state of class.

	result_state: INTEGER
			-- Result state of class.

	verification_score: REAL
			-- Combined verification score.
		local
			l_score: REAL
			l_sum: REAL
			l_count: INTEGER
		do
			Result := {EBB_VERIFICATION_SCORE}.not_verified
			from
				children.start
			until
				children.after or Result = {EBB_VERIFICATION_SCORE}.failed
			loop
				l_score := children.item.verification_score
				if l_score /= {EBB_VERIFICATION_SCORE}.not_verified then
					if l_score = {EBB_VERIFICATION_SCORE}.failed then
						Result := {EBB_VERIFICATION_SCORE}.failed
					else
						l_count := l_count + 1
						l_sum := l_sum + l_score
					end
				end
				children.forth
			end
			if l_count > 0 and Result /= {EBB_VERIFICATION_SCORE}.failed then
				Result := l_sum / l_count
			end
		end

	static_score: REAL
			-- Score of static verification tools.
		local
			l_score: REAL
			l_sum: REAL
			l_count: INTEGER
		do
			Result := {EBB_VERIFICATION_SCORE}.not_verified
			from
				children.start
			until
				children.after or Result = {EBB_VERIFICATION_SCORE}.failed
			loop
				l_score := children.item.static_score
				if l_score /= {EBB_VERIFICATION_SCORE}.not_verified then
					if l_score = {EBB_VERIFICATION_SCORE}.failed then
						Result := {EBB_VERIFICATION_SCORE}.failed
					else
						l_count := l_count + 1
						l_sum := l_sum + l_score
					end
				end
				children.forth
			end
			if l_count > 0 and Result /= {EBB_VERIFICATION_SCORE}.failed then
				Result := l_sum / l_count
			end
		end

	dynamic_score: REAL
			-- Score of dynamic verification tools.
		local
			l_score: REAL
			l_sum: REAL
			l_count: INTEGER
		do
			Result := {EBB_VERIFICATION_SCORE}.not_verified
			from
				children.start
			until
				children.after or Result = {EBB_VERIFICATION_SCORE}.failed
			loop
				l_score := children.item.dynamic_score
				if l_score /= {EBB_VERIFICATION_SCORE}.not_verified then
					if l_score = {EBB_VERIFICATION_SCORE}.failed then
						Result := {EBB_VERIFICATION_SCORE}.failed
					else
						l_count := l_count + 1
						l_sum := l_sum + l_score
					end
				end
				children.forth
			end
			if l_count > 0 and Result /= {EBB_VERIFICATION_SCORE}.failed then
				Result := l_sum / l_count
			end
		end

	message: STRING
			-- Latest message to be displayed.
		do
			Result := ""
		end

feature -- Status report

	is_stale: BOOLEAN
			-- Is data stale?
		do
			if static_score >= 0 then
				Result := is_static_score_stale
			end
			if not Result and dynamic_score >= 0 then
				Result := is_dynamic_score_stale
			end
		end

	is_dynamic_score_stale: BOOLEAN
			-- Is dynamic score stale?
		do
			from
				children.start
			until
				children.after or Result
			loop
				Result := children.item.is_dynamic_score_stale
				children.forth
			end
		end

	is_static_score_stale: BOOLEAN
			-- Is static score stale?
		do
			from
				children.start
			until
				children.after or Result
			loop
				Result := children.item.is_static_score_stale
				children.forth
			end
		end

feature -- Element change

	set_work_state (a_state: like work_state)
			-- Set `work_state' to `a_state'.
		require
			(create {EBB_STATE}).is_valid_work_state (a_state)
		do
			work_state := a_state
		ensure
			work_state_set: work_state = a_state
		end

	set_result_state (a_state: like result_state)
			-- Set `result_state' to `a_state'.
		require
			(create {EBB_STATE}).is_valid_result_state (a_state)
		do
			result_state := a_state
		ensure
			result_state_set: result_state = a_state
		end

invariant
	work_state_valid: (create {EBB_STATE}).is_valid_work_state (work_state)
	result_state_valid: (create {EBB_STATE}).is_valid_result_state (result_state)

end
