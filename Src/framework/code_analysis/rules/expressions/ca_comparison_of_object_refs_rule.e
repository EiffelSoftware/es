note
	description: "[
			RULE #49: Comparison of object references
	
			The '=' operator always compares two object references by checking
			whether they point to the same object in memory. In the majority of
			cases one wants to compare the object states, which can be done by
			the '~' operator.
		]"
	author: "Samuel Schmid"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_COMPARISON_OF_OBJECT_REFS_RULE

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
			a_checker.add_bin_eq_pre_action (agent process_bin_eq)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.comparison_of_object_refs_title
		end

	id: STRING_32 = "CA049"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.comparison_of_object_refs_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.comparison_of_object_refs_violation_1)
		end

feature {NONE} -- Rule Checking

	process_bin_eq (a_bin_eq: BIN_EQ_AS)
			-- Checks if `a_bin_eq' compares object references.
		local
			l_viol: CA_RULE_VIOLATION
		do
			if a_bin_eq.left.is_detachable_expression and a_bin_eq.right.is_detachable_expression then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_bin_eq.start_location)
				violations.extend (l_viol)
			end
		end

end
