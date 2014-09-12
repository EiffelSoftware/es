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
		do
			if attached a_class.parent_with_name ("ANY") as l_any then
				-- Explicit inheritance from ANY found
				if not has_adaptations_to_any (a_class) then
					-- Class has no adapations to ANY, inheritance is not needed.
					create_violation(l_any)
				end
			end
		end

	has_adaptations_to_any (a_class: attached CLASS_AS): BOOLEAN
		-- Does `a_class' have any adaptations to ANY?
		do
			if attached a_class.parents as l_parents then
				if not a_class.is_equivalent (current_context.checking_class.ast) and then
					attached a_class.parent_with_name ("ANY") as l_any and then
					(not attached l_any.renaming and
					 not attached l_any.undefining and
					 not attached l_any.redefining) then
					-- This means that there is a plain inheritance to ANY which "resets" the adaptations all the parents of this class had,
					-- hence we return False.
					-- We cannot account for this case in the checking_class because otherwise we violate the rule every time we tried to reset
					-- adaptations by inheriting plainly from ANY.
					Result := False
				else
					from
						l_parents.start
					until
						Result or l_parents.after
					loop
						current_class := current_context.system.find_class (l_parents.item.type.class_name.name_32)
						Result := (attached l_parents.item.renaming and then l_parents.item.renaming.there_exists (agent is_rename_written_by_any)) or
								  (attached l_parents.item.undefining and then l_parents.item.undefining.there_exists (agent is_feature_written_by_any)) or
								  (attached l_parents.item.redefining and then l_parents.item.redefining.there_exists (agent is_feature_written_by_any)) or
								  has_adaptations_to_any (current_context.system.find_class (l_parents.item.type.class_name.name_32).ast)
						l_parents.forth
					end
				end
			end
		end


	is_rename_written_by_any (a_rename: RENAME_AS): BOOLEAN
		do
			Result := is_feature_written_by_any (a_rename.old_name)
		end

	is_feature_written_by_any (a_feature: FEATURE_NAME): BOOLEAN
		do
			Result := current_class.feature_named_32 (a_feature.visual_name_32).written_class.name_in_upper.is_equal ("ANY")
		end

	create_violation (a_parent: PARENT_AS)
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_INHERIT_FROM_ANY_FIX
		do
			create l_violation.make_with_rule (Current)
			l_violation.set_location (a_parent.start_location)
			l_violation.long_description_info.extend (current_context.checking_class.name_in_upper)

			create l_fix.make_with_class (current_context.checking_class)
			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

feature -- Properties

	current_class: CLASS_C

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
