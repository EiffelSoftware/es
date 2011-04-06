note
	description: "Summary description for {TEST5B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_INV_B

inherit
	TEST_INV_A
		redefine establish_invariant end

create
	make

feature {NONE} -- Implementation

	establish_invariant
		do
			value := value.abs
			if value <= 10 then
				value := 10
			end
			Current.qualified_call
		end

	invariant_from_b: BOOLEAN
		do
			invariant_from_b_count := invariant_from_b_count + 1
			Result := value >= 10
		end

invariant
	inv: invariant_from_b
end
