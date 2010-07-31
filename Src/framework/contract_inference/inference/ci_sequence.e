note
	description: "Sequence used in contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEQUENCE [G]

inherit
	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

	SHARED_TEXT_ITEMS
		undefine
			out
		end

	SHARED_TEXT_ITEMS
		undefine
			out
		end

	EPA_STRING_UTILITY
		undefine
			out
		end

create
	make,
	make_from_function

convert
	content: {MML_FINITE_SEQUENCE [G]}

feature{NONE} -- Initialization

	make (a_content: LINKED_LIST [G]; a_target_varaible_name: like target_variable_name; a_function_name: STRING; a_function_type: TYPE_A; a_context: like context; a_count_expressions_name: STRING; a_target_variable_position: INTEGER; a_lower_bound_expr, a_upper_bound_expr: STRING)
			-- Initialize Current with `a_array'.
		local
			l_cursor: CURSOR
			l_hash_str: STRING
		do
			target_variable_name := a_target_varaible_name.twin
			context := a_context
			count_expressions_name := a_count_expressions_name.twin
			create signature.make (a_target_variable_position, a_function_name, a_function_type, a_lower_bound_expr, a_upper_bound_expr)

				-- Initialize `content'.
			create l_hash_str.make (64)
			create content.empty
			l_cursor := a_content.cursor
			from
				a_content.start
			until
				a_content.after
			loop
				content := content.extended (a_content.item_for_iteration)
				l_hash_str.append (a_content.item_for_iteration.out)
				l_hash_str.append_character ('.')
				a_content.forth
			end
			a_content.go_to (l_cursor)
			hash_code := l_hash_str.hash_code
		end

	make_from_function (a_function: CI_FUNCTION_WITH_INTEGER_DOMAIN; a_count_expressions_name: STRING; a_content: LINKED_LIST [G]; a_target_variable_position: INTEGER; a_lower_bound_expr, a_upper_bound_expr: detachable STRING)
			-- Initialize Current.
		do
			make (a_content, a_function.target_variable_name, a_function.function_name, a_function.result_type, a_function.context, a_count_expressions_name, a_target_variable_position, a_lower_bound_expr, a_upper_bound_expr)
		end

feature -- Access

	signature: CI_SEQUENCE_SIGNATURE
			-- Signature of current

	content: MML_FINITE_SEQUENCE [G]
			-- Content of current sequence

	target_variable_name: STRING
			-- Name of the target variable which Current represents

	target_variable_index: INTEGER
			-- 0-based operand position of `target_variable_name'
		do
			Result := signature.target_variable_index
		end

	target_variable_type: TYPE_A
			-- Type of the target varaible
		do
			Result := context.variable_type (target_variable_name)
		end

	target_variable_class: CLASS_C
			-- Class of target variable
		do
			Result := context.variable_class (target_variable_name)
			check Result /= Void end
		end

	function_name: STRING
			-- Name of the function whose range forms the elements in `content'
		do
			Result := signature.function_name
		end

	function_type: TYPE_A
			-- Type of `function_name'
		do
			Result := signature.function_type
		end

	context: EPA_CONTEXT
			-- Context in which Current exists

	hash_code: INTEGER
			-- Hash code value

	count_expressions_name: STRING
			-- Name of the expression on `target_variable_name' to get the count of current sequence
			-- Format: surpose `target_variable_name' is v_1, then: v_1.count + 1, or v_1.count.

	lower_bound_expression: detachable STRING
			-- Expression to get lower bound
		do
			Result := signature.lower_bound_expression
		end

	upper_bound_expression: detachable STRING
			-- Expression to get upper bound
		do
			Result := signature.upper_bound_expression
		end

feature -- Status

	is_special: BOOLEAN
			-- Is current sequence special?
			-- A sequence is special if and only if it is made out of
			-- a single element.
		do
			Result := function_name ~ ti_current
		end

	is_model_equal alias "|=|" (other: like Current): BOOLEAN
			-- Is this model mathematically equal to `other'?
		do
			Result := content |=| other.content
		end

feature -- Status report

	out, debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		local
			i: INTEGER
			l_content: like content
			l_count: INTEGER
		do
			create Result.make (128)
			Result.append_character ('[')

			l_content := content
			from
				i := 1
				l_count := l_content.count
			until
				i > l_count
			loop
				Result.append (l_content.item (i).out)
				if i < l_count then
					Result.append (once ", ")
				end
				i := i + 1
			end
			Result.append (once "] @ ")
			Result.append (curly_brace_surrounded_integer (signature.target_variable_index))
			Result.append_character ('.')
			Result.append (function_name)
		end

end
