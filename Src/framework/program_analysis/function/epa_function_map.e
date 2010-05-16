note
	description: "Class that represents argument(s) to value mapping for functions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_MAP

inherit
	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make (a_function: like function)
			-- Initialize current.
		do
			function := a_function
		ensure
			function_set: function = a_function
		end

feature -- Access

	function: EPA_FUNCTION
			-- Function whose argument(s) to value map that current represents


	map: DS_LINKED_LIST [TUPLE [arguments: DS_ARRAYED_LIST [EPA_EXPRESSION_VALUE]; value: EPA_EXPRESSION_VALUE]]
			-- List of argument(s) to value pairs
			-- `arguments' is a list of arguments (the first element is the first argument, and so on).
			-- `value' is the value 'of `function' when applied with `arguments'.

	values: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION_VALUE], INTEGER]
			-- Values for the i-th argument (including result)
			-- Key is the argument (including result) position, 1 for the first argument,
			-- arity+1 for the result.
			-- Value is a set of values that argument (including result) can have according to `map'.
			-- Note: Create a new hash-table every time when this feature is called.
		local
			i: INTEGER
			l_arg_count: INTEGER
			l_value_set: DS_HASH_SET [EPA_EXPRESSION_VALUE]
			l_cursor: DS_LINKED_LIST_CURSOR [TUPLE [arguments: DS_ARRAYED_LIST [EPA_EXPRESSION_VALUE]; value: EPA_EXPRESSION_VALUE]]
			l_arguments: DS_ARRAYED_LIST [EPA_EXPRESSION_VALUE]
			l_value: EPA_EXPRESSION_VALUE
		do
				-- Setup empty values for each argument (including result).
			l_arg_count := function.arity + 1
			create Result.make (l_arg_count)
			from
				i := 1
			until
				i > l_arg_count
			loop
				create l_value_set.make (10)
				l_value_set.set_equality_tester (expression_value_equality_tester)
				i := i + 1
				Result.put (l_value_set, i)
			end

				-- Populate Result with values in `map'.
			from
				l_cursor := map.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_arguments := l_cursor.item.arguments
				l_value := l_cursor.item.value
				l_arguments.do_all_with_index (
					agent (a_arg: EPA_EXPRESSION_VALUE; a_index: INTEGER; a_sets: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION_VALUE], INTEGER])
						do
							a_sets.item (a_index).force_last (a_arg)
						end (?, ?, Result))
				Result.item (l_arg_count).force_last (l_value)
				l_cursor.forth
			end
		end

	projected (a_position: INTEGER; a_values: DS_HASH_SET [EPA_EXPRESSION_VALUE]): like Current
			-- Projected function mapping.
			-- The projection is done at the `a_position'-th position (1 for the first argument, arity+1 for the result),
			-- with only the values in `a_values'. For example, if the function {1}.has ({2}) has the following mappings:
			-- v1.has (o1)
			-- v1.has (o2)
			-- v1.has (o3)
			-- The projection at position 2 with values {o1, o2} will result in the following mapping:
			-- v1.has (o1)
			-- v1.has (o2)
		require
			a_position_valid: a_position >= 1 and then a_position <= function.arity + 1
		local
			l_new_map: like map
			l_cursor: DS_LINKED_LIST_CURSOR [TUPLE [arguments: DS_ARRAYED_LIST [EPA_EXPRESSION_VALUE]; value: EPA_EXPRESSION_VALUE]]
			l_arguments: DS_ARRAYED_LIST [EPA_EXPRESSION_VALUE]
			l_value: EPA_EXPRESSION_VALUE
			l_arg_count: INTEGER
			l_should_include: BOOLEAN
		do
			create l_new_map.make
			from
				l_arg_count := function.arity + 1
				l_cursor := map.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_arguments := l_cursor.item.arguments
				l_value := l_cursor.item.value
				if a_position = l_arg_count then
						-- Check result value.
					l_should_include := a_values.has (l_value)
				else
						-- Check argument value.
					l_should_include := a_values.has (l_arguments.item (a_position))
				end

				if l_should_include then
					l_new_map.force_last ([l_arguments.twin, l_value])
				end
				l_cursor.forth
			end
			create Result.make (function)
			set_map (l_new_map)
		end

feature -- Setting

	set_map (a_map: like map)
			-- Set `map' with `a_map'.
		do
			map := a_map
		ensure
			map_set: map = a_map
		end
end
