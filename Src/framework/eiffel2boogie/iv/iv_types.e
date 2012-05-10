note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_TYPES

feature -- Access: default types

	bool: IV_TYPE
			-- Boolean type.
		once
			create {IV_BASIC_TYPE} Result.make_boolean
		end

	int: IV_TYPE
			-- Integer type.
		once
			create {IV_BASIC_TYPE} Result.make_integer
		end

	ref: IV_TYPE
			-- Reference type.
		once
			create {IV_BASIC_TYPE} Result.make_reference
		end

	heap_type: IV_TYPE
			-- Heap type.
		once
			create {IV_BASIC_TYPE} Result.make_heap
		end

	type: IV_TYPE
			-- Type type.
		once
			create {IV_BASIC_TYPE} Result.make_type
		end

	field (a_content_type: IV_TYPE): IV_TYPE
			-- Field type that has content of type `a_content_type'.
		do
			create {IV_FIELD_TYPE} Result.make (a_content_type)
		end

	generic_type: IV_TYPE
			-- Generic type.
		once
			create {IV_GENERIC_TYPE} Result.make
		end

	for_type_a (a_type: TYPE_A): IV_TYPE
			-- Boogie type for `a_type'.
		require
			a_type_attached: attached a_type
			a_type_valid: not a_type.deep_actual_type.is_like
		local
			l_type: TYPE_A
		do
			l_type := a_type.deep_actual_type
			check not l_type.is_like end

			if l_type.is_integer or l_type.is_natural or l_type.is_character or l_type.is_character_32 then
				Result := int
			elseif l_type.is_boolean then
				Result := bool
			elseif l_type.is_real_32 or else l_type.is_real_64 then
				Result := generic_type
			elseif l_type.is_expanded then
				Result := generic_type
			elseif l_type.is_formal then
				Result := ref
			else
				Result := ref
			end
		end

	for_type_in_context (a_type: TYPE_A; a_context_type: TYPE_A): IV_TYPE
			-- Boogie type for `a_type' in context of `a_context_type'.
		require
			a_type_attached: attached a_type
			a_type_valid: not a_type.deep_actual_type.is_like
			a_context_type_attached: attached a_context_type
		local
			l_type: TYPE_A
		do
			l_type := a_type.deep_actual_type
			l_type := l_type.instantiated_in (a_context_type)
			Result := for_type_a (l_type)
		end

end
