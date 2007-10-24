indexing
	description: "Define the notion of equality between MML and non-MML objects"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"
	comment: "[
		The main reason of this class is the covariant definition
		of the "is_equals" feature and the equal comparison in
		ANY. Such a definition is unusable within MML, as models
		can have the same value even though they are instances
		of different classes.

		The algorithm used for MML is: if the two values are
		MML objects, then '|=|' is used. If not, then it is
		looked if both classes conform to each other. If yes then
		is_equal is used, otherwise standard '=' is used.
	]"

class
	MML_COMPARISON

feature -- Comparison

	equal_value (first,second: ANY): BOOLEAN is
			-- Compare `first' to `second' and tell if they are equivalent.
		local
			first_model, second_model: MML_ANY
		do
			first_model ?= first
			second_model ?= second
			if first = second then
				Result := true
			elseif first = Void or second = Void then
				Result := false
			elseif first_model = Void or second_model = Void then
				if first.conforms_to (second) then
					Result := equal (first,second)
				elseif second.conforms_to (first) then
					Result := equal (second,first)
				else
					Result := false
				end
			else
				Result := first_model.equals (second_model)
			end
		ensure
			same_objects_have_equal_values: first = second implies Result
			reflexive: Result = equal_value (second,first)
		end

end
