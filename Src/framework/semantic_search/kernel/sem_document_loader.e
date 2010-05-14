note
	description: "Summary description for {SEM_DOCUMENT_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_DOCUMENT_LOADER
inherit
	SEM_FIELD_NAMES
	EPA_UTILITY

feature -- Loading

	load (a_document: like document)
			-- Load `a_document' into a queryable
		do
			document := a_document
			create fields.make(50)

			from
				position := 1
			until
				position >= document.count
			loop
				parse_field
			end

			-- Determine document-type
			if fields[document_type_field].is_equal ("transition") then
				-- Transition
				if fields.has(feature_field) then
					-- Feature-call transition
					load_feature_call_transition
				end
			end
		end

feature -- Access

	last_queryable: SEM_QUERYABLE

feature {NONE} -- Implementation

	variable_locations (a_var_index_list: LIST[STRING]): LIST[TUPLE[type:STRING;position:INTEGER]]
			-- Extracts types and positions from a list of variables ({type}@position)
		local
			l_cur_var: LIST[STRING]
			l_type_name: STRING
		do
			create {LINKED_LIST[TUPLE[name:STRING;position:INTEGER]]}Result.make

			from
				a_var_index_list.start
			until
				a_var_index_list.after
			loop
				l_cur_var := a_var_index_list.item.split ('@')
				l_type_name := l_cur_var.i_th (1)
				l_type_name := l_type_name.substring (2, l_type_name.count-1)
				Result.extend ([l_type_name, l_cur_var.i_th (2).to_integer])
				a_var_index_list.forth
			end
		end

	concrete_variable_locations (a_var_loc_list: like variable_locations): like variable_locations
			-- Filters out abstract types from `a_var_loc'. Uses that the concrete type always comes last.
		local
			l_last: TUPLE[name:STRING;position:INTEGER]
		do
			create {LINKED_LIST[TUPLE[name:STRING;position:INTEGER]]}Result.make

			if not a_var_loc_list.is_empty then
				from
					l_last := a_var_loc_list.first
					a_var_loc_list.start
				until
					a_var_loc_list.after
				loop
					if a_var_loc_list.item.position /= l_last.position then
						Result.extend ([l_last.name, l_last.position])
					end

					l_last := a_var_loc_list.item
					a_var_loc_list.forth
				end
				Result.extend ([l_last.name, l_last.position])
			end
		end

	context_from_var_locations (a_var_loc_list: like variable_locations): EPA_CONTEXT
			-- Returns a context with the variables in `a_var_loc_list'
		local
			l_last: TUPLE[type:STRING;position:INTEGER]
			l_var_hash: HASH_TABLE[TYPE_A,STRING]
			l_cur_type: TYPE_A
			l_any: CLASS_C
		do
			l_any := first_class_starts_with_name("ANY")

			from
				create l_var_hash.make (a_var_loc_list.count)
				a_var_loc_list.start
			until
				a_var_loc_list.after
			loop
				l_cur_type := type_a_from_string (a_var_loc_list.item.type, l_any)
				l_var_hash.extend (l_cur_type, "v"+a_var_loc_list.item.position.out)
				a_var_loc_list.forth
			end
			create Result.make (l_var_hash)
		end

	linear_operand_list (a_count: INTEGER): HASH_TABLE[STRING,INTEGER]
			-- Return a simple operand-list where vn is at index n with n=0..a_count-1
		local
			l_index: INTEGER
		do
			create Result.make (a_count)
			from
				l_index := 0
			until
				l_index >= a_count
			loop
				Result.extend("v"+l_index.out, l_index)
				l_index := l_index + 1
			end
		end

	variable_form_from_anonymous (a_string: STRING): STRING
			-- Converts any {n} to vn
		local
			l_pos: INTEGER
			l_change: BOOLEAN
		do
			from
				create Result.make (a_string.count)
				l_pos := 1
			until
				l_pos > a_string.count
			loop
				if a_string.item (l_pos) = '{' then
					l_change := true
				elseif a_string.item (l_pos) /= '}' then
					if l_change then
						Result.extend ('v')
						l_change := false
					end

					Result.extend (a_string.item (l_pos))
				end
				l_pos := l_pos + 1
			end
		end

	is_anonymous_form (a_string: STRING): BOOLEAN
			-- Is `a_string' in anonymous form? ({0}.count etc)
		local
			l_anon_start: INTEGER
		do
			-- Find '{'
			-- Check if next character is an integer
			l_anon_start := a_string.index_of ('{', 1)
			Result :=  l_anon_start = 0 or else a_string.item (l_anon_start+1).is_digit
		end

	load_feature_call_transition
			-- Loads a feature-call transition
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_context: EPA_CONTEXT
			l_transition: SEM_FEATURE_CALL_TRANSITION

			l_variables: LIST[STRING]
			l_var_locations: like variable_locations
			l_concrete_var_locations: like variable_locations

			l_operands: HASH_TABLE[STRING,INTEGER]
			l_prestate, l_poststate: EPA_STATE
			l_prestate_queries, l_poststate_queries: HASH_TABLE[STRING,STRING]
			l_var_replacement_map: HASH_TABLE[STRING,STRING]

			l_current_anon_property, l_current_var_property, l_current_property_value: STRING
			l_field: STRING
		do
			-- Split variable field into single variables+index
			l_variables := string_slices (fields[variables_field], field_value_separator)

			-- Extract typename and positions
			l_var_locations := variable_locations (l_variables)

			-- Filter out abstracted types
			l_concrete_var_locations := concrete_variable_locations (l_var_locations)

			-- Create a context with the variables
			l_context := context_from_var_locations (l_concrete_var_locations)

			-- Create simple operand-list			
			l_operands := linear_operand_list (l_context.variables.count)

			-- Create the transition
			l_class := first_class_starts_with_name (fields[class_field])
			l_feature := l_class.feature_named (fields[feature_field])
			create l_transition.make (l_class, l_feature, l_operands, l_context, false)

			-- Gather pre- & poststate-queries
			from
				fields.start
				create l_prestate_queries.make (20)
				create l_poststate_queries.make (20)
			until
				fields.after
			loop
				l_field := fields.key_for_iteration
				if l_field.starts_with (precondition_field_prefix) then
					l_current_anon_property := l_field.substring (precondition_field_prefix.count+1, l_field.count)
					if is_anonymous_form (l_current_anon_property) then
						l_current_var_property := variable_form_from_anonymous (l_current_anon_property)
						l_current_property_value := fields.item_for_iteration
						l_prestate_queries.extend (l_current_property_value, l_current_var_property)
					end
				elseif l_field.starts_with (postcondition_field_prefix) then
					l_current_anon_property := l_field.substring (postcondition_field_prefix.count+1, l_field.count)
					if is_anonymous_form (l_current_anon_property) then
						l_current_var_property := variable_form_from_anonymous (l_current_anon_property)
						l_current_property_value := fields.item_for_iteration
						l_poststate_queries.extend (l_current_property_value, l_current_var_property)
					end
				end
				fields.forth
			end

			-- Create and set pre- & poststates
			create l_prestate.make_from_object_state (l_prestate_queries, l_class, l_feature)
			create l_poststate.make_from_object_state (l_poststate_queries, l_class, l_feature)
			l_transition.set_precondition (l_prestate)
			l_transition.set_postcondition (l_poststate)

			last_queryable := l_transition
		end

	document: STRING

	position: INTEGER

	fields: HASH_TABLE[STRING, STRING]
	-- Field name -> content

	parse_field
		local
			field_name: STRING
			field_content_string: STRING
			field_content_list: LIST[STRING]
			name_start, name_end: like position
			content_start, content_end: like position
		do
			name_start := position

			-- Get field name
			name_end := document.index_of ('%N', name_start)
			field_name := document.substring (name_start, name_end-1)

			-- Skip boost & type
			content_start := document.index_of ('%N', name_end+1)
			content_start := document.index_of ('%N', content_start+1)

			-- Read content
			content_end := document.index_of ('%N', content_start+1)
			field_content_string := document.substring (content_start+1, content_end-1)

			-- Add field
			fields.extend (field_content_string, field_name)

			-- Skip to next field
			from
				position := content_end+1
			until
				document.item (position) /= '%N' or position>=document.count
			loop
				position := position + 1
			end
		end
end
