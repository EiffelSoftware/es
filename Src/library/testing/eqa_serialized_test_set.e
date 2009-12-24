note
	description: "Summary description for {EQA_SERIALIZED_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_SERIALIZED_TEST_SET

inherit
	EQA_TEST_SET

	EQA_TEST_CASE_SERIALIZATION_UTILITY

feature -- Access

	operands: SPECIAL [detachable ANY];
			-- Operands for the feature under test
			-- target of the feature call is of index 0, followed by arguments to the feature

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
