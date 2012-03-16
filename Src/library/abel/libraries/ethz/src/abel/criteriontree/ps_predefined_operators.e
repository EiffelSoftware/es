note
	description: "Defines the allowed predefined operators for each basic type"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_PREDEFINED_OPERATORS


feature -- Predefined operators

	equals: STRING = "="

	greater: STRING = ">"

	greater_equal: STRING = ">="

	less: STRING = "<"

	less_equal: STRING = "<="

	like_string: STRING = "like"


feature -- Status

	is_valid_combination (operator: STRING; value: ANY) : BOOLEAN
		-- Is `operator' a valid string that can be used with the runtime type of `value'?
		local
			valid_operators: ARRAY[STRING]
		do
			Result := True

		-- Strings
			if attached {READABLE_STRING_8} value or  attached {READABLE_STRING_32} value then
				valid_operators :=  << equals, like_string>>

		-- Booleans
			elseif attached {BOOLEAN} value then
				valid_operators :=  <<equals>>

		-- Integers
			elseif attached {INTEGER_64} value or attached {INTEGER_32} value
						or attached {INTEGER_16} value or attached {INTEGER_8} value then
				valid_operators :=  <<equals, greater, greater_equal, less, less_equal>>

		-- Reals
			elseif attached {REAL_64} value or attached {REAL_32} value then
				valid_operators :=  <<equals, greater, greater_equal, less, less_equal>>

		-- Naturals
			elseif attached {NATURAL_64} value or attached {NATURAL_32} value
						or attached {NATURAL_16} value or attached {NATURAL_8} value then
				valid_operators := <<equals, greater, greater_equal, less, less_equal>>

		-- Value is not a valid base type - return false
			else
				Result:= False
				valid_operators := <<"">>
			end

			Result := Result and across valid_operators as cursor some cursor.item.is_case_insensitive_equal (operator) end
		end


end
