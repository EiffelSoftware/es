note
	description: "[
			RULE #31: Explicit inheritance from ANY
			
			Inheritance with no adaptations from the ANY class need not explicitely be defined. This should be removed.
		]"
	author: "Samuel Schmid"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_INHERIT_FROM_ANY_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_defaults
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent check_inheritance)
		end

feature {NONE} -- Rule checking

	check_inheritance (a_class: attached CLASS_AS)
		-- Checks whether `a_class' inherits explicitly from ANY or not.
		local
			l_violation: CA_RULE_VIOLATION
			l_found_any, l_found_adaptations: BOOLEAN
			l_feature_name: FEATURE_NAME
		do
			if attached a_class.parents as l_parents then
				across l_parents as p loop
					if p.item.type.class_name.name_8.is_equal ("ANY") then
						-- Explicit inheritance from ANY found
						if not has_changes(p.item) then
							-- Inheritance from ANY has no adaptations to the class and is not needed.
							create l_violation.make_with_rule (Current)
							l_violation.set_location (p.item.start_location)
							l_violation.long_description_info.extend (a_class.class_name.name_8)
							violations.extend (l_violation)
						end
					end
				end
			end
		end

	has_adaptations_to_any (a_class: attached CLASS_AS): BOOLEAN
		-- Does `a_class' (or one of its ancestors) have an explicit
		-- inheritance to ANY with adaptations to it?
		do
			--Todo: Implement me.
			Result := True
		end

	has_changes (a_parent: attached PARENT_AS): BOOLEAN
		-- Does `a_parent' have any adaptations to it?
		do
			Result := attached a_parent.renaming or else
				attached a_parent.undefining or else
				attached a_parent.redefining or else
				attached a_parent.selecting or else
				attached a_parent.exports
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.inherit_from_any_title
		end

	id: STRING_32 = "CA031"

	description: STRING_32
		do
			Result := ca_names.inherit_from_any_description
		end


	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.inherit_from_any_violation_1)
			check
				attached {STRING} a_violation.long_description_info.first
			end
			if attached {STRING} a_violation.long_description_info.first as l_class_name then
				a_formatter.add (l_class_name)
			end
			a_formatter.add (ca_messages.inherit_from_any_violation_2)
		end
end
