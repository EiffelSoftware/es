note
	description: "Class that represents argument(s) to value mapping for functions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_VALUATIONS

inherit
	EPA_SHARED_EQUALITY_TESTERS

	DEBUG_OUTPUT

	EPA_CONSTANTS

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

	map: DS_HASH_SET [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
			-- List of argument(s) to value mappings

	cloned: like Current
			-- Cloned current
		local
			l_new_map: like map
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
		do
			create Result.make (function)
			create l_new_map.make (map.count)
			l_new_map.set_equality_tester (map.equality_tester)
			from
				l_cursor := map.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_new_map.force_last (l_cursor.item.cloned)
				l_cursor.forth
			end

			Result.set_map (l_new_map)
		end

	values: DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], INTEGER]
			-- Values for the i-th argument (including result)
			-- Key is the argument (including result) position, 1 for the first argument,
			-- arity+1 for the result.
			-- Value is a set of values that argument (including result) can have according to `map'.
			-- Note: Create a new hash-table every time when this feature is called.
		local
			i: INTEGER
			l_arg_count: INTEGER
			l_value_set: DS_HASH_SET [EPA_FUNCTION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
			l_arguments: DS_ARRAYED_LIST [EPA_FUNCTION]
			l_value: EPA_FUNCTION
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
				l_value_set.set_equality_tester (function_equality_tester)
				Result.put (l_value_set, i)
				i := i + 1
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
					agent (a_arg: EPA_FUNCTION; a_index: INTEGER; a_sets: DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], INTEGER])
						do
							a_sets.item (a_index).force_last (a_arg)
						end (?, ?, Result))
				Result.item (l_arg_count).force_last (l_value)
				l_cursor.forth
			end
		end

	projected (a_position: INTEGER; a_values: DS_HASH_SET [EPA_FUNCTION]): like Current
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
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
			l_arguments: DS_ARRAYED_LIST [EPA_FUNCTION]
			l_value: EPA_FUNCTION
			l_arg_count: INTEGER
			l_should_include: BOOLEAN
		do
			create l_new_map.make (map.count)
			l_new_map.set_equality_tester (function_argument_value_map_equality_tester)
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
					l_new_map.force_last (create {EPA_FUNCTION_ARGUMENT_VALUE_MAP}.make (l_arguments.twin, l_value, function))
				end
				l_cursor.forth
			end
			create Result.make (function)
			Result.set_map (l_new_map)
		end

	partially_evaluated (a_argument_index: INTEGER): like Current
			-- Partially evaluated mapping on argument with at position `a_argument_index'
			-- This is only possible if there is only one value in `map' for that argument.
		require
			a_argument_index_valid: a_argument_index >= 1 and then a_argument_index <= function.arity
			only_one_value_for_argument: values.item (a_argument_index).count = 1
		local
			l_values: like values
			l_value: EPA_FUNCTION
			l_new_func: like function
			l_new_map: like map
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
			l_args: DS_ARRAYED_LIST [EPA_FUNCTION]
		do
				-- Create new partially evaluated function.
			l_values := values
			l_value := l_values.item (a_argument_index).first
			l_new_func := function.partially_evalauted (l_value, a_argument_index)

				-- Create partially evaluated map.
			create l_new_map.make (map.count)
			from
				l_cursor := map.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_args := l_cursor.item.arguments.twin
				l_args.remove (a_argument_index)
				l_value := l_cursor.item.value
				l_new_map.force_last (create {EPA_FUNCTION_ARGUMENT_VALUE_MAP}.make (l_args, l_value, l_new_func))
				l_cursor.forth
			end

				-- Fabricate final Result.
			create Result.make (l_new_func)
			Result.set_map (l_new_map)
		end

feature -- Status report

	has_nondeterministic_value (a_valuation: EPA_FUNCTION_ARGUMENT_VALUE_MAP): BOOLEAN
			-- Does `a_valuation' contain same arguments in `map' but different value?
		do
			Result :=
				map.there_exists (
					agent (a_map, b_map: EPA_FUNCTION_ARGUMENT_VALUE_MAP): BOOLEAN
						do
							Result :=
								a_map.arguments.is_equal (b_map.arguments) and then
								not function_equality_tester.test (a_map.value, b_map.value)
						end (?, a_valuation))
		end

	has_nonsensical_in_result: BOOLEAN
			-- Does "nonsensical" exist as a value in result of curent valuation?
		do
			Result :=
				map.there_exists (
					agent (a_map: EPA_FUNCTION_ARGUMENT_VALUE_MAP): BOOLEAN
						do
							Result := a_map.value.body ~ nonsensical_value
						end)
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (128)
			Result.append (function.debug_output)
			Result.append_character ('%N')

			map.do_all (
				agent (a_map: EPA_FUNCTION_ARGUMENT_VALUE_MAP; a_str: STRING)
					do
						a_str.append (a_map.debug_output)
						a_str.append_character ('%N')
					end (?, Result))
		end

feature -- Setting

	set_map (a_map: like map)
			-- Set `map' with `a_map'.
		require
			a_map_valid: a_map.equality_tester = function_argument_value_map_equality_tester
		do
			map := a_map
		ensure
			map_set: map = a_map
		end

feature -- Basic operations

	merge (other: like Current)
			-- Merge `other'.`map' into Current.
			-- Leave `other' unchanged.
		require
			same_function: function_equality_tester.test (function, other.function)
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
			l_map: like map
			l_valuation: EPA_FUNCTION_ARGUMENT_VALUE_MAP
		do
			l_map := map
			from
				l_cursor := other.map.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_valuation := l_cursor.item
				if not l_map.has (l_valuation) and then not has_nondeterministic_value (l_valuation) then
					l_map.force_last (l_valuation.cloned)
				end
				l_cursor.forth
			end
		end

end
