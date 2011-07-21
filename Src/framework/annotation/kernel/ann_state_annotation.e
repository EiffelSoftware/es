note
	description: "[
		Annotation that represents state information
		Note: This class should be treated as immutable class.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_STATE_ANNOTATION

inherit
	ANN_ANNOTATION

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_UTILITY

create
	make,
	make_with_single_breakpoint,
	make_as_precondition,
	make_as_postcondition

feature{NONE} -- Initialization

	make (a_breakpoints: like breakpoints; a_property: like property; a_is_pre_state: BOOLEAN; a_confidence: DOUBLE)
			-- Initialize Current.
		require
			a_breakpoints_not_empty: not a_breakpoints.is_empty
			a_property_not_is_empty: not a_property.is_empty
			a_confidence_valid: a_confidence >= 0.0 and a_confidence <= 1.0
		do
			a_breakpoints.do_all (agent breakpoints.force_last)
			property := a_property.twin
			is_pre_state := a_is_pre_state
			hash_code := debug_output.hash_code
		end

	make_with_single_breakpoint (a_breakpoint: INTEGER; a_property: STRING; a_is_pre_state: BOOLEAN; a_confidence: DOUBLE)
			-- Initialize Current.
		require
			a_property_not_is_empty: not a_property.is_empty
			a_confidence_valid: a_confidence >= 0.0 and a_confidence <= 1.0
		do
			breakpoints.force_last (a_breakpoint)
			property := a_property.twin
			is_pre_state := a_is_pre_state
			hash_code := debug_output.hash_code
		end

	make_as_precondition (a_breakpoint: INTEGER; a_property: STRING)
			-- Initialize Current as a precondition annotation.
		do
			make_with_single_breakpoint (a_breakpoint, a_property, True, 1.0)
		end

	make_as_postcondition (a_breakpoint: INTEGER; a_property: STRING)
			-- Initialize Current as a postcondition annotation.
		do
			make_with_single_breakpoint (a_breakpoint, a_property, False, 1.0)
		end

feature -- Status report

	is_pre_state: BOOLEAN
			-- Is current annotation in pre-state?

feature -- Access

	property: STRING
			-- Property of current annotation
			-- This must be a valid Eiffel expression with boolean type

	hash_code: INTEGER
			-- Hash code value

	ast_of_property: EXPR_AS
			-- AST representtion of `property'
		do
			Result := ast_from_expression_text (property)
		end

	text_of_property: STRING
			-- Text of `property' with pre/post state modifier
		do
			create Result.make (property.count + 13)
			if is_pre_state then
				Result.append (once "Pre-state: ")
			else
				Result.append (once "Post-state: ")
			end
			Result.append (property)
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (256
			)
			Result.append (once "Breakpoints: ")
			Result.append (breakpoints_as_string (breakpoints))
			Result.append_character (':')
			Result.append_character (' ')
			Result.append (text_of_property)
			Result.append_character ('%N')
		end

	confidence: DOUBLE
			-- Confidence of this annotation

invariant
	confidence_valid: confidence >= 0.0 and confidence <= 1.0

end
