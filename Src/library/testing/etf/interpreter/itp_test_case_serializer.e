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

	EXCEPTIONS
		rename
			exception as exp,
			class_name as class__name
		end

create
	make

feature{NONE} -- Initialization

	make (a_interpreter: like interpreter) is
			-- Initialization `interpreter' with `a_interpreter'.
		require
			a_interpreter_attached: a_interpreter /= Void
		do
			interpreter := a_interpreter
			create object_graph_traversor
			create test_case_hashs.make (2048)
			test_case_hashs.compare_objects
		ensure
			interpreter_set: interpreter = a_interpreter
		end

feature -- Access

	interpreter: ITP_INTERPRETER
			-- AutoTest interpreter attached to current serializer

	test_case_hashs: HASH_TABLE [STRING, INTEGER]
			-- Table of hash codes for test cases seen so far.
			-- Key is hash code, value is the string representation of that hash code

	string_representation: STRING is
			-- String representation of the test case
		local
			i: INTEGER
			l_last: INTEGER
			l_lower, l_upper: INTEGER
			l_var_tbl: HASH_TABLE [INTEGER, INTEGER]
			l_var_id: INTEGER
			l_description: like object_description
			l_index: INTEGER
			l_object: detachable ANY
			l_should_serialize: BOOLEAN
			l_hash: INTEGER
		do
			if is_test_case_setup then
				l_hash := test_case_hash_code.hash_code
				l_should_serialize :=
					interpreter.is_duplicated_test_case_serialized or else
					not test_case_hashs.has (l_hash)

				if not l_should_serialize then
					Result := ""
				else
					if not interpreter.is_duplicated_test_case_serialized then
						test_case_hashs.put (test_case_hash_code, l_hash)
					end

					l_last := operands.count - 1
					create Result.make (1024)
					Result.append (once "<serialization>%N")

						-- Synthesize class.
					Result.append (once "<class>%N")
					Result.append (class_name)
					Result.append (once "%N</class>%N")

						-- Synthesize time.
					Result.append (once "<time>")
					Result.append (time.out)
					Result.append (once "</time>%N")

						-- Synthesize test case body.
					Result.append (once "<test_case>%N")

						-- Synthesize return value.
					if is_query then
						Result.append (once "v_")
						Result.append (operands.item (l_last).out)
						Result.append (once " := ")
					end

					if is_creation then
						Result.append (once "create {")
						Result.append (types.item (0))
						Result.append (once "}")
					end

					Result.append (once "v_")
					Result.append (operands.item (0).out)
					Result.append_character ('.')
					Result.append (feature_name)

						-- Synthesize arguments.
					if argument_count > 0 then
						Result.append (once " (")
						from
							i := 1
						until
							i > argument_count
						loop
							Result.append (once "v_")
							Result.append (operands.item (i).out)
							if i < argument_count then
								Result.append (once ", ")
							end
							i := i + 1
						end
						Result.append (once ")")
					end
					Result.append (once "%N</test_case>%N")

						-- Synthesize type information.
					Result.append (once "<types>%N")
					from
						i := 0
						create l_var_tbl.make (5)
					until
						i > l_last
					loop
						l_var_id := operands.item (i)
						if not l_var_tbl.has (l_var_id) then
							l_var_tbl.put (l_var_id, l_var_id)
							append_variable_with_type (l_var_id, types.item (i), Result)
						end
						i := i + 1
					end
					Result.append (once "</types>%N")

						-- Synthesize all AutoTest created variables in current test case.
					l_description := object_description
					Result.append (once "<all_variables>%N")
					from
						l_description.start
					until
						l_description.after
					loop
						l_index := l_description.key_for_iteration
						l_object := l_description.item_for_iteration
						if l_object = Void then
							append_variable_with_type (l_index, once "NONE", Result)
						else
							append_variable_with_type (l_index, l_object.generating_type, Result)
						end
						l_description.forth
					end
					Result.append (once "</all_variables>%N")

						-- Synthesize trace.
					Result.append (once "<trace>%N<![CDATA[%N")
					if exception /= Void then
						Result.append (exception)
					end
					Result.append (once "%N]]>%N</trace>%N")

						-- Synthesize hash.
					Result.append (once "<hash_code>")
					Result.append (test_case_hash_code)
					Result.append (once "</hash_code>%N")

						-- Synthesize object summary.
					Result.append (once "<object_state>%N")
					from
						object_summary.start
					until
						object_summary.after
					loop
						Result.append (object_summary.item_for_iteration)
						Result.append_character ('%N')
						object_summary.forth
					end
					Result.append (once "</object_state>%N")

						-- Synthesize serialization
					Result.append (once "<data_length>")
					Result.append (object_serialization.count.out)
					Result.append (once "</data_length>%N")
					Result.append (once "<data><![CDATA[")
					if object_serialization /= Void then
						Result.append (object_serialization)
					end
					Result.append (once "]]></data>%N")
					Result.append (once "%N</serialization>%N")
				end
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	append_variable_with_type (a_index: INTEGER; a_type: STRING; a_buffer: STRING)
			-- Append variable with `a_index' and `a_type' into `a_buffer'.
		do
			a_buffer.append (once "%Tv_")
			a_buffer.append_integer (a_index)
			a_buffer.append (once ": ")
			if a_index = 0 then
				a_buffer.append (once "NONE")
			else
				a_buffer.append (a_type)
			end
			a_buffer.append_character ('%N')
		end

feature -- Status report

	is_test_case_setup: BOOLEAN
			-- Is the last test case set by `setup_test_case' valid?

feature -- Basic operations

	setup_test_case (a_test_case: detachable ANY) is
			-- Setup information about the current test case.
			-- Set `is_test_case_setup' to True if `a_test_case' contain valid information of a test case,
			-- otherwise, set `is_test_case_setup' to False'.
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
			-- Set `is_test_case_setup' with `b'.
		do
			is_test_case_setup := b
		ensure
			is_test_case_valid_set: is_test_case_setup
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
			if is_test_case_setup then
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
			l_sum_data: TUPLE [summary: STRING; hash: INTEGER]
			l_hash_code: STRING
		do
			if is_test_case_setup then
					-- Setup test case hash code, which consists the hash of the states of all operands.
				create test_case_hash_code.make (64)
				l_hash_code := test_case_hash_code
				l_hash_code.append (class_name)
				l_hash_code.append_character ('.')
				l_hash_code.append (feature_name)
				l_hash_code.append_character ('.')

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
					l_sum_data := l_interpreter.object_summary (l_operands.item (i))
					l_hash_code.append_integer (l_sum_data.hash)
					if i < l_upper then
						l_hash_code.append_character ('.')
					end
					l_summary.put (commented_string (l_sum_data.summary), i)
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
			l_stream: STRING
			l_data: TUPLE [serialization: STRING; description: HASH_TABLE [detachable ANY, INTEGER]]
		do
			if is_test_case_setup then

				if is_creation then
					l_lower := 1
					l_upper := argument_count
				else
					l_lower := 0
					l_upper := l_lower + argument_count
				end
				l_data := objects_as_string (operands, l_lower, l_upper)
				object_serialization := l_data.serialization
				object_description := l_data.description
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

	test_case_hash_code: STRING
			-- Hash code for current test case

	object_serialization: detachable STRING
			-- String representing the serialized data for objects specified by
			-- `operands'

	object_description: HASH_TABLE [detachable ANY, INTEGER]
			-- List of variables in `object_serialization' along with their object index.
			-- Key is variable index, value is the variable object itself.

feature{NONE} -- Implementation

	objects_as_string (a_objects: SPECIAL [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): TUPLE [serialization: STRING; description: like recursively_referenced_objects] is
			-- Serialized version of objects whose ID are specified by `a_objects' starting from
			-- position `a_lower' and ending at position `a_upper'.
			-- `serialization' is the serialized stream for those objects.
			-- `description' describes what variables are in the stream and what their vairable IDs are.
		local
			l: SPECIAL [INTEGER]
			i: INTEGER
			l_obj_list: like recursively_referenced_objects
			l_objects: SPECIAL [TUPLE [index: INTEGER; object: detachable ANY]]
			l_index: INTEGER
			l_object: detachable ANY
			l_data: TUPLE [index: INTEGER; object: detachable ANY]
		do
				-- Filter out unnecessary objects.
			create l.make (a_upper - a_lower + 1)
			from
				i := a_lower
			until
				i > a_upper
			loop
				l.put (a_objects.item (i), i - a_lower)
				i := i + 1
			end

				-- Recursively traverse object graphs starting from objects given in `l'.
			if a_lower <= a_upper then
				l_obj_list := recursively_referenced_objects (l)
				create l_objects.make (l_obj_list.count)
				from
					i := 0
					l_obj_list.start
				until
					l_obj_list.after
				loop
					l_index := l_obj_list.key_for_iteration
					l_object := l_obj_list.item_for_iteration
					l_objects.put ([l_index, l_object], i)
					i := i + 1
					l_obj_list.forth
				end
			else
				create l_obj_list.make (0)
				create l_objects.make (0)
			end
			Result := [serialized_object (l_objects), l_obj_list]
		end

	recursively_referenced_objects (a_roots: SPECIAL [INTEGER]): HASH_TABLE [detachable ANY, INTEGER]
			-- Objects in `interpreter''s object pool that are recursively referenced by varibles whose IDs are
			-- specified by `a_roots'. Result is a list of such referenced object pairs. In each pair, `index' is the
			-- variable index in the object pool, `object' is the variable itself.
			-- Objects specified in `a_roots' are also included in Result.
			-- A pair [Void, 1] is always included in Result.
		require
			a_roots_not_empty: a_roots.count > 0
		local
			l_tbl: HASH_TABLE [detachable ANY, INTEGER]
			i: INTEGER
			c: INTEGER
			l_store: ITP_STORE
			l_object: detachable ANY
			l_traversor: like object_graph_traversor
			l_index: INTEGER
		do
			create l_tbl.make (20)
				-- Insert [Void, v_1], becuase AutoTest will always set v_1 to Void.
			l_tbl.put (Void, 1)

			l_store := interpreter.store
			l_traversor := object_graph_traversor

				-- Iterate through all root objects.
			from
				i := 0
				c := a_roots.count
			until
				i = c
			loop
				l_index := a_roots.item (i)
				l_object := l_store.variable_value (l_index)
				if l_object /= Void then
						-- For each root object, recursively traverse the whole object graph.
					l_tbl.put (l_object, l_index)
					l_traversor.wipe_out
					l_traversor.set_object_action (agent on_object_visited (?, l_tbl))
					l_traversor.set_root_object (l_object)
					l_traversor.traverse
				end
				i := i + 1
			end
			Result := l_tbl
		end

	on_object_visited (a_object: detachable ANY; a_object_table: HASH_TABLE [detachable ANY, INTEGER])
			-- Action to be performed when `a_object' is visited during object graph traversal.
			-- If `a_object' is found in the object pool in `interpreter', put it in `a_object_table'.
			-- Key of `a_object_table' is the object index in the object pool, value is the object itself.
		local
			l_interpreter: like interpreter
			l_index: INTEGER
		do
			l_interpreter := interpreter
			l_index := l_interpreter.store.variable_index (a_object)
			if l_index > 0 then
				a_object_table.put (a_object, l_index)
			end
		end

	object_graph_traversor: OBJECT_GRAPH_BREADTH_FIRST_TRAVERSABLE
			-- Object graph traversor, used to find objects in the object pool
			-- that are also (recursively) referenced by a given object.

invariant
	interpreter_attached: interpreter /= Void

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
