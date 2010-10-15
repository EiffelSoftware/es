note
	description: "Class that represents a candidate object document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CANDIDATE_OBJECTS

inherit
	SEM_CANDIDATE_QUERYABLE
		redefine
			is_valid
		end

create
	make,
	make_with_score,
	make_from_document

feature{NONE} -- Initialization

	make (a_uuid: STRING)
			-- Initialize Current.
		do
			uuid := a_uuid
			create variables.make (10)
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
			l_variables: like variables
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
				l_variables := variables
				across l_fields as l_field_tbl loop
					if l_field_tbl.key.starts_with (once "s_") then
							-- This is a field for meta data.
						extend_criterion_from_string (l_field_tbl.item.first.name, l_field_tbl.item.first.value.text, l_variables)
					end
				end
			end
		end

feature -- Access

	text: STRING
			-- Text representation of Current.
		do
			create Result.make (2048)

				-- Append UUID
			Result.append (uuid)
			Result.append_character ('%N')

				-- Append variable information.
			across variables as l_variables loop
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
			-- Set `variables' from `a_string'.
		local
			l_variable: like variable_and_position_from_config
			l_variables: like variables
		do
			l_variables := variables
			across a_string.split (field_value_separator) as l_vars loop
				l_variable := variable_and_position_from_config (l_vars.item)
				l_variables.force (l_variable.type, l_variable.position)
			end
		end

end
