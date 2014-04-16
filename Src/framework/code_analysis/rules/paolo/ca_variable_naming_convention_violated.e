note
	description: "[
					RULE #65: Local variable naming convention violated
		
					Local variable names should respect the Eiffel naming convention for local variables
					(all lowercase begin with 'l_', no trailing or two consecutive underscores).
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VARIABLE_NAMING_CONVENTION_RULE

inherit

	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			make_with_defaults
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_routine_pre_action (agent process_routine)
		end

feature {NONE} -- Rule checking

	process_routine (a_routine_as: attached ROUTINE_AS)
		local
			l_viol: CA_RULE_VIOLATION
			i: INTEGER
			l_variable_name: STRING
		do
			if a_routine_as.locals /= Void then
				across
					a_routine_as.locals as locals
				loop
					from
						i := 1
					until
						i > locals.item.id_list.count
					loop
						l_variable_name := locals.item.item_name (i)
						if not is_valid_local_variable_name (l_variable_name) then
							create l_viol.make_with_rule (Current)
							l_viol.set_location (locals.item.start_location)
							l_viol.long_description_info.extend (l_variable_name)
							violations.extend (l_viol)
						end
						i := i + 1
					end
				end
			end
		end

	is_valid_local_variable_name (a_name: attached STRING): BOOLEAN
			-- Currently the casing restriction cannot be enforced, as identifiers received by this
			-- function are always upper- or lower-cased.
		do
			Result := not a_name.ends_with ("_") and not a_name.has_substring ("__") and (a_name.as_lower ~ a_name) and a_name.starts_with ("l_")
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.variable_naming_convention_title
		end

	id: STRING_32 = "CA065"

	description: STRING_32
		do
			Result := ca_names.variable_naming_convention_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.variable_naming_convention_violation_1)
			check attached {STRING} a_violation.long_description_info.first as variable_name then
				a_formatter.add (variable_name)
			end
			a_formatter.add (ca_messages.variable_naming_convention_violation_2)
		end

end
