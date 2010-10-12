note
	description: "Class to generate a field in Solr query syntax"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_SOLR_QUERY_FIELD_SYNTAX_GENERATOR

inherit
	IR_TERM_VALUE_VISITOR

	REFACTORING_HELPER

	IR_TERM_OCCURRENCE

feature -- Access

	field_syntax (a_term: IR_TERM): STRING
			-- Field syntax for `a_term'
		do
				-- Add term occurrence flag.
			create last_field_syntax.make (128)
			if a_term.occurrence = term_occurrence_must then
				last_field_syntax.append_character ('+')
			elseif a_term.occurrence = term_occurrence_must_not then
				last_field_syntax.append_character ('-')
			end

				-- Add field name.
			last_field_syntax.append (a_term.field_name)
			last_field_syntax.append_character (':')
			last_field_syntax.append_character (' ')

				-- Add field value.
			a_term.value.process (Current)

			Result := last_field_syntax
		end

feature{NONE} -- Implementation

	last_field_syntax: STRING
			-- Last generated field syntax

feature{NONE} -- Process

	process_boolean_term_value (a_value: IR_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
			if a_value.item then
				last_field_syntax.append_character ('T')
			else
				last_field_syntax.append_character ('F')
			end
		end

	process_integer_term_value (a_value: IR_INTEGER_VALUE)
			-- Process `a_value'.
		do
			last_field_syntax.append (a_value.item.out)
		end

	process_string_term_value (a_value: IR_STRING_VALUE)
			-- Process `a_value'.
		do
			last_field_syntax.append (a_value.item)
		end

	process_integer_range_term_value (a_value: IR_INTEGER_RANGE_VALUE)
			-- Process `a_value'.
		do
			last_field_syntax.append_character ('[')
			last_field_syntax.append (a_value.lower.out)
			last_field_syntax.append (once " TO ")
			last_field_syntax.append (a_value.upper.out)
			last_field_syntax.append_character (']')
		end

	process_double_term_value (a_value: IR_DOUBLE_VALUE)
			-- Process `a_value'.
		do
			last_field_syntax.append (a_value.item.out)
		end

end
