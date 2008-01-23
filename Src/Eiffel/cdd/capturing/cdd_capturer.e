indexing
	description: "Objects that capture the state of some application"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CAPTURER

inherit

	CDD_ROUTINES

	DEBUG_VALUE_EXPORTER
		export
			{NONE} all
		end

	CDD_CONSTANTS

	UT_STRING_FORMATTER

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_manager: like cdd_manager) is
			-- Create `capture_observers'.
		require
			a_manager_not_void: a_manager /= Void
		do
			cdd_manager := a_manager
			create capture_observers.make
			create call_stack_target_objects.make(20)
			call_stack_target_objects.set_equality_tester (case_insensitive_string_equality_tester)
		ensure
			cdd_manager_set: cdd_manager = a_manager
		end

feature -- Access

	cdd_manager: CDD_MANAGER
			-- CDD manager

	capture_observers: DS_LINKED_LIST [CDD_CAPTURE_OBSERVER]
			-- Observers tracking the capture process

feature -- Basic operations

	capture_call_stack (a_status: APPLICATION_STATUS) is
			-- Create test cases for each feature call in the stack.
		require
			a_status_not_void: a_status /= Void
			a_status_valid: a_status.is_stopped
		do
			capture_stack_frames (a_status, a_status.current_call_stack.count)
		end

	capture_active_stack_frame (a_status: APPLICATION_STATUS) is
			-- Create test case for top feature call in call stack.
		require
			a_status_not_void: a_status /= Void
			a_status_valid: a_status.is_stopped
		do
			capture_stack_frames (a_status, 1)
		end

feature {NONE} -- Implementation (Capturing)

	capture_stack_frames (a_status: APPLICATION_STATUS; a_count: INTEGER) is
			-- Capture max `a_count' test cases for valid call stack elements
			-- from top of call stack in `a_status'.
			-- Wipes out `last_created_test_cases'.
		require
			a_status_not_void: a_status /= Void
			a_status_valid: a_status.is_stopped
		local
			i: INTEGER
			l_cse, l_cse2: EIFFEL_CALL_STACK_ELEMENT
			an_csid: STRING
			l_dt: DT_DATE_TIME
			l_sec: INTEGER_32
		do
			l_cse ?= a_status.current_call_stack_element
			if a_status.exception_code = {EXCEP_CONST}.precondition then
				if l_cse /= Void and then l_cse.level_in_stack < a_status.current_call_stack.count then
					l_cse := caller (l_cse, a_status.current_call_stack)
				end
			end

				-- As a call stack id, we used to number of seconds
				-- elapsed since epoch date. This can later
				-- be used for sorting and displaying an arbitrary
				-- date time format.
			l_dt := system_clock.date_time_now
			l_sec := l_dt.epoch_days (l_dt.year, l_dt.month, l_dt.day)*l_dt.seconds_in_day
			l_sec := l_sec + l_dt.time.second_count
			an_csid := l_sec.out
			--an_csid := l_time.formatted_out ("yyyy/[0]mm/[0]dd [0]hh:[0]mi")

			call_stack_target_objects.wipe_out
			from
				l_cse2 := l_cse
			until
				l_cse2 = void
			loop
				if l_cse.current_object_value /= void and then l_cse.current_object_value.address /= void then
					call_stack_target_objects.force (l_cse.current_object_value.address)
				end
				l_cse2 := caller (l_cse2, a_status.current_call_stack)
			end

			from
				i := 1
			until
				l_cse = Void or i > a_count
			loop
				l_cse := next_valid_cse (a_status, l_cse)
				if l_cse /= Void then
					capture_call_stack_element (l_cse, an_csid, i)
					l_cse := caller (l_cse, a_status.current_call_stack)
					i := i + 1
				end
			end
			cdd_manager.status_update_actions.call ([create {CDD_STATUS_UPDATE}.make_with_code ({CDD_STATUS_UPDATE}.capturer_extracted_code)])
		end

	capture_call_stack_element (a_cse: EIFFEL_CALL_STACK_ELEMENT; a_csid: STRING; a_cs_level: INTEGER) is
			-- Capture state for `a_cse'. `a_cs_uuid' is the call stack's uuid.
		require
			a_cse_not_void: a_cse /= Void
			valid_cse: is_valid_cse (a_cse)
			a_csid_not_empty: a_csid /= Void and then not a_csid.is_empty
			a_cs_level_positiv: a_cs_level > 0
		local
			l_feature: E_FEATURE
			l_class: CLASS_C
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_CAPTURE_OBSERVER]
			l_arguments: DS_ARRAYED_LIST [ABSTRACT_DEBUG_VALUE]
			i, j, l_ops_count: INTEGER
			l_type: STRING
		do
			l_cursor := capture_observers.new_cursor
			l_feature := a_cse.routine
			l_class := a_cse.dynamic_class

				-- Notify all observers that capturing has started
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_cursor.item.start (a_cse.current_object_value, l_feature, l_class, a_csid, a_cs_level)
				l_cursor.forth
			end

				-- Add operands as first object of context
			current_object_id := 1
			create object_queue.make
			create object_map.make (20) -- Note: this value says how many objects we assume to reflect...

			if not is_creation_feature (l_feature) then
				i := 1
			end
			create l_arguments.make (l_feature.argument_count + i)
			l_type := "TUPLE"
			l_ops_count := i + l_feature.argument_count
			if l_ops_count > 0 then
				l_type.append (" [")
			end
			if i > 0 then
				l_arguments.put_first (a_cse.current_object_value)
				l_type.append (a_cse.current_object_value.dump_value.generating_type_representation (True))
				if l_feature.argument_count > 0 then
					l_type.append (", ")
				end
			end

			from
				j := 1
			until
				j > l_feature.argument_count
			loop
				l_arguments.put (a_cse.arguments.i_th (j), j + i)
				l_type.append (a_cse.arguments.i_th (j).dump_value.generating_type_representation (True))
				if l_feature.argument_count > j then
					l_type.append (", ")
				end
				j := j + 1
			end
			if l_ops_count > 0 then
				l_type.append ("]")
			end
			put_object ("#operand", l_type, True, fetch_object_attributes (l_arguments, False, 0))

				-- Start capturing objects
			from until
				object_queue.is_empty
			loop
				process_object (object_queue.item.object, object_queue.item.depth)
				object_queue.remove
			end

				-- Notify all observers that capturing has finished
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_cursor.item.finish
				l_cursor.forth
			end
		end

	process_object (an_object: ABSTRACT_DEBUG_VALUE; a_depth: INTEGER) is
			-- Create context representation for `an_object'
			-- and notify observers.
		require
			capturing: is_capturing
			reference_value: is_reference_value (an_object)
			object_already_added: object_map.has (an_object.address)
			a_depth_not_negative: a_depth >= 0
		local
			l_class: EIFFEL_CLASS_C
			l_id, l_type: STRING
			l_ref_adv: ABSTRACT_REFERENCE_VALUE
			l_attrs: DS_LIST [STRING]

			l_class_id: INTEGER
			l_feature_id: INTEGER
			l_routine_target_type: CLASS_TYPE
			l_routine_target_class: CLASS_C
			l_routine: E_FEATURE
		do
			l_class := an_object.dynamic_class.eiffel_class_c
			l_type := an_object.dump_value.generating_type_representation (True)
			l_id := object_map.item (an_object.address)

			if l_class.name.is_equal ("STRING_8") or l_class.name.is_equal ("STRING_32") then
				create {DS_ARRAYED_LIST [STRING]} l_attrs.make (1)
				l_ref_adv ?= an_object
				check l_ref_adv_not_void: l_ref_adv /= Void end
				l_attrs.put_first (format_output_value(l_ref_adv.dump_value.truncated_string_representation (0, -1)))
			elseif l_class.parents_classes.there_exists (agent (x: CLASS_C): BOOLEAN do Result := x.name_in_upper.is_equal("ROUTINE") end) then
				l_attrs := fetch_object_attributes (an_object.children, True, a_depth)
					-- find target class for agent
				l_attrs.set_equality_tester (case_insensitive_string_equality_tester)
				l_attrs.start
				l_attrs.search_forth ("class_id")
				check class_id_attr_exists: not l_attrs.after end
				l_attrs.forth
				check class_id_attr_valid: not l_attrs.after and l_attrs.item_for_iteration.is_integer_32 end
				l_class_id := l_attrs.item_for_iteration.to_integer_32 + 1

				l_attrs.start
				l_attrs.search_forth ("feature_id")
				check feature_id_attr_exists: not l_attrs.after end
				l_attrs.forth
				check feature_id_attr_valid: not l_attrs.after and l_attrs.item_for_iteration.is_integer_32 end
				l_feature_id := l_attrs.item_for_iteration.to_integer_32

				if l_class_id > 0 then
					l_routine_target_type := l_class.system.class_type_of_static_type_id (l_class_id)
					if l_routine_target_type /= void then
						l_routine_target_class := l_routine_target_type.associated_class
					end
				end

				if l_routine_target_class /= void and l_feature_id > 0 then
					l_attrs.start
					l_attrs.search_forth ("class_id")
					check class_id_attr_exists: not l_attrs.after end
					l_attrs.forth
					check class_id_attr_valid: not l_attrs.after and l_attrs.item_for_iteration.is_integer_32 end
					l_attrs.replace_at (l_routine_target_class.name_in_upper)

					l_routine := l_routine_target_class.feature_with_feature_id (l_feature_id)
					if l_routine /= void then
						l_attrs.start
						l_attrs.search_forth ("feature_id")
						check feature_id_attr_exists: not l_attrs.after end
						l_attrs.forth
						check feature_id_attr_valid: not l_attrs.after and l_attrs.item_for_iteration.is_integer_32 end
						l_attrs.replace_at (l_routine.name)
					end
				end

			elseif l_class.is_special or l_class.is_tuple then
				l_attrs := fetch_object_attributes (an_object.children, False, a_depth)
			else
				l_attrs := fetch_object_attributes (an_object.children, True, a_depth)
			end


			put_object (l_id, l_type, not (an_object.address /= void and then call_stack_target_objects.has(an_object.address)), l_attrs)
		end

	put_object (an_id, a_type: STRING; an_inv: BOOLEAN; some_attrs: DS_LIST [STRING]) is
			-- Notify obervers that new object with id `an_id', type `a_type' and
			-- attributes `an_attrs' has been added. `an_inv' determines whether the
			-- invariant of the object should hold or not.
		require
			an_id_not_empty: an_id /= Void and then not an_id.is_empty
			a_type_not_empty: a_type /= Void and then not a_type.is_empty
			some_attrs_valid: some_attrs /= Void and then not some_attrs.has (Void)
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_CAPTURE_OBSERVER]
		do
			l_cursor := capture_observers.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_cursor.item.put_object (an_id, a_type, an_inv, some_attrs)
				l_cursor.forth
			end
		end

	add_referenced_object (an_adv: ABSTRACT_DEBUG_VALUE; a_depth: INTEGER) is
			-- Add `an_adv' to `object_map' and `object_queue'.
		require
			capturing: is_capturing
			an_adv_valid: an_adv /= Void and is_reference_value (an_adv)
			not_yet_added: not object_map.has (an_adv.address)
			a_depth_not_negative: a_depth >= 0
		local
			l_new_id: STRING
		do
			if object_map.is_full then
				object_map.resize (object_map.capacity * 2)
			end
			current_object_id := current_object_id + 1
			l_new_id := "#" + current_object_id.out
			object_map.put (l_new_id, an_adv.address)
			object_queue.put ([an_adv, a_depth])
		ensure
			added_to_mapping: object_map.has (an_adv.address)
			added_to_queue: object_queue.count = old object_queue.count + 1
		end

	fetch_object_attributes (an_attr_list: DS_LIST [ABSTRACT_DEBUG_VALUE]; an_use_attr_names: BOOLEAN; a_depth: INTEGER): DS_LIST [STRING] is
			-- List of string representations for attributes in `an_attr_list'.
			-- If `an_use_attr_name' is true, also provide the attributes names.
		require
			capturing: is_capturing
			object_map_not_void: object_map /= Void
			object_queue_not_void: object_queue /= Void
			an_attr_list_not_void: an_attr_list /= Void
			a_depth_not_negative: a_depth >= 0
		local
			l_cursor: DS_LIST_CURSOR [ABSTRACT_DEBUG_VALUE]
			l_child: ABSTRACT_DEBUG_VALUE
			l_value: STRING
		do
			create {DS_LINKED_LIST [STRING]} Result.make
			from
				l_cursor := an_attr_list.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_child := l_cursor.item
				l_value := attribute_value (l_child, a_depth + 1)
				if an_use_attr_names then
					Result.put_last (l_child.name)
				end
				Result.put_last (l_value)
				l_cursor.forth
			end
		end

	attribute_value (an_adv: ABSTRACT_DEBUG_VALUE; a_depth: INTEGER): STRING is
			-- Value represented by `an_adv' if it is a basic type,
			-- otherwise the mapped id for the object it is pointing to.
			-- Is void in case `an_adv' represents a void or unhandled value.
		require
			capturing: is_capturing
			a_depth_not_negative: a_depth >= 0
		do
			if is_reference_value (an_adv) then
				if  an_adv.dynamic_class /= Void and then an_adv.dynamic_class.is_eiffel_class_c then
					if not object_map.has (an_adv.address) then
						if current_object_id <= max_object_count and a_depth <= max_reference_depth then
							add_referenced_object (an_adv, a_depth)
							Result := object_map.item (an_adv.address)
						else
							Result := "Void"
						end
					else
						Result := object_map.item (an_adv.address)
					end
				end
			elseif an_adv.kind = {VALUE_TYPES}.immediate_value then
				if an_adv.dump_value.output_value (false) /= void then
					Result := format_output_value(an_adv.dump_value.truncated_string_representation (0, -1))
				else
					Result := ""
				end
			else
				Result := "Void"
			end
		ensure
			not_void: Result /= Void
		end

feature {NONE} -- Implementation (Access)

	object_map: DS_HASH_TABLE [STRING, STRING]
			-- Hash table that maps object addresses to an id in the test case context

	object_queue: DS_LINKED_QUEUE [TUPLE [object: ABSTRACT_DEBUG_VALUE; depth: INTEGER]]
			-- Queue of objects together with the reference depth still need to printed in the context

	current_object_id: INTEGER
			-- Counter for giving new objects an id.
			-- NOTE: this will be replaced with id from capture/replay module.

	call_stack_target_objects: DS_HASH_SET [STRING]
			-- Hash set for all addresses of objects which are target for a routine call represented by a frame of current call stack
			-- This is used to prevent invariant checks for theses objects

	is_capturing: BOOLEAN is
			-- Are we currently capturing?
		do
			Result := object_map /= Void and
				object_queue /= Void
		end

	is_reference_value (an_adv: ABSTRACT_DEBUG_VALUE): BOOLEAN is
			-- Is `an_adv' a reference to some object?
		do
			Result := an_adv.kind = {VALUE_TYPES}.reference_value or an_adv.kind = {VALUE_TYPES}.special_value
		end

	caller (a_element: EIFFEL_CALL_STACK_ELEMENT; a_call_stack: EIFFEL_CALL_STACK): EIFFEL_CALL_STACK_ELEMENT is
			-- Call stack element which called the routine in `a_element' in `a_call_stack'.
			-- NOTE: Void if `a_element' is first element in `a_call_stack' or caller is not a eiffel call stack element.
		require
			a_element_not_void: a_element /= Void
			a_call_stack_not_void: a_call_stack /= Void
			a_element_valid: a_call_stack.i_th (a_element.level_in_stack) = a_element
		do
			if a_call_stack.valid_index (a_element.level_in_stack + 1) then
				Result ?= a_call_stack.i_th (a_element.level_in_stack + 1)
			end
		ensure
			valid_result: Result = Void or else
				(Result.level_in_stack = a_element.level_in_stack + 1 and
				a_call_stack.i_th (Result.level_in_stack) = Result)
		end

	is_valid_cse (a_cse: EIFFEL_CALL_STACK_ELEMENT): BOOLEAN is
			-- Are `a_cse' a valid call stack element in `an_app_status' for creating a test case?
			-- e.g. exported to all or creation procedure?
		require
			a_cse_not_void: a_cse /= Void
		local
			l_class: EIFFEL_CLASS_C
			l_feature: E_FEATURE
			l_is_creation_call: BOOLEAN
		do
			if a_cse.dynamic_class /= Void and then a_cse.dynamic_class.is_eiffel_class_c then
				l_class := a_cse.dynamic_class.eiffel_class_c
				l_feature := a_cse.routine
				l_is_creation_call := l_class.creation_feature = l_feature.associated_feature_i or
					(l_class.creators /= Void and then l_class.creators.has (l_feature.name))
				if l_is_creation_call or l_feature.export_status.is_all then
					Result := True
				end
			end
		end

	next_valid_cse (an_app_status: APPLICATION_STATUS; a_cse: EIFFEL_CALL_STACK_ELEMENT): EIFFEL_CALL_STACK_ELEMENT is
			-- Next valid call stack element below `a_cse' (including `a_cse') in
			-- `an_app_status' call stack.
		require
			an_app_status_not_void: an_app_status /= Void
			a_cse_not_void: a_cse /= Void
			valid_a_cse: an_app_status.current_call_stack.i_th (a_cse.level_in_stack) = a_cse
		local
			i: INTEGER
		do
			from
				Result := a_cse
			until
				Result = Void or else is_valid_cse (Result)
			loop
				i := Result.level_in_stack + 1
				if an_app_status.current_call_stack.valid_index (i) then
					Result := caller (Result, an_app_status.current_call_stack)
				else
					Result := Void
				end
			end
		ensure
			valid_result: Result = Void or else Result.level_in_stack >= a_cse.level_in_stack
			result_is_valid_cse: Result = Void or else an_app_status.current_call_stack.i_th (Result.level_in_stack) = Result
		end

	format_output_value (a_string: STRING): STRING is
			-- Format output value `a_string'
		require
			a_string_not_void: a_string /= void
		local
			i: INTEGER
		do
			Result := eiffel_string_out (a_string.substring (1, max_manifest_string_size.min (a_string.count)))

			from
				i := max_manifest_string_size + 1
			until
				i > a_string.count
			loop
				Result := Result + "%" + %"" + eiffel_string_out (a_string.substring (i, (i + max_manifest_string_size - 1).min (a_string.count)))
				i := i + max_manifest_string_size
			end
		ensure
			result_not_void: Result /= void
		end


feature {NONE} -- Implementation

	uuid_generator: UUID_GENERATOR is
			-- UUID generator for creating uuid's
		once
			create Result
		ensure
			not_void: Result /= Void
		end


invariant
	cdd_manager_not_void: cdd_manager /= Void
	capture_observers_not_void: capture_observers /= Void


end
