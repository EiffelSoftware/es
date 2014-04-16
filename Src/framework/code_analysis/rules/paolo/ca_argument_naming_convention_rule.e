note
	description: "[
					RULE #66: Argument naming convention violated
		
					Argument names should respect the Eiffel naming convention for arguments
					(all lowercase begin with 'a_', no trailing or two consecutive underscores).
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_ARGUMENT_NAMING_CONVENTION_RULE

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
			a_checker.add_body_pre_action (agent process_body)
		end

feature {NONE} -- Rule checking

	process_body (a_body_as: attached BODY_AS)
		local
			l_viol: CA_RULE_VIOLATION
			i: INTEGER
			l_arg_name: STRING
		do
			if a_body_as.arguments /= Void then
				across
					a_body_as.arguments as args
				loop
					from
						i := 1
					until
						i > args.item.id_list.count
					loop
						l_arg_name := args.item.item_name (i)
						if not is_valid_argument_name (l_arg_name) then
							create l_viol.make_with_rule (Current)
							l_viol.set_location (args.item.start_location)
							l_viol.long_description_info.extend (l_arg_name)
							violations.extend (l_viol)
						end
						i := i + 1
					end
				end
			end
		end

	is_valid_argument_name (a_name: attached STRING): BOOLEAN
			-- Currently the casing restriction cannot be enforced, as identifiers received by this
			-- function are always upper- or lower-cased.
		do
			Result := not a_name.ends_with ("_") and not a_name.has_substring ("__") and (a_name.as_lower ~ a_name) and a_name.starts_with ("a_")
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.argument_naming_convention_title
		end

		-- TODO: Add the ID of your rule here. Should be unique!

	id: STRING_32 = "CA066"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.argument_naming_convention_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.argument_naming_convention_violation_1)
			check attached {STRING} a_violation.long_description_info.first as arg_name then
				a_formatter.add (arg_name)
			end
			a_formatter.add (ca_messages.argument_naming_convention_violation_2)
		end

end
