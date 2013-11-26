note
	description: "Summary description for {CA_VARIABLE_NOT_READ_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VARIABLE_NOT_READ_RULE

inherit
	CA_CFG_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_backward
			is_enabled := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Node Visitor

	visit_node (a_start_node, a_end_node: EPA_BASIC_BLOCK; a_edge: EPA_CFG_EDGE; a_new_start: BOOLEAN)
		do

		end

feature {NONE} -- Analysis data

	lv_entry, lv_exit: HASH_TABLE[LINKED_LIST[STRING], INTEGER]

feature -- Properties

	title: STRING_32
		once
			Result := ca_names.variable_not_read_title
		end

	description: STRING_32
		once
			Result :=  "---"
		end

	is_system_wide: BOOLEAN
		once
			Result := True
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end

end
