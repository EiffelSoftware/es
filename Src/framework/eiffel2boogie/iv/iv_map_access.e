note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_MAP_ACCESS

inherit

	IV_EXPRESSION
		redefine
			is_equal
		end

	IV_SHARED_TYPES
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Implementation

	make (a_target, a_index: IV_EXPRESSION)
			-- Make map access to `a_target' with index `a_index'.
		require
			a_target_attached: attached a_target
			a_target_valid: a_target.type.is_map
			a_index_attached: attached a_index
		do
			target := a_target
			create indexes.make
			indexes.extend (a_index)
		ensure
			target_set: target = a_target
			index_set: indexes.first = a_index
		end

	make_two (a_target, a_index1, a_index2: IV_EXPRESSION)
			-- Make map access to `a_target' with two-dimensional indexes
			-- `a_index1' and `a_index2'.
		require
			a_target_attached: attached a_target
			a_target_valid: a_target.type.is_map
			a_index1_attached: attached a_index1
			a_index2_attached: attached a_index2
		do
			target := a_target
			create indexes.make
			indexes.extend (a_index1)
			indexes.extend (a_index2)
		ensure
			target_set: target = a_target
			index1_set: indexes.i_th (1) = a_index1
			index2_set: indexes.i_th (2) = a_index2
		end

feature -- Access

	type: IV_TYPE
			-- Type of map.
		do
			Result := types.generic_type
		end

	target: IV_EXPRESSION
			-- Target of map access.

	indexes: LINKED_LIST [IV_EXPRESSION]
			-- List of indexes for map access.

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_map_access (Current)
		end

feature -- Comparison

	is_equal (other: IV_HEAP_ACCESS):BOOLEAN
			-- <Precursor>
		local
			i: INTEGER
		do
				-- Check if target is the same
			Result := target.is_deep_equal(other.target)
				-- Check if indexes are the same.
				-- If indexes are entities, it just checks the name.
			from
				i:= 1
			until
				i > indexes.count or (not Result)
			loop
				if (attached {IV_ENTITY} indexes.i_th (i) as e1) and then (attached {IV_ENTITY} other.indexes.i_th (i) as e2)then
					if not e1.name.is_equal (e2.name) then
						Result := False
					end
				else
					if not indexes.i_th (i).is_deep_equal(other.indexes.i_th (i)) then
						Result := False
					end
				end
				i:= i+1
			end
		end

invariant
	target_attached: attached target
	target_valid: target.type.is_map
	indexes_attached: attached indexes
	indexes_valid: not indexes.is_empty

end
