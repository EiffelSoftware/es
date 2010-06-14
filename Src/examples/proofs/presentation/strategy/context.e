indexing
	description: "Summary description for {CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONTEXT

create
	set_strategy

feature

	set_strategy (a_strategy: !OPERATOR_STRATEGY)
		do
			strategy := a_strategy
		ensure
			strategy = a_strategy
		end

feature

	strategy: !OPERATOR_STRATEGY

	execute (a, b: INTEGER)
		do
			strategy.execute (a, b)
		ensure
			(agent strategy.execute).postcondition ([a, b])
			strategy.last_result = strategy.last_result -- modifies
--			Result = strategy.execute (a, b)
		end

	last_result: INTEGER
		indexing
			pure: True
		do
			Result := strategy.last_result
		ensure
			Result = strategy.last_result
		end

end
