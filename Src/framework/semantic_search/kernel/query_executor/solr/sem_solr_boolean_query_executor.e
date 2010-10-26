note
	description: "Class to execute a boolean query through Solr platform"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SOLR_BOOLEAN_QUERY_EXECUTOR

inherit
	SEM_TERM_VISITOR

	IR_SHARED_EQUALITY_TESTERS

	SEM_SOLR_UTILITY

	SEM_FIELD_NAMES

	SOLR_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
		end

feature -- Access

	last_result: IR_QUERY_RESULT
			-- Result from last query execution.

feature -- Basic operations

	execute (a_boolean_query: SEM_BOOLEAN_QUERY)
			-- Execute `a_boolean_query', make result available in `last_result'.
		do
			execute_with_options (a_boolean_query, Void)
		end

	execute_with_options (a_boolean_query: SEM_BOOLEAN_QUERY; a_options: detachable HASH_TABLE [STRING, STRING])
			-- Execute `a_boolean_query' with `a_options', make result available in `last_result'.
			-- `a_options' is a hash-table containing options for the query execution, specified as
			-- name-value pairs. Key is option name, value is option value.
		local
			l_ir_query: IR_BOOLEAN_QUERY
			l_executor: IR_SOLR_QUERY_EXECUTOR
		do
			query := a_boolean_query
			l_ir_query := ir_boolean_query
			if a_options /= Void then
				across a_options as l_options loop
					l_ir_query.meta.put (l_options.item, l_options.key)
				end
			end
			create l_executor.make
			io.put_string (l_ir_query.text)
			l_executor.execute (l_ir_query)
			last_result := l_executor.last_result
		end

feature{NONE} -- Implementation

	query: SEM_BOOLEAN_QUERY
			-- Query to be executed

	query_config: SEM_QUERY_CONFIG
			-- Config of the to-be-executed query
		do
			Result := query.config
		end

	primary_type_form: INTEGER
			-- Primary type from in `query_config'
		do
			Result := query_config.primary_property_type_form
		end

feature{NONE} -- Implementation

	terms: DS_HASH_SET [IR_TERM]
			-- Set of information-retrieval terms

feature{NONE} -- Process terms

	process_change_term (a_term: SEM_CHANGE_TERM)
			-- Process `a_term'.
		local
			l_term: IR_TERM
			l_field: IR_FIELD
			l_value: detachable IR_VALUE
			l_data: like final_occurrence_for_term
			l_occur: INTEGER
		do
			l_value := value_from_expression_value (a_term.value)
			l_data := final_occurrence_for_term (l_value, a_term)
			l_value := l_data.value
			l_occur := l_data.occurrence
			if l_value /= Void then
				create l_field.make (field_name_for_term (a_term, primary_type_form, False), l_value, default_boost_value)
				create l_term.make (l_field, l_occur)
				terms.force_last (l_term)
			end
		end

	process_equation_term (a_term: SEM_EQUATION_TERM)
			-- Process `a_term'.
		local
			l_term: IR_TERM
			l_field: IR_FIELD
			l_value: detachable IR_VALUE
			l_occur: INTEGER
			l_data: like final_occurrence_for_term
		do
			l_value := value_from_expression_value (a_term.value)
			l_data := final_occurrence_for_term (l_value, a_term)
			l_value := l_data.value
			l_occur := l_data.occurrence

			if l_value /= Void then
				create l_field.make (field_name_for_term (a_term, primary_type_form, False), l_value, default_boost_value)
				create l_term.make (l_field, l_occur)
				terms.force_last (l_term)
			end
		end

	process_contract_term (a_term: SEM_CONTRACT_TERM)
			-- Process `a_term'.
		do
			process_equation_term (a_term)
		end

	process_property_term (a_term: SEM_PROPERTY_TERM)
			-- Process `a_term'.
		do
			process_equation_term (a_term)
		end

	process_variable_term (a_term: SEM_VARIABLE_TERM)
			-- Process `a_term'.
		local
			l_field: IR_FIELD
			l_value: IR_STRING_VALUE
			l_term: IR_TERM
		do
			create l_value.make (once "%"" + output_type_name (a_term.type.name) + once "%"")
			create l_field.make (field_name_for_term (a_term, primary_type_form, False), l_value, default_boost_value)
			create l_term.make (l_field, a_term.occurrence)
			terms.force_last (l_term)
		end

	process_variable_position_term (a_term: SEM_VARIABLE_POSITION_TERM)
			-- Process `a_term'.
		local
			l_field: IR_FIELD
			l_value: IR_STRING_VALUE
			l_term: IR_TERM
		do
			create l_value.make (once "%"" + output_type_name (a_term.type.name) + once "%"")
			create l_field.make (field_name_for_term (a_term, primary_type_form, False), l_value, default_boost_value)
			create l_term.make (l_field, a_term.occurrence)
			terms.force_last (l_term)
		end

feature{NONE} -- Implementation

	ir_boolean_query: IR_BOOLEAN_QUERY
			-- Information-retrieval boolean query generated from `query'
		local
			l_returned_fields: DS_HASH_SET [STRING]
			l_type_form: INTEGER
		do
				-- Iterate through all terms in `a_boolean_query' and
				-- translate those terms into information-retrieval terms.
			create terms.make (20)
			terms.set_equality_tester (ir_term_equality_tester)
			query.config.terms.do_all (agent {SEM_TERM}.process (Current))

				-- Add extra specified fields.
			across query.config.extra_fields as l_fields loop
				terms.force_last (ir_term_from_data (l_fields.key, l_fields.item))
			end

				-- Setup searchable terms in result information-retrieval boolean query.
			create Result.make
			Result.terms.force_last (document_type_term (query_config.queryable))
			Result.terms.append (terms)

				-- Setup returned fields.
			l_returned_fields := Result.returned_fields
			l_returned_fields.force_last (content_field)
			l_returned_fields.force_last (variables_field)
			l_returned_fields.force_last (uuid_field)
			l_type_form := primary_type_form
			across query_config.terms as l_terms loop
				l_returned_fields.force_last (
					field_name_prefix_for_term (l_terms.item, primary_type_form, True) +
					encoded_field_string (l_terms.item.field_content_in_type_form (l_type_form)))
			end

				-- Add extra specified returned fields.
			across query.config.returned_fields as l_fields loop
				l_returned_fields.force_last (l_fields.item)
			end

		end

	ir_term_from_data (a_field_name: STRING; a_field_value: STRING): IR_TERM
			-- ir term from `a_field_name' and `a_field_value'
		do
			create Result.make_as_string (a_field_name, a_field_value, default_boost_value, {IR_TERM_OCCURRENCE}.term_occurrence_must)
		end

	value_from_expression_value (a_expression_value: EPA_EXPRESSION_VALUE): IR_VALUE
			-- Information-retrieval value from `a_expression_value'
		local
			l_int: INTEGER
		do
			if a_expression_value.is_boolean then
				create {IR_BOOLEAN_VALUE} Result.make (a_expression_value.as_boolean.item)
			elseif a_expression_value.is_integer then
				l_int := a_expression_value.as_integer.item
				create {IR_INTEGER_RANGE_VALUE} Result.make (l_int, l_int)
			elseif a_expression_value.is_any then
				create {IR_ANY_VALUE} Result.make
			elseif attached {EPA_NUMERIC_RANGE_VALUE} a_expression_value as l_range then
				create {IR_INTEGER_RANGE_VALUE} Result.make (l_range.lower, l_range.upper)
			elseif a_expression_value.is_any then
				create {IR_ANY_VALUE} Result.make
			end
		end

	field_name_for_term (a_term: SEM_TERM; a_type_form: INTEGER; a_meta: BOOLEAN): STRING
			-- Field name for `a_term' in `a_type_form'
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			create Result.make (128)
			Result.append (field_prefix_generator.term_prefix (a_term, a_type_form, a_meta))
			Result.append (encoded_field_string (a_term.field_content_in_type_form (a_type_form)))
		end

	final_occurrence_for_term (a_value: IR_VALUE; a_term: SEM_TERM): TUPLE [value: detachable IR_VALUE; occurrence: INTEGER]
			-- Final occurrence for `a_term'
		local
			l_occur: INTEGER
		do
			if a_term.is_negated then
				l_occur := a_term.occurrence
				if l_occur = term_occurrence_must then
					Result := [a_value, term_occurrence_must_not]
				elseif l_occur = term_occurrence_must_not then
					Result := [a_value, term_occurrence_must]
				elseif l_occur = term_occurrence_should then
					Result := [Void, l_occur]
				end
			else
				Result := [a_value, a_term.occurrence]
			end


		end

	document_type_term (a_queryable: SEM_QUERYABLE): IR_TERM
			-- Term which indicates the type of `a_queryable'		
		local
			l_value: STRING
		do
			if a_queryable.is_feature_call then
				l_value := transition_field_value
			elseif a_queryable.is_objects then
				l_value := object_field_value
			elseif a_queryable.is_snippet then
				l_value := snippet_field_value
			end
			create Result.make_as_string (document_type_field, l_value, default_boost_value, term_occurrence_must)
		end

end
