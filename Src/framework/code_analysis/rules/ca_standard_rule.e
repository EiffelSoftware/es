note
	description: "Summary description for {CA_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_STANDARD_RULE

inherit
	CA_RULE
	CA_SHARED_NAMES

feature -- Activation

	frozen prepare_checking (a_checker: CA_ALL_RULES_CHECKER)
		do
			violations.wipe_out
			register_actions (a_checker)
		end

feature {NONE} -- Implementation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		deferred
		end

invariant
	title_set: title.count > 3
end
