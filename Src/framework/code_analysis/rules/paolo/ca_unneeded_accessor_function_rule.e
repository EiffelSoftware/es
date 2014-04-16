note
	description: "[
		RULE #79: Unneeded accessor function
		
		In Eiffel, it is not necessary to use a secret attribute together with an exported accessor ('getter') function.
		Since it is not allowed to write to an attribute from outside a class, an exported attribute can be used instead
		and the accessor may be removed.
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNEEDED_ACCESSOR_FUNCTION_RULE

inherit

	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
				-- TODO: Some preferences here?
			make_with_defaults
			create {CA_SUGGESTION} severity
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_do_pre_action (agent process_do)
		end

feature {NONE} -- Rule checking

	current_feature: detachable FEATURE_AS

	process_do (a_as: attached DO_AS)
		local
			l_viol: CA_RULE_VIOLATION
			l_called_feature: FEATURE_I
		do
				-- It would be very, very nice to have all these condition formatted as a list,
				-- but the pretty printer will put them back on a single line.
			if attached current_feature and then current_feature.is_function and then attached a_as.compound and then a_as.compound.count = 1 and then attached {ASSIGN_AS} a_as.compound.first as assignment and then attached {RESULT_AS} assignment.target then
				if attached {EXPR_CALL_AS} assignment.source as expr_call and then attached {ACCESS_ID_AS} expr_call.call as access_id then
					l_called_feature := current_context.checking_class.feature_named_32 (access_id.access_name_32)
					if attached {ATTRIBUTE_I} l_called_feature as called_attribute then
						create l_viol.make_with_rule (Current)
						l_viol.set_location (current_feature.start_location)
						l_viol.long_description_info.extend (current_feature.feature_name.name_32)
						l_viol.long_description_info.extend (called_attribute.feature_name_32)
						violations.extend (l_viol)
					end
				end
			end
		end

	process_feature (a_feature_as: attached FEATURE_AS)
		local
			l_name: STRING
			l_viol: CA_RULE_VIOLATION
			l_leaf_list: LEAF_AS_LIST
			l_comments: EIFFEL_COMMENTS
			l_comments_empty: BOOLEAN
		do
			current_feature := a_feature_as
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.unneeded_accessor_function_title
		end

	id: STRING_32 = "CA079"

	description: STRING_32
		do
			Result := ca_names.unneeded_accessor_function_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.unneeded_accessor_function_violation_1)
			a_violation.long_description_info.start
			check attached {STRING_32} a_violation.long_description_info.item as feature_name then
				a_formatter.add (feature_name)
				a_violation.long_description_info.forth
			end
			a_formatter.add (ca_messages.unneeded_accessor_function_violation_2)
			check attached {STRING_32} a_violation.long_description_info.item as attribute_name then
				a_formatter.add (attribute_name)
			end
			a_formatter.add (ca_messages.unneeded_accessor_function_violation_3)
		end

end
