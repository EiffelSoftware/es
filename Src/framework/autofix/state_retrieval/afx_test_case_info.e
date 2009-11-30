note
	description: "Summary description for {AFX_TEST_CASE_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_INFO

inherit
	HASHABLE
		redefine
			is_equal,
			out
		end

	AFX_UTILITY
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

	make (a_class_under_test: STRING; a_feature_under_test: STRING; a_recipient_class: STRING; a_recipient: STRING; a_exception_code: INTEGER; a_bpslot: INTEGER; a_tag: STRING; a_passing: BOOLEAN)
			-- Initialize Current.
		do
			class_under_test := a_class_under_test.twin
			feature_under_test := a_feature_under_test.twin
			recipient_class := a_recipient_class.twin
			recipient := a_recipient.twin
			exception_code := a_exception_code
			breakpoint_slot := a_bpslot
			tag := a_tag.twin
			is_passing := a_passing
			initialize_id
		ensure
			id_attached: id /= Void
		end

feature -- Access

	class_under_test: STRING
			-- Name of class under test

	feature_under_test: STRING
			-- Name of feature under test

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

	exception_code: INTEGER
			-- Exception code in case of a failed test case.
			-- In a passing test case, 0.

	tag: STRING
			-- Tag of the failing assertion in case of a failed test case.
			-- In a passing test case, "noname"

	id: STRING
			-- Identifier of Current test case

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make (128)

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

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id.hash_code
		ensure then
			good_result: Result = id.hash_code
		end

feature{NONE} -- Implementation

	string_slices (a_string: STRING; a_separater: STRING): LIST [STRING]
			-- Split `a_string' on `a_separater', return slices.
		local
			l_index1, l_index2: INTEGER
			l_part: STRING
			l_done: BOOLEAN
		do
			create {LINKED_LIST [STRING]} Result.make
			from

			until
				l_done
			loop
				l_index2 := a_string.substring_index (a_separater, l_index1 + 1)
				if l_index2 = 0 then
					l_index2 := a_string.count + 1
					l_done := True
				end
				l_part := a_string.substring (l_index1 + 1, l_index2 - 1)
				Result.extend (l_part)
				l_index1 := l_index2 + 1
			end
		end

	initialize (a_class_name: STRING)
			-- Initialize with `a_class_name'
  		local
  			l_parts: LIST [STRING]
  			l_part: STRING
		do
			l_parts := string_slices (a_class_name, once "__")
			l_parts.start
			l_parts.remove
			class_under_test := l_parts.i_th (1)
			feature_under_test := l_parts.i_th (2).as_lower
			recipient_class := class_under_test
			recipient := feature_under_test
			is_passing := True
			tag := "noname"

			l_parts.start
			l_parts.remove
			l_parts.start
			l_parts.remove

			from
				l_parts.start
			until
				l_parts.after
			loop
				l_part := l_parts.item_for_iteration
				if not l_parts.is_empty then
					if l_part.is_equal (once "S") then
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
			id.append (recipient_class)
			id.append_character ('.')
			id.append (recipient)
			id.append_character ('.')
			id.append (exception_code.out)
			id.append_character ('.')
			id.append (breakpoint_slot.out)
			id.append_character ('.')
			id.append (tag)
			id.append_character ('.')
			if is_passing then
				id.append_character ('S')
			else
				id.append_character ('F')
			end
		end

end
