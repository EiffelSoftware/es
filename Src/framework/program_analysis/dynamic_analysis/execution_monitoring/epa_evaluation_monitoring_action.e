note
	description: "Objects that represent a monitoring action which evaluate a set of expressions when a certain project location is reached."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EVALUATION_MONITORING_ACTION

inherit
	EPA_MONITORING_ACTION

feature -- Access

	expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions that are to be evaluated with `location' is reached
			-- during program execution.

	evaluation_finished_actions: ACTION_SEQUENCE [TUPLE [state: EPA_STATE]]
			-- Actions to be performed when `expressions' are evaluated
			-- when `location' is reached.
			-- `state' is a hash-table storing the `expressions' and their evaluation
			-- values. Key is the expression, value is the evaluation value for that expression.

end
