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

create
	make,
	make_from_function

feature{NONE} -- Initialization

	make (a_content: LINKED_LIST [G]; a_target_varaible_name: like target_variable_name; a_function_name: STRING; a_is_pre_state: BOOLEAN; a_context: like context)
			-- Initialize Current with `a_array'.
		local
			l_cursor: CURSOR
			l_hash_str: STRING
		do
			target_variable_name := a_target_varaible_name.twin
			is_pre_state := a_is_pre_state
			context := a_context
			function_name := a_function_name.twin

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

	make_from_function (a_function: CI_FUNCTION_WITH_INTEGER_DOMAIN; a_is_pre_state: BOOLEAN; a_content: lINKED_LIST [G])
			-- Initialize Current.
		do
			make (a_content, a_function.target_variable_name, a_function.function_name, a_is_pre_state, a_function.context)
		end

feature -- Access

	content: MML_FINITE_SEQUENCE [G]
			-- Content of current sequence

	target_variable_name: STRING
			-- Name of the target variable which Current represents

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

	context: EPA_CONTEXT
			-- Context in which Current exists

	hash_code: INTEGER
			-- Hash code value

feature -- Status

	is_pre_state: BOOLEAN
			-- Is current sequence evalauted in pre test case execution state?

	is_post_state: BOOLEAN
			-- Is current sequence evalauted in post test case execution state?
		do
			Result := not is_pre_state
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
			if is_pre_state then
				Result.append (ti_old_keyword)
				Result.append_character (' ')
			end
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
			Result.append (function_name)
		end

end
