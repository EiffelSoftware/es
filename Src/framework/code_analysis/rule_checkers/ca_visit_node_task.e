note
	description: "Summary description for {CA_VISIT_NODE_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VISIT_NODE_TASK [G -> AST_EIFFEL]

inherit
	ROTA_TIMED_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_node: G; a_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[G]]])
		do
			node := a_node
			actions := a_actions
			actions.start
		end

feature {NONE} -- Implementation

	node: G

	actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[G]]]

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
