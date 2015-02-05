note
	description: "[
			RULE #67: Formal generic parameter name has more than one character
	
			Names of formal generic parameters in generic class declarations should only have one character.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_GENERIC_PARAM_TOO_LONG_RULE

inherit
	CA_STANDARD_RULE

create
	make_with_defaults

feature -- Access

	title: STRING_32
		do
			Result := ca_names.generic_param_too_long_title
		end

	id: STRING_32 = "CA067"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.generic_param_too_long_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent pre_check_class)
		end

	pre_check_class (a_class: attached CLASS_AS)
		do
			if attached a_class.generics as l_generics then
				across l_generics as l_generic_decl loop
					if l_generic_decl.item.name.name_32.count > 1 then
						create_violation (l_generic_decl.item.name.name_32)
					end
				end
			end
		end

	create_violation (a_name: STRING)
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_GENERIC_PARAM_TOO_LONG_FIX
		do
			create l_violation.make_with_rule (Current)

			l_violation.long_description_info.extend (a_name)

			l_violation.set_location (current_context.checking_class.generics.start_location)

			create l_fix.make_with_param_name (current_context.checking_class, a_name)
			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.generic_param_too_long_violation_1)

			if attached {STRING} a_violation.long_description_info.first as l_param_name then
				a_formatter.add (l_param_name)
			end

			a_formatter.add (ca_messages.generic_param_too_long_violation_2)
		end

end
