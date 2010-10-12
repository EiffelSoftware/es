note
	description: "Class that represents a searchable term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TERM

inherit
	SEM_CONSTANTS

	DEBUG_OUTPUT

feature -- Access

	occurrence: INTEGER
			-- Occurrence flag for this term
			-- Check `is_valid_occurrence' for valid values.
			-- Default: `term_occurrence_should'

	boost: DOUBLE
			-- Boost value of for this term
			-- Default: `default_boost_value'

	queryable: SEM_QUERYABLE
			-- Queryable where current term is from

	text: STRING
			-- Text representation of Current
		deferred
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

	field_content_in_static_type_form: STRING
			-- Text of current term in static type form
		deferred
		end

	field_content_in_dynamic_type_form: STRING
			-- Text of current term in static type form
		deferred
		end

	field_content_in_anonymous_type_form: STRING
			-- Text of current term in static type form
		deferred
		end

	field_content_in_type_form (a_type_form: INTEGER): STRING
			-- Text of current term in `a_type_form'
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			if a_type_form = dynamic_type_form then
				Result := field_content_in_dynamic_type_form
			elseif a_type_form = static_type_form then
				Result := field_content_in_static_type_form
			elseif a_type_form = anonymous_type_form then
				Result := field_content_in_anonymous_type_form
			end
		end

	operands: LINKED_LIST [INTEGER]
			-- Indexes of operands in Current term
		deferred
		end

feature -- Status report

	is_contract: BOOLEAN
			-- Is current a contract term?
		do
		end

	is_precondition: BOOLEAN
			-- Is current a precondition term?
		do
		end

	is_postcondition: BOOLEAN
			-- Is current a postcondition term?
		do
		end

	is_human_written: BOOLEAN
			-- Is current a contract term and that contract is human-written?
		do
		end


	is_change: BOOLEAN
			-- Is current a term for a change?
		do
		end

	is_property: BOOLEAN
			-- Is current a property term (for objects)?
		do
		end

	is_variable: BOOLEAN
			-- Is current a variable term?
		do
		end

feature -- Setting

	set_occurrence (a_occurrence: INTEGER)
			-- Set `occurrence' with `a_occurrence'.
		require
			a_occurrence_valid: is_term_occurrence_valid (a_occurrence)
		do
			occurrence := a_occurrence
		ensure
			occurrence_set: occurrence = a_occurrence
		end

feature{NONE} -- Implementation

	initialize
			-- Initialize.
		do
			occurrence := term_occurrence_should
			boost := default_boost_value
		end

	operand_indexes (a_anonymous_form: STRING): LINKED_LIST [INTEGER]
			-- Operand indexes from `a_anonymous_form'
		local
			i: INTEGER
			c: INTEGER
			l_index: STRING
			l_char: CHARACTER
			l_in: BOOLEAN
		do
			create Result.make
			create l_index.make (5)
			from
				i := 1
				c := a_anonymous_form.count
			until
				i > c
			loop
				l_char := a_anonymous_form.item (i)
				if l_char = '{' then
					l_in := True
					l_index.wipe_out
				elseif l_char = '}' then
					Result.extend (l_index.to_integer)
					l_in := False
				elseif l_in then
					l_index.extend (l_char)
				end
				i := i + 1
			end
		end

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

invariant
	occurrence_valid: is_term_occurrence_valid (occurrence)

end
