indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 74021 $"

class
	SAT_BRANCH_COVERAGE_INFO

inherit
	SAT_COVERAGE_INFO

feature -- Access

	class_name: STRING
			-- Name of the class where `feature_name' is written in
			-- In upper case

	feature_name: STRING
			-- Name of the feature where current branch appears
			-- In lower case

	covered_time: INTEGER
			-- Time when current branch is covered.
			-- In seconds from 1970...

	decision_start_position: INTEGER
			-- Start position of the decision in source text file associated with current branch.			
			-- Every decision has two branches.

feature -- Setting

	set_class_name (a_class_name: like class_name) is
			-- Set `class_name' with `a_class_name'.
			-- Reference setting, the actual objects are shared.
		do
			class_name := a_class_name
		ensure
			class_name_set: class_name = a_class_name
		end

	set_feature_name (a_feature_name: like feature_name) is
			-- Set `feature_name' with `a_feature_name'.
			-- Reference setting, the actual objects are shared.
		do
			feature_name := a_feature_name
		ensure
			feature_name_set: feature_name = a_feature_name
		end

	set_covered_time (a_covered_time: like covered_time) is
			-- Set `covered_time' with `a_covered_time'.
		do
			covered_time := a_covered_time
		ensure
			covered_time_set: covered_time = a_covered_time
		end

	set_decision_start_position (a_decision_start_position: like decision_start_position) is
			-- Set `decision_start_position' with `a_decision_start_position'.
			-- Reference setting, the actual objects are shared.
		do
			decision_start_position := a_decision_start_position
		ensure
			decision_start_position_set: decision_start_position = a_decision_start_position
		end

end
