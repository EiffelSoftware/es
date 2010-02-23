note
	description: "Summary description for {EPA_NORMAL_SPLITTING_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_NORMAL_SPLITTING_BLOCK

inherit
	EPA_SPLITTING_BLOCK
		redefine
			condition
		end
		
feature -- Access

	condition: EXPR_AS
			-- Condition on which execution branches

end
