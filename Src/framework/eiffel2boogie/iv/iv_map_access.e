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

	make (a_target: IV_EXPRESSION; a_indexes: ARRAY [IV_EXPRESSION])
			-- Make map access to `a_target' with index `a_indexes'.
		require
			a_target_attached: attached a_target
			a_target_valid: attached {IV_MAP_TYPE} a_target.type as t and then t.domain_types.count = a_indexes.count
			a_indexes_attached: attached a_indexes and then across a_indexes as i all attached i.item end
		do
			target := a_target
			indexes := a_indexes
		ensure
			target_set: target = a_target
			indexes_set: indexes = a_indexes
		end

feature -- Access

	target: IV_EXPRESSION
			-- Target.

	indexes: ARRAY [IV_EXPRESSION]
			-- Indexes.

	type: IV_TYPE
			-- Type of map.
		do
			check attached {IV_MAP_TYPE} target.type as map_type then
				-- ToDo: find most general unifier of domain types with index types and instantiate the range type
				-- For now a workaround: heap is the only map type with a polymorphic result we use
				if types.is_heap (map_type) then
					check attached {IV_USER_TYPE} indexes [2].type as field_type then
						Result := field_type.parameters [1]
					end
				else
					Result := map_type.range_type
				end
			end
		end

feature -- Comparison

	same_expression (a_other: IV_EXPRESSION): BOOLEAN
			-- Does this expression equal `a_other' (if considered in the same context)?
		do
			Result := attached {IV_MAP_ACCESS} a_other as m and then
				(target.same_expression (m.target) and
				indexes.count = m.indexes.count and
				across 1 |..| indexes.count as i all indexes [i.item].same_expression (m.indexes [i.item]) end)
		end

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_map_access (Current)
		end

feature -- Comparison

	is_equal (other: IV_MAP_ACCESS):BOOLEAN
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
				if (attached {IV_ENTITY} indexes [i] as e1) and then (attached {IV_ENTITY} other.indexes [i] as e2)then
					if not e1.name.is_equal (e2.name) then
						Result := False
					end
				else
					if not indexes [i].is_deep_equal(other.indexes [i]) then
						Result := False
					end
				end
				i:= i+1
			end
		end

invariant
	target_attached: attached target
	indexes_attached: attached indexes
	target_valid: attached {IV_MAP_TYPE} target.type as t and then t.domain_types.count = indexes.count
	indexes_nonempty: not indexes.is_empty

end
