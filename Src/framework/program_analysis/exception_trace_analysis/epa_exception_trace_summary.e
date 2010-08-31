note
	description: "Summary description for {EPA_EXCEPTION_TRACE_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXCEPTION_TRACE_SUMMARY

inherit
	EXCEP_CONST

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_code: INTEGER; a_context_class_name, a_context_feature_name: STRING;
					a_failing_bp_index: INTEGER; a_failing_tag, a_failing_written_class: STRING;
					a_recipient_context_class_name, a_recipient_feature_name: STRING;
					a_recipient_bp_index: INTEGER; a_recipient_written_class_name: STRING)
			-- Initialization
		do
			set_exception_code (a_code)
			set_failing_context_class_name (a_context_class_name)
			set_failing_feature_name (a_context_feature_name)
			set_failing_position_breakpoint_index (a_failing_bp_index)
			set_failing_assertion_tag (a_failing_tag)
			set_failing_written_class_name (a_failing_written_class)
			set_recipient_context_class_name (a_recipient_context_class_name)
			set_recipient_feature_name (a_recipient_feature_name)
			set_recipient_breakpoint_index (a_recipient_bp_index)
			set_recipient_written_class_name (a_recipient_written_class_name)
		end

feature -- Status report

	is_exception_supported: BOOLEAN
			-- Is the exception type supported?
		do
			Result := (exception_code /= 0)
		end

	is_precondition_violation: BOOLEAN
			-- Is this summary about a precondition violation?
		do
			Result := exception_code = precondition
		end

	is_postcondition_violation: BOOLEAN
			-- Is this summary about a postcondition violation?
		do
			Result := exception_code = postcondition
		end

	is_class_invariant_violation: BOOLEAN
			-- Is this summary about a class invariant violation?
		do
			Result := exception_code = class_invariant
		end

	is_assertion_violation: BOOLEAN
			-- Is this summary about an assertion violation?
		do
			Result := exception_code = check_instruction
		end

feature -- Access (Failing position)

	exception_code: INTEGER assign set_exception_code
			-- Code for the exception.
			-- Set to 0, for exceptions other than pre-/post-condition violation, assertion violation,
			--		feature call on void target, or class invariant violation.
			-- Refer to {EXCEP_CONST}.

	failing_position_breakpoint_index: INTEGER assign set_failing_position_breakpoint_index
			-- Breakpoint index of the failing position, which is
			--		indicated by the first exception trace frame.
			-- Set to 0 in case of a class invariant violation.

	failing_feature_name: STRING assign set_failing_feature_name
			-- Name of the failing feature, as indicated by the first exception trace frame.
		do
			if failing_feature_name_cache = Void then
				create failing_feature_name_cache.make_empty
			end
			Result := failing_feature_name_cache
		end

	failing_feature: FEATURE_I
			-- Feature that has failed.
		require
			failing_context_class_attached: failing_context_class /= Void
			failing_feature_name_not_empty: failing_feature_name /= Void
					and then not failing_feature_name.is_empty
			not_class_invariant_violation: not is_class_invariant_violation
		do
			if failing_feature_cache = Void then
				failing_feature_cache := failing_context_class.feature_named (failing_feature_name)
			end

			Result := failing_feature_cache
		ensure
			same_name: Result.feature_name ~ failing_feature_name
		end

	failing_context_class_name: STRING assign set_failing_context_class_name
			-- Name of the context class of the failing feature.
		do
			if failing_context_class_name_cache = Void then
				create failing_context_class_name_cache.make_empty
			end
			Result := failing_context_class_name_cache
		end

	failing_context_class: CLASS_C
			-- Context class of `failing_feature'.
		require
			failing_context_class_name_not_empty: failing_context_class_name /= Void
					and then not failing_context_class_name.is_empty
		do
			if failing_context_class_cache = Void then
				failing_context_class_cache := first_class_starts_with_name (failing_context_class_name)
			end

			Result := failing_context_class_cache
		ensure
			same_name: Result.name ~ failing_context_class_name
		end

	failing_written_class_name: STRING assign set_failing_written_class_name
			-- Name of the written class of the failing feature.
		do
			if failing_written_class_name_cache = Void then
				create failing_written_class_name_cache.make_empty
			end
			Result := failing_written_class_name_cache
		end

	failing_written_class: CLASS_C
			-- Written class of `failing_feature'
		require
			failing_feature_attached: failing_feature /= Void
			failing_written_class_name_not_empty: failing_written_class_name /= Void
					and then not failing_written_class_name.is_empty
		do
			if failing_written_class_cache = Void then
				failing_written_class_cache := failing_feature.written_class
			end

			Result := failing_written_class_cache
		ensure
			same_name: Result.name = failing_written_class_name
		end

	failing_assertion_tag: STRING assign set_failing_assertion_tag
			-- Tag of the failing assertion, in context of the failing feature.
		do
			if failing_assertion_tag_cache = Void or failing_assertion_tag_cache.is_empty then
				failing_assertion_tag_cache := once "noname"
			end
			Result := failing_assertion_tag_cache
		end

feature -- Access (recipient)

	recipient_breakpoint_index: INTEGER assign set_recipient_breakpoint_index
			-- Breakpoint index of the exception recipient.

	recipient_feature_name: STRING assign set_recipient_feature_name
			-- Name of the feature as the recipient.
		do
			if recipient_feature_name_cache = void then
				create recipient_feature_name_cache.make_empty
			end

			Result := recipient_feature_name_cache
		end

	recipient_feature: FEATURE_I
			-- Recipient feature.
		require
			recipient_context_class_attached: recipient_context_class /= Void
			recipient_feature_name_not_empty: recipient_feature_name /= Void
					and then not recipient_feature_name.is_empty
		do
			if recipient_feature_cache = Void then
				recipient_feature_cache := recipient_context_class.feature_named (recipient_feature_name)
			end

			Result := recipient_feature_cache
		ensure
			is_consistent: Result.feature_name ~ recipient_feature_name
		end

	recipient_context_class_name: STRING assign set_recipient_context_class_name
			-- Name of the recipient context class.
		do
			if recipient_context_class_name_cache = Void then
				create recipient_context_class_name_cache.make_empty
			end

			Result := recipient_context_class_name_cache
		end

	recipient_context_class: CLASS_C
			-- Context class of recipient feature.
		require
			recipient_context_class_name_not_empty: recipient_context_class_name /= Void
					and then not recipient_context_class_name.is_empty
		do
			if recipient_context_class_cache = Void then
				recipient_context_class_cache := first_class_starts_with_name (recipient_context_class_name)
			end

			Result := recipient_context_class_cache
		ensure
			is_consistent: Result.name ~ recipient_context_class_name
		end

	recipient_written_class_name: STRING assign set_recipient_written_class_name
			-- Name of the recipient written class.
		do
			if recipient_written_class_name_cache = Void then
				recipient_written_class_name_cache := recipient_context_class_name.twin
			end

			Result := recipient_written_class_name_cache
		end

	recipient_written_class: CLASS_C
			-- Written class of the recipient feature.
		require
			recipient_written_class_name_not_empty: recipient_written_class_name /= Void
					and then not recipient_written_class_name.is_empty
		do
			if recipient_written_class_cache = Void then
				recipient_written_class_cache := first_class_starts_with_name (recipient_written_class_name)
			end

			Result := recipient_written_class_cache
		ensure
			is_consistent: Result.name ~ recipient_written_class_name
		end

feature -- Status set

	set_exception_code (a_code: INTEGER)
			-- Set `exception_code'.
		require
			valid_code_or_zero: a_code = 0 or else valid_code (a_code)
		do
			exception_code := a_code
		end

	set_failing_position_breakpoint_index (a_index: INTEGER)
			-- Set `failing_position_breakpoint_index'.
		require
			valid_breakpoint_index:	a_index >= 0
		do
			failing_position_breakpoint_index := a_index
		end

	set_failing_feature_name (a_name: STRING)
			-- Set `failing_feature_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			failing_feature_name_cache := a_name.twin
			failing_feature_cache := Void
		end

	set_failing_context_class_name (a_name: STRING)
			-- Set `failing_context_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			failing_context_class_name_cache := a_name.twin
			failing_context_class_cache := Void
		end

	set_failing_written_class_name (a_name: STRING)
			-- Set `failing_written_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			failing_written_class_name_cache := a_name.twin
			failing_written_class_cache := Void
		end

	set_failing_assertion_tag (a_tag: STRING)
			-- Set `failing_assertion_tag'.
		do
			if a_tag = Void or a_tag.is_empty then
				failing_assertion_tag_cache := once "noname"
			else
				failing_assertion_tag_cache := a_tag.twin
			end
		end

	set_recipient_breakpoint_index (a_index: INTEGER)
			-- Set `recipient_breakpoint_index'.
		require
			recipient_feature_attached: recipient_feature /= Void
			valid_breakpoint_index: recipient_feature.first_breakpoint_slot_index <= a_index
					and then a_index <= recipient_feature.number_of_breakpoint_slots
		do
			recipient_breakpoint_index := a_index
		end

	set_recipient_feature_name (a_name: STRING)
			-- Set `recipient_feature_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			recipient_feature_name_cache := a_name.twin
			recipient_feature_cache := Void
		end

	set_recipient_context_class_name (a_name: STRING)
			-- Set `recipient_context_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			recipient_context_class_name_cache := a_name.twin
			recipient_context_class_cache := Void
		end

	set_recipient_written_class_name (a_name: STRING)
			-- Set `recipient_written_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			recipient_written_class_name_cache := a_name.twin
			recipient_written_class_cache := Void
		end

feature{NONE} -- Cache

	failing_feature_name_cache: STRING
			-- Cache for `failing_feature_name'.

	failing_context_class_name_cache: STRING
			-- Cache for `failing_context_class_name'.

	failing_written_class_name_cache: detachable STRING
			-- Cache for `failing_written_class_name'.

	failing_assertion_tag_cache: STRING
			-- Cache for `failing_assertion_tag'.

	failing_feature_cache: FEATURE_I
			-- Cache for `failing_feature'.

	failing_context_class_cache: CLASS_C
			-- Cache for `failing_context_class'.

	failing_written_class_cache: CLASS_C
			-- Cache for `failing_written_class'.

	recipient_written_class_cache: CLASS_C
			-- Cache for `recipient_written_class'.

	recipient_written_class_name_cache: STRING
			-- Cache for `recipient_written_class_name'.

	recipient_context_class_cache: CLASS_C
			-- Cache for `recipient_context_class'.

	recipient_context_class_name_cache: STRING
			-- Cache for `recipient_context_class'

	recipient_feature_cache: FEATURE_I
			-- Cache for `recipient_feature'.

	recipient_feature_name_cache: STRING
			-- Cache for `recipient_feature_name'.


end
