note
	description: "Summary description for {EPA_LOOP_BRANCHING_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_LOOP_BRANCHING_BLOCK

inherit
	EPA_BRANCHING_BLOCK
		redefine
			condition
		end

create
	make

feature{NONE} -- Initialization

	make (a_id: INTEGER; a_condition: like condition)
			-- Initialize Current.
		do
			set_id (a_id)
			condition := a_condition
			create asts.make (initial_capacity)
			asts.extend (condition)
		end

feature -- Access

	condition: EXPR_AS
			-- Condition on which execution branches

end
