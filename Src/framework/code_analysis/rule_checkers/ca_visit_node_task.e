note
	description: "Summary description for {CA_VISIT_NODE_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VISIT_NODE_TASK

inherit
	ROTA_TIMED_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_node: AST_EIFFEL; a_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[AST_EIFFEL]]])
		do
			node := a_node
			actions := a_actions
			actions.start
		end

feature {NONE} -- Implementation

	node: AST_EIFFEL

	actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[AST_EIFFEL]]]

feature -- From ROTA

	sleep_time: NATURAL = 10

	has_next_step: BOOLEAN
		do
			Result := not actions.after
		end

	step
		do
			actions.item.call ([node])
			actions.forth
		end

	cancel
		do
			actions.finish
			actions.forth
		end

	is_interface_usable: BOOLEAN = True

end
