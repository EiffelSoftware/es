note
	description: "A criterion that will filter the objects based on a PREDICATE agent."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_AGENT_CRITERION
inherit
	PS_CRITERION

create
	make

feature -- Access

	agent_criterion: PREDICATE [ANY, TUPLE [ANY]]
			-- The agent representing the current criterion.

feature -- Check

	is_satisfied_by (retrieved_obj: ANY): BOOLEAN
			-- Does `retrieved_obj' satisfy the criteria in Current?
		do
			Result := agent_criterion.item ([retrieved_obj])
		end

	can_handle_object (an_object: ANY): BOOLEAN
			-- Can `Current' handle `an_object' in the is_satisfied_by check?
		do
			Result:= agent_criterion.valid_operands ([an_object])
		end

feature -- Miscellaneous

	has_agent_criterion:BOOLEAN = True
		-- Is there an agent criterion in the criterion tree?

	accept (a_visitor: PS_CRITERION_VISITOR[ANY]): ANY
			-- Call visit_agent on `a_visitor'
		do
			Result:=a_visitor.visit_agent (Current)
		end

feature {NONE} -- Initialization

	make (a_predicate: PREDICATE [ANY, TUPLE [ANY]])
			-- Initialize `Current' with `a_predicate'
		do
			agent_criterion := a_predicate
		ensure
			agent_criterion_set: agent_criterion = a_predicate
		end

end
