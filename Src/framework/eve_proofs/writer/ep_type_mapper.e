indexing
	description:
		"[
			Provides mapping of Eiffel types to Boogie types.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_TYPE_MAPPER

feature -- Access

	boogie_type_for_type (a_type: TYPE_A): STRING
			-- Boogie type for type `a_type'
		require
			type_not_void: a_type /= Void
		local
			l_type: TYPE_A
		do
			if a_type.is_like then
				l_type := a_type.actual_type
			else
				l_type := a_type
			end
			check not l_type.is_like end
			if l_type.is_boolean then
				Result := "bool"
			elseif l_type.is_integer or l_type.is_character or l_type.is_natural then
				Result := "int"
			elseif l_type.is_expanded then
					-- TODO: this type doesn't exist anymore in Boogie 2
				Result := "any"
			else
				Result := "ref"
			end
		ensure
			result_not_void: Result /= Void
		end

	boogie_type_for_class (a_class: CLASS_C): STRING
			-- Boogie type for class `a_class'
		require
			not_void: a_class /= Void
		do
			Result := boogie_type_for_type (a_class.actual_type)
		ensure
			result_not_void: Result /= Void
		end

end
