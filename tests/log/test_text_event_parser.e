indexing
	description: "[
				Test Cases for TEXT_EVENT_PARSER and EVENT_FACTORY.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_TEXT_EVENT_PARSER

inherit
	TS_TEST_CASE
	redefine
		set_up,
		tear_down
	end

feature -- Test Variables:

feature --Access

		incall_prototype: INCALL_EVENT
		outcall_prototype: OUTCALL_EVENT

		incallret_prototype: INCALLRET_EVENT
		outcallret_prototype: OUTCALLRET_EVENT

feature -- Setup

	set_up
			-- Set up the environment
		local
			arguments: DS_ARRAYED_LIST[ENTITY]
			entity: NON_BASIC_ENTITY
		do
				create entity.make ("FOO_TYPE", 99)
				create arguments.make(1)
				create incall_prototype.make(entity, "incall_prototype", arguments)
				create outcall_prototype.make(entity,"outcall_prototype", arguments)

				create incallret_prototype.make (entity)
				create outcallret_prototype.make (entity)
		end

	tear_down
			-- tear down the environment.
		do
		end

feature -- Testing the tests:

	test_testing
			-- Just for experiments
		do

		end

	test_event_types is
			-- Only check if events of the right type are generated
		local
			event_input: EVENT_INPUT
		do
			event_input := create_event_input("test_parser_calls.res")

			event_input.read_next_event
			assert_false ("event 1 read", event_input.has_error)
			assert_true("correct event-type", event_input.last_event.conforms_to (incall_prototype))
			event_input.read_next_event
			assert_false ("event 2 read", event_input.has_error)
			assert_true("correct event-type", event_input.last_event.conforms_to(incall_prototype))
			event_input.read_next_event
			assert_false ("event 3 read", event_input.has_error)
			assert_true("correct event-type", event_input.last_event.conforms_to(incall_prototype))
			event_input.read_next_event
			assert_false ("event 4 read", event_input.has_error)
			assert_true("correct event-type", event_input.last_event.conforms_to(outcall_prototype))
			event_input.read_next_event
			assert_false ("event 5 read", event_input.has_error)
			assert_true("correct event-type", event_input.last_event.conforms_to(outcall_prototype))
			event_input.read_next_event
			assert_false ("event 6 read", event_input.has_error)
			assert_true("correct event-type", event_input.last_event.conforms_to(outcall_prototype))
		end

	test_call_parsing
			-- Test the parsing of the call events (INCALL/OUTCALL)
		local
			event_input: EVENT_INPUT
		do
			event_input := create_event_input("test_parser_calls.res")

			-- Test the 3 INCALLS in the log
			check_calls(event_input, incall_prototype)

			-- Test the 3 OUTCALLS in the log
			check_calls(event_input, outcall_prototype)
		end


	test_callret_parsing
			-- Test for parsing of the callret events(INCALLRET/OUTCALLRET).
		local
			event_input: EVENT_INPUT
		do
			event_input := create_event_input("test_parser_callrets.res")

			--test the 3 INCALLRETs in the log
			check_callrets(event_input, incallret_prototype)

			--test the 3 OUTCALLRETs in the log
			check_callrets(event_input, outcallret_prototype)
		end

	test_generics_parsing
			-- Test for parsing of generic entities.
		local
			event_input: EVENT_INPUT
			incall: INCALL_EVENT
			incallret: INCALLRET_EVENT
		do
			event_input := create_event_input("test_generics.res")

			event_input.read_next_event
			assert ("event 1 read", not event_input.has_error)
			incall ?= event_input.last_event
			assert ("event 1 is incall", incall /= Void)
			assert_strings_equal("correct feature name", "put", incall.feature_name)
			assert_strings_equal("correct (generic) target", "ARRAY [EXAMPLE_CLASS]", incall.target.type)
			assert_equal("argument count correct", 2, incall.arguments.count)


			event_input.read_next_event
			assert ("event 2 read", not event_input.has_error)
			incallret ?= event_input.last_event
			assert ("event 2 is incallret", incallret /= Void)
			assert ("incallret has return value", incallret.return_value /= Void)
			assert_strings_equal ("return value has correct type", "ARRAY [EXAMPLE_CLASS]" ,incallret.return_value.type)

			event_input.read_next_event
			assert ("event 3 read", not event_input.has_error)
			incall ?= event_input.last_event
			assert ("event 3 is incall", incall /= Void)
			assert_strings_equal("correct feature name", "put", incall.feature_name)
			assert_strings_equal("correct (generic) target", "ARRAYED_LIST [ARRAY [EXAMPLE_CLASS]]", incall.target.type)
			assert_equal("argument count correct", 2, incall.arguments.count)

			event_input.read_next_event
			assert ("event 4 read", not event_input.has_error)
			incallret ?= event_input.last_event
			assert ("event 4 is incallret", incallret /= Void)
			assert ("incallret has return value", incallret.return_value /= Void)
			assert_strings_equal ("return value has correct type", "ARRAYED_LIST [ARRAY [EXAMPLE_CLASS]]" ,incallret.return_value.type)

			event_input.read_next_event
			assert ("event 5 read", not event_input.has_error)
			incallret ?= event_input.last_event
			assert ("event 5 is incallret", incallret /= Void)
			assert ("incallret has return value", incallret.return_value /= Void)
			assert_strings_equal ("return value has correct type", "TUPLE [ARRAYED_LIST [ARRAY [EXAMPLE_CLASS]], INTEGER_32]" ,incallret.return_value.type)
		end




feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	check_calls(event_input: EVENT_INPUT; call_event_prototype: CALL_EVENT)
		-- Check 4 Callret events, if they match the sample log file and
		-- check if the type conforms to `call_event_prototype'.
		local
			call: CALL_EVENT
			non_basic: NON_BASIC_ENTITY
			basic: BASIC_ENTITY
		do

			event_input.read_next_event
			assert_true("correct event type", event_input.last_event.conforms_to (call_event_prototype))

			call ?= event_input.last_event
			--Target
			non_basic ?= call.target
			check_non_basic("target", call.target, "EXAMPLE_CLASS", 1)

			--Feature name
			assert_equal("feature_name correct", "test_call", call.feature_name)

			--arguments
			assert_true("arguments not void" , call.arguments /= Void)
			assert_equal("argument_count correct", 4, call.arguments.count)


			check_non_basic("argument 1", call.arguments @ 1, "EXAMPLE_CLASS", 1)
			check_non_basic("argument 2", call.arguments @ 2, "STRING_8", 2)
			check_basic("argument 3", call.arguments @ 3, "REAL_32", "12.25")
			check_basic("argument 4", call.arguments @ 4, "INTEGER_32", "12")

			--check call without arguments
			event_input.read_next_event
			assert_true("correct event type", event_input.last_event.conforms_to (call_event_prototype))

			call ?= event_input.last_event
			-- Target
			check_non_basic("target", call.target, "EXAMPLE_CLASS", 1)

			-- Feature Name
			assert_equal("feature_name correct", "test_call_no_arguments", call.feature_name)

			-- Arguments
			assert_true("arguments not void", call.arguments /= Void)
			assert_equal("argument_count correct", 0, call.arguments.count)

			--check call on basic type
			event_input.read_next_event
			assert_true("correct event type", event_input.last_event.conforms_to (call_event_prototype))

			call ?= event_input.last_event
			--Target
			basic ?= call.target
			check_basic("target", call.target, "REAL_32", "12.99")

			--Feature name
			assert_equal("feature_name correct", "test_call_on_basic_type", call.feature_name)

			--arguments
			assert_true("arguments not void" , call.arguments /= Void)
			assert_equal("argument_count correct", 1, call.arguments.count)

			check_basic("argument 1", call.arguments @ 1, "INTEGER_32", "12")
		end

	check_callrets(event_input: EVENT_INPUT; event_prototype: RETURN_EVENT) is
			-- Check three callrets from `event_input'. check if the return-event type
			-- conforms to `event_prototype', too.
		local
			ret: RETURN_EVENT
		do
			event_input.read_next_event
			assert_true("correct event type", event_input.last_event.conforms_to (event_prototype))

			ret ?= event_input.last_event
			check_non_basic ("return_value, line 1:", ret.return_value, "NON_BASIC_EXAMPLE", 4)

			event_input.read_next_event
			assert_true("correct event type", event_input.last_event.conforms_to (event_prototype))

			ret ?= event_input.last_event
			check_basic ("return value, line 2", ret.return_value, "REAL_32", "1.21234565")

			event_input.read_next_event
			assert_true("correct event type", event_input.last_event.conforms_to (event_prototype))

			ret ?= event_input.last_event
			assert_true("no return value", ret.return_value = Void)
		end


	create_event_input(file_name: STRING): EVENT_INPUT
			--A new EVENT_FACTORY on file `file_name'
		local
			parser: TEXT_EVENT_PARSER
			input: KL_TEXT_INPUT_FILE
		do
			create input.make(file_name)
			input.open_read
			create Result
			create parser.make(input,Result)
		end

	check_non_basic(tag: STRING; an_entity: ANY; expected_type:STRING; expected_id: INTEGER)
			-- Check an object if it conforms to the NON_BASIC_ENTITY with type `expected_type'
			-- and object_id `expected_id'
		local
			non_basic: NON_BASIC_ENTITY
		do
				assert_true(tag + ": entity not void", an_entity /= Void)
				non_basic ?= an_entity
				assert_true(tag + ": non basic", non_basic /= Void)
				assert_equal(tag + ": correct Type", expected_type, non_basic.type)
				assert_equal(tag + ": correct id", expected_id, non_basic.id)
		end

	check_basic (tag: STRING; an_entity: ANY; expected_type:STRING; expected_value: STRING)
			-- Check an object if it conforms to the BASIC_ENTITY with type `expected_type'
			-- and value `expected_value'
		local
			basic: BASIC_ENTITY
		do
				assert_true(tag + ": entity not void", an_entity /= Void)
				basic ?= an_entity
				assert_true(tag + ": basic", basic /= Void)
				assert_equal(tag + ": correct Type", expected_type, basic.type)
				assert_equal(tag + ": correct value", expected_value, basic.value)
		end

invariant
	invariant_clause: True -- Your invariant here

end
