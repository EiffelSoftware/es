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
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature -- Node Visitor

	process_instruction (a_instr: CA_CFG_INSTRUCTION)
		do
		end

	process_loop (a_loop: CA_CFG_LOOP): BOOLEAN
			-- Process the loop header. Result is True if and only if iteration through the
			-- body of the loop shall continue. After a finite (and computationally
			-- reasonable) number of loop iterations, Result must be set to True.
		do
		end

	process_if (a_if: CA_CFG_IF)
		do
		end

	process_inspect (a_inspect: CA_CFG_INSPECT)
		do
		end

feature {NONE} -- Analysis data

	lv_entry, lv_exit: HASH_TABLE[LINKED_LIST[STRING], INTEGER]

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.variable_not_read_title
		end

	description: STRING_32
		do
			Result :=  "---"
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end

end
