note
	description: "Writer to output a feature call transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FEATURE_CALL_TRANSITION_WRITER

inherit
	SEM_TRANSITION_WRITER [SEM_FEATURE_CALL_TRANSITION]

	EPA_CONTRACT_EXTRACTOR

	EPA_UTILITY

create
	make,
	make_with_medium

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			set_is_anonymous_expression_enabled (True)
			set_is_dynamic_typed_expression_enabled (True)
			set_is_static_typed_expression_enabled (True)
		end

	make_with_medium (a_medium: like medium)
			-- Initialize `medium' with `a_medium'.
		do
			make
			set_medium (a_medium)
		end

feature -- Access

	precondition_veto_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]]
			-- List of agents to decide if a precondition is to be written into result document
			-- A precondition is selected if all agents returns True.
			-- If the list is empty, all preconditions are selected by default.
		do
			if precondition_veto_agents_cache = Void then
				create precondition_veto_agents_cache.make
			end
			Result := precondition_veto_agents_cache
		end

	postcondition_veto_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]]
			-- List of agents to decide if a postcondition is to be written into result document
			-- A postcondition is selected if all agents returns True.
			-- If the list is empty, all postconditions are selected by default.
		do
			if postcondition_veto_agents_cache = Void then
				create postcondition_veto_agents_cache.make
			end
			Result := postcondition_veto_agents_cache
		end

	auxiliary_field_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [a_transition: like queryable], DS_HASH_SET [SEM_DOCUMENT_FIELD]]]
			-- Actions to return a list of auxiliary fields for `a_transition'
			-- If the list is empty, no auxiliary field is used.
		do
			if auxiliary_field_agents_cache = Void then
				create auxiliary_field_agents_cache.make
			end
			Result := auxiliary_field_agents_cache
		end

feature -- Status report

	is_anonymous_expression_enabled: BOOLEAN
			-- Should anonymous expression be output?
			-- For example, for an expression v_1.has (v_2), then
			-- the output will be {0}.has ({1}), if the position of v_1 is 0 and that of v_2 is 1.
			-- Default: True

	is_dynamic_typed_expression_enabled: BOOLEAN
			-- Should assertions with dynamic types be output?
			-- For example, for an expression v_1.has (v_2), if the dynamic type of v_1 is LINKED_LIST [ANY] and of v_2 is STRING_8,
			-- then the output will be {LINKED_LIST [ANY]}.has ({STRING_8}).
			-- Default: True

	is_static_typed_expression_enabled: BOOLEAN
			-- Should assertions with static types be output?
			-- For example, for an expression v_1.has (v_2), if the static type of v_1 is LINKED_LIST [ANY] and of v_2 is ANY,
			-- then the output will be {LINKED_LIST [ANY]}.has ({ANY}).
			-- Default: True		

feature -- Setting

	set_is_anonymous_expression_enabled (b: BOOLEAN)
			-- Set `is_anonymous_expression_enabled' with `b'.
		do
			is_anonymous_expression_enabled := b
		ensure
			is_anonymous_expression_enabled_set: is_anonymous_expression_enabled = b
		end

	set_is_dynamic_typed_expression_enabled (b: BOOLEAN)
			-- Set `is_dynamic_typed_expression_enabled' with `b'.
		do
			is_dynamic_typed_expression_enabled := b
		ensure
			is_dynamic_typed_expression_enabled_set: is_dynamic_typed_expression_enabled = b
		end

	set_is_static_typed_expression_enabled (b: BOOLEAN)
			-- Set `is_static_typed_expression_enabled' with `b'.
		do
			is_static_typed_expression_enabled := b
		ensure
			is_static_typed_expression_enabled_set: is_static_typed_expression_enabled = b
		end

feature -- Basic operations

	write (a_document: like queryable)
			-- Write `a_document' into output stream.
		do
			queryable := a_document
			write_begin
			write_header
			write_variables
			write_variable_positions
			write_content
			write_preconditions
			write_postconditions
			write_auxiliary_fields
			write_end
		end

feature{NONE} -- Implementation

	write_variable_positions
			-- Write variable position tables
			-- The written data is a commo separated string.
			-- For each pair of strings, the first is variable name, the second is the position of that variable
		local
			l_data: STRING
			l_cursor: like queryable.variable_positions.new_cursor
		do
			create l_data.make (128)
			from
				l_cursor := queryable.variable_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not l_data.is_empty then
					l_data.append_character (',')
				end
				l_data.append (l_cursor.key.text.as_lower)
				l_data.append_character (',')
				l_data.append (l_cursor.item.out)
				l_cursor.forth
			end
			write_field_with_data (variable_position_field, l_data, string_field_type, default_boost_value)
		end

	write_content
			-- Append content of `queryable' to `buffer'.
		do
			write_field_with_data (content_field, queryable.content, string_field_type, default_boost_value)
		end

	write_begin
			-- Write begin section of the whole document
		do
			write_field_with_data (begin_field, begin_field_value, string_field_type, default_boost_value)
		end

	write_end
			-- Write end section of the whole document
		do
			write_field_with_data (end_field, end_field_value, string_field_type, default_boost_value)
		end

	write_header
			-- Write document header, including
			-- document type, class name, feature name.
		do
			write_field_with_data (document_type_field, transition_field_value, string_field_type, default_boost_value)
			write_field_with_data (class_field, queryable.class_.name_in_upper, string_field_type, default_boost_value)
			write_field_with_data (feature_field, queryable.feature_.feature_name_32.as_lower , string_field_type, default_boost_value)
			write_field_with_data (uuid_field, queryable.uuid, string_field_type, default_boost_value)
			write_library
		end

	write_variables
			-- Write variables from `a_document' into `output'.
		do
			append_variables (queryable.variables, variables_field, True, False)
			append_variables (queryable.variables, variable_types_field, False, True)
			append_variables (queryable.inputs, inputs_field, True, False)
			append_variables (queryable.inputs, input_types_field, False, True)
			append_variables (queryable.outputs, outputs_field, True, False)
			append_variables (queryable.outputs, output_types_field, False, True)
			append_variables (queryable.intermediate_variables, locals_field, True, False)
			append_variables (queryable.intermediate_variables, local_types_field, False, True)
		end

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN)
			-- Append operands in `queryable' to `buffer'.
			-- `a_print_position' indicates if position of variables are to be printed.
			-- `a_print_ancestor' indicates if ancestors of the types of `a_variables' are to be printed.
		local
			l_values: STRING
		do
			l_values := variable_info (a_variables, queryable, a_print_position, a_print_ancestor)
			if not l_values.is_empty then
				write_field_with_data (a_field, l_values, string_field_type, default_boost_value)
			end
		end

	write_library
			-- Write the library of `queryable' into `output'
		do
			write_field_with_data (library_field, queryable.class_.group.name, string_field_type, default_boost_value)
		end

	write_preconditions
			-- Write preconditions from `queryable' into `output'.
		do
			write_assertions (queryable.preconditions, precondition_veto_agents, precondition_field_prefix)
			write_assertions (queryable.written_preconditions, precondition_veto_agents, written_precondition_field_prefix)
		end

	write_postconditions
			-- Write postcondition from `queryable' into `output'.
		do
			write_assertions (queryable.postconditions, postcondition_veto_agents, postcondition_field_prefix)
			write_assertions (queryable.written_postconditions, precondition_veto_agents, written_postcondition_field_prefix)
		end

	write_assertions (a_assertions: EPA_STATE; a_veto_agents: like precondition_veto_agents; a_prefix: STRING)
			-- Write `a_assertions' (filtered by `a_veto_agents') into `output'.
			-- `a_prefix' is the prefix that is put in front of every output field name.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_assertion: EPA_EQUATION
			l_expression: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_anonymous: STRING
			l_dtype_tbl: like type_name_table
			l_stype_tbl: like type_name_table
		do
			if is_dynamic_typed_expression_enabled then
				l_dtype_tbl := type_name_table (queryable.variable_dynamic_type_table)
			end
			if is_static_typed_expression_enabled then
				l_stype_tbl := type_name_table (queryable.variable_static_type_table)
			end

			from
				l_cursor := a_assertions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_assertion := l_cursor.item
					-- Only process assertions that are selected by `a_veto_agents'.
				if across a_veto_agents as l_agents all l_agents.item.item ([l_assertion]) end then
					l_expression := l_assertion.expression
					l_value := l_assertion.value
					l_anonymous := queryable.anonymous_expression_text (l_expression)

						-- Output anonymous format.
					if is_anonymous_expression_enabled then
						write_field_with_data (a_prefix + l_anonymous, l_value.text, type_of_equation (l_assertion), default_boost_value)
					end

						-- Output dynamic type format.
					if is_dynamic_typed_expression_enabled then
						write_field_with_data (a_prefix + expression_with_replacements (l_expression, l_dtype_tbl, True), l_value.text, type_of_equation (l_assertion), default_boost_value)
					end

						-- Output static type format.
					if is_static_typed_expression_enabled then
						write_field_with_data (a_prefix + expression_with_replacements (l_expression, l_stype_tbl, True), l_value.text, type_of_equation (l_assertion), default_boost_value)
					end

				end
				l_cursor.forth
			end
		end

feature{NONE} -- Implementation

	precondition_veto_agents_cache: detachable like precondition_veto_agents
			-- Cache for `precondition_veto_agents'

	postcondition_veto_agents_cache: detachable like postcondition_veto_agents
			-- Cache for `postcondition_veto_agents'

	auxiliary_field_agents_cache: detachable like auxiliary_field_agents
			-- Cache for `auxiliary_fields_agent'

feature{NONE} -- Writing

	write_auxiliary_fields
			-- Write auxiliary fields retrieved from `auxiliary_field_agents' into `output'.
		local
			l_fields: DS_HASH_SET [SEM_DOCUMENT_FIELD]
		do
				-- Collect all auxiliary fields from `auxiliary_field_agents'.
			create l_fields.make (10)
			l_fields.set_equality_tester (document_field_equality_tester)
			across auxiliary_field_agents as l_agents loop
				l_fields.append_last (l_agents.item.item ([queryable]))
			end

				-- Write collected auxiliary fields into `output'.
			l_fields.do_all (agent write_field)
		end

	write_field (a_field: SEM_DOCUMENT_FIELD)
			-- Write `a_field' into `output', and update `written_fields'.
		do
			if not written_fields.has (a_field) then
				medium.put_string (a_field.out)
				medium.put_new_line

				written_fields.force_last (a_field)
			end
		end

	write_field_with_data (a_name: STRING; a_value: STRING; a_type: STRING; a_boost: DOUBLE)
			-- Write field specified through `a_name', `a_value', `a_type' and `a_boost' into `output'.
		do
			write_field (create {SEM_DOCUMENT_FIELD}.make (a_name, a_value, a_type, a_boost))
		end

end
