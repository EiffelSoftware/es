note
	description: "Class that represents a candidate document from query results"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CANDIDATE_QUERYABLE

inherit
	SEM_FIELD_NAMES

	EPA_TYPE_UTILITY

	SOLR_UTILITY

	IR_SHARED_EQUALITY_TESTERS

	DEBUG_OUTPUT

create
	make,
	make_with_score,
	make_from_document

feature{NONE} -- Initialization

	make (a_uuid: STRING)
			-- Initialize Current.
		do
			uuid := a_uuid
			create variable_types.make (10)
			create criteria.make (10)
			criteria.compare_objects
			create criteria_by_value_internal.make (10)
			criteria_by_value_internal.compare_objects
			create integer_criteria_by_value_internal.make (10)
			integer_criteria_by_value_internal.compare_objects
			set_is_valid (True)
		end

	make_with_score (a_uuid: STRING; a_score: DOUBLE)
			-- Initialize Current.
		do
			make (a_uuid)
			set_score (a_score)
		end

	make_from_document (a_document: IR_DOCUMENT)
			-- Initialize Current using data from `a_document'.
		local
			l_fields: HASH_TABLE [LINKED_LIST [IR_FIELD], STRING_8]
			l_variables: like variable_types
		do
			l_fields := a_document.table_by_name

				-- Initialize UUID and score.
			set_is_valid (l_fields.has (uuid_field))
			if is_valid then
				make (l_fields.item (uuid_field).first.value.text)
			end

			if is_valid then
				set_is_valid (l_fields.has (score_field))
				if is_valid then
					set_score (l_fields.item (score_field).first.value.text.to_double)
				end
			end


				-- Initialize variables.
			if is_valid then
				set_is_valid (l_fields.has (variables_field))
				if is_valid then
					set_variables_from_string (l_fields.item (variables_field).first.value.text)
				end
			end

			if is_valid then
					-- Initialize meta data.
				l_variables := variable_types
				across l_fields as l_field_tbl loop
					if l_field_tbl.key.starts_with (once "s_") then
							-- This is a field for meta data.
						extend_criterion_from_string (l_field_tbl.item.first.name, l_field_tbl.item.first.value.text, l_variables)
					end
				end
			end

			if is_valid then
				l_fields.search (content_field)
				if l_fields.found then
					content := l_fields.found_item.first.value.text
				end
			end
		end

feature -- Access

	uuid: STRING
			-- UUID of Current document

	score: DOUBLE
			-- Score of Current document

	variable_types: HASH_TABLE [TYPE_A, INTEGER]
			-- Table for variables inside Current document
			-- Key is object index, value is the dynamic type of that variable

	content: detachable STRING
			-- Content of current candidate

	criteria: HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], STRING]
			-- Table of criteria that are used for matching
			-- Key is criteria content, value is the matching criteria of the same content.			

	criteria_by_value (a_criterion_name: STRING; a_value: IR_VALUE): detachable LINKED_LIST [SEM_MATCHING_CRITERION]
			-- List of matching criterion with `a_criterion_name' and `a_value'
			-- Return Void if nothing is found.
		local
			l_internal: like criteria_by_value_internal
			l_tbl: DS_HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], IR_VALUE]
			l_itbl: DS_HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], INTEGER]
			l_lower, l_upper: INTEGER
			l_iinternal: like integer_criteria_by_value_internal
			l_cursor: DS_HASH_TABLE_CURSOR [LINKED_LIST [SEM_MATCHING_CRITERION], INTEGER]
			l_bool_value: IR_BOOLEAN_VALUE
		do
			l_internal := criteria_by_value_internal
			l_internal.search (a_criterion_name)
			if l_internal.found then
				l_tbl := l_internal.found_item
				l_tbl.search (a_value)
				if l_tbl.found then
					Result := l_tbl.found_item
				elseif attached {IR_INTEGER_RANGE_VALUE} a_value as l_range then
						-- For integer range values, we do a linear search.
					l_lower := l_range.lower
					l_upper := l_range.upper
					l_iinternal := integer_criteria_by_value_internal
					l_iinternal.search (a_criterion_name)
					if l_iinternal.found then
						l_itbl := l_iinternal.found_item
						create Result.make
						from
							l_cursor := l_itbl.new_cursor
							l_cursor.start
						until
							l_cursor.after
						loop
							if l_cursor.key >= l_lower and then l_cursor.key <= l_upper  then
								Result.append (l_cursor.item)
							end
							l_cursor.forth
						end
						if Result.is_empty then
							Result := Void
						end
					end
				elseif attached {IR_ANY_VALUE} a_value as l_any_value then
					create l_bool_value.make (True)
					l_tbl.search (l_bool_value)
					if l_tbl.found then
						Result := l_tbl.found_item
					end
				end
			end
		end

	text: STRING
			-- Text representation of Current.
		do
			create Result.make (2048)

				-- Append UUID
			Result.append (uuid)
			Result.append_character ('%N')

				-- Append content
			if content /= Void then
				Result.append (content)
				Result.append_character ('%N')
			end

				-- Append variable information.
			across variable_types as l_variables loop
				Result.append (l_variables.key.out)
				Result.append_character (':')
				Result.append_character (' ')
				Result.append (l_variables.item.name)
				Result.append_character ('%N')
			end

				-- Append meta information.
			across criteria as l_criteria loop
				across l_criteria.item as l_cri_list loop
					Result.append (l_cri_list.item.text)
					Result.append_character ('%N')
				end
			end
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Status report

	is_valid: BOOLEAN
			-- Is Current candidate valid?

feature -- Setting

	set_score (a_score: DOUBLE)
			-- Set `score' with `a_score'.
		do
			score := a_score
		ensure
			score_set: score = a_score
		end

	set_is_valid (a_valid: BOOLEAN)
			-- Set `is_valid' with `a_valid'.
		do
			is_valid := a_valid
		ensure
			is_valid_set: is_valid = a_valid
		end

	set_variables_from_string (a_string: STRING)
			-- Set `variable_types' from `a_string'.
		local
			l_variable: like variable_and_position_from_config
			l_variables: like variable_types
		do
			l_variables := variable_types
			across a_string.split (field_value_separator) as l_vars loop
				l_variable := variable_and_position_from_config (l_vars.item)
				l_variables.force (l_variable.type, l_variable.position)
			end
		end


feature -- Basic operations

	extend_criterion_from_string (a_criterion_name: STRING; a_value: STRING; a_types: HASH_TABLE [TYPE_A, INTEGER])
			-- Add an criterion parsed from `a_criterion_name' and `a_value' into `criteria'.
			-- `a_types' is a table from variable indexes to variable types.
		local
			l_criterion_name: STRING
			l_index: INTEGER
			l_combination: LIST [STRING]
			l_criterion: SEM_MATCHING_CRITERION
			l_operands: ARRAYED_LIST [INTEGER]
			l_value: IR_VALUE
			l_int_value: INTEGER
			l_name: STRING
		do
				-- 1. Remove prefix from `a_criterion_name'
				-- 2. Decode `a_criterion_name'
			l_index := a_criterion_name.index_of ('_', 1)
--			l_index := a_criterion_name.index_of ('_', l_index + 1)
--			l_index := a_criterion_name.index_of ('_', l_index + 1)
			l_criterion_name := decoded_field_string (a_criterion_name.substring (l_index + 1, a_criterion_name.count))

				-- Iterate through all combinations of objects.
			across a_value.split (field_value_separator) as l_matches loop
				if not l_matches.item.is_empty then
						-- Analyze the value section.
					l_combination := l_matches.item.split (',')
					l_value := value_from_string (l_combination.last)
					l_combination.finish
					l_combination.remove
					create l_operands.make (3)
					across l_combination as l_positions loop
						l_operands.extend (l_positions.item.to_integer)
					end
					create l_name.make (l_criterion_name.count + 10)
					if l_value.is_boolean_value then
						l_name.append (boolean_prefix)
					elseif l_value.is_integer_value then
						l_name.append (integer_prefix)
					end
					l_name.append (l_criterion_name)
					create l_criterion.make (l_name, l_value, l_operands, a_types)

						-- Setup `criteria'.
					extend_criteria (l_criterion)

						-- Setup `criteria_by_value_internal'.
					extend_criteria_by_value_internal (l_criterion)

						-- Setup `integer_criteria_by_value_internal'.
					if attached {IR_INTEGER_VALUE} l_value as l_int then
						l_int_value := l_int.item
						extend_integer_criteria_by_value_internal (l_criterion, l_int_value)
					end
				end
			end
		end

feature{NONE} -- Implementation

	extend_criteria (a_criterion: SEM_MATCHING_CRITERION)
			-- Add `a_criterion' into `criteria'.
		local
			l_criteria: like criteria
			l_criterion_name: STRING
			l_cri_list: LINKED_LIST [SEM_MATCHING_CRITERION]
		do
			l_criterion_name := a_criterion.criterion
			l_criteria := criteria
			l_criteria.search (l_criterion_name)
			if l_criteria.found then
				l_cri_list := l_criteria.found_item
			else
				create l_cri_list.make
				l_criteria.force (l_cri_list, l_criterion_name)
			end
			l_cri_list.extend (a_criterion)
		end

	extend_criteria_by_value_internal (a_criterion: SEM_MATCHING_CRITERION)
			-- Add `a_criterion' into `criteria_by_value_internal'.
		local
			l_cri_list: LINKED_LIST [SEM_MATCHING_CRITERION]
			l_criteria: like criteria
			l_tbl: DS_HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], IR_VALUE]
			l_cri_internal: like criteria_by_value_internal
			l_criterion_name: STRING
		do
			l_criterion_name := a_criterion.criterion
			l_cri_internal := criteria_by_value_internal
			l_cri_internal.search (l_criterion_name)
			if l_cri_internal.found then
				l_tbl := l_cri_internal.found_item
			else
				create l_tbl.make (10)
				l_tbl.set_key_equality_tester (ir_value_equality_tester)
				l_cri_internal.force (l_tbl, l_criterion_name)
			end

			l_tbl.search (a_criterion.value)
			if l_tbl.found then
				l_cri_list := l_tbl.found_item
			else
				create l_cri_list.make
				l_tbl.force_last (l_cri_list, a_criterion.value)
			end
			l_cri_list.extend (a_criterion)
		end

	extend_integer_criteria_by_value_internal (a_criterion: SEM_MATCHING_CRITERION; a_value: INTEGER)
			-- Add `a_criterion' with `a_value' into `integer_criteria_by_value_internal'.
		local
			l_criterion_name: STRING
			l_icri_internal: like integer_criteria_by_value_internal
			l_itbl: DS_HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], INTEGER]
			l_cri_list: LINKED_LIST [SEM_MATCHING_CRITERION]
		do
			l_criterion_name := a_criterion.criterion
			l_icri_internal := integer_criteria_by_value_internal
			l_icri_internal.search (l_criterion_name)
			if l_icri_internal.found then
				l_itbl := l_icri_internal.found_item
			else
				create l_itbl.make (10)
				l_icri_internal.force (l_itbl, l_criterion_name)
			end

			l_itbl.search (a_value)
			if l_itbl.found then
				l_cri_list := l_itbl.found_item
			else
				create l_cri_list.make
				l_itbl.force_last (l_cri_list, a_value)
			end
			l_cri_list.extend (a_criterion)

		end

feature{NONE} -- Implementation

	variable_and_position_from_config (a_config: STRING): TUPLE [type: TYPE_A; position: INTEGER]
			-- Type and position of an object from `a_config'
		local
			l_sep_pos: INTEGER
			l_type_name: STRING
			l_index: INTEGER
		do
			l_sep_pos := a_config.index_of ('@', 1)
			l_type_name := a_config.substring (2, l_sep_pos - 2)
			l_index := a_config.substring (l_sep_pos + 1, a_config.count).to_integer
			Result := [type_a_from_string_in_application_context (l_type_name), l_index]
		end

	value_from_string (a_string: STRING): IR_VALUE
			-- Value from `a_string'
		do
			if a_string.is_boolean then
				create {IR_BOOLEAN_VALUE} Result.make (a_string.to_boolean)
			elseif a_string.is_integer then
				create {IR_INTEGER_VALUE} Result.make (a_string.to_integer)
			end
		end

	criteria_by_value_internal: HASH_TABLE [DS_HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], IR_VALUE], STRING]
			-- Table of critera.
			-- Key of outer table is criterion content,
			-- Key of inner table is criterion value, value of the inner table
			-- is the list of critera with the same value.

	integer_criteria_by_value_internal: HASH_TABLE [DS_HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], INTEGER], STRING]
			-- Table of integer critera.
			-- Key of outer table is criterion content,
			-- Key of inner table is criterion value, value of the inner table
			-- is the list of critera with the same value.

end
