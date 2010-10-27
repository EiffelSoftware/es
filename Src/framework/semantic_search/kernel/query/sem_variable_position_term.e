note
	description: "Class that represents a variable position term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_VARIABLE_POSITION_TERM

inherit
	SEM_TERM
		redefine
			is_variable_position
		end

	SEM_FIELD_NAMES

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable; a_variable: EPA_EXPRESSION; a_position: like position)
			-- Initialize Current.
		do
			initialize
			queryable := a_queryable
			variable := a_variable
			position := a_position
		end

feature -- Access

	variable: EPA_EXPRESSION
			-- Expression of current variable

	type: TYPE_A
			-- Type of current variable
		do
			Result := variable.type
		end

	position: SEM_TRANSITION_VARIABLE_POSITION
			-- Position of `variable'

	text: STRING
			-- Text representation of Current
		do
			create Result.make (128)
			Result.append (once "Variable ")
			Result.append (variable.text)
			Result.append (once ": ")
			Result.append (type.name)
			Result.append (once " at ")
			if position.is_unspecified then
				if position.is_argument then
					Result.append (once "some argument")
				elseif position.is_operand then
					Result.append (once "some operand")
				elseif position.is_interface then
					Result.append (once "some interface variable position")
				end
			else
				if position.is_target then
					Result.append (once "target")
				elseif position.is_result then
					Result.append (once "result")
				elseif position.is_argument then
					Result.append (position.position.out)
					Result.append (once "-th argument")
				end
			end
		end

	field_content_in_static_type_form: STRING
			-- Text of current term in static type form
		do
			Result := category (position)
		end

	field_content_in_dynamic_type_form: STRING
			-- Text of current term in static type form
		do
			Result := category (position)
		end

	field_content_in_anonymous_type_form: STRING
			-- Text of current term in static type form
		do
			Result := field_content_in_static_type_form
		end

	operands: ARRAYED_LIST [INTEGER]
			-- Indexes of operands in Current term
		do
			create Result.make (3)
			Result.extend (queryable.variable_position (variable))
		end

feature -- Status report

	is_variable_position: BOOLEAN = True
			-- Is current a variable position term?

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_variable_position_term (Current)
		end

feature{NONE} -- Implementation

	category (a_position: SEM_TRANSITION_VARIABLE_POSITION): STRING
			-- Category of `a_position'
		do
			if a_position.is_unspecified then
				if a_position.is_argument then
					Result := argument_variable_short
				elseif a_position.is_operand then
					Result := operand_variable_short
				elseif a_position.is_interface then
					Result := interface_variable_short
				end
			else
				if a_position.is_target then
					Result := target_varaible_short
				elseif a_position.is_argument then
					create Result.make (5)
					Result.append (one_argument_variable_short)
					Result.append_character ('_')
					Result.append_integer (a_position.position)
				elseif a_position.is_result then
					Result := result_varaible_short
				end
			end
		end

end
