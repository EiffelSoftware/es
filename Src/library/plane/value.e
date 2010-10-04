note
	description: "Summary description for {STATE_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VALUE

feature

	execute (env : PLAN_ENVIRONMENT) : ANY
		deferred
		end

feature {NONE}
	representation : STRING

end
