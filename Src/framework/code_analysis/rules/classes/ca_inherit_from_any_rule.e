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

					if has_adaptations_to_any (p.item) then
						
					end

--					if p.item.type.class_name.name_8.is_equal ("ANY") then
--						-- Explicit inheritance from ANY found
--						if not has_adaptations_to_any (p.item) then
--							-- Inheritance from ANY has no adaptations to the class.

--							-- We need to check all the other parents if they have adaptations to ANY.
--							create l_violation.make_with_rule (Current)
--							l_violation.set_location (p.item.start_location)
--							l_violation.long_description_info.extend (a_class.class_name.name_8)
--							violations.extend (l_violation)
--						end
--					end
				end
			end
		end

	has_adaptations_to_any (a_parent: attached PARENT_AS): BOOLEAN
		-- Does `a_parent' have any adaptations to ANY?
		local
			l_string: STRING_8
		do
			if attached a_parent.undefining then
				l_string := current_context.system.class_of_id (a_parent.type.class_name.name_id).feature_named_32 (a_parent.undefining.first.internal_name.name_32).written_class.name_in_upper
			end
			Result := (attached a_parent.renaming and not a_parent.renaming.there_exists (agent is_rename_written_by_any)) or else
				attached a_parent.undefining or else
				attached a_parent.redefining
		end

	is_rename_written_by_any (a_rename: RENAME_AS): BOOLEAN
		do
			Result := a_rename.old_name.class_name.name_32.is_equal ("ANY")
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
