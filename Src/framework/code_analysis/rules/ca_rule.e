note
	description: "A rule that will be used by the Code Analyzer."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE

inherit
	HASHABLE

	CA_SHARED_NAMES

	SHARED_SERVER

feature -- Basic properties, usually fix

	title: STRING_32
			-- A short title.
		deferred
		end

	id: STRING_32
			-- A preferrably unique identifier for the rule. It should start with "CA".
		deferred
		end

	description: STRING_32
			-- A description of what this rule checks.
		deferred
		end

	is_system_wide: BOOLEAN
			-- Only check the rule if a system wide analysis is performed.
		deferred
		end

	checks_library_classes: BOOLEAN
			-- Does this rule check library classes?
		once
			Result := True
		end

	checks_nonlibrary_classes: BOOLEAN
			-- Does this rule check non-library classes?
		once
			Result := True
		end

	is_enabled_by_default: BOOLEAN
			-- Is this rule enabled by default?

	default_severity_score: INTEGER
			-- The default severity score.

feature {CA_RULE_VIOLATION} -- formatted rule checking output

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Formats a description of a violation of this rule, `a_violation', using `a_formatter'.
		require
			violation_added: violations.has (a_violation)
			violation_correct: a_violation.rule = Current
		deferred
		end

feature -- Properties the user can change

	is_enabled: BOOLEAN_PREFERENCE
			-- Is the rule enabled?

	severity: CA_RULE_SEVERITY
			-- The severity of violations of this rule.

	severity_score: INTEGER_PREFERENCE
			-- The severity score.

	set_severity (a_severity: CA_RULE_SEVERITY)
			-- Sets the severity to `a_severity'.
		do
			severity := a_severity
		end

	set_is_enabled_preference (a_pref: BOOLEAN_PREFERENCE)
			-- Sets the "enabled" preference to `a_pref'.
		do
			is_enabled := a_pref
		end

	set_severity_score_preference (a_pref: INTEGER_PREFERENCE)
			-- Sets the "severity score" preference to `a_pref'.
		do
			severity_score := a_pref
		end

feature -- Rule checking

	set_checking_class (a_class: CLASS_C)
			-- Sets the class that is being checked to `a_class'.
			-- (Used for creating violations.)
		do
			checking_class := a_class
		end

	checking_class: detachable CLASS_C
			-- The class that is currently being checked.

	set_node_types (a_types: HASH_TABLE [TYPE_A, TUPLE [node: INTEGER; written_class: INTEGER; feat: INTEGER; cl: INTEGER]])
			-- Sets the hash table mapping AST nodes to type information to `a_types'.
		do
			node_types := a_types
		end

feature {NONE} -- Rule checking

	matchlist: detachable LEAF_AS_LIST
			-- The match list of the currently checked class.
		do
			if attached checking_class then
				Result := Match_list_server.item (checking_class.class_id)
			end
		end

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
			-- Clears all stored rule violations.
		do
			violations.wipe_out
		end

	violations: LINKED_LIST [CA_RULE_VIOLATION]
			-- The violations this rule has found.

feature -- Hash Code

	hash_code: INTEGER
		do
				-- Delegate it.
			Result := id.hash_code
		end

feature {NONE} -- Preferences

	frozen preference_namespace: STRING
			-- Every rule has a separate sub namespace so that in the preferences dialog,
			-- the rule will have its own folder.
		do
			Result := ca_names.rules_category + "." + title + "."
		end

	frozen is_integer_string_within_bounds (a_value: READABLE_STRING_GENERAL; a_lower, a_upper: INTEGER): BOOLEAN
			-- Is the integer string `a_value' within the interval [`a_lower', `a_upper']?
		require
			is_integer: a_value.is_integer
		local
			int: INTEGER
		do
			int := a_value.to_integer
			if int >= a_lower and int <= a_upper then
				Result := True
			end
		end

invariant
	checks_some_classes: checks_library_classes or checks_nonlibrary_classes
end
