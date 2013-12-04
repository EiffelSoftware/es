note
	description: "Summary description for {CA_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE

inherit
	HASHABLE

	CA_SHARED_NAMES

feature -- Basic properties, usually fix

	title: STRING_32
		deferred
		end

	id: detachable STRING_32
			-- A preferrably unique identifier for the rule. It should start with "CA".
		once
			Result := Void
		end

	description: STRING_32
		deferred
		end

	is_system_wide: BOOLEAN
			-- Only check the rule if a system wide analysis is performed.
		deferred
		end

	checks_library_classes: BOOLEAN
		once
			Result := True
		end

	checks_nonlibrary_classes: BOOLEAN
		once
			Result := True
		end

	is_enabled_by_default: BOOLEAN

	default_severity_score: INTEGER

feature {CA_RULE_VIOLATION} -- formatted rule checking output

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		require
			violation_added: violations.has (a_violation)
			violation_correct: a_violation.rule = Current
		deferred
		end

feature -- Properties the user can change

	is_enabled: BOOLEAN_PREFERENCE

	severity: CA_RULE_SEVERITY

	severity_score: INTEGER_PREFERENCE

	set_severity (a_severity: CA_RULE_SEVERITY)
		do
			severity := a_severity
		end

	set_is_enabled_preference (a_pref: BOOLEAN_PREFERENCE)
		do
			is_enabled := a_pref
		end

	set_severity_score_preference (a_pref: INTEGER_PREFERENCE)
		do
			severity_score := a_pref
		end

feature -- Rule checking

	set_checking_class (a_class: CLASS_C)
		do
			checking_class := a_class
		end

	checking_class: detachable CLASS_C

	set_node_types (a_types: HASH_TABLE [TYPE_A, TUPLE [node: INTEGER; written_class: INTEGER; feat: INTEGER; cl: INTEGER]])
		do
			node_types := a_types
		end

feature {NONE} -- Rule checking

	node_types: HASH_TABLE [TYPE_A, TUPLE [node: INTEGER; written_class: INTEGER; feat: INTEGER; cl: INTEGER]]
			-- Type of the AST node `node' written in class
			-- `written_class' when evaluated in a feature `feature' of class
			-- `class'.

	node_type (a_node: AST_EIFFEL; a_feature: FEATURE_I): TYPE_A
			-- Type of the AST node `a_node' from feature `a_feature'.
		local
			l_class_id: INTEGER
		do
			l_class_id := a_feature.written_class.class_id
			Result := node_types [[a_node.index, l_class_id, a_feature.rout_id_set.first, l_class_id]]
		end

feature -- Results

	frozen clear_violations
		do
			violations.wipe_out
		end

	violations: LINKED_LIST[CA_RULE_VIOLATION]

feature -- Hash Code

	hash_code: INTEGER
		do
			Result := title.hash_code
		end

feature {NONE} -- Preferences

	frozen preference_namespace: STRING
		do
			Result := ca_names.rules_category + "." + title + "."
		end

	frozen is_integer_string_within_bounds (a_value: READABLE_STRING_GENERAL; a_lower, a_upper: INTEGER): BOOLEAN
		require
			is_integer: a_value.is_integer
		local
			int: INTEGER
		do
			int := a_value.to_integer
			Result := False
			if int >= a_lower and int <= a_upper then
				Result := True
			end
		end

invariant
	checks_some_classes: checks_library_classes or checks_nonlibrary_classes
end
