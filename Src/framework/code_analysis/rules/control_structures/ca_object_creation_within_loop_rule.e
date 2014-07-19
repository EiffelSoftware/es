note
	description: "[
			RULE #68: Object creation within loop
	
			Creating objects within a loop may decrease
			performance. On such an occurrence it should
			be checked whether the object creation can be
			moved outside the loop.
		]"
	author: "Samuel Schmid"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_OBJECT_CREATION_WITHIN_LOOP_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
			make_with_defaults
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_loop_pre_action (agent process_loop)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.object_creation_within_loop_title
		end

	id: STRING_32 = "CA068"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.object_creation_within_loop_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.object_creation_within_loop_violation_1)
		end

feature {NONE} -- Rule Checking

	process_loop (a_loop: LOOP_AS)
			-- Checks if `a_loop' contains an object creation.
		local
			l_violation: CA_RULE_VIOLATION
		do
			if attached a_loop.compound as l_body then
				across l_body as l_instruction loop
					if attached {CREATE_CREATION_AS} l_instruction.item then
						create l_violation.make_with_rule (Current)
						l_violation.set_location (l_instruction.item.start_location)
						violations.extend (l_violation)
					end
				end
			end
		end

end
