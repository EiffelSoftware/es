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

	EPA_HASH_CALCULATOR

create
	make

feature{NONE} -- Initialization

	make (a_code: INTEGER; a_context_class_name, a_context_feature_name: STRING;
					a_failing_bp_index: INTEGER; a_failing_tag: STRING;
					a_recipient_context_class_name, a_recipient_feature_name: STRING;
					a_recipient_bp_index: INTEGER)
			-- Initialization
		do
			set_exception_code (a_code)
			set_failing_context_class_name (a_context_class_name)
			set_failing_feature_name (a_context_feature_name)
			set_failing_position_breakpoint_index (a_failing_bp_index)
			set_failing_assertion_tag (a_failing_tag)
			set_recipient_context_class_name (a_recipient_context_class_name)
			set_recipient_feature_name (a_recipient_feature_name)
			set_recipient_breakpoint_index (a_recipient_bp_index)
		end

feature -- Status report

	is_exception_supported: BOOLEAN
			-- Is the exception type supported?
		do
			Result := is_precondition_violation or else is_postcondition_violation
					or else is_class_invariant_violation or else is_assertion_violation
					or else is_void_call_target or else is_unmatched_inspect_value
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

	is_void_call_target: BOOLEAN
			-- Is this summary about a void call target?
		do
			Result := exception_code = Void_call_target
		end

	is_unmatched_inspect_value: BOOLEAN
		do
			Result := exception_code = Incorrect_inspect_value
		end

feature -- Hash

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_list: DS_LINKED_LIST [INTEGER]
		do
			create l_list.make
			l_list.force_last (exception_code)
			l_list.force_last (failing_context_class.class_id)
			l_list.force_last (failing_feature.feature_id)
			l_list.force_last (failing_position_breakpoint_index)
			l_list.force_last (failing_assertion_tag.hash_code)
			l_list.force_last (recipient_context_class.class_id)
			l_list.force_last (recipient_feature.feature_id)
			l_list.force_last (recipient_breakpoint_index)

			Result := l_list
		end

feature -- ID

	id: STRING
			-- ID of the summary.
		do
			if id_cache = Void then
				id_cache := "RECI_" + recipient_context_class_name + "__" + recipient_feature_name + "__"
							+ "b" + recipient_breakpoint_index.out + "__"
							+ "FAIL_" + failing_context_class_name + "__" + failing_feature_name + "__"
							+ "b" + failing_position_breakpoint_index.out + "__"
							+ "c" + exception_code.out
			end
			Result := id_cache
		end

feature -- Access (Failing position)

	exception_code: INTEGER assign set_exception_code
			-- Code for the exception.
			-- Set to 0, for exceptions other than pre-/post-condition violation, assertion violation,
			--		feature call on void target, or class invariant violation.
			-- Refer to {EXCEP_CONST}.

	failing_assertion_tag: STRING assign set_failing_assertion_tag
			-- Tag of the failing assertion, in context of the failing feature.

	failing_position_breakpoint_index: INTEGER assign set_failing_position_breakpoint_index
			-- Breakpoint index of the failing position, which is
			--		indicated by the first exception trace frame.
			-- Set to 0 in case of a class invariant violation.

	failing_feature_name: STRING assign set_failing_feature_name
			-- Name of the failing feature, as indicated by the first exception trace frame.

	failing_feature: FEATURE_I
			-- Feature that has failed.
		require
			failing_context_class_attached: failing_context_class /= Void
			failing_feature_name_not_empty: failing_feature_name /= Void
					and then not failing_feature_name.is_empty
			not_class_invariant_violation: not is_class_invariant_violation
		do
			Result := failing_context_class.feature_named (failing_feature_name)
		ensure
			same_name: Result.feature_name ~ failing_feature_name
		end

	failing_context_class_name: STRING assign set_failing_context_class_name
			-- Name of the context class of the failing feature.

	failing_context_class: CLASS_C
			-- Context class of `failing_feature'.
		require
			failing_context_class_name_not_empty: failing_context_class_name /= Void
					and then not failing_context_class_name.is_empty
		do
			Result := first_class_starts_with_name (failing_context_class_name)
		ensure
			same_name: Result.name ~ failing_context_class_name
		end

	failing_written_class: CLASS_C
			-- Written class of `failing_feature'
			-- In case of a class invariant violation, return `failing_context_class'.
		require
			class_available: failing_feature /= Void
					or else (is_class_invariant_violation and then failing_context_class /= Void)
		do
			if failing_feature /= Void then
				Result := failing_feature.written_class
			else
				check is_class_invariant_violation: is_class_invariant_violation end
				Result := failing_context_class
			end
		end

	failing_written_class_name: STRING
			-- Name of the written class of the failing feature.
		require
			failing_written_class_attached: failing_written_class /= Void
		do
			Result := failing_written_class.name
		end

feature -- Access (recipient)

	recipient_breakpoint_index: INTEGER assign set_recipient_breakpoint_index
			-- Breakpoint index of the exception recipient.

	recipient_context_class_name: STRING assign set_recipient_context_class_name
			-- Name of the recipient context class.

	recipient_context_class: CLASS_C
			-- Context class of recipient feature.
		require
			recipient_context_class_name_not_empty: recipient_context_class_name /= Void
					and then not recipient_context_class_name.is_empty
		do
			Result := first_class_starts_with_name (recipient_context_class_name)
		ensure
			is_consistent: Result.name ~ recipient_context_class_name
		end

	recipient_feature_name: STRING assign set_recipient_feature_name
			-- Name of the feature as the recipient.

	recipient_feature: FEATURE_I
			-- Recipient feature.
		require
			recipient_context_class_attached: recipient_context_class /= Void
			recipient_feature_name_not_empty: recipient_feature_name /= Void
					and then not recipient_feature_name.is_empty
		do
			Result := recipient_context_class.feature_named (recipient_feature_name)
		ensure
			is_consistent: Result.feature_name ~ recipient_feature_name
		end

	recipient_written_class: CLASS_C
			-- Written class of the recipient feature.
		require
			recipient_feature_attached: recipient_feature /= Void
		do
			Result := recipient_feature.written_class
		end

	recipient_written_class_name: STRING
			-- Name of the recipient written class.
		require
			recipient_written_class_attached: recipient_written_class /= Void
		do
			Result := recipient_written_class.name
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
			-- In case of a c-inline failing feature, the index could be 0.
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
			failing_feature_name := a_name.twin
		end

	set_failing_context_class_name (a_name: STRING)
			-- Set `failing_context_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			failing_context_class_name := a_name.twin
		end

	set_failing_assertion_tag (a_tag: STRING)
			-- Set `failing_assertion_tag'.
		do
			if a_tag = Void or a_tag.is_empty then
				failing_assertion_tag := once "noname"
			else
				failing_assertion_tag := a_tag.twin
			end
		end

	set_recipient_breakpoint_index (a_index: INTEGER)
			-- Set `recipient_breakpoint_index'.
			-- For c-inline features, such breakpoint index could be 0.
		require
			recipient_feature_attached: recipient_feature /= Void
			valid_breakpoint_index: 0 <= a_index
		do
			recipient_breakpoint_index := a_index
		end

	set_recipient_feature_name (a_name: STRING)
			-- Set `recipient_feature_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			recipient_feature_name := a_name.twin
		end

	set_recipient_context_class_name (a_name: STRING)
			-- Set `recipient_context_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			recipient_context_class_name := a_name.twin
		end

feature{NONE} -- Cache

	id_cache: STRING
			-- Cache for `id'.

end
