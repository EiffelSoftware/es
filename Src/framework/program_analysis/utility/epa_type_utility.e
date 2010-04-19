note
	description: "Summary description for {EPA_TYPE_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TYPE_UTILITY

feature -- Access

	actual_type_from_formal_type (a_type: TYPE_A; a_context: CLASS_C): TYPE_A
			-- If `a_type' is formal, return its actual type in context of `a_context'
			-- otherwise return `a_type' itself.
		do
			if a_type.is_formal then
				if attached {FORMAL_A} a_type as l_formal then
					Result := l_formal.constrained_type (a_context)
				end
			else
				Result := a_type
			end
			if Result.has_generics then
				Result := Result.associated_class.constraint_actual_type
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	cleaned_type_name (a_type_name: STRING): STRING
			-- A copy from `a_type_name', with all "?" removed.
		do
			create Result.make_from_string (a_type_name)
			Result.replace_substring_all (once "?", once "")
		end

end
