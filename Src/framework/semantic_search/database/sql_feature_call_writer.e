note
	description: "Class to generate data for a feature call transition for database-based semantic search engine"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_FEATURE_CALL_WRITER

inherit
	SEM_TRANSITION_WRITER [SEM_FEATURE_CALL_TRANSITION]

	SEM_FIELD_BASED_QUERYABLE_WRITER [SEM_FEATURE_CALL_TRANSITION]
		redefine
			clear_for_write
		end

	EPA_SHARED_EQUALITY_TESTERS

	SQL_QUERYABLE_WRITER [SEM_FEATURE_CALL_TRANSITION]

create
	make_with_medium

feature -- Basic operations

	write (a_document: SEM_FEATURE_CALL_TRANSITION)
			-- Write `a_document' into `output'.
		do
			next_augxiliary_variable_id := max_vairable_id_from_queryable (a_document)
			queryable := a_document
			append_basic_info
			append_contracts (a_document)
			append_changes (a_document)
			append_serialization
			append_exception
		end

	clear_for_write
			-- Clear intermediate data for next `write'.
		do
			Precursor
			reference_value_table.wipe_out
			object_value_table.wipe_out

			next_reference_equivalent_class_id := 1
			next_object_equivalent_class_id := 1
			next_augxiliary_variable_id := 1
		end

feature{NONE} -- Implementation

	append_basic_info
			-- Append basic information of `queryable' into `medium'.
		do
			append_queryable_type (queryable)
			append_class_and_feature (queryable)
			append_uuid
			append_library (queryable)
			append_feature_type (queryable)
			append_transition_status (queryable)
			append_content
			append_hit_breakpoints (queryable)
			append_timestamp ("")
		end

	append_serialization
			-- Append object serialization data into `medium'.
		do
			if pre_state_serialization /= Void and then pre_state_object_info /= Void then
				append_string_field (pre_serialization_field, pre_state_serialization)
				append_string_field (pre_object_info_field, pre_state_object_info)
			end
		end

	append_contracts (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append contracts from `queryable' into `medium'.
		local
			l_obj_equiv_sets: like object_equivalent_classes
		do
				-- Appending preconditions.
			setup_reference_value_table (queryable.preconditions)
			l_obj_equiv_sets := object_equivalent_classes (queryable.preconditions)
			append_contracts_internal (queryable.preconditions, l_obj_equiv_sets, True, False, a_transition)
			create l_obj_equiv_sets.make (0)
			l_obj_equiv_sets.set_key_equality_tester (expression_equality_tester)
			append_contracts_internal (queryable.written_preconditions, l_obj_equiv_sets, True, True, a_transition)

				-- Appending postconditions.
			setup_reference_value_table (queryable.postconditions)
			l_obj_equiv_sets := object_equivalent_classes (queryable.postconditions)
			append_contracts_internal (queryable.postconditions, l_obj_equiv_sets, False, False, a_transition)
			create l_obj_equiv_sets.make (0)
			l_obj_equiv_sets.set_key_equality_tester (expression_equality_tester)
			append_contracts_internal (queryable.written_postconditions, l_obj_equiv_sets, False, True, a_transition)
		end

	append_contracts_internal (a_state: EPA_STATE; a_object_equivalent_classes: like object_equivalent_classes; a_precondition: BOOLEAN; a_human_written: BOOLEAN; a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append `a_state' into `medium' as precondition if `a_precondition' is True; otherwise as postcondition'.
			-- `a_object_equivalent_classes' indicates which expressions in `a_state' are object-equivalent to each other.
			-- `a_human_written' indicates if expressions in `a_state' is human-written contracts.
		local
			l_property_type: STRING
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
		do
			if a_precondition then
				l_property_type := precondition_property_prefix
			else
				l_property_type := postcondition_property_prefix
			end
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_value := l_cursor.item.value
				l_expr := l_cursor.item.expression
				append_equation (a_transition, l_expr, l_value, l_property_type, a_human_written, a_object_equivalent_classes, reference_value_table)
				l_cursor.forth
			end
		end

	append_changes (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append state-changes of `queryable' to `medium'.
		local
			l_change_calculator: EPA_EXPRESSION_CHANGE_CALCULATOR
			l_dynamic_change: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_static_change: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_type: INTEGER
			l_set: DS_HASH_SET_CURSOR [STRING]
			l_value_text: STRING
			l_cursor: DS_HASH_TABLE_CURSOR [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
		do
			if queryable.is_passing then
				create l_change_calculator.make
				l_dynamic_change := l_change_calculator.change_set (queryable.preconditions, queryable.postconditions)
				from
					l_cursor := l_dynamic_change.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_cursor.item.do_all (agent append_change (?, default_boost_value, a_transition))
					l_cursor.forth
				end
			end
		end

	append_change (a_change: EPA_EXPRESSION_CHANGE; a_boost_value: DOUBLE; a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Append `a_change' into `medium'.
		local
			l_value_text: STRING
			l_value: detachable EPA_EXPRESSION_VALUE
			l_prefix: STRING
		do
			l_value_text := a_change.values.first.text
			if l_value_text.is_integer then
				create {EPA_INTEGER_VALUE} l_value.make (l_value_text.to_integer)
			elseif l_value_text.is_boolean then
				create {EPA_BOOLEAN_VALUE} l_value.make (l_value_text.to_boolean)
			end
			if l_value /= Void then
				if a_change.is_relative then
					l_prefix := relative_change_property_prefix
				else
					l_prefix := absolute_change_property_prefix
				end
				append_equation (a_transition, a_change.expression, l_value, l_prefix, False, Void, reference_value_table)
			end
		end

feature{NONE} -- Implementation

	append_content
			-- Append content of `queryable' to `medium'.
		do
			append_string_field (content_field, queryable.content)
		end

end
