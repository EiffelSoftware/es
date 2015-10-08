note
	description: "Information of a test case"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TEST_CASE_SIGNATURE

inherit
	HASHABLE
		redefine
			is_equal,
			out
		end

	EPA_UTILITY
		undefine
			is_equal,
			out
		end

create
	make,
	make_with_string

feature{NONE} -- Initialization

	make_with_string (a_tc_name: STRING)
			-- Initialize Current with a test case name `a_tc_name'.
		do
			initialize (a_tc_name)
		ensure
			id_attached: id /= Void
		end

	make (a_class_under_test: STRING; a_feature_under_test: STRING; a_recipient_class: STRING; a_recipient: STRING; a_exception_code: INTEGER; a_bpslot: INTEGER; a_tag: STRING; a_passing: BOOLEAN; a_uuid: STRING)
			-- Initialize Current.
		do
			class_under_test := a_class_under_test.twin
			feature_under_test:= a_feature_under_test.twin
			recipient_class := a_recipient_class.twin
			recipient := a_recipient.twin
			exception_code := a_exception_code
			breakpoint_slot := a_bpslot
			tag := a_tag.twin
			is_passing := a_passing
			initialize_id
			uuid := a_uuid.twin
		ensure
			id_attached: id /= Void
		end

feature -- Access

	class_under_test: STRING
			-- Name of the class under test.

	class_under_test_: CLASS_C
		do
			Result := first_class_starts_with_name (class_under_test)
		end

	feature_under_test: STRING
			-- Name of the feature under test.

	class_and_feature_under_test: STRING
			-- Class and feature under test.
		do
			Result := "" + class_under_test + "." + feature_under_test
		end

	recipient_class: STRING
			-- Name of the class containing `recipient' in case of a failed test case.
			-- In a passing test case, same as `class_under_test'.

	recipient: STRING
			-- Name of the recipient in case of a failed test case.
			-- In a passing test case, same as `feature_under_test'.

	recipient_class_: CLASS_C
			-- Class for `recipient_class'
		do
			Result := first_class_starts_with_name (recipient_class)
		ensure
			result_attached: Result /= Void
		end

	recipient_written_class: CLASS_C
			-- Written class of `recipient_'
		do
			Result := recipient_.written_class
		end

	origin_recipient: FEATURE_I
			-- The original version of `recipient_' in `recipient_written_class'
		do
			Result := recipient_written_class.feature_of_rout_id_set (recipient_.rout_id_set)
		end

	recipient_: FEATURE_I
			-- Feature for `recipient'
		do
			Result := recipient_class_.feature_named (recipient)
		ensure
			result_attached: Result /= Void
		end

	breakpoint_slot: INTEGER
			-- Breakpoint slot of the exception in case of a failed test case.
			-- In a passing test case, 0.

	nested_breakpoint_slot: INTEGER
			-- Nested breakpoint slot of the exception in a failing test case.
			-- In a passing test case, 0.

	exception_code: INTEGER
			-- Exception code in case of a failed test case.
			-- In a passing test case, 0.

	tag: STRING
			-- Tag of the failing assertion in case of a failed test case.
			-- In a passing test case, "noname"

	id: STRING
			-- Identifier of Current test case

	uuid: STRING
			-- A sequence of digits serving as a universal identifier of current test case

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make (256)

			Result.append ("Class under test: ")
			Result.append (class_under_test)
			Result.append_character ('%N')

			Result.append ("Feature under test: ")
			Result.append (feature_under_test)
			Result.append_character ('%N')

			Result.append ("Recipient class: ")
			Result.append (recipient_class)
			Result.append_character ('%N')

			Result.append ("Recipient: ")
			Result.append (recipient)
			Result.append_character ('%N')

			Result.append ("Exception code: ")
			Result.append (exception_code.out)
			Result.append_character ('%N')

			Result.append ("Breakpoint slot: ")
			Result.append (breakpoint_slot.out)
			Result.append_character ('%N')

			Result.append ("Tag: ")
			Result.append (tag)
			Result.append_character ('%N')

			Result.append ("Passing: ")
			Result.append (is_passing.out)
			Result.append_character ('%N')
		end

	first_break_point_slot: INTEGER
			-- Index of the first break point slot.
			-- Include those of pre/post conditions.
		do
			Result := 1
		end

	last_break_point_slot: INTEGER
			-- Index of the last break point slot.
			-- Include those of pre/post conditions.
		do
			Result := recipient_.number_of_breakpoint_slots
		end

feature -- Status report

	is_passing: BOOLEAN
			-- Is current a passing test case?

	is_failing: BOOLEAN
			-- Is currrent a failing test case?
		do
			Result := not is_passing
		ensure
			good_result: Result = not is_passing
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := id ~ other.id
		end

	is_testing_same_feature (a_signature_id: STRING): BOOLEAN
			--
		require
			a_signature_id /= Void and then not a_signature_id.is_empty
			is_signature_id: True
		do
			Result := a_signature_id.starts_with (class_and_feature_under_test + ".")
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id.hash_code
		ensure then
			good_result: Result = id.hash_code
		end

feature -- Setting

	set_is_passing (b: BOOLEAN)
			-- Set `is_passing' with `b'.
		do
			is_passing := b
		ensure
			is_passing_set: is_passing = b
		end

	set_uuid (a_uuid: STRING)
			-- Set `uuid' with `a_uuid'.
			-- Create a new copy of `a_uuid'.
		require
			a_uuid_attached: a_uuid /= Void
		do
			uuid := a_uuid.twin
		end

feature{NONE} -- Implementation

	initialize (a_class_name: STRING)
			-- Initialize with `a_class_name'
  		local
  			l_parts: LIST [STRING]
  			l_part: STRING
		do
			l_parts := string_slices (a_class_name, once "__")
			l_parts.start
			l_parts.remove 		-- Bypass "TC".
			class_under_test := l_parts.i_th (1).as_upper
			l_parts.remove
			feature_under_test := l_parts.i_th (1).as_lower
			l_parts.remove
			l_parts.remove		-- Bypass "FUN"/"CMD".
			recipient_class := class_under_test
			recipient := feature_under_test
			is_passing := True
			tag := "noname"

			from
				l_parts.start
			until
				l_parts.after
			loop
				l_part := l_parts.item_for_iteration
				if not l_parts.is_empty then
						-- UUID doesn't need to always start with digit. Max 10.12.2011
					-- if l_parts.islast and then l_part.item (1).is_digit then
					if l_parts.islast then
						uuid := l_part.twin
					elseif l_part.is_equal (once "S") then
						is_passing := True

					elseif l_part.is_equal (once "F") then
						is_passing := False

					elseif l_part.starts_with (once "c") then
						exception_code := l_part.substring (2, l_part.count).to_integer

					elseif l_part.starts_with (once "b") then
						breakpoint_slot := l_part.substring (2, l_part.count).to_integer

					elseif l_part.starts_with (once "REC_") then
						recipient_class := l_part.substring (5, l_part.count)
						l_parts.forth
						recipient := l_parts.item_for_iteration.as_lower

					elseif l_part.starts_with (once "TAG_") then
						tag := l_part.substring (5, l_part.count)
					end
				end
				l_parts.forth

			end
			initialize_id
		end

	initialize_id
			-- Initialize `id'.
		do
			create id.make (128)
			id.append (class_under_test)
			id.append_character ('.')
			id.append (feature_under_test)
			id.append_character ('.')
			id.append (exception_code.out)
			id.append_character ('.')
			id.append (breakpoint_slot.out)
			id.append_character ('.')
			id.append (recipient_class)
			id.append_character ('.')
			id.append (recipient)
			id.append ("." + tag)
		end

end
