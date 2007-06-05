indexing
	description: "CALLER implementation for the 'direct manipulation' example"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_CALLER

inherit
	BASE_CALLER

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	call (target: ANY; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features on BANK or BANK_ACCOUNT
		local
			observed: OBSERVED_CLASS
			unobserved: UNOBSERVED_CLASS
			string: STRING_8
		do
			-- Discriminate by target type first, to speed things up.
			if target.generating_type.is_equal("UNOBSERVED_CLASS") then
				unobserved ?= target
				call_unobserved(unobserved, feature_name, arguments)
			elseif target.generating_type.is_equal("STRING_8") then
				string ?= target
				call_string_8 (string, feature_name, arguments)
			else
				report_and_set_type_error(target)
			end
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

		call_unobserved(unobserved: UNOBSERVED_CLASS; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of UNOBSERVED_CLASS
		local
			ignored_result: ANY
		do
			if feature_name.is_equal ("read_literal_string") then
				ignored_result := unobserved.read_literal_string
			elseif feature_name.is_equal ("read_from_file") then
				ignored_result := unobserved.read_from_file
			end
		end
invariant
	invariant_clause: True -- Your invariant here

end
