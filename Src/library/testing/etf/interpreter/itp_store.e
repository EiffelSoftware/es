note
	description: "[
		Object store for interpreter
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_STORE

inherit
	REFACTORING_HELPER

create

	make

feature {NONE} -- Initialization

	make
			-- Create new store
		do
			create storage.make_filled (Void, 1, default_capacity)
			create storage_flag.make_filled (False, 1, default_capacity)
			create typed_storage.make (initial_capacity)
			create internal
		end

feature -- Status report

	is_variable_defined (a_index: INTEGER): BOOLEAN
			-- Is the slot at position `a_index' used for store some (possibly Void) variable?
		require
			a_index_positive: a_index > 0
		do
			Result := a_index <= storage_flag.count and then storage_flag.item (a_index)
		ensure
			good_result: Result = (a_index <= storage_flag.count) and then storage_flag.item (a_index)
		end

	is_expression_defined (an_expression: ITP_EXPRESSION): BOOLEAN
			-- Is expression defined in the context of this store? An
			-- expression is defined iff it is a constant or a variable
			-- which is defined in this store.
		require
			an_expression_not_void: an_expression /= Void
		do
			if attached {ITP_VARIABLE} an_expression as l_variable then
				Result := is_variable_defined (l_variable.index)
			else
				Result := True
			end
		end

	is_typed_search_enabled: BOOLEAN
			-- Should Type information of all variables be stored so
			-- a fast search from an variable to its index is possible?
			-- Default: False

feature -- Access

	variable_value (a_index: INTEGER): detachable ANY
			-- Value of variable at index `a_index'
		require
			a_index_large_enough: a_index > 0
			a_index_valid: is_variable_defined (a_index)
		do
			Result := storage.item (a_index)
		ensure
			good_result: Result = storage.item (a_index)
		end

	expression_value (an_expression: ITP_EXPRESSION): detachable ANY
			-- Value of expression `an_expression' in the context of this store.
		require
			an_expression_not_void: an_expression /= Void
			an_expression_defined: is_expression_defined (an_expression)
		do
			if attached {ITP_VARIABLE} an_expression as l_variable then
				Result := variable_value (l_variable.index)
			elseif attached {ITP_CONSTANT} an_expression as l_constant then
				Result := l_constant.value
			else
				check
					type_not_supported: False
				end
			end
		end

feature -- Basic routines

	assign_value (a_value: detachable ANY; a_index: INTEGER)
			-- Assign the value `a_value' to variable named `a_name'.
		require
			a_index_large_enough: a_index > 0
		local
			l_storage: like storage
			l_flag: like storage_flag
			l_capacity: INTEGER
			l_type: INTEGER
			l_list: ARRAYED_LIST [TUPLE [index: INTEGER; object: detachable ANY]]
			l_tbl: like typed_storage
		do
			l_storage := storage
			l_flag := storage_flag
			l_capacity := l_storage.capacity

				-- Resize storage if needed.
			if a_index > l_capacity then
				l_storage.grow (l_capacity + l_capacity.to_integer // 4)
				l_flag.grow (l_capacity + l_capacity.to_integer // 4)
			end

			l_storage.put (a_value, a_index)
			l_flag.put (True, a_index)

				-- Only can store dynamic type information if the variable is not Void.
			if a_value /= Void and then is_typed_search_enabled then
				l_type := internal.dynamic_type (a_value)
				l_tbl := typed_storage
				l_tbl.search (l_type)
				if l_tbl.found then
					l_list := l_tbl.found_item
				else
					create l_list.make (initial_capacity)
					l_tbl.put (l_list, l_type)
				end
				if l_list.count = l_list.capacity then
					l_list.resize (l_list.count + l_list.count // 4)
				end
				l_list.extend ([a_index, a_value])
			end
		ensure
			a_value_assigned: storage.item (a_index) = a_value
			variable_defined: is_variable_defined (a_index)
		end

	assign_expression (an_expression: ITP_EXPRESSION; a_index: INTEGER)
			-- Assign the value of expression `an_expression' to variable at index `a_index'.
		require
			an_expression_not_void: an_expression /= Void
			an_expression_defined: is_expression_defined (an_expression)
			a_index_large_enough: a_index > 0
		do
			assign_value (expression_value (an_expression), a_index)
		ensure
			variable_defined: is_variable_defined (a_index)
		end

	arguments (an_expression_list: ARRAY [ITP_EXPRESSION]): detachable ARRAY [detachable ANY]
			-- Arguments with the values from `an_expression_list'
			-- using `variables' to lookup variable values or `Void'
			-- in case of an error
		require
			an_expression_list_not_void: an_expression_list /= Void
		local
			i: INTEGER
			count: INTEGER
			expression: detachable ITP_EXPRESSION
		do
			from
				count := an_expression_list.count
				create Result.make_filled (False, 1, count)
				i := 1
			until
				i > count or Result = Void
			loop
				expression := an_expression_list.item (i)
				if expression = Void or else not is_expression_defined (expression) then
					Result := Void
				else
					Result.put (expression_value (expression), i)
					i := i + 1
				end
			end
		end

	variable_index (a_object: detachable ANY): INTEGER
			-- Index of `a_object'
			-- 0  if `a_object' is Void,
			-- -1 if `a_object' does not exist in storage.
		local
			l_dyn_type: INTEGER
			l_typed_storage: like typed_storage
			l_list: ARRAYED_LIST [TUPLE [index: INTEGER; object: detachable ANY]]
			l_cursor: CURSOR
		do
			if a_object /= Void then
				l_dyn_type := internal.dynamic_type (a_object)
				l_typed_storage := typed_storage
				l_typed_storage.search (l_dyn_type)
				if l_typed_storage.found then
					l_list := l_typed_storage.found_item
					l_cursor := l_list.cursor
					from
						l_list.start
					until
						l_list.after or else Result > 0
					loop
						if l_list.item.object = a_object then
							Result := l_list.item.index
						end
						l_list.forth
					end
					l_list.go_to (l_cursor)
				else
					Result := -1
				end
			end
		end

feature -- Setting

	set_is_typed_search_enabled (b: BOOLEAN)
			-- Set `is_typed_search_enabled' with `b'.
		do
			is_typed_search_enabled := b
		ensure
			is_typed_search_enabled_set: is_typed_search_enabled = b
		end

feature {NONE} -- Implementation

	storage: ARRAY [detachable ANY]
			-- Variables and their attached values

	storage_flag: ARRAY [BOOLEAN]
			-- Flag to decide if an object at index is defined.

	default_capacity: INTEGER = 1000
			-- Default capacity for `storage' and `storage_flag'.

	typed_storage: HASH_TABLE [ARRAYED_LIST [TUPLE [index: INTEGER; object: detachable ANY]], INTEGER]
			-- Storage for variables which support (relatively) fast lookup using dyanmic type ID of a variable.
			-- This is used to look for the ID of a variable.
			-- Key is a dynamic type ID, value is a list of variables of that dynamic type with their variable IDs.

	internal: INTERNAL
			-- Internal class used to get type ID of an object

	initial_capacity: INTEGER is 200
			-- Initial capacity for some storage

invariant
	storage_attached: storage /= Void
	storage_flag_attached: storage_flag /= Void
	storage_count_same_as_storage_flag_count: storage.count = storage_flag.count

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
