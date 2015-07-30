note
	description: "[Test case serializer]"
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

	ITP_TEST_CASE_SERIALIZATION_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make (a_interpreter: like interpreter; a_post_state_serialized: BOOLEAN)
			-- Initialization `interpreter' with `a_interpreter'.
			-- `a_post_state_serialized' indicates if post-state information should
			-- be serialized as well.
		require
			a_interpreter_attached: a_interpreter /= Void
		do
			interpreter := a_interpreter
			create object_graph_traversor
			create test_case_hashs.make (2048)
			create state_counts.make (2048)
			state_counts.compare_objects
			test_case_hashs.compare_objects
			is_post_state_serialized := a_post_state_serialized
		ensure
			interpreter_set: interpreter = a_interpreter
		end

feature -- Access

	interpreter: ITP_INTERPRETER
			-- AutoTest interpreter attached to current serializer

	test_case_hashs: HASH_TABLE [STRING, STRING]
			-- Table of hash codes for test cases seen so far.
			-- Key is hash code, value is the string representation of that hash code

	state_counts: HASH_TABLE [INTEGER, STRING]
			-- Table of counts for established pre-states for test cases
			-- Keys are state hash codes, values are the number of times those states have been
			-- seen.

	string_representation: TUPLE [serialization: STRING; states: STRING]
			-- String representation of the test case
		local
			i: INTEGER
			l_last: INTEGER
			l_lower, l_upper: INTEGER
			l_var_tbl: HASH_TABLE [INTEGER, INTEGER]
			l_var_id: INTEGER
			l_description: like pre_state_objects
			l_index: INTEGER
			l_object: detachable ANY
			l_should_serialize: BOOLEAN
			l_serialization: STRING
			l_states: STRING
			l_state_count: INTEGER
			l_id: STRING
			l_state_hash: STRING
			l_idx: INTEGER
			l_hash: STRING
			l_test_case_id: STRING
			l_tc_signature: STRING
		do
			if is_test_case_setup then
				if attached test_case_hash_code as l_test_case_hash_code then
					l_hash := l_test_case_hash_code.twin
				else
					-- should not happen, this branch is to make void-safety happy.
					l_hash := ""
				end

				l_idx := l_hash.index_of ('#', 1)
				l_state_hash := l_hash.substring (l_idx + 1, l_hash.count)

				if interpreter.is_failing_test_case then
						-- For failing test cases, ID = recipient_class.recipient.exception_code.tag
					l_test_case_id := interpreter.last_fault_id
				else
						-- For passing test cases, ID = class_under_test.feature_under_test.0.noname
					l_test_case_id := l_hash.substring (1, l_idx - 1) + ".0.noname"
				end

				l_tc_signature := l_test_case_id + "#" + l_state_hash

					-- Update state counts.
				state_counts.search (l_state_hash)
				if state_counts.found then
					l_state_count := state_counts.found_item + 1
					state_counts.replace (l_state_count, l_state_hash)
				else
					l_state_count := 1
					state_counts.force (1, l_state_hash)
				end

				create l_states.make (1024)
				create l_id.make (128)

				if attached class_name as l_class_name then
					l_id.append (l_class_name)
				end

				l_id.append_character ('.')
				l_id.append (feature_name)
				l_id.append_character ('.')
				l_id.append_integer (l_state_hash.hash_code)

				l_states.append (once "<state>")
				l_states.append (l_id)
				l_states.append (once " count=")
				l_states.append_integer (state_counts.item (l_state_hash))
				l_states.append (once "; fault=")
				l_states.append_boolean (exception /= Void and then not exception.is_empty)
				l_states.append (once "</state>%N")

					-- This is a new state
				if l_state_count = 1 then
					l_states.append (once "<state_detail id=%"")
					l_states.append (l_id)
					l_states.append (once "%">%N")
					append_object_state (pre_state_object_summary, l_states, True)
					append_object_state (post_state_object_summary, l_states, False)
					l_states.append (once "</state_detail>%N")
				end

				l_should_serialize :=
					interpreter.is_duplicated_test_case_serialized or else
					not test_case_hashs.has (l_tc_signature)

				if not l_should_serialize then
					l_serialization := ""
				else
					if not interpreter.is_duplicated_test_case_serialized then
						test_case_hashs.put (l_tc_signature, l_tc_signature)
					end

						-- Synthesize serialization part for a test case.
					create l_serialization.make (1024)
					l_serialization.append (once "<test_case>%N")

						-- Synthesize time.
					append_time (time, l_serialization)

					if attached types as l_types   then
						if attached operands as l_operands then
							if attached class_name as l_class_name then
								if attached feature_name as l_feature_name then
									-- Synthesize test case.
									append_test_case (l_class_name,
										l_feature_name,
										argument_count,
										is_creation,
										is_query,
										l_operands,
										l_types,
										l_serialization)
								end
							end
						end
					end


					if attached pre_state_objects as l_pre_state_objects then
						-- Synthesize all AutoTest created variables in current test case.
						append_all_variables (l_pre_state_objects, l_serialization)
					end


						-- Synthesize trace.
					append_exception_trace (exception, l_serialization)

						-- Synthesize hash.
					append_test_case_hash_code (l_tc_signature, l_serialization)

						-- Synthesize pre-/post-state object summary.
					append_object_state (pre_state_object_summary, l_serialization, True)
					append_object_state (post_state_object_summary, l_serialization, False)

						-- Synthesize serialization
					append_object_serialization (pre_state_serialization, l_serialization)

					l_serialization.append (once "</test_case>%N")
				end
			else
				create l_serialization.make_empty
				create l_states.make_empty
			end
			Result := [l_serialization, l_states]
		ensure
			result_attached: Result /= Void
		end

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

	exception: detachable STRING
			-- Exception trace of the last test case
			-- Can be empty if there was no exception
			-- or Void if the test case is not properly setup.		

feature -- Status report

	is_test_case_setup: BOOLEAN
			-- Is the last test case set by `setup_test_case' valid?

	is_creation: BOOLEAN
			-- Is feature with `feature_name' a creator?

	is_query: BOOLEAN
			-- Is feature with `feature_name' a query?

	is_post_state_serialized: BOOLEAN
			-- Should post-state information be serialized as well?
			-- Strictly speaking, post-state information is not necessary because
			-- when pre-state information is available, we can reexecute the test case
			-- to observe the post-state. But if post-state information is available, we
			-- don't need to re-execute the test case.

feature -- Basic operations

	setup_test_case (a_test_case: detachable ANY)
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

	set_is_test_case_valid (b: BOOLEAN)
			-- Set `is_test_case_setup' with `b'.
		do
			is_test_case_setup := b
		ensure
			is_test_case_valid_set: is_test_case_setup = b
		end

	retrieve_pre_state
			-- Retrieve state of objects before test case
			-- execution.
		local
			l_data: detachable TUPLE [summary: STRING; hash: STRING]
			l_serialization: like object_serialization
		do
			pre_state_object_summary := Void
			test_case_hash_code := Void
			l_data := abstract_object_state (True)
			if l_data /= Void then
				pre_state_object_summary := l_data.summary
				test_case_hash_code := l_data.hash
			end

			l_serialization := object_serialization (True)
			if l_serialization /= Void then
				pre_state_serialization := l_serialization.serialization
				pre_state_objects := l_serialization.description
			else
				pre_state_serialization := Void
				pre_state_objects := Void
			end
		end

	retrieve_post_state (a_is_failing_test_case: BOOLEAN)
			-- Retrieve post state of the test case.
			-- `a_is_failing_test_case' indicates if the last test case is failing.
		local
			l_data: detachable TUPLE [summary: STRING; hash: STRING]
		do
			if is_test_case_setup then
				if interpreter.error_buffer /= Void then
					exception := interpreter.error_buffer.twin
				end

				if attached exception as l_exception then
					if  l_exception.is_empty then
						if is_post_state_serialized and then interpreter.post_state_retrieveal_byte_code /= Void then
							interpreter.retrieve_post_object_state
							post_state_object_summary := Void
							l_data := abstract_object_state (False)
							if l_data /= Void then
								post_state_object_summary := l_data.summary
							end
						else
							post_state_object_summary := Void
						end
					else
						post_state_object_summary := Void
					end
				end
			else
				exception := Void
			end
		end

	object_serialization (a_pre_state: BOOLEAN): detachable TUPLE [serialization: detachable STRING; description: detachable HASH_TABLE [TUPLE [object: detachable ANY; type: STRING], INTEGER]]
			-- Object serialization for `operands'. `a_pre_state' indicates if the objects are in pre-execution or post-execution state.
		local
			l_lower: INTEGER
			l_upper: INTEGER
			l_any: detachable ANY
			l_retried: BOOLEAN
		do
			if not l_retried then
				if is_test_case_setup then
					if is_creation and then a_pre_state then
						l_lower := 1
					else
						l_lower := 0
					end
					l_upper := argument_count
					if is_query and then not a_pre_state then
						l_upper := l_upper + 1
					end

					Result := objects_as_string (operands, l_lower, l_upper)
--						 Uncomment the following code to check if serialization is done correctly.
--					l_any ?= deserialized_object (Result.serialization)
--					if attached {SPECIAL [detachable ANY]} l_any as l_obj then
--						interpreter.log_message ("Serialization: Deserialization correct.%N")
--					else
--						interpreter.log_message ("Serialization: Deserialization failed.")
--						if l_any /= Void then
--							interpreter.log_message (l_any.generating_type + "%N")
--						else
--							interpreter.log_message ("Void %N")
--						end
--					end
				else
					Result := Void
				end
			end
		rescue
			l_retried := True
			Result := Void
			retry
		end
feature{NONE} -- Implementation

	pre_state_object_summary: detachable STRING
			-- Pre-state object summary

	post_state_object_summary: detachable STRING
			-- Post-state object summary

	test_case_hash_code: detachable STRING
			-- Hash code for current test case

	pre_state_serialization: detachable STRING
			-- String representing the serialized data for objects specified by
			-- `operands' in pre-execution state.

	pre_state_objects: detachable HASH_TABLE [TUPLE [object: detachable ANY; type: STRING], INTEGER]
			-- List of variables in `pre_state_serialization' along with their object index.
			-- Key is variable index, value is the variable object itself in pre-execution state.

	abstract_object_state (a_pre_state: BOOLEAN): detachable TUPLE [summary: STRING; hash: STRING]
			-- Retrieve object state summary from objects specified by `operands'
			-- `summary' is the state summary for `operands'.
			-- `hash' is the hash code of `summary'.
			-- `a_pre_state' indicates if those object states are retrieved before test case execution.
		local
			l_summary: like pre_state_object_summary
			l_hash_code: STRING
			l_queries: HASH_TABLE [STRING, STRING]
			l_cursor: CURSOR
			l_value_hash_list: LINKED_LIST [INTEGER]
		do
			if is_test_case_setup then
				create l_hash_code.make (64)
					-- Setup test case hash code, which consists the hash of the states of all operands.
				if a_pre_state then
					if attached class_name as l_class_name then
						l_hash_code.append (l_class_name)
					end

					l_hash_code.append_character ('.')

					if attached feature_name as l_feature_name then
						l_hash_code.append (l_feature_name)
					end
					l_hash_code.append_character ('#')
				end

				create l_summary.make (256)
				l_queries := interpreter.query_values
				l_cursor := l_queries.cursor
				from
					l_queries.start
				until
					l_queries.after
				loop
					l_summary.append_character ('%T')
					l_summary.append (l_queries.key_for_iteration)
					l_summary.append (query_value_separator)
					l_summary.append (l_queries.item_for_iteration)
					l_summary.append_character ('%N')
					l_queries.forth
				end
				l_queries.go_to (l_cursor)

					-- Calculate hash code of current test case for test case duplication detection.
				if a_pre_state then
					l_hash_code.append (hash_code_from_list (interpreter.query_value_hash_list).out)
				else
					l_hash_code.append ("0")
				end
				Result := [l_summary, l_hash_code]
			else
				Result := Void
			end
		end

	hash_code_from_list (a_list: LINKED_LIST [INTEGER]): INTEGER
			-- Hash code of `a_list'.
		do
			from
				a_list.start
			until
				a_list.after
			loop
				Result := ((Result \\ 8388593) |<< 8) + (a_list.item_for_iteration \\ 255)
				a_list.forth
			end
		end

	commented_string (a_string: STRING): STRING
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

feature{NONE} -- Implementation

	objects_as_string (a_objects: detachable SPECIAL [INTEGER]; a_lower: INTEGER; a_upper: INTEGER): TUPLE [serialization: STRING; description: like recursively_referenced_objects]
			-- Serialized version of objects whose ID are specified by `a_objects' starting from
			-- position `a_lower' and ending at position `a_upper'.
			-- `serialization' is the serialized stream for those objects.
			-- The serialized objects have the format: SPECIAL [detachable ANY]
			-- The number of elements in this SPECIAL is even, and partitioned into pairs.
			-- The first two elements are a pair, and the third and fourth elements are another pair, and so on.
			-- So it looks like this: [(object1_index, object1), (object2_index, object2), ... , (objectn_index, objectn)].
			-- `description' describes what variables are in the stream and what their vairable IDs are.
		local
			l: SPECIAL [INTEGER]
			i: INTEGER
			l_obj_list: like recursively_referenced_objects
			l_objects: SPECIAL [detachable ANY]
			l_index: INTEGER
			l_object: detachable ANY
			l_type_name: STRING
		do
				-- Filter out unnecessary objects.
			create l.make_filled (0, a_upper - a_lower + 1)
			from
				i := a_lower
			until
				i > a_upper
			loop
				if a_objects /= Void  then
					l.put (a_objects.item (i), i - a_lower)
				end

				i := i + 1
			end

				-- Recursively traverse object graphs starting from objects given in `l'.
			if a_lower <= a_upper then
--				interpreter.log_message ("Serialization: To-be-serialized objects: ")
--				if pre_state_object_summary /= Void then
--					interpreter.log_message (pre_state_object_summary)
--					interpreter.log_message ("%N")
--				end
				l_obj_list := recursively_referenced_objects (l)
				create l_objects.make_filled (Void, l_obj_list.count * 2)
				from
					i := 0
					l_obj_list.start
				until
					l_obj_list.after
				loop
					l_index := l_obj_list.key_for_iteration
					l_object := l_obj_list.item_for_iteration.object
					l_objects.put (l_index, i)
					l_objects.put (l_object, i + 1)
--					interpreter.log_message (l_index.out + ", ")
--					if l_object /= Void then
--						l_type_name := l_object.generating_type
--						if l_type_name ~ "INTEGER_32" or l_type_name ~ "BOOLEAN" then
--							interpreter.log_message ("(" + l_object.out + ")")
--						end
--						interpreter.log_message (l_type_name + ", ")
--					else
--						interpreter.log_message ("Void, ")
--					end
					i := i + 2
					l_obj_list.forth
				end
--				interpreter.log_message ("%N")
			else
				create l_objects.make_filled (0, 1)
				create l_obj_list.make (0)
			end
			Result := [serialized_object (l_objects), l_obj_list]
		end

	recursively_referenced_objects (a_roots: SPECIAL [INTEGER]): HASH_TABLE [TUPLE [object: detachable ANY; type: STRING], INTEGER]
			-- Objects in `interpreter''s object pool that are recursively referenced by varibles whose IDs are
			-- specified by `a_roots'. Result is a list of such referenced object pairs. In each pair, `index' is the
			-- variable index in the object pool, `object' is the variable itself.
			-- Objects specified in `a_roots' are also included in Result.
			-- A pair [[Void, "NONE"], 1] is always included in Result.
		require
			a_roots_not_empty: a_roots.count > 0
		local
			l_tbl: HASH_TABLE [TUPLE[object: detachable ANY; type: STRING], INTEGER]
			i: INTEGER
			c: INTEGER
			l_store: ITP_STORE
			l_object: detachable ANY
			l_traversor: like object_graph_traversor
			l_index: INTEGER
		do
			create l_tbl.make (20)
				-- Insert [Void, v_1], becuase AutoTest will always set v_1 to Void.
			l_tbl.put ([Void, "NONE"], 1)

			l_store := interpreter.object_store
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
					l_tbl.put ([l_object, l_object.generating_type.name.out], l_index)
					l_traversor.wipe_out
					l_traversor.set_object_action (agent on_object_visited (?, l_tbl))
					l_traversor.set_root_object (l_object)
					l_traversor.traverse
				else
					l_tbl.put ([Void, "NONE"], l_index)
				end
				i := i + 1
			end
			Result := l_tbl
		end

	on_object_visited (a_object: detachable ANY; a_object_table: HASH_TABLE [TUPLE [detachable ANY, STRING], INTEGER])
			-- Action to be performed when `a_object' is visited during object graph traversal.
			-- If `a_object' is found in the object pool in `interpreter', put it in `a_object_table'.
			-- Key of `a_object_table' is the object index in the object pool, value is the object itself.
		local
			l_interpreter: like interpreter
			l_index: INTEGER
		do
			l_interpreter := interpreter
			if attached {INTEGER} a_object as l_int then
				l_index := l_interpreter.object_store.variable_index (l_int)
				if l_index > 0 then
--					interpreter.log_message ("Serialization: Found an integer%N")
					a_object_table.put ([l_int.item, l_int.generating_type.out], l_index)
				end
			elseif attached {BOOLEAN} a_object as l_bool then
				l_index := l_interpreter.object_store.variable_index (l_bool)
				if l_index > 0 then
--					interpreter.log_message ("Serialization: Found boolean%N")
					a_object_table.put ([l_bool.item, l_bool.generating_type.out], l_index)
				end
			elseif attached{INTEGER_8} a_object as l_int8 then
				l_index := l_interpreter.object_store.variable_index (l_int8)
				if l_index > 0 then
					a_object_table.put ([l_int8.item, l_int8.generating_type.out], l_index)
				end
			elseif attached{INTEGER_16} a_object as l_int16 then
				l_index := l_interpreter.object_store.variable_index (l_int16)
				if l_index > 0 then
					a_object_table.put ([l_int16.item, l_int16.generating_type.out], l_index)
				end
			elseif attached{INTEGER_64} a_object as l_int64 then
				l_index := l_interpreter.object_store.variable_index (l_int64)
				if l_index > 0 then
					a_object_table.put ([l_int64.item, l_int64.generating_type.out], l_index)
				end
			elseif attached{NATURAL_8} a_object as l_nat8 then
				l_index := l_interpreter.object_store.variable_index (l_nat8)
				if l_index > 0 then
					a_object_table.put ([l_nat8.item, l_nat8.generating_type.out], l_index)
				end
			elseif attached{NATURAL_16} a_object as l_nat16 then
				l_index := l_interpreter.object_store.variable_index (l_nat16)
				if l_index > 0 then
					a_object_table.put ([l_nat16.item, l_nat16.generating_type.out], l_index)
				end
			elseif attached{NATURAL_32} a_object as l_nat32 then
				l_index := l_interpreter.object_store.variable_index (l_nat32)
				if l_index > 0 then
					a_object_table.put ([l_nat32.item, l_nat32.generating_type.out], l_index)
				end
			elseif attached{NATURAL_64} a_object as l_nat64 then
				l_index := l_interpreter.object_store.variable_index (l_nat64)
				if l_index > 0 then
					a_object_table.put ([l_nat64.item, l_nat64.generating_type.out], l_index)
				end
			elseif attached{CHARACTER_8} a_object as l_char8 then
				l_index := l_interpreter.object_store.variable_index (l_char8)
				if l_index > 0 then
					a_object_table.put ([l_char8.item, l_char8.generating_type.out], l_index)
				end
			elseif attached{CHARACTER_32} a_object as l_char32 then
				l_index := l_interpreter.object_store.variable_index (l_char32)
				if l_index > 0 then
					a_object_table.put ([l_char32.item, l_char32.generating_type.out], l_index)
				end
			elseif attached{REAL_32} a_object as l_real32 then
				l_index := l_interpreter.object_store.variable_index (l_real32)
				if l_index > 0 then
					a_object_table.put ([l_real32.item, l_real32.generating_type.out], l_index)
				end
			elseif attached{REAL_64} a_object as l_real64 then
				l_index := l_interpreter.object_store.variable_index (l_real64)
				if l_index > 0 then
					a_object_table.put ([l_real64.item, l_real64.generating_type.out], l_index)
				end
--			elseif attached{POINTER} a_object as l_ptr then
--				l_index := l_interpreter.object_store.variable_index (l_ptr)
--				if l_index > 0 then
--					a_object_table.put ([l_ptr.item, l_ptr.generating_type.out], l_index)
--				end

			else
				l_index := l_interpreter.object_store.variable_index (a_object)
				if l_index > 0 then
					if a_object = Void then
						a_object_table.put ([Void, "NONE"], l_index)
					else
						a_object_table.put ([a_object, a_object.generating_type.out], l_index)
					end

				end
			end
		end

	object_graph_traversor: ITP_OBJECT_TRAVERSABLE
			-- Object graph traversor, used to find objects in the object pool
			-- that are also (recursively) referenced by a given object.

feature{NONE} -- Implementation/Test case synthesis

	append_time (a_time: INTEGER; a_buffer: STRING)
			-- Append `a_time' into `a_buffer'.
		do
			a_buffer.append (time_tag_start)
			a_buffer.append (a_time.out)
			a_buffer.append (time_tag_end)
			a_buffer.append_character ('%N')
		end

	append_test_case (a_class_name: STRING;
		a_feature_name: STRING;
		a_argument_count: INTEGER;
		a_is_creation: BOOLEAN;
		a_is_query: BOOLEAN;
		a_operands: SPECIAL[INTEGER];
		a_types: SPECIAL[STRING];
		a_buffer: STRING)
			-- Append test case defined by `a_class_name', `a_feature_name', `a_is_creation', `a_is_query', `a_operands' and `a_types' into `a_buffer'.			
		local
			l_last: INTEGER
			i: INTEGER
			l_var_id: INTEGER
		do
			l_last := a_operands.count - 1

				-- Synthesize class.
			a_buffer.append (class_tag_start)
			a_buffer.append (a_class_name)
			a_buffer.append (class_tag_end)
			a_buffer.append_character ('%N')

				-- Synthesize test case body.
			a_buffer.append (code_tag_start)
			a_buffer.append_character ('%N')

				-- Synthesize return value.
			if a_is_query then
				a_buffer.append (once "v_")
				a_buffer.append (a_operands.item (l_last).out)
				a_buffer.append (once " := ")
			end

			if a_is_creation then
				a_buffer.append (once "create {")
				a_buffer.append (type_with_marks_removed(a_types.item (0)))
				a_buffer.append (once "}")
			end

			a_buffer.append (once "v_")
			a_buffer.append (a_operands.item (0).out)
			a_buffer.append_character ('.')
			a_buffer.append (a_feature_name)

				-- Synthesize arguments.
			if a_argument_count > 0 then
				a_buffer.append (once " (")
				from
					i := 1
				until
					i > a_argument_count
				loop
					a_buffer.append (once "v_")
					a_buffer.append (a_operands.item (i).out)
					if i < a_argument_count then
						a_buffer.append (once ", ")
					end
					i := i + 1
				end
				a_buffer.append (once ")")
			end
			a_buffer.append_character ('%N')
			a_buffer.append (code_tag_end)
			a_buffer.append_character ('%N')

				-- Synthesize type information.
			a_buffer.append (operands_tag_start)
			a_buffer.append_character ('%N')
			from
				i := 0
			until
				i > l_last
			loop
				if attached types as l_types then
					append_variable_with_type (a_operands.item (i), l_types.item (i), a_buffer, True)
				end

				i := i + 1
			end
			a_buffer.append (operands_tag_end)
			a_buffer.append_character ('%N')
		end

	append_all_variables (a_objects: HASH_TABLE [TUPLE[object: detachable ANY; type: STRING], INTEGER_32]; a_buffer: STRING)
			-- Append variable descriptions in `a_objects' into `a_buffer'.
			-- `a_objects' is a hash table, key is variable index in object pool, value is the object itself.
		local
			l_index: INTEGER
			l_object: detachable ANY
			l_type_name: STRING
		do
			a_buffer.append (all_variables_tag_start)
			a_buffer.append_character ('%N')
			if a_objects /= Void then
				from
					a_objects.start
				until
					a_objects.after
				loop
					l_index := a_objects.key_for_iteration
					l_object := a_objects.item_for_iteration.object
					l_type_name := a_objects.item_for_iteration.type;
					if l_object = Void then
						append_variable_with_type (l_index, once "NONE", a_buffer, True)
					else
						append_variable_with_type (l_index, l_type_name, a_buffer, True)
					end
					a_objects.forth
				end
			end
			a_buffer.append (all_variables_tag_end)
			a_buffer.append_character ('%N')
		end

	append_exception_trace (a_trace: detachable STRING; a_buffer: STRING)
			-- Append `a_trace' into `a_buffer'.
		do
			a_buffer.append (trace_tag_start)
			a_buffer.append_character ('%N')
			a_buffer.append (cdata_tag_start)
			a_buffer.append_character ('%N')
			if attached exception as l_exp then
				a_buffer.append (l_exp)
			end
			a_buffer.append_character ('%N')
			a_buffer.append (cdata_tag_end)
			a_buffer.append_character ('%N')
			a_buffer.append (trace_tag_end)
			a_buffer.append_character ('%N')
		end

	append_test_case_hash_code (a_hash_code: STRING; a_buffer: STRING)
			-- Append test case hash code `a_hash_code' in `a_buffer'.
		do
			a_buffer.append (hash_code_tag_start)
			a_buffer.append (a_hash_code)
			a_buffer.append (hash_code_tag_end)
			a_buffer.append_character ('%N')
		end

	append_object_serialization (a_serialization: detachable STRING; a_buffer: STRING)
			-- Append object serialization data `a_serialization' into `a_buffer'.
		do
			a_buffer.append (pre_serialization_length_tag_start)

			if a_serialization = Void then
				a_buffer.append_character ('0')
			else
				a_buffer.append (a_serialization.count.out)
			end

			a_buffer.append (pre_serialization_length_tag_end)
			a_buffer.append_character ('%N')
			a_buffer.append (pre_serialization_tag_start)
			a_buffer.append (cdata_tag_start)

			if a_serialization /= Void then
				a_buffer.append (a_serialization)
			end

			a_buffer.append (cdata_tag_end)
			a_buffer.append (pre_serialization_tag_end)
			a_buffer.append_character ('%N')
		end

	append_object_state (a_state: detachable STRING; a_buffer: STRING; a_is_pre_state: BOOLEAN)
			-- Append `a_state' into `a_buffer'.			
		do
			if a_is_pre_state then
				a_buffer.append (pre_state_tag_start)
				a_buffer.append_character ('%N')
			else
				a_buffer.append (post_state_tag_start)
				a_buffer.append_character ('%N')
			end

			if a_state /= Void then
				a_buffer.append (a_state)
			end

			if a_is_pre_state then
				a_buffer.append (pre_state_tag_end)
				a_buffer.append_character ('%N')
			else
				a_buffer.append (post_state_tag_end)
				a_buffer.append_character ('%N')
			end
		end

	append_variable_with_type (a_index: INTEGER; a_type: STRING; a_buffer: STRING; a_indent_needed: BOOLEAN)
			-- Append variable with `a_index' and `a_type' into `a_buffer'.			
		do
			if a_indent_needed then
				a_buffer.append_character ('%T')
			end
			a_buffer.append (once "v_")
			a_buffer.append_integer (a_index)
			a_buffer.append (once ": ")

			if a_index = 0 then
				a_buffer.append (none_type_name)
			else
				a_buffer.append (type_with_marks_removed(a_type))
			end
			a_buffer.append_character ('%N')
		end

	type_with_marks_removed (a_type: STRING): STRING
		do
			if a_type = Void then
				Result := a_type
			else
				create Result.make_from_string (a_type)
				Result.replace_substring_all ("!", "")
				Result.replace_substring_all ("?", "")
				Result.replace_substring_all ("attached", "")
				Result.replace_substring_all ("detachable", "")
				Result.replace_substring_all ("separate", "")
			end
		end

invariant
	interpreter_attached: interpreter /= Void

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
