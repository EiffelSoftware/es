note
	description: "Summary description for {AFX_EXCEPTION_SIGNATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXCEPTION_SIGNATURE

inherit
	SHARED_TYPES
		redefine
			is_equal
		end

	HASHABLE
		redefine
			is_equal
		end

	EPA_UTILITY
		redefine
			is_equal
		end

	REFACTORING_HELPER
		redefine
			is_equal
		end

feature{AFX_EXCEPTION_SIGNATURE} -- Initialization

	make_common (a_exception_class: CLASS_C; a_exception_feature: FEATURE_I;
				a_exception_breakpoint: INTEGER; a_exception_nested_breakpoint: INTEGER;
				a_recipient_class: CLASS_C; a_recipient_feature: FEATURE_I;
				a_recipient_breakpoint: INTEGER; a_recipient_nested_breakpoint: INTEGER)
			-- Initialization.
		do
			set_exception_class (a_exception_class)
			set_exception_feature (a_exception_feature)
			set_exception_breakpoint (a_exception_breakpoint)
			set_exception_nested_breakpoint (a_exception_nested_breakpoint)
			set_recipient_class (a_recipient_class)
			set_recipient_feature (a_recipient_feature)
			set_recipient_breakpoint (a_recipient_breakpoint)
			set_recipient_nested_breakpoint (a_recipient_nested_breakpoint)
			analyze_exception_condition
			analyze_exception_condition_in_recipient
		end

feature -- Direct access

	exception_code: INTEGER
			-- Code for exception type.

	exception_class: CLASS_C
			-- Context class of `exception_feature'.

	exception_feature: FEATURE_I
			-- Feature being executed when the exception is raised.

	exception_breakpoint: INTEGER
			-- Breakpoint index in `exception_feature'.
			-- The breakpoint index should correspond to a contract clause, except for "Void_call_target".

	exception_nested_breakpoint: INTEGER
			-- Nested breakpoint index in `exception_feature'.
			-- Non-zero for "Void_call_target" exceptions, 0 for other cases.

	recipient_class: CLASS_C
			-- Context class of `recipient_feature'.
			-- Equals `raising_class' in all cases except for precondition violations.

	recipient_feature: FEATURE_I
			-- Recipient feature of the exception.
			-- Equals `raising_feature' in all cases except for precondition violations.

	recipient_breakpoint: INTEGER
			-- Breakpoint index in `recipient_feature'.
			-- Equals `failing_breakpoint' in all cases except for precondition-violations.

	recipient_nested_breakpoint: INTEGER
			-- Nested breakpoint index in `recipient_feature'.
			-- Only used for precondition violations to decide which sub-expression has caused the exception.
			-- Set to 0 when the information is not available or not used.

feature{AFX_EXCEPTION_SIGNATURE} -- Status set

	set_exception_code (a_code: INTEGER)
			-- Set `exception_code'.
		do
			exception_code := a_code
		end

	set_exception_class (a_class: CLASS_C)
			-- Set `exception_class'.
		do
			exception_class := a_class
		end

	set_exception_feature (a_feature: FEATURE_I)
			-- Set `exception_feature'.
		do
			exception_feature := a_feature
		end

	set_exception_breakpoint (a_breakpoint: INTEGER)
			-- Set `exception_breakpoint'.
		do
			exception_breakpoint := a_breakpoint
		end

	set_exception_nested_breakpoint (a_breakpoint: INTEGER)
			-- Set `exception_nested_breakpoint'.
		do
			exception_nested_breakpoint := a_breakpoint
		end

	set_recipient_class (a_class: CLASS_C)
			-- Set `recipient_class'.
		do
			recipient_class := a_class
		end

	set_recipient_feature (a_feature: FEATURE_I)
			-- Set `recipient_feature'.
		do
			recipient_feature := a_feature
		end

	set_recipient_breakpoint (a_breakpoint: INTEGER)
			-- Set `recipient_breakpoint'.
		do
			recipient_breakpoint := a_breakpoint
		end

	set_recipient_nested_breakpoint (a_breakpoint: INTEGER)
			-- Set `recipient_nested_breakpoint'.
		do
			recipient_nested_breakpoint := a_breakpoint
		end

	set_exception_condition (a_condition: EPA_EXPRESSION)
			-- Set `exception_condition'.
		do
			exception_condition := a_condition
		end

	set_exception_condition_in_recipient (a_condition: EPA_EXPRESSION)
			-- Set `exception_condition_in_recipient'.
		do
			exception_condition_in_recipient := a_condition
		end

feature{AFX_ASSERTION_VIOLATION_SIGNATURE} -- Analyze

	analyze_exception_condition
			-- Analyze exception condition in the failing feature.
		deferred
		ensure
			exception_condition_initialized: exception_condition /= Void
		end

	analyze_exception_condition_in_recipient
			-- Analyze exception condition in the recipient feature.
		require
			exception_condition_attached: exception_condition /= Void
		deferred
		ensure
			exception_condition_in_recipient_initialized: exception_condition_in_recipient /= Void
		end

feature -- Derived access

	origin_recipient_feature: FEATURE_I
			-- Ancester of `recipient_feature' in its written class.
		do
			Result := recipient_written_class.feature_of_rout_id_set (recipient_feature.rout_id_set)
		end

	recipient_written_class: CLASS_C
			-- Written class of `recipient_feature'.
		do
			Result := recipient_feature.written_class
		end

	id: STRING
			-- ID of the exception.
		do
			if id_cache = Void then
				initialize_id
			end
			Result := id_cache
		end

	exception_condition: EPA_EXPRESSION
			-- Exception condition in `exception_feature'.
			-- For pre-/post-condition violations and invariant-/check-violations, this is the violated assertion.
			-- For void-call-target, this is "call_target = Void".

	exception_condition_in_recipient: EPA_EXPRESSION
			-- Exception condition as written in `recipient_feature'.
			-- For exceptions other than pre-condition violation, this is the same as `exception_condition'.
			-- For precondition violations, this is the translation of `exception_condition' in `recipient_feature'.

feature -- Status report

	is_precondition_violation: BOOLEAN
			-- Does current represent a precondition violation?
		do
			Result := exception_code = {EXCEP_CONST}.precondition
		end

	is_postcondition_violation: BOOLEAN
			-- Does current represent a postcondition violation?
		do
			Result := exception_code = {EXCEP_CONST}.postcondition
		end

	is_class_invariant_violation: BOOLEAN
			-- Does current represent a class invariant violation?
		do
			Result := exception_code = {EXCEP_CONST}.class_invariant
		end

	is_check_violation: BOOLEAN
			-- Does current represent a check violation?
		do
			Result := exception_code = {EXCEP_CONST}.check_instruction
		end

	is_void_call_target: BOOLEAN
			-- Does current represent a void-call-target exception?
		do
			Result := exception_code = {EXCEP_CONST}.Void_call_target
		end

feature -- Redefinition

	is_equal(other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := id ~ other.id
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id.hash_code
		ensure then
			good_result: Result = id.hash_code
		end

feature{AFX_EXCEPTION_SIGNATURE} -- Implementation

	initialize_id
			-- Initialize `id'.
		do
			create id_cache.make_empty
			id_cache.append_integer (exception_code)
			id_cache.append_character ('.')
			id_cache.append (recipient_class.name)
			id_cache.append_character ('.')
			id_cache.append (recipient_feature.feature_name_32)
			id_cache.append_character ('.')
			id_cache.append_integer (recipient_breakpoint)
			id_cache.append_character ('.')
			id_cache.append_integer (recipient_nested_breakpoint)
			id_cache.append_character ('.')
			id_cache.append (exception_class.name)
			id_cache.append_character ('.')
			id_cache.append (exception_feature.feature_name_32)
			id_cache.append_character ('.')
			id_cache.append_integer (exception_breakpoint)
			id_cache.append_character ('.')
			id_cache.append_integer (exception_nested_breakpoint)
		end

feature{NONE} -- Cache

	id_cache: STRING
			-- Cache for `id'.

end
