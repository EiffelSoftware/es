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
		do
			if a_type.is_boolean then
				Result := "bool"
			elseif a_type.is_integer or a_type.is_character then
				Result := "int"
			elseif a_type.is_expanded then
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
