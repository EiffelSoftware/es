note
	description: "Test case serializer"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITP_TEST_CASE_SERIALIZER

inherit
	ITP_SHARED_CONSTANTS

	EQA_TEST_CASE_SERIALIZATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_interpreter: like interpreter) is
			-- Initialization `interpreter' with `a_interpreter'.
		require
			a_interpreter_attached: a_interpreter /= Void
		do
			interpreter := a_interpreter
		ensure
			interpreter_set: interpreter = a_interpreter
		end

feature -- Access

	interpreter: ITP_INTERPRETER
			-- AutoTest interpreter attached to current serializer

	string_representation: STRING is
			-- String representation of the test case
		local
			i: INTEGER
			l_last: INTEGER
			l_lower, l_upper: INTEGER
			l_var_tbl: HASH_TABLE [INTEGER, INTEGER]
			l_var_id: INTEGER
		do
			if is_test_case_valid then
				l_last := operands.count - 1
				create Result.make (1024)
				Result.append ("<serialization>%N")

					-- Synthesize class.
				Result.append ("<class>%N")
				Result.append (class_name)
				Result.append ("%N</class>%N")

					-- Synthesize time.
				Result.append ("<time>")
				Result.append (time.out)
				Result.append ("</time>%N")

					-- Synthesize test case body.
				Result.append ("<test_case>%N")

					-- Synthesize return value.
				if is_query then
					Result.append ("v_")
					Result.append (operands.item (l_last).out)
					Result.append (" := ")
				end

				if is_creation then
					Result.append ("create {")
					Result.append (types.item (0))
					Result.append ("}")
				end

				Result.append ("v_" + operands.item (0).out)
				Result.append (".")
				Result.append (feature_name)

					-- Synthesize arguments.
				if argument_count > 0 then
					Result.append (" (")
					from
						i := 1
					until
						i > argument_count
					loop
						Result.append ("v_")
						Result.append (operands.item (i).out)
						if i < argument_count then
							Result.append (", ")
						end
						i := i + 1
					end
					Result.append (")")
				end
				Result.append ("%N</test_case>%N")

					-- Synthesize type information.
				Result.append ("<types>%N")
				from
					i := 0
					create l_var_tbl.make (5)
				until
					i > l_last
				loop
					l_var_id := operands.item (i)
					if not l_var_tbl.has (l_var_id) then
						l_var_tbl.put (l_var_id, l_var_id)
						Result.append ("v_")
						Result.append (l_var_id.out)
						Result.append (": ")
						Result.append (types.item (i))
						Result.append ("%N")
					end
					i := i + 1
				end
				Result.append ("</types>%N")

					-- Synthesize trace.
				Result.append ("<trace>%N<![CDATA[%N")
				if exception /= Void then
					Result.append (exception)
				end
				Result.append ("%N]]>%N</trace>%N")

					-- Synthesize object summary.
				Result.append ("<object_state>%N")
				from
					object_summary.start
				until
					object_summary.after
				loop
					Result.append (object_summary.item_for_iteration)
					Result.append ("%N")
					object_summary.forth
				end
				Result.append ("</object_state>%N")

					-- Synthesize serialization
				Result.append ("<data_length>")
				Result.append (object_serialization.count.out)
				Result.append ("</data_length>%N")
				Result.append ("<data><![CDATA[")
				if object_serialization /= Void then
					Result.append (object_serialization)
				end
				Result.append ("]]></data>%N")
				Result.append ("%N</serialization>%N")
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_test_case_valid: BOOLEAN
			-- Is the last test case set by `setup_test_case' valid?

feature -- Basic operations

	setup_test_case (a_test_case: detachable ANY) is
			-- Setup information about the current test case.
			-- Set `is_test_case_valid' to True if `a_test_case' contain valid information of a test case,
			-- otherwise, set `is_test_case_valid' to False'.
		do
				-- Check if `a_test_case' contains correct information.
			if attached{detachable TUPLE [class_name: STRING; feature_name: STRING; test_case_index: INTEGER; time: INTEGER; operands: SPECIAL [INTEGER]; types: SPECIAL [STRING]; argument_count: INTEGER; is_creation: BOOLEAN; is_query: BOOLEAN]} a_test_case as l_tc then
				class_name := l_tc.class_name
				feature_name := l_tc.feature_name
				test_case_index := l_tc.test_case_index
				time := l_tc.time
				operands := l_tc.operands
				types := l_tc.types
				argument_count := l_tc.argument_count
				is_creation := l_tc.is_creation
				is_query := l_tc.is_query
			end

				-- Check if `a_test_case' contains information of a valid test case.
			if
				(class_name /= Void and then not class_name.is_empty) and then
				(feature_name /= Void and then not feature_name.is_empty) and then
				test_case_index > 0 and then
				(operands /= Void and then types /= Void and then operands.count = types.count) and then
				argument_count < operands.count and then
				(not (is_creation and is_query))
			then
				set_is_test_case_valid (True)

			else
				set_is_test_case_valid (False)
			end
		end

	set_is_test_case_valid (b: BOOLEAN) is
			-- Set `is_test_case_valid' with `b'.
		do
			is_test_case_valid := b
		ensure
			is_test_case_valid_set: is_test_case_valid
		end

	retrieve_pre_state is
			-- Retrieve state of objects before test case
			-- execution.
		do
			retrieve_object_state_summary
			retrieve_object_serialization
		end

	retrieve_post_state is
			-- Retrieve post state of the test case.
		do
			if is_test_case_valid then
				exception := interpreter.error_buffer
			else
				exception := Void
			end
		end

	retrieve_object_state_summary is
			-- Retrieve object state summary from objects specified by `operands'
			-- and store summaries in `object_summary'.
		local
			i: INTEGER
			l_upper: INTEGER
			l_summary: like object_summary
			l_operands: like operands
			l_interpreter: like interpreter
		do
			if is_test_case_valid then
				l_operands := operands
				l_interpreter := interpreter
				from
					if is_creation then
						i := 1
						l_upper := argument_count
					else
						i := 0
						l_upper := argument_count
					end
					create l_summary .make (l_upper - i + 1)
				until
					i > l_upper
				loop
					l_summary.put (commented_string (l_interpreter.object_summary (l_operands.item (i))) , i)
					i := i + 1
				end
				object_summary := l_summary
			else
				object_summary := Void
			end
		end

	commented_string (a_string: STRING): STRING is
			-- A commented version of `a_string', with every line lead by "--"
		require
			a_string_attached: a_string /= Void
		local
			l_lines: LIST [STRING]
			l_header: STRING
			l_line: STRING
		do
			l_header := "--"
			l_lines := a_string.split ('%N')
			create Result.make (a_string.count + 10)
			from
				l_lines.start
			until
				l_lines.after
			loop
				l_line := l_lines.item_for_iteration
				if not l_line.is_empty then
					l_line.prepend (l_header)
					l_line.extend ('%N')
					Result.append (l_line)
				end
				l_lines.forth
			end
		ensure
			result_attached: Result /= Void
		end

	retrieve_object_serialization is
			-- Retrieve serialized data for objects specified by `operands'
			-- and store the data in `object_serialization'.
		local
			l_lower: INTEGER
			l_upper: INTEGER
		do
			if is_test_case_valid then

				if is_creation then
					l_lower := 1
					l_upper := argument_count
				else
					l_lower := 0
					l_upper := l_lower + argument_count
				end
				object_serialization := objects_as_string (operands, l_lower, l_upper)
			else
				object_serialization := Void
			end
		end

feature{NONE} -- Implementation

	class_name: detachable STRING
			-- Class name of the test case

	feature_name: detachable STRING
			-- Feature name of the test case

	test_case_index: INTEGER
			-- Test case index

	time: INTEGER
			-- Time in millisecond relative to the starting of current test session

	operands: detachable SPECIAL [INTEGER]
			-- Object index of operands for the test case
			-- Target object is in the 0-th position,
			-- followed by arguments, if any, and then by result object, if any.
			-- Note: Strictly speaking, the result object is not an operand for the feature call.

	types: detachable SPECIAL [STRING]
			-- Type names of the `operands'.
			-- Type names appear in the same order as their corresponding objects in `operands'.

	argument_count: INTEGER
			-- Number of arguments in the feature with name `feature_name'

	is_creation: BOOLEAN
			-- Is feature with `feature_name' a creator?

	is_query: BOOLEAN
			-- Is feature with `feature_name' a query?

	exception: detachable STRING
			-- Exception trace of the last test case
			-- Can be empty if there was no exception
			-- or Void if the test case is not properly setup.

feature{NONE} -- Implementation

	object_summary: detachable HASH_TABLE [STRING, INTEGER]
			-- Table of object state summary
			-- Key is the object index,
			-- value is a string containing state summary for that object

	object_serialization: detachable STRING
			-- String representing the serialized data for objects specified by
			-- `operands'

feature{NONE} -- Implementation

	objects_as_string (a_objects: SPECIAL [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): STRING is
			-- Serialized version of objects whose ID are specified by `a_objects' starting from
			-- position `a_lower' and ending at position `a_upper'.
		local
			l: SPECIAL [detachable ANY]
			i: INTEGER
			l_interpreter: like interpreter
		do
			create l.make (a_upper - a_lower + 1)
			l_interpreter := interpreter
			from
				i := a_lower
			until
				i > a_upper
			loop
				l.put (l_interpreter.variable_at_index (a_objects.item (i)), i - a_lower)
				i := i + 1
			end
			Result := serialized_object (l)
		end

invariant
	interpreter_attached: interpreter /= Void

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
