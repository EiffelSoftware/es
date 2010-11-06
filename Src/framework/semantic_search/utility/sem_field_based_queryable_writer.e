note
	description: "Field based queryable writer"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_FIELD_BASED_QUERYABLE_WRITER [G -> SEM_QUERYABLE]

inherit
	SEM_FIELD_NAMES

	SEM_UTILITY

feature -- Access

	queryable: G
			-- Queryable to be written
		deferred
		end

	medium: IO_MEDIUM
			-- Medium used to IO
		deferred
		end

	written_fields: DS_HASH_SET [IR_FIELD]
			-- Fields that are already written
			-- Used to avoid writing duplicated fields
		deferred
		end

	uuid: detachable UUID
			-- UUID used for the queryable to write
			-- If Void, a new UUID will be generated

feature -- Access

	pre_state_serialization: detachable STRING
			-- Pre-state serialization

	pre_state_object_info: detachable STRING
			-- Object info in pre-state

	recipient: detachable STRING
			-- The recipient feature if the transition to be written represents a failing test case

	recipient_class: detachable STRING
			-- The class of `recipient'  if the transition to be written represents a failing test case

	exception_break_point_slot: detachable STRING
			-- The break point slot of the exception if the transition to be written represents a failing test case

	exception_code: detachable STRING
			-- The error code of the exception if the transition to be written represents a failing test case

	exception_meaning: detachable STRING
			-- The error meaning of the exception if the transition to be written represents a failing test case

	exception_trace: detachable STRING
			-- Trace of the exception if the transition to be written represents a failing test case

	exception_tag: detachable STRING
			-- Tag of the failing assertion  if the transition to be written represents a failing test case

	fault_id: detachable STRING
			-- Fault identifier if the transition to be written represents a failing test case

feature -- Setting

	set_pre_state_serialization (a_data: like pre_state_serialization)
			-- Set `pre_state_serialization' with `a_data'.
		do
			pre_state_serialization := a_data
		end

	set_pre_state_object_info (a_data: like pre_state_object_info)
			-- Set `pre_state_object_info' with `a_data'.
		do
			pre_state_object_info := a_data
		end

	set_recipient (a_data: like recipient)
			-- Set `recipient' with `a_data'.
		do
			recipient := a_data
		ensure
			recipient_set: recipient = a_data
		end

	set_recipient_class (a_data: like recipient_class)
			-- Set `recipient_class' with `a_data'.
		do
			recipient_class := a_data
		ensure
			recipient_class_set: recipient_class = a_data
		end

	set_exception_break_point_slot (a_data: like exception_break_point_slot)
			-- Set `exception_break_point_slot' with `a_data'.
		do
			exception_break_point_slot := a_data
		ensure
			exception_break_point_slot_set: exception_break_point_slot = a_data
		end

	set_exception_code (a_data: like exception_code)
			-- Set `exception_code' with `a_data'.
		do
			exception_code := a_data
		ensure
			exception_code_set: exception_code = a_data
		end

	set_exception_meaning (a_data: like exception_meaning)
			-- Set `exception_meaning' with `a_data'.
		do
			exception_meaning := a_data
		ensure
			exception_meaning_set: exception_meaning = a_data
		end

	set_exception_trace (a_data: like exception_trace)
			-- Set `exception_trace' with `a_data'.
		do
			exception_trace := a_data
		ensure
			exception_trace_set: exception_trace = a_data
		end

	set_fault_id (a_data: like fault_id)
			-- Set `fault_id' with `a_data'.
		do
			fault_id := a_data
		ensure
			fault_id_set: fault_id = a_data
		end

	set_exception_tag (a_data: like exception_tag)
			-- Set `exception_tag' with `a_data'.
		do
			exception_tag := a_data
		ensure
			exception_tag_set: exception_tag = a_data
		end

	set_uuid (a_uuid: like uuid)
			-- Set `uuid' with `a_uuid'.
		do
			uuid := a_uuid
		ensure
			uuid_set: uuid = a_uuid
		end

	clear_for_write
			-- Clear intermediate data for next `write'.
		do
			set_pre_state_serialization (Void)
			set_pre_state_object_info (Void)
			set_recipient (Void)
			set_recipient_class (Void)
			set_exception_break_point_slot (Void)
			set_exception_code (Void)
			set_exception_meaning (Void)
			set_exception_trace (Void)
			set_fault_id (Void)
		end

feature{NONE} -- Implementation

	string_representation_of_field (a_field: IR_FIELD): STRING
			-- String representation of `a_field'
		deferred
		end

	append_field_with_data (a_name: STRING; a_value: STRING; a_type: INTEGER; a_boost: DOUBLE)
			-- Write field specified through `a_name', `a_value', `a_type' and `a_boost' into `output'.
		do
			append_field (create {IR_FIELD}.make_with_raw_value (a_name, a_value, a_type, a_boost))
		end

	append_field (a_field: IR_FIELD)
			-- append `a_field' into `medium'.
		do
			if not written_fields.has (a_field) then
				medium.put_character (' ')
				medium.put_character (' ')
				medium.put_string (string_representation_of_field (a_field))
				medium.put_character ('%N')
				written_fields.force_last (a_field)
			end
		end

	append_string_field (a_name: STRING; a_value: STRING)
			-- Append a string field with `a_name' and `a_value' and default boost value.
		do
			append_field (create {IR_FIELD}.make_as_string (a_name, a_value, default_boost_value))
		end

	append_boolean_field (a_name: STRING; a_value: BOOLEAN)
			-- Append a boolean field with `a_name' and `a_value' and default boost value.
		do
			append_field (create {IR_FIELD}.make_as_boolean (a_name, a_value, default_boost_value))
		end

	append_integer_field (a_name: STRING; a_value: INTEGER)
			-- Append an integer field with `a_name' and `a_value' and default boost value.
		do
			append_field (create {IR_FIELD}.make_as_integer (a_name, a_value, default_boost_value))
		end

feature{NONE} -- Implementation

	append_queryable_type (a_queryable: SEM_QUERYABLE)
			-- Append type of `a_queryable' into `medium'.
		do
			append_field (queryable_type_field (a_queryable))
		end

	append_transition_status (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append transition status into `medium'.
		do
			if a_transition.is_passing then
				append_string_field (test_case_status_field, test_case_status_passing)
			else
				append_string_field (test_case_status_field, test_case_status_failing)
			end
		end

	append_feature_type (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append feature type fields into `medium'.
		do
			if a_transition.feature_.has_return_value then
				append_string_field (feature_type_field, feature_type_query)
			else
				append_string_field (feature_type_field, feature_type_command)
			end
			append_boolean_field (is_creation_field, a_transition.is_creation)
			append_integer_field (operand_count_field, a_transition.feature_.argument_count + 1)
			append_integer_field (argument_count_field, a_transition.feature_.argument_count)
		end

	append_library (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append library information of `a_transition' into `medium'.
		do
			append_string_field (library_field, a_transition.class_.group.name)
		end

	append_class_and_feature (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append class and feature of `a_transition' into `medium'.
		do
			append_string_field (class_field, a_transition.class_.name_in_upper)
			append_string_field (feature_field, a_transition.feature_.feature_name.as_lower)
		end

	append_uuid
			-- Append an UUID into `medium'.
		do
			if uuid = Void then
				append_string_field (uuid_field, uuid_generator.generate_uuid.out)
			else
				append_string_field (uuid_field, uuid.out)
			end
		end

	append_hit_breakpoints (a_transtion: SEM_FEATURE_CALL_TRANSITION)
			-- Append hit breakpoint information into `medium'.
		local
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
			l_data: STRING
		do
			create l_data.make (128)
			from
				l_cursor := a_transtion.hit_breakpoints.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not l_data.is_empty then
					l_data.append_character (',')
				end
				l_data.append_integer (l_cursor.item)
				l_cursor.forth
			end
			append_string_field (hit_break_points_field, l_data)
		end

	append_timestamp (a_stamp: STRING)
			-- Append `a_stamp' into `medium'.
		do
			append_string_field (timestamp_field, a_stamp)
		end

	append_exception
			-- Append exception related fields into `medium'.
		do
			if recipient_class /= Void then
				append_string_field (recipient_class_field, recipient_class)
			end
			if recipient /= Void then
				append_string_field (recipient_field, recipient)
			end
			if exception_break_point_slot /= Void then
				append_integer_field (exception_break_point_slot_field, exception_break_point_slot.to_integer)
			end
			if exception_code /= Void then
				append_integer_field (exception_code_field, exception_code.to_integer)
			end
			if exception_meaning /= Void then
				append_string_field (exception_meaning_field, exception_meaning)
			end
			if exception_tag /= Void then
				append_string_field (exception_tag_field, exception_tag)
			end
			if fault_id /= Void then
				append_string_field (fault_id_field, fault_id)
			end
			if exception_trace /= Void then
				append_string_field (exception_trace_field, once "<![CDATA[%N" +  exception_trace + once "]]>%N")
			end
		end

end
