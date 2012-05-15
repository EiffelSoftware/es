note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_FACTORY

inherit

	IV_SHARED_TYPES
		rename
			equal as any_equal
		end

	E2B_SHARED_CONTEXT
		rename
			equal as any_equal
		export
			{NONE} all
		end

feature -- Values

	false_: IV_VALUE
			-- Value for constant `false'.
		do
			create Result.make ("false", types.bool)
		end

	true_: IV_VALUE
			-- Value for constant `true'.
		do
			create Result.make ("true", types.bool)
		end

	void_: IV_VALUE
			-- Value for constant `Void'.
		do
			create Result.make ("Void", types.ref)
		end

	int_value (a_value: INTEGER): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (a_value.out, types.int)
		end

	int64_value (a_value: INTEGER_64): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (a_value.out, types.int)
		end

	type_value (a_value: TYPE_A): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (name_translator.boogie_name_for_type (a_value), types.type)
		end

feature -- Boolean operators

	or_ (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Or operator `||'.
		do
			create Result.make (a_left, "||", a_right, types.bool)
		end

	and_ (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- And operator `&&'.
		do
			create Result.make (a_left, "&&", a_right, types.bool)
		end

	implies_ (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Implies operator `==>'.
		do
			create Result.make (a_left, "==>", a_right, types.bool)
		end

	not_ (a_expr: IV_EXPRESSION): IV_UNARY_OPERATION
			-- Not operator `!'.
		do
			create Result.make ("!", a_expr, types.bool)
		end

feature -- Operators

	equal (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Equal operator `=='.
		do
			create Result.make (a_left, "==", a_right, types.bool)
		end

	not_equal (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Not equal operator `!='.
		do
			create Result.make (a_left, "!=", a_right, types.bool)
		end

	less_equal (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Less than or equal operator `<='.
		do
			create Result.make (a_left, "<=", a_right, types.bool)
		end

	less (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Less than operator `<'.
		do
			create Result.make (a_left, "<", a_right, types.bool)
		end

	sub_type (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Less than operator `<:'.
		do
			create Result.make (a_left, "<:", a_right, types.bool)
		end

feature -- Functions

	type_of (a_arg: IV_EXPRESSION): IV_FUNCTION_CALL
			-- Function call `type_of (a_arg)'.
		do
			create Result.make ("type_of", types.type)
			Result.add_argument (a_arg)
		end

	old_ (a_arg: IV_EXPRESSION): IV_FUNCTION_CALL
			-- Function call `old (a_arg)'.
		do
			create Result.make ("old", a_arg.type)
			Result.add_argument (a_arg)
		end

feature -- Miscellaneous

	trace (a_text: STRING): IV_STATEMENT
			-- Tracing statement.
		local
			l_assume: IV_ASSUME
		do
			create l_assume.make (true_)
			l_assume.set_attribute_string (":captureState %"" + a_text + "%"")
			Result := l_assume
		end

end
