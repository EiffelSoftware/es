note
	description: "Summary description for {AFX_TEST_CASE_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_INFO

create
	make

feature{NONE} -- Initialization

	make (a_tc_name: STRING)
			-- Initialize Current with a test case name `a_tc_name'.
		do
			initialize (a_tc_name)
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

	breakpoint_slot: INTEGER
			-- Breakpoint slot of the exception in case of a failed test case.
			-- In a passing test case, 0.

	exception_code: INTEGER
			-- Exception code in case of a failed test case.
			-- In a passing test case, 0.

	tag: STRING
			-- Tag of the failing assertion in case of a failed test case.
			-- In a passing test case, "noname"

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
		end

end
