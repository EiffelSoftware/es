note
	description: "Class that represents a term consisting of an equation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_EQUATION_TERM

inherit
	SEM_TERM

	REFACTORING_HELPER

	EPA_TYPE_UTILITY

	SEM_UTILITY

	SEM_FIELD_NAMES

create
	make

feature{NONE} -- Initialization

	make (a_prefix: STRING; a_equation: like equation; a_context: like context)
			-- Initialize Current.
			-- Set `field_prefix' with `a_prefix', make a copy of `a_prefix'.
		require
			a_prefix_valid: is_valid_field_prefix (a_prefix)
			a_equation_valid: a_equation.class_ = a_context.class_ and a_equation.feature_ = a_context.feature_
		local
			l_type_name_tbl: HASH_TABLE [STRING, STRING]
		do
			context := a_context
			equation := a_equation
			field_prefix := a_prefix.twin
			l_type_name_tbl := context.variable_type_name_table
			create field_name_internal.make (a_equation.text.count + 10)
			field_name_internal.append (field_prefix)
			field_name_internal.append (expression_rewriter.expression_text (equation.expression, l_type_name_tbl))
			value_internal := expression_rewriter.expression_value_text (equation.value, l_type_name_tbl)
		end

feature -- Access

	field_prefix: STRING
			-- Prefix of field name

	field_name: STRING
			-- Field name of current term
		do
			Result := field_name_internal
		end

	value: STRING
			-- Value of current term
		do
			Result := value_internal
		end

	equation: EPA_EQUATION
			-- Equation of current term

feature{NONE} -- Implementation

	field_name_internal: like field_name
			-- Cache for `field_name'

	value_internal: like value
			-- Cache for `value'

end
