note
	description: "Class to generate Solr field prefix for a term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FIELD_PREFIX_GENERATOR

inherit
	SEM_TERM_VISITOR

	SEM_CONSTANTS

feature -- Basic operations

	term_prefix (a_term: SEM_TERM; a_type_form: INTEGER; a_meta: BOOLEAN): STRING
			-- Prefix for `a_term' in `a_type_form'
			-- `a_meta' indicates if the returned prefix is for meta data field.
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			create last_prefix.make (9)
			last_type_form := a_type_form
			last_is_meta := a_meta
			a_term.process (Current)
			Result := last_prefix
		end

feature{NONE} -- Process

	last_prefix: STRING
			-- Last prefix

	last_type_form: INTEGER
			-- Last type form

	last_is_meta: BOOLEAN
			-- Last meta indicator

feature{NONE} -- Process

	append_position_1_2_prefix (a_type: TYPE_A)
			-- Append position 1 and position 2 prefix to `last_prefix'.
		do
				-- Append position 1 prefix.
			if last_is_meta then
				last_prefix.append (string_prefix)
			else
				if a_type.is_integer then
					last_prefix.append (integer_prefix)
				elseif a_type.is_boolean then
					last_prefix.append (boolean_prefix)
				else
					check other_type_not_supported: False end
				end
			end

				-- Append position 2 prefix.
			if last_type_form = dynamic_type_form then
				last_prefix.append (dynamic_type_form_prefix)
			elseif last_type_form = static_type_form then
				last_prefix.append (static_type_form_prefix)
			elseif last_type_form = anonymous_type_form then
				last_prefix.append (anonymous_type_form_prefix)
			end
		end

	process_change_term (a_term: SEM_CHANGE_TERM)
			-- Process `a_term'.
		do
			append_position_1_2_prefix (a_term.type)

				-- Append position 3 prefix.
			if a_term.is_relative then
				last_prefix.append (by_change_prefix)
			elseif a_term.is_absolute then
				last_prefix.append (to_change_prefix)
			end
		end

	process_contract_term (a_term: SEM_CONTRACT_TERM)
			-- Process `a_term'.
		do
			append_position_1_2_prefix (a_term.type)

				-- Append position 3 prefix.
			if a_term.is_precondition then
				last_prefix.append (precondition_prefix)
			elseif a_term.is_postcondition then
				last_prefix.append (postcondition_prefix)
			end
		end

	process_property_term (a_term: SEM_PROPERTY_TERM)
			-- Process `a_term'.
		do
			append_position_1_2_prefix (a_term.type)

				-- Append position 3 prefix.
			last_prefix.append (property_prefix)
		end

	process_variable_term (a_term: SEM_VARIABLE_TERM)
			-- Process `a_term'.
		do
			-- Do nothing
		end

end
